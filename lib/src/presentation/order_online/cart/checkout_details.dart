import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:dartx/dartx.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../../application/cart/cart_provider.dart';
import '../../../application/user/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/ui_utils.dart';

class CheckoutDetailsScreen extends StatelessWidget {
  const CheckoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartListener = context.watch<CartProvider>();
    final userListener = context.watch<UserProvider>();
    // final shopListener = context.watch<ShopProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taxGroup = cartListener.selectedOrderType == OrderType.delivery
        ? cartListener.deliveryDetails?.taxDetailsGroup
        : cartListener.takeAwayDetails?.taxDetailsGroup;
    final isTaxApplied = cartListener.selectedOrderType == OrderType.delivery
        ? cartListener.deliveryDetails?.isTaxAppliedBool
        : cartListener.takeAwayDetails?.isTaxAppliedBool;
    final taxAmount = cartListener.selectedOrderType == OrderType.delivery
        ? cartListener.deliveryDetails?.amountFormatted?.taxTotalAmount
        : cartListener.takeAwayDetails?.amountFormatted?.taxTotalAmount;
    final subTotal = cartListener.selectedOrderType == OrderType.delivery
        ? cartListener.deliveryDetails?.amountFormatted?.cartGrossAmount
        : cartListener.takeAwayDetails?.amountFormatted?.cartGrossAmount;
    final deliveryCharge =
        cartListener.deliveryDetails?.amountFormatted?.deliveryFeeAmount;
    final totalDiscount = cartListener.selectedOrderType == OrderType.delivery
        ? cartListener.deliveryDetails?.amountFormatted?.totalDiscount
        : cartListener.takeAwayDetails?.amountFormatted?.totalDiscount;
    final cartDiscount = cartListener.selectedOrderType == OrderType.delivery
        ? cartListener.deliveryDetails?.amountFormatted?.cartDiscountAmount
        : cartListener.takeAwayDetails?.amountFormatted?.cartDiscountAmount;
    final deliveryDiscount =
        cartListener.deliveryDetails?.amountFormatted?.deliveryDiscount;
    final takeawayDiscount =
        cartListener.takeAwayDetails?.amountFormatted?.takeAwayDiscount;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 120,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              verticalSpaceRegular,
              ListTile(
                tileColor: isDark ? AppColors.kCardBackground2 : Colors.white,
                leading: Icon(FluentIcons.cart_24_regular,
                    color: isDark ? Colors.white : Colors.black),
                trailing: Icon(FluentIcons.chevron_right_24_regular,
                    color: isDark ? Colors.white : Colors.black),
                title: Text("${cartListener.cartItems.length} Item(s)"),
                textColor: isDark ? Colors.white : Colors.black,
                // subtitle: const Text("**** **** **** 4242"),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: isDark
                            ? AppColors.kCardBackground2
                            : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15.0)),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) {
                      return DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          maxChildSize: 0.9,
                          minChildSize: 0.5,
                          builder: (context, scrollController) {
                            return Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.kCardBackground2
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: [
                                  verticalSpaceRegular,
                                  Container(
                                    height: 4,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  verticalSpaceRegular,
                                  Expanded(
                                    child: ListView.separated(
                                      controller: scrollController,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      itemCount: cartListener.cartItems.length,
                                      itemBuilder: (context, index) {
                                        final product = cartListener.cartItems
                                            .elementAt(index);
                                        return Row(
                                          children: [
                                            AppConfig.instance
                                                    .isCategoryImageEnabled
                                                ? product.productPhoto != null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: CachedNetworkImage(
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover,
                                                            imageUrl: product
                                                                .productPhoto!),
                                                      )
                                                    : const SizedBox.shrink()
                                                : SizedBox.shrink(),
                                            product.productPhoto != null
                                                ? horizontalSpaceSmall
                                                : const SizedBox.shrink(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    product.variation != null
                                                        ? SizedBox(
                                                            width: context
                                                                    .screenWidth *
                                                                0.5,
                                                            child: Tooltip(
                                                              message:
                                                                  "${product.productName ?? 'N/A'} (${product.variation ?? 'N/A'})",
                                                              triggerMode:
                                                                  TooltipTriggerMode
                                                                      .tap,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${product.productName ?? 'N/A'} (${product.variation ?? 'N/A'})",
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: context
                                                                        .customTextTheme
                                                                        .text16W700
                                                                        .copyWith(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                context.customTextTheme.color),
                                                                  ),
                                                                  product.amountDetails
                                                                              ?.isOfferApplied ==
                                                                          true
                                                                      ? Row(
                                                                          children: [
                                                                              Text(
                                                                                product.amountDetails?.itemDetails?.display?.totalAmount ?? product.amountDetails?.display?.totalAmountWithAddon ?? 'N/A',
                                                                                style: context.customTextTheme.text14W600.copyWith(color: context.customTextTheme.color),
                                                                              ),
                                                                              const SizedBox(width: 4),
                                                                              Text(
                                                                                product.amountDetails?.itemDetails?.display?.totalAmountNormal ?? 'N/A',
                                                                                style: context.customTextTheme.text14W600.copyWith(decoration: TextDecoration.lineThrough, decorationColor: Colors.grey, color: Colors.grey),
                                                                              ),
                                                                            ])
                                                                      : Text(
                                                                          product.product_total_price ??
                                                                              'N/A',
                                                                          style: context
                                                                              .customTextTheme
                                                                              .text14W600
                                                                              .copyWith(color: context.customTextTheme.color),
                                                                        ),
                                                                ],
                                                              ),
                                                            ))
                                                        : SizedBox(
                                                            width: context
                                                                    .screenWidth *
                                                                0.5,
                                                            child: Tooltip(
                                                              message: product
                                                                          .variation !=
                                                                      null
                                                                  ? "${product.productName ?? 'N/A'} (${product.variation ?? 'N/A'})"
                                                                  : product
                                                                          .productName ??
                                                                      'N/A',
                                                              triggerMode:
                                                                  TooltipTriggerMode
                                                                      .tap,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    product.productName
                                                                            ?.capitalize() ??
                                                                        'N/A',
                                                                    style: context
                                                                        .customTextTheme
                                                                        .text16W700
                                                                        .copyWith(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                context.customTextTheme.color),
                                                                  ),
                                                                  product.amountDetails
                                                                              ?.isOfferApplied ==
                                                                          true
                                                                      ? Row(
                                                                          children: [
                                                                              Text(
                                                                                product.amountDetails?.itemDetails?.display?.totalAmount ?? product.amountDetails?.display?.totalAmountWithAddon ?? 'N/A',
                                                                                style: context.customTextTheme.text14W600.copyWith(color: context.customTextTheme.color),
                                                                              ),
                                                                              const SizedBox(width: 4),
                                                                              Text(
                                                                                product.amountDetails?.itemDetails?.display?.totalAmountNormal ?? 'N/A',
                                                                                style: context.customTextTheme.text14W600.copyWith(decoration: TextDecoration.lineThrough, decorationColor: Colors.grey, color: Colors.grey),
                                                                              ),
                                                                            ])
                                                                      : Text(
                                                                          product.product_total_price ??
                                                                              'N/A',
                                                                          style: context
                                                                              .customTextTheme
                                                                              .text14W600
                                                                              .copyWith(color: context.customTextTheme.color),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    // const Spacer(),
                                                  ],
                                                ),
                                                product.master_addon_apllied
                                                            .isNotEmpty ==
                                                        true
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: product
                                                            .master_addon_apllied
                                                            .map(
                                                              (addon) => Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  // RichText(
                                                                  //   text: TextSpan(
                                                                  //     text: '|  ',
                                                                  //     style: const TextStyle(color: Colors.grey),
                                                                  //     children: [
                                                                  //       TextSpan(text: addon.title, style: const TextStyle(color: Colors.black)),
                                                                  //     ],
                                                                  //   ),
                                                                  // ),
                                                                  Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: addon
                                                                          .choosedOption
                                                                          .map((option) =>
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 0.0),
                                                                                child: Row(
                                                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      "+ ${option.text}",
                                                                                      style: TextStyle(color: isDark ? Colors.white : null),
                                                                                    ),
                                                                                    // const Spacer(),
                                                                                    horizontalSpaceSmall,
                                                                                    Text(
                                                                                      option.price ?? 'N/A',
                                                                                      style: TextStyle(color: isDark ? Colors.white : null),
                                                                                    ),
                                                                                    // horizontalSpaceTiny,
                                                                                    // const Icon(
                                                                                    //   Icons.delete_outline,
                                                                                    //   color: Colors.transparent,
                                                                                    // )
                                                                                  ],
                                                                                ),
                                                                              ))
                                                                          .toList())
                                                                ],
                                                              ),
                                                            )
                                                            .toList(),
                                                      )
                                                    : const SizedBox.shrink(),
                                                product.addon_apllied
                                                            .isNotEmpty ==
                                                        true
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children:
                                                            product
                                                                .addon_apllied
                                                                .map(
                                                                  (addon) =>
                                                                      Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      // RichText(
                                                                      //   text: TextSpan(
                                                                      //     text: '|  ',
                                                                      //     style: const TextStyle(color: Colors.grey),
                                                                      //     children: [
                                                                      //       TextSpan(text: addon.title, style: const TextStyle(color: Colors.black)),
                                                                      //     ],
                                                                      //   ),
                                                                      // ),
                                                                      Column(
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .start,
                                                                          children: addon
                                                                              .choosedOption
                                                                              .map((option) => Padding(
                                                                                    padding: const EdgeInsets.only(left: 0.0),
                                                                                    child: Row(
                                                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "+ ${option.text}",
                                                                                          style: TextStyle(color: isDark ? Colors.white : null),
                                                                                        ),
                                                                                        // const Spacer(),
                                                                                        horizontalSpaceSmall,
                                                                                        Text(
                                                                                          option.price ?? 'N/A',
                                                                                          style: TextStyle(color: isDark ? Colors.white : null),
                                                                                        ),
                                                                                        // horizontalSpaceTiny,
                                                                                        // const Icon(
                                                                                        //   Icons.delete_outline,
                                                                                        //   color: Colors.transparent,
                                                                                        // )
                                                                                      ],
                                                                                    ),
                                                                                  ))
                                                                              .toList())
                                                                    ],
                                                                  ),
                                                                )
                                                                .toList(),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                            const Spacer(),
                                            horizontalSpaceRegular
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return verticalSpaceSmall;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const _CartItemsSummary(),
                  //     fullscreenDialog: true,
                  //   ),
                  // );
                },
              ),
              verticalSpaceRegular,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Order Type : ",
                      style: GoogleFonts.quicksand(
                        textStyle: context.customTextTheme.text16W600.copyWith(
                          color: isDark ? Colors.white : AppColors.kBlack2,
                        ),
                      ),
                    ),
                    TextSpan(
                      text:
                          " ${cartListener.selectedOrderType == OrderType.delivery ? "Home Delivery" : "Takeaway"}",
                      style: GoogleFonts.quicksand(
                        textStyle: context.customTextTheme.text16W500.copyWith(
                          color: isDark ? Colors.white : AppColors.kBlack2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceRegular,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Payment Method : ",
                      style: GoogleFonts.quicksand(
                        textStyle: context.customTextTheme.text16W600.copyWith(
                            color: isDark ? Colors.white : AppColors.kBlack2),
                      ),
                    ),
                    TextSpan(
                      text:
                          " ${cartListener.selectedPaymentMethod == PaymentMethod.cash ? "Cash on Delivery" : "Card Payment"}",
                      style: GoogleFonts.quicksand(
                        textStyle: context.customTextTheme.text16W500.copyWith(
                          color: isDark ? Colors.white : AppColors.kBlack2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Type",
                              style: context.customTextTheme.text16W600),
                          verticalSpaceTiny,
                          ListTile(
                            leading:
                                const Icon(FluentIcons.checkmark_24_filled),
                            title: Text(cartListener.selectedOrderType ==
                                    OrderType.delivery
                                ? OrderType.delivery.label
                                : OrderType.takeaway.label),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ],
                      ),
                    ),
                    horizontalSpaceRegular,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Payment Method",
                              style: context.customTextTheme.text16W600),
                          verticalSpaceTiny,
                          ListTile(
                            leading:
                                const Icon(FluentIcons.checkmark_24_filled),
                            title: Text(cartListener.selectedPaymentMethod ==
                                    PaymentMethod.cash
                                ? PaymentMethod.cash.label
                                : PaymentMethod.card.label),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Text("Delivery Date & Time", style: context.customTextTheme.text16W600),
              // verticalSpaceTiny,
              // Text(
              //   shopListener.formattedSelectedDate,
              //   style: context.customTextTheme.text16W500,
              // ),
              // verticalSpaceTiny,
              // shopListener.selectedDeliverySlot != null
              //     ? Text(
              //         "${shopListener.selectedDeliverySlot?.openingTime} - ${shopListener.selectedDeliverySlot?.closingTime}",
              //         style: context.customTextTheme.text14W600,
              //       )
              //     : Text(
              //         'Empty',
              //         style: context.customTextTheme.text14W400,
              //       ),
              verticalSpaceRegular,
              Text(
                  cartListener.selectedOrderType == OrderType.delivery
                      ? "Delivery Address"
                      : "Billing Address",
                  style: context.customTextTheme.text16W600
                      .copyWith(color: isDark ? Colors.white : null)),
              verticalSpaceTiny,
              Text(
                cartListener.selectedAddress?.userFulladdress
                        .trimLeft()
                        .capitalize() ??
                    '',
                style: GoogleFonts.quicksand(
                  textStyle: context.customTextTheme.text16W500.copyWith(
                    color: isDark ? Colors.white : AppColors.kBlack2,
                  ),
                ),
              ),
              userListener.userData?.user.userMobile == null ||
                      userListener.userData?.user.userMobile?.isEmpty == true
                  ? const SizedBox.shrink()
                  : Text(
                      userListener.userData?.user.userMobileFormatted ?? "",
                      style: GoogleFonts.quicksand(
                        textStyle: context.customTextTheme.text16W500.copyWith(
                          color: isDark ? Colors.white : null,
                        ),
                      ),
                    ),
              userListener.userData?.user.userEmail == null ||
                      userListener.userData?.user.userEmail?.isEmpty == true
                  ? const SizedBox.shrink()
                  : Text(
                      userListener.userData?.user.userEmail ?? "",
                      style: GoogleFonts.quicksand(
                        textStyle: context.customTextTheme.text16W500.copyWith(
                          color: isDark ? Colors.white : null,
                        ),
                      ),
                    ),
              verticalSpaceRegular,
              if (cartListener.deliveryNotes.isNotEmpty)
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Order / Delivery Notes",
                      style: context.customTextTheme.text16W600
                          .copyWith(color: isDark ? Colors.white : null)),
                  verticalSpaceTiny,
                  Text(
                    cartListener.deliveryNotes,
                    style: GoogleFonts.quicksand(
                      textStyle: context.customTextTheme.text16W500.copyWith(
                        color: isDark ? Colors.white : AppColors.kBlack2,
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                ]),

              // RichText(
              //   text: TextSpan(
              //     children: [
              //       TextSpan(
              //         text: "Payment Method : ",
              //         style: GoogleFonts.quicksand(
              //           textStyle: context.customTextTheme.text16W600
              //               .copyWith(color: AppColors.kBlack2),
              //         ),
              //       ),
              //       TextSpan(
              //         text:
              //             " ${cartListener.selectedPaymentMethod == PaymentMethod.cash ? PaymentMethod.cash.label : PaymentMethod.card.label}",
              //         style: GoogleFonts.quicksand(
              //           textStyle: context.customTextTheme.text16W500.copyWith(
              //             color: AppColors.kBlack2,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const Divider(),
              verticalSpaceRegular,
              Text(
                "Bill Details",
                style: context.customTextTheme.text16W500.copyWith(
                  color: isDark ? Colors.white : null,
                ),
              ),
              verticalSpaceSmall,
              _SummaryRow(
                label: "Sub Total",
                value: subTotal ??
                    '${AppConfig.instance.country.symbol} ${0.00.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}',
                style: context.customTextTheme.text16W600
                    .copyWith(color: context.customTextTheme.color),
              ),
              cartListener.selectedOrderType == OrderType.delivery
                  ? verticalSpaceTiny
                  : SizedBox.shrink(),
              cartListener.selectedOrderType == OrderType.delivery
                  ? _SummaryRow(
                      label: "Delivery Charge",
                      value: cartListener.calculatedDeliveryFee == 0.00
                          ? 'Free'
                          : "$deliveryCharge",
                      style: context.customTextTheme.text16W600
                          .copyWith(color: context.customTextTheme.color))
                  : SizedBox.shrink(),
              verticalSpaceTiny,
              _SummaryRow(
                  label: "Discount",
                  value: totalDiscount ??
                      '${AppConfig.instance.country.symbol} ${0.00.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}',
                  style: context.customTextTheme.text16W600
                      .copyWith(color: context.customTextTheme.color),
                  infoWidget: totalDiscount !=
                          '${AppConfig.instance.country.symbol} ${0.00.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}'
                      ? Tooltip(
                          decoration: BoxDecoration(
                            color: context.customTextTheme.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          showDuration: Duration(seconds: 8),
                          triggerMode: TooltipTriggerMode.tap,
                          richMessage: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Cart Discount : ${cartDiscount ?? '${AppConfig.instance.country.symbol} ${0.00.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}'}",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: cartListener.selectedOrderType ==
                                        OrderType.delivery
                                    ? "\nDelivery Discount : ${deliveryDiscount ?? '${AppConfig.instance.country.symbol} ${0.00.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}'}"
                                    : "\nTakeaway Discount : ${takeawayDiscount ?? '${AppConfig.instance.country.symbol} ${0.00.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}'}",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        )
                      : SizedBox.shrink()),
              if (isTaxApplied == true || taxAmount != null) ...[
                verticalSpaceTiny,
                isTaxApplied == true
                    ? _SummaryRow(
                        label: "VAT",
                        value: taxAmount ??
                            '${AppConfig.instance.country.symbol}0.00',
                        style: context.customTextTheme.text16W600
                            .copyWith(color: context.customTextTheme.color),
                        infoWidget: taxAmount !=
                                '${AppConfig.instance.country.symbol} ${0.00.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}'
                            ? Tooltip(
                                decoration: BoxDecoration(
                                  color: context.customTextTheme.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                showDuration: Duration(seconds: 8),
                                triggerMode: TooltipTriggerMode.tap,
                                richMessage: TextSpan(
                                  children: List.generate(
                                    taxGroup?.length ?? 0,
                                    (index) {
                                      final tax = taxGroup![index];
                                      return TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${tax.taxSlab} : ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${tax.totalTax}',
                                          ),
                                          if (index != taxGroup.length - 1)
                                            const TextSpan(text: '\n'),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  size: 18,
                                ),
                              )
                            : SizedBox.shrink())
                    : SizedBox.shrink(),
              ],
            ]),
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
  final Widget? infoWidget;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.infoWidget,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style ?? context.customTextTheme.text14W500,
        ),
        horizontalSpaceTiny,
        Visibility(
          visible: infoWidget != null,
          child: infoWidget ?? SizedBox.shrink(),
        ),
        Spacer(),
        Text(
          value,
          style: style ?? context.customTextTheme.text14W500,
        ),
      ],
    );
  }
}

