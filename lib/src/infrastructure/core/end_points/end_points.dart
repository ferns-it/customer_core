import 'package:customer_core/src/core/config/app_env.dart';

class Endpoints {
  static const String _kDemoBaseUrl = 'https://demo.foodpage.co.uk/v2/';
  static const String _kDevBaseUrl = 'https://development.foodpage.co.uk/v2/';
  static const String _kBaseUrl = 'https://foodpage.co.uk/v2/';
  static const String kTableReservationBaseUrl =
      'https://dev.ferns-it.in/view-reservation';

  static const String kPromotionsBaseUrl = 'https://shopadmin.vgrex.com/';

  static String get baseUrl {
    return AppEnvironment.current == AppEnv.dev
        ? _kDevBaseUrl
        : AppEnvironment.current == AppEnv.demo
            ? _kDemoBaseUrl
            : _kBaseUrl;
  }

  // User endpoints
  static const String kUserLogin = 'shop/user/login';
  static const String kUserLoginSecret = 'shop/user/login/secret';
  static const String kPasswordResetOtp = 'shop/user/passwordresetotp';
  static const String kVerificationOtpMail = 'shop/user/verificationotpmail';
  static const String kResetPassword = 'shop/user/resetpassword';
  static const String kUserRegistration = 'shop/user/registration';
  static const String kAddNewAddress = 'shop/user/newaddress';
  static const String kUpdateAddress = 'shop/user/updateaddress';
  static const String kSetDefaultAddress = 'shop/user/setdefaultaddress';
  static const String kDeleteAddress = 'shop/user/deleteaddress';
  static const String kUserAddressList = 'shop/user/addresslist';
  static const String kMakeFavourite = 'shop/user/activity/makefavourite';
  static const String kDeleteFavourite = 'shop/user/activity/deletefavourite';
  static const String kFavouriteList = 'shop/user/activity/favouritelist';
  static const String kOrderHistory = 'shop/user/orderhistory/';
  static const String kActiveOrders = 'shop/user/activeorders/';
  static const String kVerifyAlreadyRegistered =
      'shop/user/verifyalreadyregistered';
  static const String kLinkPartialUser = 'shop/user/linkpartialuser';
  static const String kUserConsent = 'shop/user/getconsents/';
  static const String kSaveUserConsent = 'shop/user/saveconsent';
  static const String kUpdateBasicProfile = 'shop/user/updatebasicprofile';

  // Cart Endpoints
  static const String kListCartItems = 'shop/user/carts';
  static const String kAddToCart = 'shop/user/carts';
  static const String kAddToCartNew = 'shop/user/carts/additem';
  static const String kGetCartItemDetails = 'shop/user/carts';
  static const String kUpdateCartItem = 'shop/user/carts';
  static const String kDeleteCartItem = 'shop/user/carts';
  static const String kNewUpdateCartItem = 'shop/user/cartupdate/updateitem';
  static const String kClearCart = 'shop/user/carts/clear';

  // Cart Web Endpoints
  static const String kWebListCartItems = 'shop/user/web/carts';
  static const String kWebAddToCart = 'shop/user/web/carts';
  static const String kWebGetCartItemDetails = 'shop/user/web/carts';
  static const String kWebUpdateCartItem = 'shop/user/web/carts';
  static const String kWebDeleteCartItem = 'shop/user/web/carts';
  static const String kWebClearCart = 'shop/user/web/carts/clear';
  static const String kWebTransferGuestCart = 'shop/user/web/carts/transfer';

  // Admin Endpoints
  static const String kAdminListAllShops = 'shop/home/listallshops/{secretkey}';

