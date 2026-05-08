import 'package:auto_route/auto_route.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:dartx/dartx.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/payment/payment_provider.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/theme/app_theme.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/core/utils/date_utils.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/auth/login_screen.dart';
import 'package:customer_core/src/presentation/widgets/bottom_sheet_drag_handler.dart';
import 'package:customer_core/src/presentation/widgets/custom_close_icon.dart';

import '../../../application/order/order_provider.dart';
import '../../../core/theme/app_colors.dart';
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
    final paymentProvider = context.read<PaymentProvider>();

    final shopProvider = context.read<ShopProvider>();
    final shopListener = context.watch<ShopProvider>();

    final orderProvider = context.read<OrderProvider>();

    final userListener = context.read<UserProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // const outlinedBorder = OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.transparent),
    // );

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
          body: cartListener.isCartEmpty
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
                                  Tab(text: 'Delivery & Pay'),
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
                            value.deliveryOrTakeAwayChargeCalculating,
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

  Widget _buildShopClosed() {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.red.shade700)
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.3), // Shadow color
          //     blurRadius: 4, // Softness of the shadow
          //     spreadRadius: 0.3, // How much the shadow extends
          //     offset: const Offset(0, 2), // Position of the shadow (x, y)
          //   ),
          // ],
          ),
      height: 60,
      width: context.screenWidth * 0.9,
      child: Center(
        child: Text(
          "Sorry, We're closed now",
          style: TextStyle(color: Colors.red.shade700),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final cartListener = context.watch<CartProvider>();
    final cartProvider = context.read<CartProvider>();
    final shopListener = context.read<ShopProvider>();
    final paymentProvider = context.read<PaymentProvider>();
    final orderProvider = context.read<OrderProvider>();
    final userListener = context.watch<UserProvider>();

    return Visibility(
      visible: !cartListener.isCartEmpty &&
          !(cartListener.cartTransferring ||
              cartListener.deliveryOrTakeAwayChargeCalculating ||
              userListener.isUserAddressListLoading),
      child: cartListener.cartDetailsModel?.paymentOptions?.shopStatus ==
                  'closed' &&
              !cartListener.isCartEmpty
          ? _buildShopClosed()
          : Visibility(
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
                        offset:
                            const Offset(0, 2), // Position of the shadow (x, y)
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
                                    "${cartListener.cartTotalPriceDisplay}")),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final isLogged =
                                      await cartProvider.checkUserIsLogged();
                                  if (!isLogged) {
                                    // context.router.push(LoginScreenRoute());
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(
                                            showBackButton: true,
                                          ),
                                        ));
                                    if (result == true) {
                                      await cartProvider.transferCart();
                                      await context
                                          .read<UserProvider>()
                                          .getAddressList()
                                          .then(
                                        (_) {
                                          final addressList =
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .userAddressList;
                                          if (addressList.isNotEmpty) {
                                            final address = addressList.first;

                                            cartProvider
                                                .onChangeAddress(address);
                                            cartProvider.onChangeOrderType(
                                                OrderType.delivery);

                                            cartProvider
                                                .calculateDeliveryCharge();
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
                                      final addressList =
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .userAddressList;
                                      if (addressList.isNotEmpty) {
                                        final address = addressList.firstWhere(
                                          (element) => element.dDefault == '1',
                                          orElse: () => addressList.first,
                                        );

                                        cartProvider.onChangeAddress(address);
                                        cartProvider.onChangeOrderType(
                                            OrderType.delivery);

                                        // cartProvider.calculateDeliveryCharge();
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                         Icon(
                                          FluentIcons.cart_24_filled,
                                          color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                        ),
                                        horizontalSpaceSmall,
                                        Text("Checkout",
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
                                            if (cartListener.selectedAddress ==
                                                null) {
                                              AlertDialogs.showError(
                                                  "Please select an address",
                                                  context: context);
                                              return;
                                            }
                                            if (cartListener
                                                        .selectedOrderType ==
                                                    OrderType.takeaway &&
                                                cartListener
                                                        .selectedPickUpTime ==
                                                    null) {
                                              AlertDialogs.showError(
                                                  "Please select pickup time",
                                                  context: context);
                                              return;
                                            }
                                            if (cartListener
                                                        .selectedPaymentMethod ==
                                                    PaymentMethod.card &&
                                                cartListener.totalAmount <
                                                    shopListener
                                                        .onlinePaymentMinAmount) {
                                              AlertDialogs.showError(
                                                  "Minimum amount for the card payment is ￡${shopListener.onlinePaymentMinAmount}, Please choose another payment option",
                                                  context: context);
                                              return;
                                            }
                                            // if (shopListener.selectedDate == null) {
                                            //   AlertDialogs.showError("Please select an delivery date", context: context);
                                            //   return;
                                            // }
                                            // if (shopListener.selectedDeliverySlot == null) {
                                            //   AlertDialogs.showError("Please select an delivery time", context: context);
                                            //   return;
                                            // }
                                            cartProvider.jumpToPage(2);
                                          },
                                    child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Row(
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
                                    child: _buildTotalAmountWidget(cartListener
                                        .totalAmount
                                        .toStringAsFixed(AppConfig
                                            .instance.country.decimalPlaces))),
                                Expanded(
                                  child: InkWell(
                                    onTap: cartListener.createOrderPending
                                        ? null
                                        : () async {
                                            if (cartProvider
                                                    .selectedPaymentMethod ==
                                                PaymentMethod.card) {
                                              paymentProvider
                                                  .createPaymentIntent(
                                                      cartProvider
                                                          .calculatedDiscount,
                                                      cartProvider
                                                          .calculatedDeliveryFee,
                                                      onPaymentSuccess:
                                                          (transactionId) {
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
                                                        const Duration(
                                                            seconds: 2), () {
                                                      cartProvider
                                                          .resetValues();

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
                                                cartProvider
                                                    .clearSelectedAddress();
                                              }
                                            });
                                            await orderProvider
                                                .fetchAllOrders();
                                          },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: cartListener.createOrderPending
                                          ? const Center(
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.kBlack,
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
                                                        .customTextTheme
                                                        .text14W700
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface)),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                horizontalSpaceSmall,
                              ],
                            )),
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
