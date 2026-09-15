import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/config/app_config.dart';
import 'package:customer_core/src/core/config/app_env.dart';
import 'package:customer_core/src/core/constants/enums.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/domain/cart/i_cart_repo.dart';
import 'package:customer_core/src/domain/checkout/i_checkout_repo.dart';
import 'package:customer_core/src/domain/offer/i_offer_repo.dart';
import 'package:customer_core/src/domain/store/i_store_repo.dart';
import 'package:customer_core/src/domain/store/models/product_category_model.dart';
import 'package:customer_core/src/domain/store/models/product_details_pagination.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';
import 'package:customer_core/src/domain/user/i_user_repo.dart';
import 'package:customer_core/src/domain/user/i_user_shared_prefs.dart';
import 'package:customer_core/src/domain/user/models/user_login_response.dart';
import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:customer_core/src/presentation/order_online/categories/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:provider/provider.dart';

/// Store repo whose categories resolve to [categories].
///
/// Categories are only fetched from the post-frame callback, so on the very
/// first frame the screen always starts with an empty category list - the state
/// that used to crash the TabBar.
class _FakeStoreRepo implements IStoreRepo {
  _FakeStoreRepo({this.categories = const []});

  final List<CategoryData> categories;

  @override
  Future<Either<AppExceptions, ProductCategoryModel>> getCategories() async =>
      Right(ProductCategoryModel(items: categories));

  @override
  Future<Either<AppExceptions, StoreSettingsDataModel>>
      getStoreSettings() async =>
          Left(GenericAppException(prefix: 'test', message: 'not used'));

  // Fired as a follow-up by ProductsProvider.getAllCategories once categories
  // exist. Failing keeps the product list empty, which is all this test needs.
  @override
  Future<Either<AppExceptions, ProductDetailsPagination>>
      getProductsByPagination({
    required String categoryID,
    required String numberOfProducts,
    required String pageNumber,
  }) async =>
          Left(GenericAppException(prefix: 'test', message: 'not used'));

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'IStoreRepo.${invocation.memberName} is not used by this test');
}

/// Everything below is never exercised by [CategoriesScreen] while it renders
/// with an empty/loading product list, so it throws instead of silently
/// returning bogus data.
class _UnusedCartRepo implements ICartRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'ICartRepo.${invocation.memberName} is not used by this test');
}

class _UnusedCheckoutRepo implements ICheckoutRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'ICheckoutRepo.${invocation.memberName} is not used by this test');
}

class _UnusedOfferRepo implements IOfferRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'IOfferRepo.${invocation.memberName} is not used by this test');
}

class _UnusedUserRepo implements IUserRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'IUserRepo.${invocation.memberName} is not used by this test');
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

CategoryData _category(String id) => CategoryData(
      cID: id,
      name: 'Category $id',
      productsCount: ProductsCount(online: 3),
    );

Future<void> _pumpScreen(WidgetTester tester, List<CategoryData> categories) {
  final storeRepo = _FakeStoreRepo(categories: categories);
  final shopProvider = ShopProvider(storeRepo);
  final productsProvider = ProductsProvider(
    storeRepo: storeRepo,
    sharedPrefsRepository: _FakeUserSharedPrefsRepo(),
    shopProvider: shopProvider,
  );

  return tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: shopProvider),
        ChangeNotifierProvider.value(value: productsProvider),
        ChangeNotifierProvider.value(
          value: CartProvider(
            cartRepo: _UnusedCartRepo(),
            checkRepo: _UnusedCheckoutRepo(),
            offerRepo: _UnusedOfferRepo(),
            sharedPrefsRepository: _FakeUserSharedPrefsRepo(),
            productsProvider: productsProvider,
          ),
        ),
        ChangeNotifierProvider.value(value: HomeProvider()),
        ChangeNotifierProvider.value(
          value: UserProvider(
            userRepo: _UnusedUserRepo(),
            sharedPrefsRepository: _FakeUserSharedPrefsRepo(),
          ),
        ),
      ],
      // The app's widgets read their text styles from a ThemeExtension that is
      // registered by the real app theme, so register it here as well.
      child: MaterialApp(
        theme: ThemeData(extensions: [lightCustomTextStyle]),
        home: const CategoriesScreen(),
      ),
    ),
  );
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
      // Keeps the category tabs free of network images.
      isCategoryImageEnabled: false,
    );
  });

  testWidgets(
      'TabBar is built with a controller while categories are still loading',
      (tester) async {
    await _pumpScreen(tester, const []);

    // Regression guard: a TabBar without a controller throws
    // "No TabController for TabBar" while it is being built.
    expect(tester.takeException(), isNull);

    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.controller, isNotNull);
    expect(tabBar.controller!.length, 0);

    // The post-frame category fetch must not break the built TabBar either.
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(tester.widget<TabBar>(find.byType(TabBar)).controller, isNotNull);
  });

  testWidgets(
      'TabBar controller is re-synced when categories arrive after the first '
      'frame', (tester) async {
    await _pumpScreen(tester, [_category('1'), _category('2')]);

    // First frame: the category list is still empty, so the controller starts
    // with a length of 0.
    expect(tester.takeException(), isNull);
    expect(tester.widget<TabBar>(find.byType(TabBar)).controller!.length, 0);

    // Categories arrive -> the controller must be recreated with the new length
    // (a TabController cannot change its length in place) and the TabBar must
    // rebuild against it without throwing.
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);

    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.controller, isNotNull);
    expect(tabBar.controller!.length, 2);
    expect(find.byType(Tab), findsNWidgets(2));
  });
}
