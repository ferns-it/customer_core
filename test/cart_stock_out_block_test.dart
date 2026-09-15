import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/core/config/app_config.dart';
import 'package:customer_core/src/core/config/app_env.dart';
import 'package:customer_core/src/core/constants/enums.dart';
import 'package:customer_core/src/domain/cart/i_cart_repo.dart';
import 'package:customer_core/src/domain/cart/models/add_product_cart_request_model.dart';
import 'package:customer_core/src/domain/cart/models/cart_details_model.dart';
import 'package:customer_core/src/domain/checkout/i_checkout_repo.dart';
import 'package:customer_core/src/domain/checkout/models/calculate_take_away_details.dart';
import 'package:customer_core/src/domain/checkout/models/calculated_delivery_charge_details_model.dart';
import 'package:customer_core/src/domain/checkout/models/checkout_data_model.dart';
import 'package:customer_core/src/domain/checkout/models/payment_intent_details.dart';
import 'package:customer_core/src/domain/offer/i_offer_repo.dart';
import 'package:customer_core/src/domain/offer/models/offer_details_model.dart';
import 'package:customer_core/src/domain/offer/models/validated_coupon_details.dart';
import 'package:customer_core/src/domain/store/i_store_repo.dart';
import 'package:customer_core/src/domain/store/models/featured_popular_products_data_model.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';
import 'package:customer_core/src/domain/store/models/store_timing_data_model.dart';
import 'package:customer_core/src/domain/store/models/product_category_model.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
import 'package:customer_core/src/domain/store/models/product_details_pagination.dart';
import 'package:customer_core/src/domain/store/models/favourite_product_data_model.dart';
import 'package:customer_core/src/domain/store/models/store_delivery_slot_model.dart';
import 'package:customer_core/src/domain/user/i_user_shared_prefs.dart';
import 'package:customer_core/src/domain/user/models/user_login_response.dart';
import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

/// Cart repo with a scripted [updateResults] queue.
///
/// Each `updateCartItem` call consumes the next entry; once the queue is
/// exhausted the update succeeds (`None`). `listCartItems` always resolves
/// with the current [cart], and `deleteCartItem` removes the item from it.
class _FakeCartRepo implements ICartRepo {
  _FakeCartRepo({required this.cart, this.updateResults = const []});

  CartDetailsModel cart;
  final List<Option> updateResults;
  int _updateCalls = 0;
  int get updateCalls => _updateCalls;

  Option _nextUpdateResult() {
    final result = _updateCalls < updateResults.length
        ? updateResults[_updateCalls]
        : const None();
    _updateCalls++;
    return result;
  }

  @override
  Future<Either<AppExceptions, CartDetailsModel>> listCartItems(
          {required bool isGuest, String? guestID, String? userID}) async =>
      Right(cart);

  @override
  Future<Option> addCartItem(AddProductCartRequestDataModel cartItem,
          bool isGuest, String? guestID, String? userID) async =>
      const None();

  @override
  Future<Option> updateCartItem(
          String cartItemId, AddProductCartRequestDataModel cartItem,
          {required bool isGuest, String? guestID, String? userID}) async =>
      _nextUpdateResult();

  @override
  Future<Option> deleteCartItem(
      {required String id,
      required bool isGuest,
      String? guestID,
      String? userID}) async {
    cart = CartDetailsModel(
      shopId: cart.shopId,
      cartItems: cart.cartItems.where((item) => item.cartID != id).toList(),
    );
    return const None();
  }

  @override
  Future<Option> clearCart(
          {required bool isGuest, String? guestID, String? userID}) async =>
      const None();

  @override
  Future<Either<AppExceptions, Option>> transferCart(
          {required String? guestID, required String? userID}) async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));
}

class _FakeCheckoutRepo implements ICheckoutRepo {
  @override
  Future<Either<AppExceptions, CalculatedDeliveryChargeDetailsModel>>
      calculateDeliveryFee({
    required bool postCodeValidation,
    required String shopID,
    required String destinationPostCode,
  }) async =>
          Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, CalculateTakeAwayDetails>> calculateTakeAwayFee(
          DateTime pickupTime) async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, Map<String, dynamic>>> completeOrder(
          {required CheckOutDataModel data}) async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, PaymentIntentDetails>> createPaymentIntent(
          {required String discountAmount,
          required String deliveryCharges,
          required String deliveryType,
          required String postCode,
          required String pickupTime}) async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Option> cancelPaymentIntent(String paymentID) async => const None();
}

class _FakeOfferRepo implements IOfferRepo {
  @override
  Future<Either<AppExceptions, List<OfferDetailsModel>>>
      listAllOffers() async =>
          Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, ValidatedCouponDetails>> validateCouponCode(
          String coupenId) async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));
}

class _FakeUserSharedPrefsRepo implements IUserSharedPrefsRepo {
  @override
  Future<bool> saveUserData(UserLoginResponse userData) async => true;

  @override
  Future<bool> deleteUserData() async => true;

  @override
  Future<UserLoginResponse?> getUserData() async => null;

  @override
  Future<bool> saveGuestID(String guestID) async => true;

