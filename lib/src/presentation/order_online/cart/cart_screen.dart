import 'package:auto_route/auto_route.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/core/utils/country_flag.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';
import 'package:dartx/dartx.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:customer_core/src/application/auth/auth_provider.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/otp/otp_provider.dart';
import 'package:customer_core/src/application/payment/payment_provider.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/theme/app_theme.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/core/utils/date_utils.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/otp/otp_purpose.dart';
import 'package:customer_core/src/domain/user/models/user.dart';
import 'package:customer_core/src/domain/user/models/user_login_response.dart';
import 'package:customer_core/src/presentation/auth/login_screen.dart';
import 'package:customer_core/src/presentation/widgets/bottom_sheet_drag_handler.dart';
import 'package:customer_core/src/presentation/widgets/custom_close_icon.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../application/order/order_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/country_flag.dart';
import '../../../core/utils/utils.dart';

import '../../widgets/button_progress.dart';
import 'cart_items_screen.dart';
import 'checkout_details.dart';
import 'delivery_details_screen.dart';

@RoutePage()
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Provider.of<CartProvider>(context, listen: false).initController(this, 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final cartListener = context.watch<CartProvider>();
    final shopProvider = context.read<ShopProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCartInProgress = cartListener.cartLoading ||
        cartListener.cartTransferring ||
        cartListener.deliveryOrTakeAwayChargeCalculating ||
        cartListener.isClearCartProgress;

    final showEmptyCartState = cartListener.isCartEmpty && !isCartInProgress;
    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (_) {
        cartProvider.resetValues();
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.quicksandTextTheme(),
          cardTheme: const CardTheme(
            margin: EdgeInsets.zero,
            color: AppColors.kWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildAppBar(context, cartListener, cartProvider),
          bottomSheet: _buildBottomSheet(
              cartListener, context, cartProvider, shopProvider),
          floatingActionButton: _buildFloatingActionButton(context),
          body: showEmptyCartState
              ? _buildIsEmptyWidget(context)
              : Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: cartProvider.listCartItems,
                      child: Column(
                        children: [
                          Visibility(
                            visible: cartListener.cartDeleteLoading ||
                                cartListener.isClearCartProgress,
                            child: LinearProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                              minHeight: 2.0,
                              backgroundColor:
                                  AppColors.kBlack2.withOpacity(0.1),
                            ),
                          ),
                          IgnorePointer(
                            // ignoring: shopListener.selectedDate == null ||
                            //     shopListener.selectedDeliverySlot == null ,
                            ignoring: false,
                            child: Container(
                              color: isDark
                                  ? Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor
                                  : Colors.white,
                              child: TabBar(
                                onTap: (value) {
                                  if (value == 1 ||
                                      value == 2 &&
                                          cartListener.guestID != null) {
                                    cartProvider.jumpToPage(0);
                                    return;
                                  }

                                  if (value == 2 &&
                                      cartListener.selectedAddress == null) {
                                    AlertDialogs.showError(
                                        "Please select an address",
                                        context: context);
                                    cartProvider.jumpToPage(1);
                                    return;
                                  }
                                  cartProvider.onchangeCartTabbarIndex(value);
                                },
                                controller: cartProvider.tabController,
                                labelColor:
                                    Theme.of(context).colorScheme.primary,
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                unselectedLabelColor: Colors.grey.shade400,
                                indicatorColor:
                                    Theme.of(context).colorScheme.primary,
                                dividerColor: Colors.transparent,

                                // isScrollable: true,
                                tabs: const <Widget>[
                                  Tab(text: 'Items'),
                                  Tab(
                                    child: Text(
                                      'Delivery & Pay',
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Tab(text: 'Checkout'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: cartProvider.tabController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: const [
                                CartItemsScreen(),
                                DeliveryDetailsScreen(),
                                CheckoutDetailsScreen()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer2<CartProvider, UserProvider>(
                      builder: (context, value, value2, child) => Visibility(
                        visible: value.cartTransferring ||
                            value2.isUserAddressListLoading ||
                            value.deliveryOrTakeAwayChargeCalculating ||
                            (value.cartLoading && value.isCartEmpty),
                        child: Positioned.fill(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: context.screenHeight,
                            width: context.screenWidth,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.kCardBackground2.withOpacity(0.8)
                                  : Colors.white.withOpacity(0.7),
                            ),
                            child: Center(
                              child: Shimmer.fromColors(
                                baseColor:
                                    Theme.of(context).colorScheme.primary,
                                highlightColor: Colors.grey,
                                child: Text(
                                  value.cartTransferring
                                      ? "Almost there… syncing your cart…"
                                      : value2.isUserAddressListLoading
                                          ? 'Loading your saved addresses…'
                                          : value.deliveryOrTakeAwayChargeCalculating
                                              ? 'Calculating charges…'
                                              : 'Loading…',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, CartProvider cartListener,
      CartProvider cartProvider) {
    return AppBar(
      elevation: 0.0,
      // leading: const CustomBackButton(),
      // automaticallyImplyLeading: false,

      leadingWidth: 70,
      title: Text(
        "Cart",
        style: context.customTextTheme.text18W600,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: [
        cartListener.isCartEmpty
            ? const SizedBox.shrink()
            : Visibility(
                visible: cartProvider.tabController.index == 0,
                child: TextButton(
                  // icon: const Icon(FluentIcons.delete_20_regular),
                  onPressed: () async {
                    await cartProvider.clearCart();
                    await cartProvider.listCartItems();
                  },
                  child: Text(
                    'Clear',
                    style: context.customTextTheme.text14W600
                        .copyWith(color: AppColors.kRed),
                  ),
                ),
              ),
        horizontalSpaceRegular
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppColors.kLightGray2,
          height: 1.0,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildIsEmptyWidget(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Assets.lib.assets.icons.emptyCart.image(
            width: 200.0,
          ),
          verticalSpaceRegular,
          Text(
            "Your cart is empty",
            style: context.customTextTheme.text18W600
                .copyWith(color: context.customTextTheme.color),
          ),
          verticalSpaceTiny,
          Text(
            "Add some items to your cart",
            style: context.customTextTheme.text16W500
                .copyWith(color: context.customTextTheme.color),
          ),
          verticalSpaceRegular,
          IconButton(
              onPressed: () => context.read<CartProvider>().listCartItems(),
              icon: Icon(
                FluentIcons.arrow_clockwise_20_filled,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
              ))
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final cartListener = context.watch<CartProvider>();
    final cartProvider = context.read<CartProvider>();
    final shopListener = context.read<ShopProvider>();
    final paymentProvider = context.read<PaymentProvider>();
    final paymentListener = context.watch<PaymentProvider>();
    final orderProvider = context.read<OrderProvider>();
    final userListener = context.watch<UserProvider>();
    final userProvider = context.read<UserProvider>();
    final authProvider = context.read<AuthProvider>();
    final storeSettings = shopListener.storeSettings.data;
    final smsRequired = storeSettings?.smsVerification == "Enabled";

    final isTakeAwayTempEnabled =
        storeSettings?.deliveryInfo?.takeAway_temp_off != null &&
            storeSettings?.deliveryInfo?.takeAway_temp_off == 'No';
    final isHomeDeliveryTempEnabled =
        storeSettings?.deliveryInfo?.homeDelivery_temp_off != null &&
            storeSettings?.deliveryInfo?.homeDelivery_temp_off == 'No';
    final isHomeDeliveryEnabled = isHomeDeliveryTempEnabled &&
        storeSettings?.deliveryInfo?.homeDelivery != null &&
        storeSettings?.deliveryInfo?.homeDelivery == '1';
    final isTakeAwayEnabled = isTakeAwayTempEnabled &&
        storeSettings?.deliveryInfo?.takeAway != null &&
        storeSettings?.deliveryInfo?.takeAway == '1';
    final isShopTempClosed =
        storeSettings?.deliveryInfo?.shopOpen_temp_off == 'Yes';
    final isShopClosed =
        cartListener.cartDetailsModel?.paymentOptions?.shopStatus == 'closed';
    final isShopClosedInactive =
        (isShopClosed && !cartListener.isCartEmpty) || isShopTempClosed;

    return Visibility(
      visible: !cartListener.isCartEmpty &&
          !(cartListener.cartTransferring ||
              cartListener.deliveryOrTakeAwayChargeCalculating ||
              userListener.isUserAddressListLoading),
      child: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.kCardBackground2
                : Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                blurRadius: 4, // Softness of the shadow
                spreadRadius: 0.3, // How much the shadow extends
                offset: const Offset(0, 2), // Position of the shadow (x, y)
              ),
            ],
          ),
          height: 60,
          width: context.screenWidth * 0.9,
          child: cartListener.tabController.index == 0
              ? Row(
                  children: [
                    Expanded(
                        child: _buildTotalAmountWidget(
                            "${cartListener.cartDetailsModel?.cartTotal?.cartTotalPriceDisplay}")),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (isShopClosedInactive) {
                            AlertDialogs.showError(
                                "Shop is temporarily closed. Please try again later.",
                                context: context);
                            return;
                          }
                          final isLogged =
                              await cartProvider.checkUserIsLogged();
                          if (!isLogged) {
                            // context.router.push(LoginScreenRoute());
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen(showBackButton: true),
                                ));
                            if (result == true) {
                              await cartProvider.transferCart();
                              await context
                                  .read<UserProvider>()
                                  .getAddressList()
                                  .then(
                                (_) {
                                  final addressList = Provider.of<UserProvider>(
                                          context,
                                          listen: false)
                                      .userAddressList;
                                  if (addressList.isNotEmpty) {
                                    final address = addressList.first;

                                    cartProvider.onChangeAddress(address);
                                    cartProvider
                                        .onChangeOrderType(OrderType.delivery);

                                    // cartProvider
                                    //     .calculateDeliveryCharge();
                                    cartProvider.jumpToPage(1);
                                    return;
                                  }
                                },
                              ).catchError((e) {
                                setState(() {});
                              });
                            }
                            return;
                          }
                          cartProvider.jumpToPage(1);
                          shopListener.clearSelectedDeliverySlot();
                          await context
                              .read<UserProvider>()
                              .getAddressList()
                              .then(
                            (_) {
                              final addressList = Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .userAddressList;
                              if (addressList.isNotEmpty) {
                                final address = addressList.firstWhere(
                                  (element) => element.dDefault == '1',
                                  orElse: () => addressList.first,
                                );

                                cartProvider.onChangeAddress(address);
                                if (!isHomeDeliveryEnabled &&
                                    isTakeAwayEnabled) {
                                  cartProvider
                                      .onChangeOrderType(OrderType.takeaway);
                                } else {
                                  cartProvider
                                      .onChangeOrderType(OrderType.delivery);
                                }
                                cartProvider.jumpToPage(1);
                                return;
                              }
                            },
                          ).catchError((e) {
                            setState(() {});
                          });
                        },
                        child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FluentIcons.cart_24_filled,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                horizontalSpaceSmall,
                                Text("Checkout",
                                    style: context.customTextTheme.text14W700
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface)),
                              ],
                            )),
                      ),
                    ),
                    horizontalSpaceSmall,
                  ],
                )
              : cartListener.tabController.index == 1
                  ? Row(
                      children: [
                        Expanded(
                            child: _buildTotalAmountWidget(
                                "${AppConfig.instance.country.symbol} ${cartListener.totalAmount.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}")),
                        Expanded(
                          child: InkWell(
                            onTap: cartProvider.createOrderPending
                                ? null
                                : () async {
                                    // Validate address / delivery charges first
                                    if (cartListener.selectedOrderType ==
                                        OrderType.delivery) {
                                      final validated =
                                          await cartProvider.validateAddress();
                                      if (!validated) return;
                                    } else {
                                      if (cartListener.selectedPickUpTime ==
                                          null) {
                                        AlertDialogs.showError(
                                            "Please select pickup time",
                                            context: context);
                                        return;
                                      }
                                      // ensure takeaway calculations present
                                      final ok =
                                          cartProvider.validateInputData();
                                      if (!ok) return;
                                    }

                                    if (cartListener.selectedPaymentMethod ==
                                            PaymentMethod.card &&
                                        cartListener.totalAmount <
                                            shopListener
                                                .onlinePaymentMinAmount) {
                                      AlertDialogs.showError(
                                          "Minimum amount for the card payment is ￡${shopListener.onlinePaymentMinAmount}, Please choose another payment option",
                                          context: context);
                                      return;
                                    }

                                    // Skip mobile verification for card payments
                                    if (cartListener.selectedPaymentMethod !=
                                        PaymentMethod.card) {
                                      final user = userProvider.userData?.user;

                                      // SMS verification disabled but no phone number
                                      if (!smsRequired &&
                                          (user?.userMobile == '0' ||
                                              user!.userMobile!
                                                  .trim()
                                                  .isEmpty)) {
                                        final phoneAdded =
                                            await mobileNumberDialog(context);

                                        if (!phoneAdded) return;

                                        cartProvider.jumpToPage(2);
                                        return;
                                      }

                                      // SMS verification enabled
                                      if (smsRequired &&
                                          user?.isMobileVerified != "Yes") {
                                        final verified =
                                            await mobileVerificationDialog(
                                                context);

                                        if (!verified) return;

                                        cartProvider.jumpToPage(2);
                                        return;
                                      }
                                    }

                                    cartProvider.jumpToPage(2);
                                  },
                            child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FluentIcons.check_24_regular,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    horizontalSpaceSmall,
                                    Text("Confirm",
                                        style: context
                                            .customTextTheme.text14W700
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface)),
                                  ],
                                )),
                          ),
                        ),
                        horizontalSpaceSmall,
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                            child: _buildTotalAmountWidget(
                                "${AppConfig.instance.country.symbol} ${cartListener.totalAmount.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}")),
                        Expanded(
                          child: InkWell(
                            onTap: cartListener.createOrderPending
                                ? null
                                : () async {
                                    // Validate address / delivery charges before payment
                                    if (cartProvider.selectedOrderType ==
                                        OrderType.delivery) {
                                      final validated =
                                          await cartProvider.validateAddress();
                                      if (!validated) return;
                                    } else {
                                      final ok =
                                          cartProvider.validateInputData();
                                      if (!ok) return;
                                    }

                                    if (cartProvider.selectedPaymentMethod ==
                                        PaymentMethod.card) {
                                      paymentProvider.createPaymentIntent(
                                          deliveryType:
                                              cartProvider.selectedOrderType ==
                                                      OrderType.delivery
                                                  ? "door_delivery"
                                                  : "store_pickup",
                                          postCode:
                                              cartProvider.selectedOrderType ==
                                                      OrderType.delivery
                                                  ? cartProvider.selectedAddress
                                                          ?.postcode ??
                                                      ""
                                                  : "",
                                          pickupTime: cartProvider
                                                      .selectedOrderType ==
                                                  OrderType.takeaway
                                              ? cartProvider.selectedPickUpTime
                                                      ?.toIso8601String() ??
                                                  ''
                                              : '',
                                          cartProvider.calculatedDiscount,
                                          cartProvider.calculatedDeliveryFee,
                                          onPaymentSuccess: (transactionId) {
                                        cartProvider
                                            .createOrder(
                                                tID: transactionId,
                                                deliveryDate: shopListener
                                                    .formattedSelectedDate,
                                                deliverySlot:
                                                    "${shopListener.selectedDeliverySlot?.openingTime}--${shopListener.selectedDeliverySlot?.closingTime}")
                                            .then((created) {
                                          if (created) {
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              cartProvider.resetValues();

                                              context.replaceRoute(
                                                  const SuccessScreenRoute());
                                            });
                                          }
                                        });
                                      });
                                      return;
                                    }

                                    cartProvider
                                        .createOrder(
                                            deliveryDate: shopListener
                                                .formattedSelectedDateForPayload,
                                            deliverySlot:
                                                "${shopListener.selectedDeliverySlot?.openingTime}--${shopListener.selectedDeliverySlot?.closingTime}")
                                        .then((created) {
                                      if (created) {
                                        context.replaceRoute(
                                            const SuccessScreenRoute());

                                        cartProvider.resetValues();
                                        // orderProvider.fetchAllOrders();
                                        cartProvider
                                            .clearSelectedAddressSecondary();
                                        cartProvider.clearSelectedAddress();
                                      }
                                    });
                                    await orderProvider.fetchAllOrders();
                                  },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: cartListener.createOrderPending
                                  ? Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    )
                                  : paymentListener.creatingPaymentIntent
                                      ? Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FluentIcons.check_24_regular,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                            horizontalSpaceSmall,
                                            Text("Pay",
                                                style: context
                                                    .customTextTheme.text14W700
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface)),
                                          ],
                                        ),
                            ),
                          ),
                        ),
                        horizontalSpaceSmall,
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildTotalAmountWidget(String amount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Total Amount".toUpperCase(),
          style: context.customTextTheme.text12W500.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : null),
        ),
        Text(
          amount,
          style: context.customTextTheme.text20W400.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : null),
        ),
      ],
    );
  }

  Widget _buildBottomSheet(CartProvider cartListener, BuildContext context,
      CartProvider cartProvider, ShopProvider shopProvider) {
    return Visibility(
      // visible: !cartListener.isCartEmpty,
      visible: false,
      child: Container(
        height: 82.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ).copyWith(right: 16.0),
          child: Row(
            children: <Widget>[
              Text(
                "${cartListener.totalCartItems} items",
                style: context.customTextTheme.text18W600.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
              const VerticalDivider(
                indent: 10.0,
                endIndent: 10.0,
                width: 40.0,
              ),
              Text(
                Utils.format(cartListener.totalAmount),
                style: context.customTextTheme.text18W600.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 2,
                child: FilledButton(
                  onPressed: !cartListener.deliveryOrTakeAwayChargeCalculating
                      ? () async {
                          if (cartProvider.validateInputData() &&
                              shopProvider.validateInputData()) {
                            context.pushRoute(
                              const CheckoutScreenRoute(),
                            );
                          }
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.kWhite,
                    disabledBackgroundColor: AppColors.kWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0,
                    foregroundColor: AppColors.kBlack2,
                    disabledForegroundColor: AppColors.kBlack2,
                    textStyle: context.customTextTheme.text16W600,
                  ),
                  child: const Text("Checkout"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row BuildDeliveryCard(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            children: [
              // Text and Icon
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Home\nDelivery',
                          style: context.customTextTheme.text14W700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Positioned Image
              Positioned(
                right: 6,
                bottom: 5,
                child: Image.asset(
                  'assets/images/homeDelivery.png',
                  width: 60,
                  height: 50,
                ),
              ),
              // Checkmark for selected item
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Text and Icon
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kBlack3,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Take\nAway',
                          style: context.customTextTheme.text14W700
                              .copyWith(color: AppColors.kWhite),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Positioned Image
              Positioned(
                right: -10,
                bottom: -10,
                child: Image.asset(
                  'assets/images/takeAway.png',
                  width: 70,
                  height: 70,
                ),
              ),
              // Checkmark for selected item
            ],
          ),
        ),
      ],
    );
  }

  Future<void> showAddressListSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        enableDrag: true,
        showDragHandle: false,
        builder: (context) {
          final userListener = context.watch<UserProvider>();
          final cartListener = context.watch<CartProvider>();
          final storeSettings = context.read<ShopProvider>().storeSettings.data;

          final isTakeAwayTempEnabled =
              storeSettings?.deliveryInfo?.takeAway_temp_off != null &&
                  storeSettings?.deliveryInfo?.takeAway_temp_off == 'No';
          final isHomeDeliveryTempEnabled =
              storeSettings?.deliveryInfo?.homeDelivery_temp_off != null &&
                  storeSettings?.deliveryInfo?.homeDelivery_temp_off == 'No';
          final isHomeDeliveryEnabled = isHomeDeliveryTempEnabled &&
              storeSettings?.deliveryInfo?.homeDelivery != null &&
              storeSettings?.deliveryInfo?.homeDelivery == '1';
          final isTakeAwayEnabled = isTakeAwayTempEnabled &&
              storeSettings?.deliveryInfo?.takeAway != null &&
              storeSettings?.deliveryInfo?.takeAway == '1';
          return Theme(
            data: quickSandTextTheme(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const RoundedCloseIcon(),
                verticalSpaceRegular,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: userListener.userAddressList.isNotEmpty
                      ? context.screenHeight * 0.8
                      : context.screenHeight * 0.3,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.kOffWhite4,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      verticalSpaceSmall,
                      const BottomSheetDragHandler(),
                      verticalSpaceRegular,
                      Text(
                        'Delivery Address',
                        style: context.customTextTheme.text18W600,
                      ),
                      verticalSpaceRegular,
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Assets.lib.assets.icons.searchNormal.svg(
                              height: 16,
                              width: 16,
                              fit: BoxFit.contain,
                            ),
                          ),
                          isDense: true,
                          fillColor: AppColors.kLightBlue2,
                          filled: true,
                          hintText: 'Look for a Postcode...',
                          hintStyle:
                              context.customTextTheme.text16W500.copyWith(
                            color: AppColors.kGray3,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                      verticalSpaceMedium,
                      userListener.userAddressList.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: userListener.userAddressList.length,
                              itemBuilder: (context, index) {
                                final address =
                                    userListener.userAddressList[index];

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.1),
                                        spreadRadius: 0,
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListTileTheme(
                                          horizontalTitleGap: 8.0,
                                          // contentPadding: const EdgeInsets.all(0.0),
                                          child: RadioListTile(
                                            value: address,
                                            groupValue:
                                                cartListener.selectedAddress,
                                            onChanged: (address) {
                                              if (address == null) return;
                                              context
                                                  .read<CartProvider>()
                                                  .onChangeAddress(address);
                                              if (!isHomeDeliveryEnabled &&
                                                  isTakeAwayEnabled) {
                                                context
                                                    .read<CartProvider>()
                                                    .onChangeOrderType(
                                                        OrderType.takeaway);
                                              } else {
                                                context
                                                    .read<CartProvider>()
                                                    .onChangeOrderType(
                                                        OrderType.delivery);
                                              }
                                            },
                                            // title: Text(
                                            //   address.addressTitle ?? "",
                                            //   style: context
                                            //       .customTextTheme.text18W600,
                                            // ),
                                            title: Text(
                                              Utils.removeExtraSpaces(address
                                                  .userFulladdress
                                                  .capitalize()),
                                              style: context
                                                  .customTextTheme.text16W400
                                                  .copyWith(
                                                      color: AppColors.kGray),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              context
                                                  .read<UserProvider>()
                                                  .initAllTextEditingController();
                                              context.router.push(
                                                AddNewAddressScreenRoute(
                                                  address: address,
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: Assets
                                                  .lib.assets.icons.editIcon
                                                  .svg(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Center(
                                                    child: Text(
                                                  'Address',
                                                  style: context.customTextTheme
                                                      .text18W600
                                                      .copyWith(
                                                          color:
                                                              AppColors.kBlack),
                                                )),
                                                content: Text(
                                                  'Are you sure you want to delete this address?',
                                                  style: context.customTextTheme
                                                      .text16W400
                                                      .copyWith(
                                                          color:
                                                              AppColors.kBlack),
                                                ),
                                                actions: <Widget>[
                                                  Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        OutlinedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        ElevatedButton(
                                                          style:
                                                              const ButtonStyle(
                                                            backgroundColor:
                                                                WidgetStatePropertyAll(
                                                                    AppColors
                                                                        .kBlack),
                                                          ),
                                                          onPressed: () {
                                                            userListener
                                                                .deleteUserAddress(
                                                                    address.uaID
                                                                        .toString())
                                                                .then(
                                                                    (success) {
                                                              if (success) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                context
                                                                    .read<
                                                                        UserProvider>()
                                                                    .getAddressList();
                                                              }
                                                            });
                                                          },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .kWhite),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: AppColors.kGray,
                                        ),
                                      )

                                      // IconButton(
                                      //   onPressed: () {
                                      //     userListener.deleteUserAddress(
                                      //         address.uaID.toString()).then((success) {
                                      //       if (success) {
                                      //         context
                                      //             .read<UserProvider>()
                                      //             .getAddressList();
                                      //       }
                                      //     });
                                      //   },
                                      //   icon: const Icon(Icons.remove_circle_outline,
                                      //       color: AppColors.kGray),
                                      // )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return verticalSpaceRegular;
                              },
                            ))
                          : Center(
                              child: Text(
                                'No address found',
                                style: context.customTextTheme.text16W600,
                              ),
                            ),
                      const Divider(height: 30.0, color: AppColors.kLightGray2),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton.icon(
                            onPressed: () {
                              context
                                  .read<UserProvider>()
                                  .initAllTextEditingController();
                              context.router.push(
                                  AddNewAddressScreenRoute(address: null));
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            label: Text(
                              '+ Add Adress',
                              style: context.customTextTheme.text14W600,
                            ),
                          )),
                          horizontalSpaceSmall,
                          Visibility(
                            visible: userListener.userAddressList.isNotEmpty,
                            child: Expanded(
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<CartProvider>()
                                      .validateAddress()
                                      .then((validated) {
                                    if (validated) {
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: cartListener
                                          .deliveryOrTakeAwayChargeCalculating
                                      ? showButtonProgress()
                                      : Center(
                                          child: Text(
                                            'Apply',
                                            style: context
                                                .customTextTheme.text14W600
                                                .copyWith(
                                                    color: AppColors.kWhite),
                                          ),
                                        ),
                                ),
                              ),
                              // child: FilledButton(
                              //   onPressed: () {
                              //     context.read<CartProvider>().validateAddress().then((validated) {
                              //       if (validated) {
                              //         Navigator.pop(context);
                              //       }
                              //     });
                              //   },
                              //   child: cartListener.deliveryOrTakeAwayChargeCalculating
                              //       ? showButtonProgress()
                              //       : Text('Apply', style: context.customTextTheme.text14W600),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> showSlotChooseSheet(
      BuildContext context, ShopProvider shopProvider) async {
    return await showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        final shopListener = context.watch<ShopProvider>();

        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Available slots for ${shopListener.formattedSelectedDate}",
                style: context.customTextTheme.text16W500
                    .copyWith(color: AppColors.kBlack),
              ),
              shopListener.isSlotsEmpty
                  ? Text(
                      "No Slots available for the slected date",
                      style: context.customTextTheme.text16W500
                          .copyWith(color: AppColors.kBlack),
                    )
                  : Wrap(
                      children: shopListener.slotForSelectedDate
                              ?.map((slot) => Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ChoiceChip(
                                        onSelected: (value) {
                                          if (value) {
                                            shopProvider
                                                .onChangeOnSelectedDeliverySlot(
                                                    slot);
                                          } else {
                                            shopProvider
                                                .onChangeOnSelectedDeliverySlot(
                                                    null);
                                          }
                                        },
                                        label: Text(
                                            "${slot.openingTime} - ${slot.closingTime}"),
                                        selected:
                                            shopListener.selectedDeliverySlot ==
                                                slot),
                                  ))
                              .toList() ??
                          [],
                    ),
              verticalSpaceSmall,
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  width: context.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                      child: Text(
                    shopListener.isSlotsEmpty
                        ? "CHOOSE ANOTHER DATE"
                        : "CONFIRM",
                    style: context.customTextTheme.text14W600
                        .copyWith(color: AppColors.kWhite),
                  )),
                ),
              ),
              verticalSpaceRegular,
            ],
          ),
        );
      },
    );
  }

  Widget _buildTakeAwayTimeWidget() {
    return Builder(builder: (context) {
      final cartListener = context.watch<CartProvider>();
      final cartProvider = context.read<CartProvider>();
      return InkWell(
        onTap: () async {
          final TimeOfDay? pickUpTime = await showTimePicker(
            context: context,
            initialTime: cartListener.selectedPickUpTime != null
                ? TimeOfDay(
                    hour: cartListener.selectedPickUpTime!.hour,
                    minute: cartListener.selectedPickUpTime!.minute)
                : DateTimeUtils.addMinutesToTime(TimeOfDay.now(), 15),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  dialogBackgroundColor: AppColors.kWhite,
                  textTheme: poppinsTextTheme(context).textTheme,
                  timePickerTheme: TimePickerThemeData(
                      backgroundColor: AppColors.kLightWhite2,
                      dialBackgroundColor: AppColors.kLightGray2,
                      dayPeriodColor: WidgetStateColor.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.kBlack2;
                          }
                          return AppColors.kLightWhite2;
                        },
                      ),
                      hourMinuteColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.kBlack2;
                        }
                        return AppColors.kLightWhite2;
                      }),
                      hourMinuteTextColor: WidgetStateColor.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.kWhite;
                          }
                          return AppColors.kGray;
                        },
                      ),
                      dayPeriodTextColor: WidgetStateColor.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.kWhite;
                          }
                          return AppColors.kGray;
                        },
                      )),
                ),
                child: child!,
              );
            },
          );

          if (pickUpTime == null) return;
          cartProvider.onChangePickUpTime(
            DateTimeUtils.combineDateTime(DateTime.now(), pickUpTime),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(FluentIcons.clock_24_regular),
            horizontalSpaceSmall,
            Expanded(
              child: Text(
                cartListener.selectedPickUpTime == null
                    ? "Select Pick Time"
                    : "Pickup on ${DateTimeUtils.formatDateTimeToTime(
                        cartListener.selectedPickUpTime!,
                      )}",
                style: context.customTextTheme.text16W600,
              ),
            ),
            Visibility(
              visible: cartListener.selectedPickUpTime != null,
              child: Text(
                "CHANGE",
                style: context.customTextTheme.text14W600,
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Shows a mobile verification dialog
  Future<bool> mobileVerificationDialog(BuildContext context) async {
    final otpProvider = context.read<OtpProvider>();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const _MobileVerificationDialogContent();
      },
    );

    // Clean up OTP resources regardless of how dialog was dismissed
    otpProvider.stopTimer();
    otpProvider.clear();
    return result ?? false;
  }
}

