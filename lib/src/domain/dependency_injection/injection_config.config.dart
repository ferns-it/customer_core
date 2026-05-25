// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:customer_core/src/application/auth/auth_provider.dart' as _i993;
import 'package:customer_core/src/application/cart/cart_provider.dart' as _i437;
import 'package:customer_core/src/application/home/home_provider.dart' as _i514;
import 'package:customer_core/src/application/notification/notification_provider.dart'
    as _i86;
import 'package:customer_core/src/application/order/order_provider.dart'
    as _i592;
import 'package:customer_core/src/application/payment/payment_provider.dart'
    as _i412;
import 'package:customer_core/src/application/products/products_provider.dart'
    as _i805;
import 'package:customer_core/src/application/promotion/promotions_provider.dart'
    as _i184;
import 'package:customer_core/src/application/search/search_provider.dart'
    as _i553;
import 'package:customer_core/src/application/shop/shop_provider.dart' as _i663;
import 'package:customer_core/src/application/table/table_provider.dart'
    as _i581;
import 'package:customer_core/src/application/theme/theme_provider.dart'
    as _i805;
import 'package:customer_core/src/application/user/user_provider.dart' as _i914;
import 'package:customer_core/src/domain/cart/i_cart_repo.dart' as _i696;
import 'package:customer_core/src/domain/checkout/i_checkout_repo.dart'
    as _i706;
import 'package:customer_core/src/domain/offer/i_offer_repo.dart' as _i94;
import 'package:customer_core/src/domain/promotion/i_promotion_repo.dart'
    as _i304;
import 'package:customer_core/src/domain/search/i_search_repo.dart' as _i71;
import 'package:customer_core/src/domain/store/i_store_repo.dart' as _i333;
import 'package:customer_core/src/domain/table/i_table_repo.dart' as _i303;
import 'package:customer_core/src/domain/user/i_user_repo.dart' as _i266;
import 'package:customer_core/src/domain/user/i_user_shared_prefs.dart'
    as _i335;
import 'package:customer_core/src/infrastructure/cart/cart_repo.dart' as _i640;
import 'package:customer_core/src/infrastructure/checkout/checkout_repo.dart'
    as _i454;
import 'package:customer_core/src/infrastructure/offer/offer_repo.dart'
    as _i459;
import 'package:customer_core/src/infrastructure/promotions/promotions_repo.dart'
    as _i1037;
import 'package:customer_core/src/infrastructure/search/search_repo.dart'
    as _i662;
import 'package:customer_core/src/infrastructure/store/store_repo.dart'
    as _i797;
import 'package:customer_core/src/infrastructure/table/table_repo.dart'
    as _i519;
import 'package:customer_core/src/infrastructure/user/user_repo.dart' as _i854;
import 'package:customer_core/src/infrastructure/user/user_shared_prefs_repo.dart'
    as _i447;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i514.HomeProvider>(() => _i514.HomeProvider());
    gh.lazySingleton<_i86.NotificationProvider>(
        () => _i86.NotificationProvider());
    gh.lazySingleton<_i805.ThemeProvider>(() => _i805.ThemeProvider());
    gh.lazySingleton<_i335.IUserSharedPrefsRepo>(
        () => _i447.UserSharedPrefsRepo());
    gh.lazySingleton<_i71.ISearchRepo>(() => _i662.SearchRepo());
    gh.lazySingleton<_i303.ITableRepo>(() => _i519.TableRepo());
    gh.lazySingleton<_i581.TableProvider>(() => _i581.TableProvider(
          tableRepo: gh<_i303.ITableRepo>(),
          userSharedPrefsRepo: gh<_i335.IUserSharedPrefsRepo>(),
        ));
    gh.lazySingleton<_i696.ICartRepo>(() => _i640.CartRepo());
    gh.lazySingleton<_i266.IUserRepo>(() => _i854.UserRepo());
    gh.lazySingleton<_i94.IOfferRepo>(() => _i459.OfferRepo());
    gh.lazySingleton<_i706.ICheckoutRepo>(() => _i454.CheckoutRepo());
    gh.lazySingleton<_i592.OrderProvider>(() => _i592.OrderProvider(
          userRepo: gh<_i266.IUserRepo>(),
          sharedPrefsRepository: gh<_i335.IUserSharedPrefsRepo>(),
        ));
    gh.lazySingleton<_i914.UserProvider>(() => _i914.UserProvider(
          userRepo: gh<_i266.IUserRepo>(),
          sharedPrefsRepository: gh<_i335.IUserSharedPrefsRepo>(),
        ));
    gh.lazySingleton<_i333.IStoreRepo>(() => _i797.StoreRepo());
    gh.lazySingleton<_i304.IPromotionRepo>(() => _i1037.PromotionsRepo());
    gh.lazySingleton<_i805.ProductsProvider>(() => _i805.ProductsProvider(
          storeRepo: gh<_i333.IStoreRepo>(),
          sharedPrefsRepository: gh<_i335.IUserSharedPrefsRepo>(),
        ));
    gh.lazySingleton<_i437.CartProvider>(() => _i437.CartProvider(
          cartRepo: gh<_i696.ICartRepo>(),
          checkRepo: gh<_i706.ICheckoutRepo>(),
          offerRepo: gh<_i94.IOfferRepo>(),
          sharedPrefsRepository: gh<_i335.IUserSharedPrefsRepo>(),
        ));
    gh.lazySingleton<_i412.PaymentProvider>(
        () => _i412.PaymentProvider(checkoutRepo: gh<_i706.ICheckoutRepo>()));
    gh.lazySingleton<_i663.ShopProvider>(
        () => _i663.ShopProvider(gh<_i333.IStoreRepo>()));
    gh.lazySingleton<_i993.AuthProvider>(() => _i993.AuthProvider(
          userRepository: gh<_i266.IUserRepo>(),
          sharedPrefsRepository: gh<_i335.IUserSharedPrefsRepo>(),
        ));
    gh.factory<_i184.PromotionsProvider>(
        () => _i184.PromotionsProvider(gh<_i304.IPromotionRepo>()));
    gh.lazySingleton<_i553.SearchProvider>(() => _i553.SearchProvider(
          searchRepo: gh<_i71.ISearchRepo>(),
          productsProvider: gh<_i805.ProductsProvider>(),
        ));
    return this;
  }
}
