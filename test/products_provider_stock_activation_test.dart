import 'package:customer_core/src/application/core/api_response.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/domain/store/i_store_repo.dart';
import 'package:customer_core/src/domain/store/models/featured_popular_products_data_model.dart';
import 'package:customer_core/src/domain/store/models/favourite_product_data_model.dart';
import 'package:customer_core/src/domain/store/models/product_category_model.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
import 'package:customer_core/src/domain/store/models/product_details_pagination.dart';
import 'package:customer_core/src/domain/store/models/store_delivery_slot_model.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';
import 'package:customer_core/src/domain/store/models/store_timing_data_model.dart';
import 'package:customer_core/src/domain/user/i_user_shared_prefs.dart';
import 'package:customer_core/src/domain/user/models/user_login_response.dart';
import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _FakeStoreRepo implements IStoreRepo {
  Left<AppExceptions, T> _fail<T>() =>
      Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  Future<Either<AppExceptions, ProductDetailsModel>> getProducts(
          {required String categoryID}) async =>
      _fail();

  @override
  Future<Either<AppExceptions, ProductCategoryModel>> getCategories() async =>
      _fail();

  @override
  Future<Either<AppExceptions, StoreTimingDataModel>>
      getShopTimingDetails() async => _fail();

  @override
  Future<Either<AppExceptions, StoreSettingsDataModel>>
      getStoreSettings() async => _fail();

  @override
  Future<Either<AppExceptions, StoreDeliverySlotModel>>
      getStoreDeliverySlots() async => _fail();

  @override
  Future<Either<AppExceptions, FeaturedPopularProductsDataModel>>
      getFeaturedPopularProducts({required String shopID}) async => _fail();

  @override
  Future<Either<AppExceptions, ProductDetailsPagination>>
      getProductsByPagination({
    required String categoryID,
    required String numberOfProducts,
    required String pageNumber,
  }) async =>
          _fail();

  @override
  Future<Either<AppExceptions, Map<String, dynamic>>> addFavourite(
          {required String productID}) async =>
      _fail();

  @override
  Future<Either<AppExceptions, String>> removeFavourite(
          {required String productID}) async =>
      _fail();

  @override
  Future<Either<AppExceptions, FavouriteProductRawDataModel>>
      getFavouriteProductList() async => _fail();
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

ProductsProvider _providerWithSetting(String? listUnavailableProducts) {
  final shopProvider = ShopProvider(_FakeStoreRepo());
  shopProvider.storeSettings = APIResponse.completed(
    StoreSettingsDataModel(
      smsAvailableCountries: const [],
      deliveryInfo: StoreDeliverySettingsInfo(
        listUnavailableProducts: listUnavailableProducts,
      ),
    ),
  );
  return ProductsProvider(
    storeRepo: _FakeStoreRepo(),
    sharedPrefsRepository: _FakeUserSharedPrefsRepo(),
    shopProvider: shopProvider,
  );
}

ProductDataModel _product({
  required String id,
  bool isAvailable = true,
  ProductStockDetails? stock,
}) =>
    ProductDataModel(
      pID: id,
      isAvailable: isAvailable,
      stock: stock,
    );

ProductStockDetails _stock({bool? activated, int? availableStock}) =>
    ProductStockDetails(activated: activated, availableStock: availableStock);

void main() {
  test(
      'inactive and out-of-stock products are always hidden, even when '
      'unavailable products are enabled', () {
    final provider = _providerWithSetting('Enabled');

    final inactive = _product(id: 'inactive', stock: _stock(activated: false));
    final outOfStock = _product(
        id: 'out-of-stock', stock: _stock(activated: true, availableStock: 0));
    final noActivationNoStock = _product(
        id: 'no-activation-zero-stock', stock: _stock(availableStock: 0));
    final notAvailable = _product(id: 'not-available', isAvailable: false);
    final inStock = _product(
        id: 'in-stock', stock: _stock(activated: true, availableStock: 5));
    final nullStock = _product(id: 'null-stock');
    final nullActivated = _product(id: 'null-activated', stock: _stock());

    final result = provider.filterListableProducts([
      inactive,
      outOfStock,
      noActivationNoStock,
      notAvailable,
      inStock,
      nullStock,
      nullActivated,
    ]);

    expect(
        result.map((p) => p.pID), ['in-stock', 'null-stock', 'null-activated']);
  });

  test(
      'inactive and out-of-stock products stay hidden together with '
      'unavailable listing disabled', () {
    final provider = _providerWithSetting('Disabled');

    final inactive = _product(id: 'inactive', stock: _stock(activated: false));
    final outOfStock = _product(
        id: 'out-of-stock', stock: _stock(activated: true, availableStock: 0));
    final notAvailable = _product(id: 'not-available', isAvailable: false);
    final inStock = _product(
        id: 'in-stock', stock: _stock(activated: true, availableStock: 5));
    final nullStock = _product(id: 'null-stock');
    final nullActivated = _product(id: 'null-activated', stock: _stock());

    final result = provider.filterListableProducts([
      inactive,
      outOfStock,
      notAvailable,
      inStock,
      nullStock,
      nullActivated
    ]);

    expect(
        result.map((p) => p.pID), ['in-stock', 'null-stock', 'null-activated']);
  });

  test('isProductListable rejects products with inactive or exhausted stock',
      () {
    final provider = _providerWithSetting(null);

    final inactive = _product(id: 'inactive', stock: _stock(activated: false));
    final outOfStock = _product(
        id: 'out-of-stock', stock: _stock(activated: true, availableStock: 0));
    final inStock = _product(
        id: 'in-stock', stock: _stock(activated: true, availableStock: 5));

    expect(provider.isProductListable(inactive), isFalse);
    expect(provider.isProductListable(outOfStock), isFalse);
    expect(provider.isProductListable(inStock), isTrue);
  });
}