Future<bool> mobileNumberDialog(BuildContext context) async {
  final authProvider = context.read<AuthProvider>();
  final userProvider = context.read<UserProvider>();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final shopProvider = context.read<ShopProvider>();
  String countryCode =
      shopProvider.selectedCountry?.code ?? AppConfig.instance.country.dialCode;
  authProvider.registerUserPhoneController.clear();

  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Column(
                  children: [
                    verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone_android_rounded,
                            color: Theme.of(context).colorScheme.primary),
                        horizontalSpaceSmall,
                        Text(
                          "Add Mobile Number",
                          style: context.customTextTheme.text18W600,
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    Text(
                      "A mobile number is required to place your order.",
                      style: context.customTextTheme.text14W500.copyWith(
                          // color: AppColors.kGray3,
                          ),
                    ),
                  ],
                ),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: AppColors.kGray3),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Row(
                      //     children: [
                      // Container(
                      //   padding:
                      //       const EdgeInsets.symmetric(horizontal: 12),
                      //   decoration: BoxDecoration(
                      //     border: Border(
                      //       right: BorderSide(color: AppColors.kGray3),
                      //     ),
                      //   ),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton<String>(
                      //       value: shopProvider.selectedCountry?.code ??
                      //           AppConfig.instance.country.dialCode,
                      //       isDense: true,
                      //       icon: const Icon(Icons.arrow_drop_down),
                      //       style: context.customTextTheme.text14W500,
                      //       items:
                      //           shopProvider.smsCountries.map((country) {
                      //         return DropdownMenuItem(
                      //           value: country.code,
                      //           child: Row(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               Text(
                      //                 countryCodeToEmoji(
                      //                     country.iso ?? ""),
                      //                 style:
                      //                     const TextStyle(fontSize: 16),
                      //               ),
                      //               const SizedBox(width: 6),
                      //               Text(
                      //                 country.code ?? "",
                      //                 style:
                      //                     const TextStyle(fontSize: 14),
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       }).toList(),
                      //       onChanged: (value) {
                      //         if (value != null) {
                      //           final country = shopProvider.smsCountries
                      //               .firstWhere((c) => c.code == value);
                      //           shopProvider
                      //               .updateSelectedCountry(country);
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: TextFormField(
                      //     controller:
                      //         authProvider.registerUserPhoneController,
                      //     keyboardType: TextInputType.phone,
                      //     decoration: InputDecoration(
                      //       labelText: 'Mobile Number',
                      //       hintText: 'Enter mobile number',
                      //       hintStyle:
                      //           const TextStyle(color: AppColors.kGray),
                      //       prefixIcon: const Icon(Icons.phone_outlined),
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //           borderSide: BorderSide.none),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         // borderSide:
                      //         //     BorderSide(color: Colors.grey.shade300),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         // borderSide: const BorderSide(
                      //         //   color: Colors.grey,
                      //         // ),
                      //       ),
                      //       contentPadding: const EdgeInsets.symmetric(
                      //         horizontal: 16,
                      //         vertical: 16,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      TextFormField(
                        controller: authProvider.registerUserPhoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                            shopProvider.selectedCountry?.code == "+91"
                                ? 10
                                : 12,
                          ),
                        ],
                        autovalidateMode: AutovalidateMode.disabled,
                        decoration: InputDecoration(
                          // hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          labelText: 'Mobile Number',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: AppColors.kGray3),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: AppColors.kGray3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: AppColors.kRed, width: 1.2),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: AppColors.kRed, width: 1.5),
                          ),
                          prefix: DropdownButtonHideUnderline(
                            child: DropdownButton<SmsAvailableCountriesData>(
                              value: shopProvider.selectedCountry,
                              isDense: true,
                              dropdownColor: Colors.white,
                              icon: const Icon(Icons.arrow_drop_down),
                              underline: const SizedBox.shrink(),
                              selectedItemBuilder: (context) {
                                return shopProvider.smsCountries.map((country) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        countryCodeToEmoji(country.iso ?? ""),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        country.code ?? "",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  );
                                }).toList();
                              },
                              items: shopProvider.smsCountries.map((country) {
                                return DropdownMenuItem(
                                  value: country,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        countryCodeToEmoji(country.iso ?? ""),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        country.code ?? "",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  final oldCountryCode =
                                      shopProvider.selectedCountry?.code;
                                  final newCountryCode = value.code;

                                  if (oldCountryCode != newCountryCode) {
                                    authProvider.registerUserPhoneController
                                        .clear();
                                    authProvider.phoneFormKey.currentState
                                        ?.reset();
                                  }
                                  shopProvider.updateSelectedCountry(value);
                                  setDialogState(() {
                                    countryCode = value.code ??
                                        AppConfig.instance.country.dialCode;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        validator: (value) {
                          final phone = value?.trim() ?? '';
                          if (phone.isEmpty) {
                            return "Please enter your mobile number";
                          }
                          if (countryCode == "+91") {
                            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                              return "Enter a valid Indian mobile number";
                            }
                          } else if (countryCode == "+44") {
                            if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
                              return "Enter a valid UK mobile number";
                            }
                          }
                          return '';
                        },
                      ),
                      //   ],
                      // ),
                      // ),
                      // verticalSpaceSmall,
                      // Text(
                      //   "Example: 7700000000",
                      //   style: context.customTextTheme.text12W500
                      //       .copyWith(color: AppColors.kGray3),
                      //   textAlign: TextAlign.start,
                      // ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.pop(dialogContext, false),
                    child: Text(
                      "Cancel",
                      style: context.customTextTheme.text14W600,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            setDialogState(() => isLoading = true);

                            final success =
                                await userProvider.updateBasicProfile(
                              firstName:
                                  userProvider.userData?.user.userFirstName ??
                                      "",
                              lastName:
                                  userProvider.userData?.user.userLastName ??
                                      "",
                              mobile: authProvider
                                  .registerUserPhoneController.text
                                  .trim(),
                            );

                            if (success && context.mounted) {
                              // Update local user data with the new mobile number
                              if (userProvider.userData != null) {
                                final phone = authProvider
                                    .registerUserPhoneController.text
                                    .trim();
                                final countryCode =
                                    userProvider.userData!.user.countryCode ??
                                        AppConfig.instance.country.dialCode;
                                final updatedUserData =
                                    userProvider.userData!.copyWith(
                                  user: userProvider.userData!.user.copyWith(
                                    userMobile: "$countryCode$phone",
                                    userMobileActual: phone,
                                  ),
                                );
                                await userProvider.sharedPrefsRepository
                                    .saveUserData(updatedUserData);
                                await userProvider.getUserData();
                              }
                              Navigator.pop(context, true);
                            }
                          },
                    // child: isLoading
                    //     ? const SizedBox(
                    //         height: 16,
                    //         width: 16,
                    //         child: CircularProgressIndicator(
                    //           strokeWidth: 2,
                    //           color: AppColors.kWhite,
                    //         ),
                    //       )
                    // :
                    child: Text(
                      "Save",
                      style: context.customTextTheme.text14W600
                          .copyWith(color: AppColors.kWhite),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ) ??
      false;
}

/// Internal widget for the mobile verification dialog content.
/// Handles phone number input and OTP verification steps.
class _MobileVerificationDialogContent extends StatefulWidget {
  const _MobileVerificationDialogContent();

  @override
  State<_MobileVerificationDialogContent> createState() =>
      _MobileVerificationDialogContentState();
}

class _MobileVerificationDialogContentState
    extends State<_MobileVerificationDialogContent> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final _otpFormKey = GlobalKey<FormState>();
  bool otpSent = false;
  String countryCode = '';

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    final shopProvider = context.read<ShopProvider>();

    final user = userProvider.userData?.user;
    phoneController.text = user?.userMobileActual ?? user?.userMobile ?? '';

    // Use the country code from the login response if available, or infer from user profile / selected country
    final rawCountryCode = user?.countryCode?.trim() ?? '';
    final formattedCode = user?.formattedCountryCode.trim() ?? '';
    final mobile = (user?.userMobileActual?.trim().isNotEmpty == true
            ? user!.userMobileActual!
            : user?.userMobile?.trim() ?? '')
        .trim();

    SmsAvailableCountriesData? matchingCountry;

    // 1. Try matching using countryCode or formattedCountryCode
    final targetCode =
        rawCountryCode.isNotEmpty ? rawCountryCode : formattedCode;
    if (targetCode.isNotEmpty) {
      final cleanTarget = targetCode.replaceAll('+', '').toLowerCase();
      matchingCountry = shopProvider.smsCountries
          .cast<SmsAvailableCountriesData?>()
          .firstWhere(
        (c) {
          if (c == null) return false;
          final cCode = (c.code ?? '').replaceAll('+', '').toLowerCase().trim();
          final cIso = (c.iso ?? '').toLowerCase().trim();
          return cCode == cleanTarget || cIso == cleanTarget;
        },
        orElse: () => null,
      );
    }

    // 2. If no match yet, try matching against mobile number prefix
    if (matchingCountry == null && mobile.isNotEmpty) {
      final cleanMobile = mobile.replaceAll('+', '').trim();
      matchingCountry = shopProvider.smsCountries
          .cast<SmsAvailableCountriesData?>()
          .firstWhere(
        (c) {
          if (c == null) return false;
          final cCode = (c.code ?? '').replaceAll('+', '').toLowerCase().trim();
          return cCode.isNotEmpty && cleanMobile.startsWith(cCode);
        },
        orElse: () => null,
      );
    }

    if (matchingCountry != null) {
      shopProvider.updateSelectedCountry(matchingCountry);
      countryCode = matchingCountry.code ?? AppConfig.instance.country.dialCode;
    } else {
      countryCode = shopProvider.selectedCountry?.code ??
          AppConfig.instance.country.dialCode;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = context.read<OtpProvider>();
    final userProvider = context.read<UserProvider>();
    final otpListener = context.watch<OtpProvider>();
    final authProvider = context.read<AuthProvider>();
    final shopProvider = context.watch<ShopProvider>();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpaceSmall,
              Icon(Icons.phone_android_rounded,
                  color: Theme.of(context).colorScheme.primary),
              horizontalSpaceSmall,
              Text(
                "Mobile Verification",
                style: context.customTextTheme.text18W600,
              ),
            ],
          ),
          if (!otpSent) ...[
            verticalSpaceTiny,
            Text(
              "Enter your mobile number to verify",
              textAlign: TextAlign.center,
              style: context.customTextTheme.text14W500,
            ),
          ],
        ],
      ),
      content: Form(
        key: _otpFormKey,
        child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!otpSent)
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                        shopProvider.selectedCountry?.code == "+91" ? 10 : 12,
                      ),
                    ],
                    autovalidateMode: AutovalidateMode.disabled,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      labelText: 'Mobile Number',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.kGray3),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.kGray3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: AppColors.kRed, width: 1.2),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: AppColors.kRed, width: 1.5),
                      ),
                      prefix: DropdownButtonHideUnderline(
                        child: DropdownButton<SmsAvailableCountriesData>(
                          value: shopProvider.selectedCountry,
                          isDense: true,
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down),
                          underline: const SizedBox.shrink(),
                          selectedItemBuilder: (context) {
                            return shopProvider.smsCountries.map((country) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    countryCodeToEmoji(country.iso ?? ""),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    country.code ?? "",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                          items: shopProvider.smsCountries.map((country) {
                            return DropdownMenuItem(
                              value: country,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    countryCodeToEmoji(country.iso ?? ""),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    country.code ?? "",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              final oldCountryCode =
                                  shopProvider.selectedCountry?.code;
                              final newCountryCode = value.code;

                              if (oldCountryCode != newCountryCode) {
                                authProvider.registerUserPhoneController
                                    .clear();
                                authProvider.phoneFormKey.currentState?.reset();
                              }
                              shopProvider.updateSelectedCountry(value);
                              setState(() {
                                countryCode = value.code ??
                                    AppConfig.instance.country.dialCode;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    validator: (value) {
                      final phone = value?.trim() ?? '';
                      if (phone.isEmpty) {
                        return "Please enter your mobile number";
                      }
                      if (countryCode == "+91") {
                        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                          return "Enter a valid Indian mobile number";
                        }
                      } else if (countryCode == "+44") {
                        if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
                          return "Enter a valid UK mobile number";
                        }
                      }
                      return '';
                    },
                  )
                else ...[
                  Text(
                    "Enter the OTP sent to $countryCode ${phoneController.text}",
                    textAlign: TextAlign.center,
                    style: context.customTextTheme.text14W500,
                  ),
                  verticalSpaceRegular,
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.scale,
                    textStyle: TextStyle(color: AppColors.kBlack2),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.0),
                      activeColor: AppColors.kBlack2,
                      inactiveColor: AppColors.kBlack2,
                      inactiveFillColor: AppColors.kOffWhite3,
                      activeFillColor: AppColors.kOffWhite3,
                      selectedColor: AppColors.kBlack2,
                      selectedFillColor: AppColors.kOffWhite3,
                      fieldHeight: MediaQuery.of(context).size.height / 20,
                      fieldWidth: MediaQuery.of(context).size.width / 11,
                      fieldOuterPadding:
                          const EdgeInsets.symmetric(horizontal: 2),
                    ),
                    controller: otpController,
                    showCursor: false,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    keyboardType: TextInputType.phone,
                    onCompleted: (v) {},
                    onChanged: (value) {},
                    appContext: context,
                    autoDisposeControllers: false,
                  ),
                  if (otpListener.canResend)
                    TextButton(
                      onPressed: otpListener.loading
                          ? null
                          : () async {
                              await otpProvider.sendPhoneOtp(
                                phone: phoneController.text.trim(),
                                countryCode: countryCode,
                                purpose: OtpPurpose.phoneVerification,
                              );
                            },
                      child: const Text("Resend OTP"),
                    )
                  else
                    Text(
                      "Resend OTP in ${otpListener.seconds} seconds",
                      style: context.customTextTheme.text12W500
                          .copyWith(color: AppColors.kGray3),
                    ),
                ],
                verticalSpaceSmall,
                if (otpListener.loading)
                  const Center(child: CircularProgressIndicator()),
              ],
            )),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            "Cancel",
            style: context.customTextTheme.text14W600,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: otpListener.loading
              ? null
              : () async {
                  if (!otpSent) {
                    // Step 1: Send OTP
                    // if (!_otpFormKey.currentState!.validate()) {
                    //   return;
                    // }
                    final rawPhone = phoneController.text.trim();
                    final fullPhone = "$countryCode$rawPhone";
                    final sent = await otpProvider.sendPhoneOtp(
                      phone: rawPhone,
                      countryCode: countryCode,
                      purpose: OtpPurpose.phoneVerification,
                    );
                    if (sent && mounted) {
                      setState(() => otpSent = true);
                    }
                  } else {
                    // Step 2: Verify OTP
                    final otp = otpController.text.trim();
                    if (otp.isEmpty) {
                      AlertDialogs.showError("Please enter the OTP",
                          context: context);
                      return;
                    }
                    final rawPhone = phoneController.text.trim();
                    final fullPhone = "$countryCode$rawPhone";
                    final isValid = await otpProvider.verifyPhoneOtp(
                        phone: rawPhone,
                        countryCode: countryCode,
                        purpose: OtpPurpose.phoneVerification,
                        otp: otp,
                        userID: userProvider.userData?.user.userID ?? '',
                        userType: 'Registered');
                    if (isValid) {
                      if (userProvider.userData != null) {
                        final phone = phoneController.text.trim();
                        final formattedCountryCode = countryCode.startsWith('+')
                            ? countryCode
                            : '+$countryCode';
                        final updatedUserData = userProvider.userData!.copyWith(
                          user: userProvider.userData!.user.copyWith(
                            isMobileVerified: "Yes",
                            countryCode: formattedCountryCode,
                            userMobileActual: phone,
                            userMobile: "$formattedCountryCode$phone",
                          ),
                        );
                        await userProvider.sharedPrefsRepository
                            .saveUserData(updatedUserData);
                        await userProvider.getUserData();
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  }
                },
          child: Text(
            otpSent ? "Verify" : "Send OTP",
            style: context.customTextTheme.text14W600
                .copyWith(color: AppColors.kWhite),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? style;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style ?? context.customTextTheme.text14W500,
        ),
        Text(
          value,
          style: style ?? context.customTextTheme.text14W500,
        ),
      ],
    );
  }
}

class _SpikyEdgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start at top-left corner
    path.moveTo(0, 0);

    // Draw spikes
    const double spikeWidth = 16.0;
    const double spikeHeight = 10.0;
    for (double i = 0; i < size.width; i += spikeWidth) {
      path.lineTo(i + spikeWidth / 2, spikeHeight); // Go up for the spike
      path.lineTo(i + spikeWidth, 0); // Go back down
    }

    path.lineTo(size.width, size.height); // Bottom-right corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