  // Store App API's Endpoints
  static const String kListAllShops = 'shop/home/shoplist';
  static const String kListPopularCategories = 'shop/home/popular-categories';
  static const String kListGlobalCategories =
      'shop/home/sellerglobalcategories';
  static const String kSendContactUs = 'shop/contactus';
  static const String kDishDetails = 'shop/dish';
  static const String kListProductsByCategory = 'shop/products';
  static const String kListProductsByCategoryName =
      'shop/products_with_category_name';
  static const String kListProductsUpdatedMinData =
      'shop/products_updated_min_data';
  static const String kProductsPagination = 'shop/products/pagination';
  static const String kProductsPaginationMinData =
      'shop/products/pagination_min_data';
  static const String kSearchProducts = 'shop/products/searchproducts';
  static const String kRelatedProducts = 'shop/products/relatedproducts';
  static const String kProductGallery = 'shop/products/gallery';
  static const String kListParentCategories = 'shop/categories';
  static const String kRetrieveShopTiming = 'shop/timing/';
  static const String kRetrieveShopStatus = 'shop/status';
  static const String kRetrieveShopSettings = 'shop/settings/';
  static const String kAuthenticateShop = 'shop/authenticate';
  static const String kWPAuthenticateShop = 'shop/wp_authenticate';
  static const String kRetrieveShopPaymentOptions = 'shop/payment-options';
  static const String kShopDeliverySlots =
      'https://ordergro.com/v2/shop/deliveryslots/';
  static const String kDashBoardContents = 'shop/dashboard/';

  // Offer Endpoints
  static const String kListActiveOffers = 'shop/offer/list';
  static const String kValidateOneTimeVoucher =
      'shop/offer/validateonetimevoucher/';
  static const String kValidateCouponCode =
      'shop/user/offer/validatecoupencode';

  // Service endpoints
  static const String kDeliveryLocations = 'shop/service/deliverylocations';

  // Table reservation endpoints
  static const String kTableReservation = 'shop/user/table/reservation';
  static const String kReservationHistory =
      'shop/user/table/reservationhistory';

  // Dining table reservation endpoints
  static const String kDiningTableReservationNew =
      'shop/user/diningtable/reservation/new';
  static const String kDiningTableReservationSendOtp =
      'shop/user/diningtable/reservation/sendotp';
  static const String kDiningTableReservationView =
      'shop/user/diningtable/reservation/view';
  static const String kDiningTableReservationCancel =
      'shop/user/diningtable/reservation/cancel';
  static const String kDiningTableReservationUpdate =
      'shop/user/diningtable/reservation/update';
  static const String kDiningTableReservationSendMailToShop =
      'shop/user/diningtable/reservation/sendmailtoshop';
  static const String kDiningTableReservationCreatePaymentIntent =
      'shop/user/diningtable/reservation/createpaymentintent';
  static const String kDiningTableReservationHistory =
      'shop/user/diningtable/reservation/history/';

  // Checkout endpoints
  static const String kCompleteOrder = 'shop/user/checkout/complete';
  static const String kCompleteOrderWeb = 'shop/user/web/checkout/complete';
  static const String kTakeawayCalculator =
      'shop/user/checkout/takeawaycalculator';
  static const String kGuestTakeawayCalculator =
      'shop/guest/checkout/takeawaycalculator';
  static const String kDeliveryCalculator =
      'shop/user/checkout/deliverycalculator';
  static const String kGuestDeliveryCalculator =
      'shop/guest/checkout/deliverycalculator';
  static const String kCreatePaymentIntent =
      'shop/user/web/checkout/createpaymentintent';
  static const String kCancelPaymentIntent =
      'shop/user/web/checkout/cancelpaymentintent';
  static const String kCaptureAmount = 'shop/user/web/checkout/captureamount';
  //Promotions
  static const String kPromotion =
      'promotions/fetch-mobile-restaurent-promotions/';

  //search
  static const String kSearch = 'shop/seller/search';

  //OTP services

  static const String kSendPhoneOTP = 'shop/otpservices/sendotptophone';
  static const String kVerifyPhoneOTP = 'shop/otpservices/verifyotptophone';
}