  @override
  Future<bool> deleteGuestID() async => true;

  @override
  Future<String?> getGuestID() async => null;

  @override
  Future<bool> isTokenExpired() async => false;

  @override
  Future<String?> getToken() async => null;
}

/// Store repo serving one product so `syncStockAfterCartChange` (fired by
/// the stock-out error branch) repopulates the stock cache with the
/// "server" stock instead of the optimistic 0.
///
/// [serverHasStock] simulates whether the server currently has stock for
/// P1; tests flip it to model stock becoming available again.
class _FakeStoreRepo implements IStoreRepo {
  _FakeStoreRepo({this.serverHasStock = true});

  bool serverHasStock;

  @override
  Future<Either<AppExceptions, FeaturedPopularProductsDataModel>>
      getFeaturedPopularProducts({required String shopID}) async => Right(
            FeaturedPopularProductsDataModel(featuredProducts: [
              ProductDataModel(
                pID: 'P1',
                isAvailable: true,
                stock: ProductStockDetails(
                  activated: true,
                  availableStock: serverHasStock ? 5 : 0,
                ),
              ),
            ]),
          );

  @override
  Future<Either<AppExceptions, StoreSettingsDataModel>> getStoreSettings() =>
      Future.value(
          Left(GenericAppException(prefix: 'test', message: 'not used')));

  @override
  Future<Either<AppExceptions, ProductDetailsPagination>>
      getProductsByPagination({
    required String categoryID,
    required String numberOfProducts,
    required String pageNumber,
  }) async =>
          Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, ProductCategoryModel>> getCategories() async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, ProductDetailsModel>> getProducts(
          {required String categoryID}) async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, StoreTimingDataModel>> getShopTimingDetails() =>
      Future.value(
          Left(GenericAppException(prefix: 'test', message: 'not used')));

  @override
  Future<Either<AppExceptions, StoreDeliverySlotModel>>
      getStoreDeliverySlots() => Future.value(
          Left(GenericAppException(prefix: 'test', message: 'not used')));

  @override
  Future<Either<AppExceptions, Map<String, dynamic>>> addFavourite(
          {required String productID}) async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, String>> removeFavourite(
          {required String productID}) async =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, FavouriteProductRawDataModel>>
      getFavouriteProductList() async =>
          Left(GenericAppException(prefix: 'test', message: 'not used'));
}

CartDetailsModel _cartWithItem(
        {required int qty, String pID = 'P1', String cartID = 'C1'}) =>
    CartDetailsModel(
      shopId: 'shop',
      cartItems: [
        CartItemDataModel(pID: pID, cartID: cartID, quantity: qty),
      ],
      // The optimistic qty-update path rewrites the cart total summary.
      cartTotal: CartItemTotalSummary(
        cartTotalPrice: 0,
        cartTotalPriceDisplay: '0.000',
        cartDiscountTotal: 0,
        cartDiscountTotalDisplay: '0.000',
        cartTotalPrice_NormalDisplay: '0.000',
      ),
    );

/// The stock-out rejection the server sends when an increase is refused.
Option _staleStockError() => Some(GenericAppException(
    prefix: 'Out of stock', message: 'Product is out of stock'));

