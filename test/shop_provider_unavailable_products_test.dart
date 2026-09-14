import 'package:customer_core/src/application/core/api_response.dart';
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
import 'package:customer_core/src/infrastructure/core/failures/app_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';

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

ShopProvider _providerWithSetting(String? listUnavailableProducts) {
  final provider = ShopProvider(_FakeStoreRepo());
  provider.storeSettings = APIResponse.completed(
    StoreSettingsDataModel(
      smsAvailableCountries: const [],
      deliveryInfo: StoreDeliverySettingsInfo(
        listUnavailableProducts: listUnavailableProducts,
      ),
    ),
  );
  return provider;
}

void main() {
  test('sold-out products are hidden when listUnavailableProducts is Disabled',
      () {
    final provider = _providerWithSetting('Disabled');
    expect(provider.canListUnavailableProducts, isFalse);
    expect(provider.shouldHideUnavailableProducts, isTrue);
  });

  test('sold-out products are hidden when the setting is missing', () {
    final provider = _providerWithSetting(null);
    expect(provider.canListUnavailableProducts, isFalse);
    expect(provider.shouldHideUnavailableProducts, isTrue);
  });

  test('sold-out products are hidden for any unrecognized value', () {
    final provider = _providerWithSetting('');
    expect(provider.canListUnavailableProducts, isFalse);
  });

  test('sold-out products are listed only when explicitly Enabled', () {
    final provider = _providerWithSetting('Enabled');
    expect(provider.canListUnavailableProducts, isTrue);
    expect(provider.shouldHideUnavailableProducts, isFalse);
  });

  test('Enabled match is case-insensitive and trims whitespace', () {
    final provider = _providerWithSetting(' Enabled ');
    expect(provider.canListUnavailableProducts, isTrue);
  });
}
