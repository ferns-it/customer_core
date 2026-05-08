import 'package:auto_route/auto_route.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:dartx/dartx.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/payment/payment_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/widgets/custom_back_button.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../widgets/button_progress.dart';

@RoutePage()
class CheckoutScreen extends GetProviderView<CartProvider> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = notifier(context);
    final cartListener = listener(context);

    final userListener = listener2<UserProvider>(context);
    final paymentProvider = notifier2<PaymentProvider>(context);
    final paymentListener = listener2<PaymentProvider>(context);

    final shopListner = listener2<ShopProvider>(context);

    final baseTextTheme = Theme.of(context).textTheme;
    final textTheme = GoogleFonts.quicksandTextTheme(baseTextTheme).apply(
      displayColor: AppColors.kBlack2,
      bodyColor: AppColors.kBlack2,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leadingWidth: 70,
        leading: const CustomBackButton(),
        centerTitle: true,
        title: const Text("Checkout"),
        backgroundColor: AppColors.kLightWhite2,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultScreenPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              verticalSpaceRegular,
              if (cartListener.selectedAddress != null) ...[
                Text(
                  cartListener.selectedOrderType == OrderType.takeaway
                      ? "Takeaway Details"
                      : "Delivery Details",
                  style: context.customTextTheme.text18W600,
                ),
                verticalSpaceSmall,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 10.0,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(FluentIcons.person_24_regular),
                          horizontalSpaceSmall,
                          Text(
                            (cartListener.selectedAddress?.userFullname ?? "")
                                .capitalize(),
                            style: GoogleFonts.quicksand(
                              textStyle: context.customTextTheme.text18W600,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const Divider(height: 28.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(FluentIcons.location_24_regular),
                          horizontalSpaceSmall,
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  cartListener.selectedOrderType ==
                                          OrderType.takeaway
                                      ? "Billing Address"
                                      : "Billing or Delivery Address",
                                  style: GoogleFonts.quicksand(
                                    textStyle: context
                                        .customTextTheme.text16W400
                                        .copyWith(
                                      color: AppColors.kBlack2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  cartListener.selectedAddress!.userFulladdress
                                      .trimLeft()
                                      .capitalize(),
                                  style: GoogleFonts.quicksand(
                                    textStyle: context
                                        .customTextTheme.text16W600
                                        .copyWith(
                                      color: AppColors.kBlack2,
                                    ),
                                  ),
                                ),
                                Text(
                                  userListener.userData?.user.userMobile ?? "",
                                  style: GoogleFonts.quicksand(
                                    textStyle:
                                        context.customTextTheme.text16W600,
                                  ),
                                ),
                                Text(
                                  userListener.userData?.user.userEmail ?? "",
                                  style: GoogleFonts.quicksand(
                                    textStyle:
                                        context.customTextTheme.text16W600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
              verticalSpaceSmall,
              // GestureDetector(
              //   onTap: () => context.router.push(const CoupenScreenRoute()),
              //   child: Card(
              //     borderOnForeground: false,
              //     color: AppColors.kWhite,
              //     // color: cartListener.validatedCouponDetails != null
              //     //     ? AppColors.kWhite
              //     //     : AppColors.kBlack,

              //     shape: cartListener.validatedCouponDetails != null
              //         ? const RoundedRectangleBorder(
              //             side: BorderSide(color: AppColors.kGray2),
              //           )
              //         : null,
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 24.0,
              //         vertical: 20.0,
              //       ),
              //       child: cartListener.validatedCouponDetails == null
              //           ? GestureDetector(
              //               onTap: () {
              //                 context.router.push(const CoupenScreenRoute());
              //               },
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 children: [
              //                   Assets.icons.dicountCopon
              //                       .image(height: 24, width: 24),
              //                   horizontalSpaceRegular,
              //                   Text(
              //                     "Apply Coupon",
              //                     style: context.customTextTheme.text16W600,
              //                   )
              //                 ],
              //               ),
              //             )
              //           : Row(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: <Widget>[
              //                     Assets.icons.dicountCopon
              //                         .image(height: 24, width: 24),
              //                     horizontalSpaceRegular,
              //                     Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: <Widget>[
              //                         Text(
              //                           "${cartListener.validatedCouponDetails?.coupenCode} coupon",
              //                           style: context.customTextTheme.text16W600,
              //                         ),
              //                         Text(
              //                           "Offer Applied",
              //                           style: context.customTextTheme.text14W600
              //                               .copyWith(
              //                             color: AppColors.kDimGray,
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 const Spacer(),
              //                 GestureDetector(
              //                   onTap: () => cartProvider.removeCouponCode(),
              //                   child: Icon(
              //                     Icons.close_rounded,
              //                     size: 22,
              //                     color: Colors.grey.shade700,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //     ),
              //   ),
              // ),

              GestureDetector(
                onTap: () async {
                  context.router.push(const CoupenScreenRoute());
                  await cartProvider.listAllOffers();
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: cartListener.validatedCouponDetails == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Assets.lib.assets.icons.dicountCopon
                                .image(height: 24, width: 24),
                            horizontalSpaceRegular,
                            Text(
                              "Apply Coupon",
                              style: context.customTextTheme.text16W600,
                            )
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Assets.lib.assets.icons.dicountCopon
                                    .image(height: 24, width: 24),
                                horizontalSpaceRegular,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${cartListener.validatedCouponDetails?.coupenCode} coupon",
                                      style: context.customTextTheme.text16W600,
                                    ),
                                    Text(
                                      "Offer Applied",
                                      style: context.customTextTheme.text14W600
                                          .copyWith(
                                        color: AppColors.kDimGray,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => cartProvider.removeCouponCode(),
                              child: Icon(
                                Icons.close_rounded,
                                size: 22,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              verticalSpaceSmall,
              Text(
                "Payment",
                style: context.customTextTheme.text18W600,
              ),
              verticalSpaceSmall,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 20.0,
                  bottom: 14.0,
                  top: 10.0,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Row(
                  children: <Widget>[
                    _PaymentOptionCard(
                      title: "Cash On\nDelivery",
                      icon: Assets.lib.assets.icons.money.image(
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      selected: cartListener.selectedPaymentMethod ==
                          PaymentMethod.cash,
                      onTap: () => cartListener
                          .onChangePaymentMethod(PaymentMethod.cash),
                    ),
                    horizontalSpaceRegular,
                    _PaymentOptionCard(
                      title: "Card\nPayment",
                      rightPos: -12,
                      bottomPos: -16,
                      icon: Assets.lib.assets.icons.creditCard.image(
                        height: 34,
                        fit: BoxFit.contain,
                      ),
                      selected: cartListener.selectedPaymentMethod ==
                          PaymentMethod.card,
                      onTap: () => cartListener
                          .onChangePaymentMethod(PaymentMethod.card),
                    ),
                  ],
                ),
              ),
              verticalSpaceMedium,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 10.0,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: textTheme,
                  ),
                  child: Column(
                    children: <Widget>[
                      _SummaryRow(
                        label: "Sub Total",
                        value: cartListener.cartTotalPriceDisplay ??
                            "${AppConfig.instance.country.symbol} 0.00",
                        style: context.customTextTheme.text16W600,
                      ),
                      verticalSpaceTiny,
                      _SummaryRow(
                        label:
                            cartListener.selectedOrderType == OrderType.takeaway
                                ? "Takeaway Charge"
                                : "Delivery Charge",
                        value:
                            "${AppConfig.instance.country.symbol} ${cartListener.calculatedDeliveryFee.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}",
                      ),
                      verticalSpaceTiny,
                      _SummaryRow(
                        label: "Discount",
                        value:
                            "-${AppConfig.instance.country.symbol} ${cartListener.calculatedDiscount.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}",
                      ),
                      verticalSpaceTiny,
                      _SummaryRow(
                        label: "Coupon Discount",
                        value:
                            "-${cartListener.offerDiscount.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}",
                      ),
                      const Divider(height: 20.0),
                      _SummaryRow(
                        label: "To Pay",
                        value:
                            "${AppConfig.instance.country.symbol} ${cartListener.totalAmount.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}",
                        style: context.customTextTheme.text18W600,
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpaceMedium,
              Center(
                child: IgnorePointer(
                  ignoring: cartListener.createOrderPending ||
                      paymentListener.creatingPaymentIntent,
                  child: InkWell(
                    onTap: () {
                      if (cartProvider.selectedPaymentMethod ==
                          PaymentMethod.card) {
                        paymentProvider.createPaymentIntent(
                          deliveryType: cartProvider.selectedOrderType == OrderType.delivery ? "door_delivery" : "store_pickup",
                          postCode:cartProvider.selectedOrderType == OrderType.delivery  ? cartProvider.selectedAddress?.postcode ?? "" : "",
                          pickupTime:cartProvider.selectedOrderType == OrderType.takeaway ? cartProvider.selectedPickUpTime?.toIso8601String() ?? '' : '',
                            cartProvider.calculatedDiscount,
                            cartProvider.calculatedDeliveryFee,
                            onPaymentSuccess: (transactionId) {
                          cartProvider
                              .createOrder(
                                  tID: transactionId,
                                  deliveryDate:
                                      shopListner.formattedSelectedDate,
                                  deliverySlot:
                                      "${shopListner.selectedDeliverySlot?.openingTime}--${shopListner.selectedDeliverySlot?.closingTime}")
                              .then((created) {
                            if (created) {
                              Future.delayed(const Duration(seconds: 2), () {
                                cartProvider.resetValues();
                                context.router.replaceAll([
                                  const OrderOnlineHomeScreenRoute(),
                                  HomeScreenRoute(),
                                ]);
                              });
                            }
                          });
                        });
                        return;
                      }

                      cartProvider
                          .createOrder(
                              deliveryDate:
                                  shopListner.formattedSelectedDateForPayload,
                              deliverySlot:
                                  "${shopListner.selectedDeliverySlot?.openingTime}--${shopListner.selectedDeliverySlot?.closingTime}")
                          .then((created) {
                        if (created) {
                          cartProvider.resetValues();
                          context.router.replaceAll([
                            const OrderOnlineHomeScreenRoute(),
                            HomeScreenRoute(),
                          ]);
                        }
                      });
                    },
                    child: Container(
                      height: 50,
                      width: context.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: cartListener.createOrderPending ||
                              paymentListener.creatingPaymentIntent
                          ? showButtonProgress()
                          : Center(
                              child: Text(
                              "PLACE ORDER",
                              style:
                                  context.customTextTheme.text16W500.copyWith(
                                color: AppColors.kWhite,
                              ),
                            )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final bool selected;
  final double? rightPos;
  final double? bottomPos;

  const _PaymentOptionCard({
    required this.title,
    required this.icon,
    this.selected = false,
    this.rightPos,
    this.bottomPos,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned.fill(
                  top: 0,
                  child: Card(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : AppColors.kWhite,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.kLightGray,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 8.0,
                      ),
                      child: Text(
                        title,
                        style: GoogleFonts.quicksand(
                          textStyle:
                              context.customTextTheme.text16W600.copyWith(
                            fontWeight: FontWeight.w700,
                            color: selected ? AppColors.kWhite : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: rightPos ?? -18,
                  bottom: bottomPos ?? -18,
                  child: icon,
                ),
              ],
            ),
          ),
        ),
      ),
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

// Padding(
// padding: EdgeInsets.symmetric(horizontal: defaultScreenPadding),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// verticalSpaceRegular,
// if (cartListener.selectedAddress != null) ...[
// Text(
// "Delivery Address",
// style: context.customTextTheme.text16W600,
// ),
// verticalSpaceSmall,
// Card(
// margin: EdgeInsets.zero,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(8.0),
// side: BorderSide(
// color: Colors.grey.shade400,
// )),
// child: ListTile(
// onTap: () {},
// selectedColor: Colors.black,
// title: Text(
// "${userListener.userFullName}\n${cartListener.selectedAddress!.addressTitle ?? " "}"),
// subtitle: Text(cartListener.selectedAddress!.userFulladdress),
// ),
// ),
// verticalSpaceRegular,
// Text(
// "Order Type: ${cartListener.selectedOrderType.name.capitalize()}",
// style: context.customTextTheme.text16W600,
// ),
// verticalSpaceRegular,
// Align(
// alignment: Alignment.centerLeft,
// child: Text(
// "Payment Method",
// style: context.customTextTheme.text16W600,
// ),
// ),
// ...PaymentMethod.values.map((type) {
// return ListTileTheme(
// contentPadding: EdgeInsets.zero,
// child: RadioListTile(
// title: Text(type.name.capitalize()),
// value: cartListener.selectedPaymentMethod,
// groupValue: type,
// onChanged: (_) => cartProvider.onChangePaymentMethod(type),
// ),
// );
// }),
// verticalSpaceRegular,
// FilledButton(
// onPressed: () {
// if (cartProvider.selectedPaymentMethod ==
// PaymentMethod.card) {
// paymentProvider.createPaymentIntent(
// cartProvider.calculatedDiscount,
// cartProvider.calculatedDeliveryFee,
// onPaymentSuccess: (transactionId) {
// cartProvider
//     .createOrder(tID: transactionId)
//     .then((created) {
// if (created) {
// Future.delayed(const Duration(seconds: 2), () {
// cartProvider.resetValues();
// context.router.replaceAll([
// const OrderOnlineHomeScreenRoute(),
// HomeScreenRoute(),
// ]);
// });
// }
// });
// });
// return;
// }
//
// cartProvider.createOrder().then((created) {
// if (created) {
// Future.delayed(const Duration(seconds: 2), () {
// cartProvider.resetValues();
// context.router.replaceAll([
// const OrderOnlineHomeScreenRoute(),
// HomeScreenRoute(),
// ]);
// });
// }
// });
// },
// style: FilledButton.styleFrom(
// fixedSize: Size(context.screenWidth, 40.0),
// ),
// child: cartListener.createOrderPending
// ? showButtonProgress()
//     : const Text("Checkout"),
// )
// ],
// ],
// ),
// )
