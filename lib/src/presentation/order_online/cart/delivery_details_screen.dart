import 'dart:io';

import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/application/theme/theme_provider.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/domain/user/models/user_address_list_data_model.dart';
import 'package:customer_core/src/presentation/widgets/custom_close_icon.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../../application/cart/cart_provider.dart';
import '../../../application/user/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/utils/utils.dart';
import '../../widgets/bottom_sheet_drag_handler.dart';
import '../../widgets/button_progress.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final cartListener = context.watch<CartProvider>();

    final userListener = context.watch<UserProvider>();
    final userProvider = context.read<UserProvider>();
    final themeListener = context.watch<ThemeProvider>();
    const outlinedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taxGroup = cartListener.selectedOrderType == OrderType.delivery
        ? cartListener.deliveryDetails?.taxDetailsGroup
        : cartListener.takeAwayDetails?.taxDetailsGroup;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0)
              .copyWith(bottom: MediaQuery.of(context).size.height * 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Type",
                    style: context.customTextTheme.text16W600
                        .copyWith(color: isDark ? Colors.white : null),
                  ),
                  verticalSpaceSmall,
                  buildOrderTypeWidget(context),
                ],
              ),
              // Divider(),
              if (cartListener.selectedAddressSecondary == null) ...[
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (cartListener.selectedOrderType ==
                            OrderType.takeaway) ...[
                          _buildTakeAwayTimeWidget(),
                          const Divider(
                            height: 30.0,
                            color: AppColors.kLightGray2,
                          ),
                        ],
                        InkWell(
                          onTap: () {
                            userProvider.initAllTextEditingController();
                            showAddressListSheet(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                FluentIcons.location_24_regular,
                                color: themeListener.isDarkMode
                                    ? Colors.white
                                    : null,
                              ),
                              const SizedBox(width: 8.0),
                              // Add space between icon and text
                              Flexible(
                                child: Text(
                                  "Select Address For ${cartListener.selectedOrderType == OrderType.takeaway ? "Billing" : "Delivery"}",
                                  style: context.customTextTheme.text16W600
                                      .copyWith(
                                          color: context.customTextTheme.color),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 0.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (cartListener.selectedOrderType ==
                            OrderType.takeaway) ...[
                          _buildTakeAwayTimeWidget(),
                          const Divider(
                            height: 30.0,
                            color: AppColors.kLightGray2,
                          ),
                        ],
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              FluentIcons.location_24_regular,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            horizontalSpaceSmall,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Address",
                                    style: GoogleFonts.quicksand(
                                      textStyle: context
                                          .customTextTheme.text16W600
                                          .copyWith(
                                        color: context.customTextTheme.color,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    cartListener.selectedAddressSecondary!
                                        .userFulladdress
                                        .trimLeft()
                                        .capitalize(),
                                    style: GoogleFonts.quicksand(
                                      textStyle: context
                                          .customTextTheme.text16W500
                                          .copyWith(
                                        color: context.customTextTheme.color,
                                      ),
                                    ),
                                  ),
                                  userListener.userData?.user.userMobile ==
                                              null ||
                                          userListener.userData?.user.userMobile
                                                  ?.isEmpty ==
                                              true
                                      ? const SizedBox.shrink()
                                      : Text(
                                          userListener
                                                  .userData?.user.userMobile ??
                                              "",
                                          style: GoogleFonts.quicksand(
                                            textStyle: context
                                                .customTextTheme.text16W500
                                                .copyWith(
                                              color:
                                                  context.customTextTheme.color,
                                            ),
                                          ),
                                        ),
                                  userListener.userData?.user.userEmail ==
                                              null ||
                                          userListener.userData?.user.userEmail
                                                  ?.isEmpty ==
                                              true
                                      ? const SizedBox.shrink()
                                      : Text(
                                          userListener
                                                  .userData?.user.userEmail ??
                                              "",
                                          style: GoogleFonts.quicksand(
                                            textStyle: context
                                                .customTextTheme.text16W500
                                                .copyWith(
                                              color:
                                                  context.customTextTheme.color,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            horizontalSpaceSmall,
                            InkWell(
                              onTap: () {
                                userListener.initAllTextEditingController();
                                showAddressListSheet(context);
                              },
                              child: Text(
                                "CHANGE",
                                style:
                                    context.customTextTheme.text14W600.copyWith(
                                  color: context.customTextTheme.color,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // verticalSpaceSmall,
              // Visibility(
              //   visible: false,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 16.0,
              //       horizontal: 0.0,
              //     ),
              //     child: shopListener.selectedDate == null &&
              //             shopListener.selectedDeliverySlot == null
              //         ? InkWell(
              //             onTap: () async {
              //               shopProvider.onChangeOnSelectedDeliverySlot(null);

              //               shopProvider.fetchShopDeliverySlots();

              //               final selectedDate = await showDatePicker(
              //                 context: context,
              //                 initialDate: DateTime.now(),
              //                 firstDate: DateTime.now(),
              //                 lastDate: DateTime(2100),
              //                 builder: (context, child) {
              //                   return Theme(
              //                     data: Theme.of(context).copyWith(
              //                       colorScheme: const ColorScheme.light(
              //                         primary: Theme.of(context).colorScheme.primary,
              //                       ),
              //                     ),
              //                     child: child!,
              //                   );
              //                 },
              //               );
              //               if (selectedDate != null) {
              //                 shopProvider.onChangeSelectedDate(selectedDate);
              //                 await showSlotChooseSheet(context, shopProvider);
              //               }
              //             },
              //             child: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               children: [
              //                 const Icon(FluentIcons.calendar_clock_24_regular),
              //                 const SizedBox(width: 8.0),
              //                 // Add space between icon and text
              //                 Flexible(
              //                   child: Text(
              //                     "Select Delivery Date & Time",
              //                     style: context.customTextTheme.text16W600,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           )
              //         : Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   const Icon(FluentIcons.calendar_clock_24_regular),
              //                   horizontalSpaceSmall,
              //                   // Text(
              //                   //     '${DateFormat.jm(shopListener.selectedDate)}'),

              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         'Delivery Date & Time',
              //                         style: context.customTextTheme.text16W700,
              //                       ),
              //                       Text(
              //                         shopListener.formattedSelectedDate,
              //                         style: context.customTextTheme.text16W500,
              //                       ),
              //                       verticalSpaceTiny,
              //                       shopListener.selectedDeliverySlot != null
              //                           ? Text(
              //                               "${shopListener.selectedDeliverySlot?.openingTime} - ${shopListener.selectedDeliverySlot?.closingTime}",
              //                               style: context
              //                                   .customTextTheme.text14W600,
              //                             )
              //                           : Text(
              //                               'Not Selected',
              //                               style: context
              //                                   .customTextTheme.text14W400
              //                                   .copyWith(
              //                                       color: Colors.red.shade700),
              //                             ),
              //                     ],
              //                   )
              //                 ],
              //               ),
              //               InkWell(
              //                   onTap: () async {
              //                     shopProvider
              //                         .onChangeOnSelectedDeliverySlot(null);
              //                     shopProvider.fetchShopDeliverySlots();

              //                     final selectedDate = await showDatePicker(
              //                       context: context,
              //                       initialDate: DateTime.now(),
              //                       firstDate: DateTime.now(),
              //                       lastDate: DateTime(2100),
              //                       builder: (context, child) {
              //                         return Theme(
              //                           data: Theme.of(context).copyWith(
              //                             colorScheme: const ColorScheme.light(
              //                               primary: Theme.of(context).colorScheme.primary,
              //                             ),
              //                           ),
              //                           child: child!,
              //                         );
              //                       },
              //                     );
              //                     if (selectedDate != null) {
              //                       shopProvider
              //                           .onChangeSelectedDate(selectedDate);
              //                       await showSlotChooseSheet(
              //                           context, shopProvider);
              //                     }
              //                   },
              //                   child: Text('CHANGE',
              //                       style: context.customTextTheme.text14W600)),
              //             ],
              //           ),
              //   ),
              // ),
              Card(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FluentIcons.notepad_24_regular,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'notes',
                          key: cartListener.notesFieldKey,
                          style: context.customTextTheme.text14W600.copyWith(
                            color:
                                themeListener.isDarkMode ? Colors.white : null,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: outlinedBorder,
                            border: outlinedBorder,
                            focusedBorder: outlinedBorder,
                            disabledBorder: outlinedBorder,
                            errorBorder: outlinedBorder,
                            focusedErrorBorder: outlinedBorder,
                            hintText: "Write your notes here",
                            hintStyle: context.customTextTheme.text16W400
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment Method",
                        style: context.customTextTheme.text16W600.copyWith(
                          color: context.customTextTheme.color,
                        )),
                    verticalSpaceSmall,
                    ListTileTheme(
                      enableFeedback: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              visualDensity: VisualDensity.compact,
                              selected: cartListener.selectedPaymentMethod ==
                                  PaymentMethod.cash,
                              selectedTileColor:
                                  cartListener.selectedPaymentMethod ==
                                          PaymentMethod.cash
                                      ? null
                                      : AppColors.kWhite,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: cartListener.selectedPaymentMethod ==
                                          PaymentMethod.cash
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // leading: Assets.icons.creditCard.image(
                              //     height: 34.0,
                              //     color: cartListener.selectedPaymentMethod ==
                              //             PaymentMethod.cash
                              //         ? AppColors.kBlack2
                              //         : AppColors.kGray2),
                              title: Text(
                                "Cash",
                                style:
                                    context.customTextTheme.text14W600.copyWith(
                                  color: cartListener.selectedPaymentMethod ==
                                          PaymentMethod.cash
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                ),
                              ),
                              value: PaymentMethod.cash,
                              groupValue: cartListener.selectedPaymentMethod,
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                              onChanged: (_) {
                                cartListener
                                    .onChangePaymentMethod(PaymentMethod.cash);
                              },
                            ),
                          ),
                          horizontalSpaceRegular,
                          Expanded(
                            child: RadioListTile(
                              visualDensity: VisualDensity.compact,
                              selected: cartListener.selectedPaymentMethod ==
                                  PaymentMethod.card,

                              selectedTileColor:
                                  cartListener.selectedPaymentMethod ==
                                          PaymentMethod.card
                                      ? null
                                      : AppColors.kWhite,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: cartListener.selectedPaymentMethod ==
                                          PaymentMethod.card
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // leading: Assets.icons.takeAway.image(
                              //     height: 34.0,
                              //     color: cartListener.selectedPaymentMethod ==
                              //             PaymentMethod.card
                              //         ? AppColors.kBlack2
                              //         : AppColors.kGray2),
                              title: Text(
                                "Card",
                                style:
                                    context.customTextTheme.text14W600.copyWith(
                                  color: cartListener.selectedPaymentMethod ==
                                          PaymentMethod.card
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                ),
                              ),
                              value: PaymentMethod.card,

                              groupValue: cartListener.selectedPaymentMethod,
                              activeColor:
                                  Theme.of(context).colorScheme.primary,

                              onChanged: (_) {
                                cartListener
                                    .onChangePaymentMethod(PaymentMethod.card);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Text("Payment Methods", style: context.customTextTheme.text16W600),
              // Row(
              //   children: <Widget>[
              //     _PaymentOptionCard(
              //       title: "Cash On\nDelivery",
              //       icon: Assets.icons.money.image(
              //         height: 40,
              //         fit: BoxFit.contain,
              //       ),
              //       selected: cartListener.selectedPaymentMethod == PaymentMethod.cash,
              //       onTap: () => cartListener.onChangePaymentMethod(PaymentMethod.cash),
              //     ),
              //     horizontalSpaceRegular,
              //     _PaymentOptionCard(
              //       title: "Card\nPayment",
              //       rightPos: -12,
              //       bottomPos: -16,
              //       icon: Assets.icons.creditCard.image(
              //         height: 34,
              //         fit: BoxFit.contain,
              //       ),
              //       selected: cartListener.selectedPaymentMethod == PaymentMethod.card,
              //       onTap: () => cartListener.onChangePaymentMethod(PaymentMethod.card),
              //     ),
              //   ],
              // ),
              Container(
                // height: context.heightPx * 0.3,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Bill Details",
                      style: context.customTextTheme.text16W500
                          .copyWith(color: context.customTextTheme.color),
                    ),
                    verticalSpaceSmall,
                    _SummaryRow(
                      label: "Sub Total",
                      value: cartListener.cartTotalPriceDisplay ??
                          "${AppConfig.instance.country.symbol}0.00",
                      style: context.customTextTheme.text16W600
                          .copyWith(color: context.customTextTheme.color),
                    ),
                    verticalSpaceTiny,
                    cartListener.selectedOrderType == OrderType.delivery
                        ? _SummaryRow(
                            label: "Delivery Charge",
                            value: cartListener.calculatedDeliveryFee == 0.00
                                ? 'Free'
                                : "${AppConfig.instance.country.symbol} ${cartListener.calculatedDeliveryFee.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}",
                            style: context.customTextTheme.text16W600
                                .copyWith(color: context.customTextTheme.color))
                        : const SizedBox.shrink(),
                    verticalSpaceTiny,
                    _SummaryRow(
                        label: "Offer Discount",
                        value:
                            "- ${AppConfig.instance.country.symbol} ${cartListener.cartDetailsModel?.getOfferDiscount.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}",
                        style: context.customTextTheme.text16W600
                            .copyWith(color: context.customTextTheme.color)),
                    verticalSpaceTiny,
                    _SummaryRow(
                        label: "Discount",
                        value:
                            "- ${AppConfig.instance.country.symbol} ${cartListener.calculatedDiscount.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}",
                        style: context.customTextTheme.text16W600
                            .copyWith(color: context.customTextTheme.color)),
                    verticalSpaceTiny,
                    Column(
                      children: taxGroup
                              ?.map(
                                (taxGroup) => Column(
                                  children: [
                                    _SummaryRow(
                                        label: "${taxGroup.taxSlab}",
                                        value: "${taxGroup.totalTax}",
                                        style: context
                                            .customTextTheme.text16W600
                                            .copyWith(
                                                color: context
                                                    .customTextTheme.color)),
                                    verticalSpaceTiny,
                                  ],
                                ),
                              )
                              .toList() ??
                          [],
                    ),

                    verticalSpaceTiny,
                    // _SummaryRow(
                    //   label: "Coupon Discount",
                    //   value: "-${AppConfig.instance.country.symbol}${cartListener.offerDiscount.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}",
                    // ),
                    // const Divider(height: 20.0),
                    // _SummaryRow(
                    //   label: "To Pay",
                    //   value: Utils.format(cartListener.totalAmount),
                    //   style: context.customTextTheme.text18W600,
                    // ),
                    // verticalSpaceRegular,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderTypeWidget(BuildContext context) {
    final shopListener = context.watch<ShopProvider>();
    final cartProvider = context.read<CartProvider>();
    final cartListener = context.watch<CartProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isHomeDeliveryEnabled =
        shopListener.storeSettings.data?.deliveryInfo?.homeDelivery != null &&
            shopListener.storeSettings.data?.deliveryInfo?.homeDelivery == '1';
    final isTakeAwayEnabled =
        shopListener.storeSettings.data?.deliveryInfo?.takeAway != null &&
            shopListener.storeSettings.data?.deliveryInfo?.takeAway == '1';

    if (isTakeAwayEnabled && isHomeDeliveryEnabled) {
      return ListTileTheme(
        enableFeedback: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                visualDensity: VisualDensity.compact,
                selected: cartListener.selectedOrderType == OrderType.delivery,
                selectedTileColor:
                    cartListener.selectedOrderType == OrderType.delivery
                        ? null
                        : Theme.of(context).iconTheme.color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: cartListener.selectedOrderType == OrderType.delivery
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                leading: Assets.lib.assets.icons.fastDelivery.image(
                    height: 34.0,
                    color: cartListener.selectedOrderType == OrderType.delivery
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey),
                title: Text(
                  "Delivery",
                  style: context.customTextTheme.text14W600.copyWith(
                    color: cartListener.selectedOrderType == OrderType.delivery
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
                onTap: () {
                  final isEnabled = shopListener
                      .storeSettings.data?.deliveryInfo?.homeDelivery;
                  if (isEnabled == null || isEnabled == '0') {
                    AlertDialogs.showInfo("Home delivery not available");
                    return;
                  }
                  cartProvider.onChangeOrderType(
                    OrderType.delivery,
                  );
                },
              ),
            ),
            horizontalSpaceRegular,
            Expanded(
              child: ListTile(
                visualDensity: VisualDensity.compact,
                selected: cartListener.selectedOrderType == OrderType.takeaway,
                selectedTileColor:
                    cartListener.selectedOrderType == OrderType.takeaway
                        ? null
                        : Colors.grey,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: cartListener.selectedOrderType == OrderType.takeaway
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                leading: Assets.lib.assets.icons.takeAway.image(
                    height: 34.0,
                    color: cartListener.selectedOrderType == OrderType.takeaway
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey),
                title: Text(
                  "Take Away",
                  style: context.customTextTheme.text14W600.copyWith(
                    color: cartListener.selectedOrderType == OrderType.takeaway
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
                onTap: () {
                  final isEnabled =
                      shopListener.storeSettings.data?.deliveryInfo?.takeAway;
                  if (isEnabled == null || isEnabled == '0') {
                    AlertDialogs.showInfo("Takeaway not available");
                    return;
                  }
                  cartProvider.onChangeOrderType(OrderType.takeaway);
                  cartProvider.clearCalculatedDeliveryDetails();
                },
              ),
            ),
          ],
        ),
      );
    } else if (isTakeAwayEnabled) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 5,
        leading: Assets.lib.assets.icons.fastDelivery
            .image(height: 25, color: isDark ? Colors.white : null),
        title: Text(
          "Home Delivery",
          style: context.customTextTheme.text16W600,
        ),
        subtitle: Text(
          'We\'re serving home delivery orders only',
          style: context.customTextTheme.text14W500,
        ),
      );
    } else if (isHomeDeliveryEnabled) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 5,
        leading: Assets.lib.assets.icons.takeAway
            .image(height: 23, color: isDark ? Colors.white : null),
        title: Text(
          "Takeaway",
          style: context.customTextTheme.text16W600,
        ),
        subtitle: Text(
          'We\'re serving takeaway orders only',
          style: context.customTextTheme.text14W500,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> showSlotChooseSheet(
      BuildContext context, ShopProvider shopProvider) async {
    return await showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        final shopListener = context.watch<ShopProvider>();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Slots for ${shopListener.formattedSelectedDate}",
                  style: context.customTextTheme.text18W600
                      .copyWith(color: AppColors.kBlack),
                ),
                shopListener.isSlotsEmpty
                    ? Column(
                        children: [
                          verticalSpaceRegular,
                          const Icon(
                            FluentIcons.clock_dismiss_24_regular,
                            size: 75,
                            color: Colors.grey,
                          ),
                          verticalSpaceRegular,
                          Text(
                            "No Slots available for the slected date",
                            style: context.customTextTheme.text16W500
                                .copyWith(color: AppColors.kBlack),
                          ),
                          verticalSpaceRegular,
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Wrap(
                          children: shopListener.slotForSelectedDate
                                  ?.map((slot) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: ChoiceChip(
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            color: const WidgetStatePropertyAll(
                                                Colors.white),
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
                                            selected: shopListener
                                                    .selectedDeliverySlot ==
                                                slot),
                                      ))
                                  .toList() ??
                              [],
                        ),
                      ),
                verticalSpaceSmall,
                InkWell(
                  onTap: () {
                    if (shopListener.selectedDeliverySlot == null &&
                        !shopListener.isSlotsEmpty) {
                      AlertDialogs.showWarning("Choose a delivery slot");
                      return;
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    width: context.screenWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).colorScheme.primary),
                    child: Center(
                        child: Text(
                      shopListener.slotForSelectedDate?.isEmpty == true
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
          ),
        );
      },
    );
  }

  Widget _buildTakeAwayTimeWidget() {
    return Builder(builder: (context) {
      final cartListener = context.watch<CartProvider>();

      final cartProvider = context.read<CartProvider>();
      final themeListener = context.watch<ThemeProvider>();

      return InkWell(
        onTap: () async {
          TimeOfDay? pickUpTime;

          if (Platform.isAndroid) {
            pickUpTime = await showTimePicker(
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
                    textTheme: poppinsTextTheme(context).textTheme.copyWith(
                        bodySmall: const TextStyle(color: Colors.white)),
                    timePickerTheme: TimePickerThemeData(
                        helpTextStyle: const TextStyle(color: AppColors.kWhite),
                        dialTextColor: WidgetStateColor.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.kBlack;
                            }
                            return AppColors.kWhite;
                          },
                        ),
                        backgroundColor: themeListener.isDarkMode
                            ? AppColors.kCardBackground2
                            : AppColors.kLightWhite2,
                        dialBackgroundColor: AppColors.kBlack,
                        dayPeriodColor: WidgetStateColor.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return Theme.of(context).colorScheme.primary;
                            }
                            return AppColors.kBlack;
                          },
                        ),
                        hourMinuteColor: WidgetStateColor.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Theme.of(context).colorScheme.primary;
                          }
                          return AppColors.kBlack;
                        }),
                        hourMinuteTextColor: WidgetStateColor.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.kBlack;
                            }
                            return AppColors.kWhite;
                          },
                        ),
                        dayPeriodTextColor: WidgetStateColor.resolveWith(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.kBlack;
                            }
                            return AppColors.kWhite;
                          },
                        )),
                  ),
                  child: child!,
                );
              },
            );
          } else {
            pickUpTime = await showModalBottomSheet<TimeOfDay>(
              context: context,
              builder: (context) {
                return Container(
                  height: 250,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, pickUpTime);
                          },
                          child: const Text("Done"),
                        ),
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: DateTime.now(),
                          use24hFormat: false,
                          onDateTimeChanged: (DateTime newTime) {
                            pickUpTime =
                                DateTimeUtils.convertDateTimeToTimeOfDay(
                                    newTime);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (pickUpTime == null) return;
          cartProvider.onChangePickUpTime(
            DateTimeUtils.combineDateTime(DateTime.now(), pickUpTime!),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              FluentIcons.clock_24_regular,
              color: Theme.of(context).iconTheme.color,
            ),
            horizontalSpaceSmall,
            Expanded(
              child: Text(
                cartListener.selectedPickUpTime == null
                    ? "Select Pick Up Time"
                    : "Pickup on ${DateTimeUtils.formatDateTimeToTime(
                        cartListener.selectedPickUpTime!,
                      )}",
                style: context.customTextTheme.text16W600.copyWith(
                  color: themeListener.isDarkMode ? Colors.white : null,
                ),
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

  Future<void> showAddressListSheet(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
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
      builder: (context) {
        final userListener = context.watch<UserProvider>();
        final cartListener = context.watch<CartProvider>();
        final themeListener = context.watch<ThemeProvider>();

        final addressList = userListener.searchAddressTxtController.text.isEmpty
            ? userListener.userAddressList
            : userListener.searchAddressListItem;

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
                height: context.screenHeight * 0.8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: userListener.isUserAddressListLoading
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Column(
                        children: [
                          verticalSpaceSmall,
                          const BottomSheetDragHandler(),

                          verticalSpaceRegular,
                          // Search TextField
                          TextFormField(
                            style: TextStyle(
                              color: themeListener.isDarkMode
                                  ? Colors.white
                                  : null,
                            ),
                            controller: userListener.searchAddressTxtController,
                            onChanged: (value) =>
                                userListener.searchAddressByPostCode(value),
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Assets.lib.assets.icons.searchNormal.svg(
                                  height: 16,
                                  width: 16,
                                  color: themeListener.isDarkMode
                                      ? AppColors.kGray3
                                      : null,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              isDense: true,
                              fillColor: themeListener.isDarkMode
                                  ? AppColors.kCardBackground2
                                  : AppColors.kLightBlue2,
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
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                          ),
                          verticalSpaceMedium,
                          // Display Address List
                          Expanded(
                            child: addressList.isNotEmpty
                                ? ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: addressList.length,
                                    itemBuilder: (context, index) {
                                      final address = addressList[index];

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          // boxShadow: const <BoxShadow>[
                                          //   BoxShadow(
                                          //     color:
                                          //         Color.fromRGBO(0, 0, 0, 0.1),
                                          //     spreadRadius: 0,
                                          //     blurRadius: 8,
                                          //     offset: Offset(0, 3),
                                          //   ),
                                          // ],
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: ListTileTheme(
                                                enableFeedback: true,
                                                tileColor: themeListener
                                                        .isDarkMode
                                                    ? AppColors.kCardBackground2
                                                    : null,
                                                horizontalTitleGap: 8.0,
                                                child: RadioListTile(
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  value: address,
                                                  groupValue: cartListener
                                                      .selectedAddress,
                                                  onChanged:
                                                      (UserAddressDataModel?
                                                          newAddress) {
                                                    if (newAddress == null) {
                                                      return;
                                                    }
                                                    context
                                                        .read<CartProvider>()
                                                        .onChangeAddress(
                                                            newAddress);
                                                    context
                                                        .read<CartProvider>()
                                                        .selectedAddressSecondaryFunc(
                                                            newAddress);
                                                  },
                                                  title: Text(
                                                    address.userFullname,
                                                    style: context
                                                        .customTextTheme
                                                        .text18W600
                                                        .copyWith(
                                                      color: themeListener
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    Utils.removeExtraSpaces(
                                                        address.userFulladdress
                                                            .capitalize()),
                                                    style: context
                                                        .customTextTheme
                                                        .text16W400
                                                        .copyWith(
                                                      color: themeListener
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<UserProvider>()
                                                    .initAllTextEditingController();
                                                context
                                                    .read<UserProvider>()
                                                    .loadDataForAddressUpdate(
                                                        address);

                                                context.router.push(
                                                  AddNewAddressScreenRoute(
                                                    address: address,
                                                  ),
                                                );
                                              },
                                              icon: Assets
                                                  .lib.assets.icons.editIcon
                                                  .svg(
                                                      color: themeListener
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : null),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // Prevents dismissing while loading
                                                  builder:
                                                      (BuildContext context) {
                                                    return Consumer<
                                                        UserProvider>(
                                                      builder: (context,
                                                          userListener, child) {
                                                        bool isLoading =
                                                            userListener
                                                                .isDeletingUserAddress;

                                                        return Stack(
                                                          children: [
                                                            AlertDialog(
                                                              title: isLoading
                                                                  ? null
                                                                  : Center(
                                                                      child:
                                                                          Text(
                                                                        'Address',
                                                                        style: context
                                                                            .customTextTheme
                                                                            .text18W600
                                                                            .copyWith(
                                                                          color: context
                                                                              .customTextTheme
                                                                              .color,
                                                                        ),
                                                                      ),
                                                                    ),
                                                              content: userListener
                                                                      .isDeletingUserAddress
                                                                  ? null
                                                                  : Text(
                                                                      'Are you sure you want to delete this address?',
                                                                      style: context
                                                                          .customTextTheme
                                                                          .text16W400
                                                                          .copyWith(
                                                                        color: context
                                                                            .customTextTheme
                                                                            .color,
                                                                      ),
                                                                    ),
                                                              actions: isLoading
                                                                  ? null
                                                                  : <Widget>[
                                                                      Center(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            OutlinedButton(
                                                                              onPressed: isLoading
                                                                                  ? null
                                                                                  : () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                              style: OutlinedButton.styleFrom(
                                                                                side: BorderSide(
                                                                                  color: Theme.of(context).colorScheme.primary,
                                                                                ),
                                                                              ),
                                                                              child: const Text('Cancel'),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            ElevatedButton(
                                                                              style: ButtonStyle(
                                                                                backgroundColor: WidgetStatePropertyAll(
                                                                                  Theme.of(context).colorScheme.primary,
                                                                                ),
                                                                                foregroundColor: WidgetStatePropertyAll(
                                                                                  AppColors.kBlack,
                                                                                ),
                                                                              ),
                                                                              onPressed: isLoading
                                                                                  ? null
                                                                                  : () async {
                                                                                      final currentContext = context; // Store context

                                                                                      await userListener.deleteUserAddress(address.uaID.toString());
                                                                                      // cartListener.selectedAddressSecondary = null;

                                                                                      cartListener.clearSelectedAddressSecondary();

                                                                                      if (currentContext.mounted) {
                                                                                        Navigator.of(currentContext).pop();

                                                                                        currentContext.read<UserProvider>().getAddressList();
                                                                                      }
                                                                                    },
                                                                              child: const Text(
                                                                                'Delete',
                                                                                style: TextStyle(color: AppColors.kBlack),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                            ),
                                                            if (isLoading)
                                                              Container(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.2),
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: AppColors
                                                                        .kBlack,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: themeListener.isDarkMode
                                                    ? Colors.white
                                                    : AppColors.kGray,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return verticalSpaceRegular;
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      userListener.searchAddressTxtController
                                              .text.isEmpty
                                          ? 'No address found'
                                          : 'The address is not found',
                                      style: context.customTextTheme.text14W400
                                          .copyWith(
                                        color: themeListener.isDarkMode
                                            ? Colors.white
                                            : null,
                                      ),
                                    ),
                                  ),
                          ),

                          Row(
                            children: [
                              Expanded(
                                  child: FilledButton(
                                onPressed: () {
                                  context
                                      .read<UserProvider>()
                                      .initAllTextEditingController();
                                  context.router.push(
                                      AddNewAddressScreenRoute(address: null));
                                },
                                style: FilledButton.styleFrom(
                                  // minimumSize: const Size.fromHeight(48),
                                  backgroundColor: Colors.transparent,

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                ),
                                child: Text(
                                  '+ Add Address',
                                  style: context.customTextTheme.text14W600
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              )),
                              horizontalSpaceSmall,
                              Visibility(
                                visible:
                                    userListener.userAddressList.isNotEmpty,
                                child: Expanded(
                                  child: FilledButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    onPressed: cartListener
                                            .deliveryOrTakeAwayChargeCalculating
                                        ? null
                                        : () async {
                                            context
                                                .read<CartProvider>()
                                                .validateAddress()
                                                .then((validated) {
                                              if (validated) {
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);
                                              }
                                            });
                                          },
                                    child: cartListener
                                            .deliveryOrTakeAwayChargeCalculating
                                        ? showButtonProgress(Colors.black)
                                        : Text('Apply',
                                            style: context
                                                .customTextTheme.text14W600
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceSmall,
                          SizedBox(height: bottomInsets > 0 ? bottomInsets : 0)
                        ],
                      ),
              ),
            ],
          ),
        );
      },
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
                        ? Theme.of(context).colorScheme.primary.withOpacity(1)
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
                Visibility(
                  visible: false,
                  child: Positioned(
                    right: rightPos ?? -18,
                    bottom: bottomPos ?? -18,
                    child: icon,
                  ),
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