Future<void> _flushAsync() async {
  for (var i = 0; i < 8; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

Future<CartProvider> _provider(_FakeCartRepo cartRepo,
    {_FakeStoreRepo? storeRepo}) async {
  final shopProvider = ShopProvider(storeRepo ?? _FakeStoreRepo());
  final productsProvider = ProductsProvider(
    storeRepo: storeRepo ?? _FakeStoreRepo(),
    sharedPrefsRepository: _FakeUserSharedPrefsRepo(),
    shopProvider: shopProvider,
  );
  final provider = CartProvider(
    cartRepo: cartRepo,
    checkRepo: _FakeCheckoutRepo(),
    offerRepo: _FakeOfferRepo(),
    sharedPrefsRepository: _FakeUserSharedPrefsRepo(),
    productsProvider: productsProvider,
  );
  await provider.listCartItems();
  await _flushAsync();
  return provider;
}

void main() {
  setUpAll(() {
    AppConfig.instance = AppConfig(
      applicationName: 'Test App',
      shopName: 'Test Shop',
      shopId: 'test-shop',
      shopIdentifier: 'test-shop',
      shopInfoEmail: 'test@example.com',
      shopInfoPhone: const ['0000000000'],
      shopInfoAddress: 'Test Address',
      buildIdentifier: 'test',
      country: Country.values.first,
      fireBaseProjectId: 'test',
      env: AppEnv.dev,
    );
  });

  test(
      'a rejected increase marks the product as stock-out blocked for the cart',
      () async {
    final cartRepo = _FakeCartRepo(
      cart: _cartWithItem(qty: 2),
      updateResults: [_staleStockError()],
    );
    // The server genuinely has no stock, so the block must persist.
    final provider = await _provider(cartRepo,
        storeRepo: _FakeStoreRepo(serverHasStock: false));

    await provider.incrementCartItemQty(0);
    await _flushAsync();

    expect(provider.isCartIncrementBlockedForStockOut('P1'), isTrue);
    expect(provider.productsProvider.stockForID('P1')?.availableStock, 0);
  });

  test(
      'a transient stale-data/parse error does NOT disable the increment '
      'button', () async {
    final cartRepo = _FakeCartRepo(
      cart: _cartWithItem(qty: 2),
      // A JSON/parse hiccup - not a real stock shortage.
      updateResults: [Some(FormatErrorException())],
    );
    final provider = await _provider(cartRepo);

    await provider.incrementCartItemQty(0);
    await _flushAsync();

    expect(provider.isCartIncrementBlockedForStockOut('P1'), isFalse,
        reason: 'a parse failure is not a stock shortage - + must stay '
            'enabled');
    // The stock cache must not have been zeroed by the optimistic mark.
    expect(provider.productsProvider.stockForID('P1')?.availableStock, 5);
  });

  test(
      'a stock-out block is lifted automatically when a stock re-sync shows '
      'the server actually has stock', () async {
    final cartRepo = _FakeCartRepo(
      cart: _cartWithItem(qty: 2),
      updateResults: [_staleStockError()],
    );
    final storeRepo = _FakeStoreRepo(serverHasStock: true);
    final provider = await _provider(cartRepo, storeRepo: storeRepo);

    await provider.incrementCartItemQty(0);
    await _flushAsync();

    expect(provider.isCartIncrementBlockedForStockOut('P1'), isFalse,
        reason: 'the fresh server data contradicts the block (stock is 5), '
            'so the button must not stay disabled');
    expect(provider.productsProvider.stockForID('P1')?.availableStock, 5);
  });

  test(
      'decrementing a blocked item lifts the block and re-syncs stock once '
      'the server confirms the drop (user scenario)', () async {
    final cartRepo = _FakeCartRepo(
      cart: _cartWithItem(qty: 2),
      // 1st update (increment): rejected as out of stock.
      // 2nd update (decrement): confirmed.
      updateResults: [_staleStockError()],
    );
    final storeRepo = _FakeStoreRepo(serverHasStock: false);
    final provider = await _provider(cartRepo, storeRepo: storeRepo);

    await provider.incrementCartItemQty(0);
    await _flushAsync();
    expect(provider.isCartIncrementBlockedForStockOut('P1'), isTrue);
    expect(provider.productsProvider.stockForID('P1')?.availableStock, 0,
        reason: 'the server genuinely has no stock, so the cache stays 0');

    // Later the server has stock again (e.g. another order freed it up) ...
    storeRepo.serverHasStock = true;
    // ... and the user decrements; the server confirms the drop.
    await provider.decrementCartItemQty(0);
    await _flushAsync();

    expect(provider.isCartIncrementBlockedForStockOut('P1'), isFalse,
        reason: 'a confirmed decrement frees stock, so + must work again');
    // The stock cache must recover from the optimistic 0 via the re-sync.
    expect(provider.productsProvider.stockForID('P1')?.availableStock, 5,
        reason: 'the decrement must refresh the cached stock from the server');
  });

  test('removing the last unit of a blocked item lifts the block as well',
      () async {
    final cartRepo = _FakeCartRepo(
      cart: _cartWithItem(qty: 1),
      updateResults: [_staleStockError()],
    );
    final provider = await _provider(cartRepo,
        storeRepo: _FakeStoreRepo(serverHasStock: false));

    await provider.incrementCartItemQty(0);
    await _flushAsync();
    expect(provider.isCartIncrementBlockedForStockOut('P1'), isTrue);

    // qty == 1 → decrement removes the item from the cart.
    await provider.decrementCartItemQty(0);
    await _flushAsync();

    expect(provider.cartItems, isEmpty);
    expect(provider.isCartIncrementBlockedForStockOut('P1'), isFalse,
        reason: 'blocks are pruned for products that left the cart');
  });

  test('a still-rejected increase re-applies the block after it was lifted',
      () async {
    final cartRepo = _FakeCartRepo(
      cart: _cartWithItem(qty: 2),
      // increment rejected → decrement confirmed → increment rejected again.
      updateResults: [_staleStockError(), const None(), _staleStockError()],
    );
    final storeRepo = _FakeStoreRepo(serverHasStock: false);
    final provider = await _provider(cartRepo, storeRepo: storeRepo);

    await provider.incrementCartItemQty(0);
    await _flushAsync();
    expect(provider.isCartIncrementBlockedForStockOut('P1'), isTrue);

    // Stock becomes available, the user decrements, the block lifts.
    storeRepo.serverHasStock = true;
    await provider.decrementCartItemQty(0);
    await _flushAsync();
    expect(provider.isCartIncrementBlockedForStockOut('P1'), isFalse);

    // ... but the server still cannot fulfil the increase.
    storeRepo.serverHasStock = false;
    await provider.incrementCartItemQty(0);
    await _flushAsync();
    expect(provider.isCartIncrementBlockedForStockOut('P1'), isTrue,
        reason: 'if stock is still missing, the block must come back');
  });
}