class _CartItemsSummary extends StatelessWidget {
  const _CartItemsSummary();

  @override
  Widget build(BuildContext context) {
    final cartListener = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Summary"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: cartListener.cartItems.length,
        itemBuilder: (context, index) {
          final product = cartListener.cartItems.elementAt(index);
          return Column(
            children: [
              Row(
                children: [
                  product.variation != null
                      ? Text(
                          "${product.productName ?? 'N/A'} (${product.variation ?? 'N/A'})",
                          style: context.customTextTheme.text16W700
                              .copyWith(fontSize: 14),
                        )
                      : Text(
                          product.productName ?? 'N/A',
                          style: context.customTextTheme.text16W700
                              .copyWith(fontSize: 14),
                        ),
                  // const Spacer(),
                  horizontalSpaceSmall,

                  Text(product.product_total_price ?? 'N/A'),
                ],
              ),
              product.master_addon_apllied.isNotEmpty == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.master_addon_apllied
                          .map(
                            (addon) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: addon.choosedOption
                                        .map((option) => Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(" + ${option.text}"),
                                                  // const Spacer(),
                                                  horizontalSpaceSmall,
                                                  Text(option.price ?? 'N/A'),
                                                ],
                                              ),
                                            ))
                                        .toList())
                              ],
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
