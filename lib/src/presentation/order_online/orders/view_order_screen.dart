import 'package:auto_route/annotations.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/core/dependency_registrar.dart';
import 'package:customer_core/src/domain/cart/models/cart_details_model.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/order/order_provider.dart';
import 'package:customer_core/src/core/theme/app_theme.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/presentation/widgets/custom_painer_shape.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../domain/user/models/order_history_raw_data_model.dart';

@RoutePage()
class ViewOrderScreen extends GetProviderView<OrderProvider> {
  const ViewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = notifier(context);
    final orderListener = listener(context);
    final orderDetails = orderListener.viewOrderDetails;
    // final customerDetails = listener2<UserProvider>(context).userData;
    // final cartListener = context.watch<CartProvider>();

    return Theme(
      data: quickSandTextTheme(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Order Details",
            style: context.customTextTheme.text20W600,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: orderDetails == null
            ? const Center(
                child: Text(
                  "Failed to retrieve order details.\nPlease go back and select it again.",
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0)
                          .copyWith(top: 20),
                      child: orderDetails.orderRejected == true
                          ? Container(
                              width: double.infinity,
                              // padding: EdgeInsets.symmetric(horizontal: 10)
                              //     .copyWith(top: 5, bottom: 5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.red.shade400.withOpacity(0.2)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.error,
                                        size: 18,
                                        color: Colors.red.shade400,
                                      ),
                                      Text(
                                        " Rejected ",
                                        style: TextStyle(
                                            color: Colors.red.shade500,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    orderDetails.status ?? '',
                                    style: TextStyle(
                                        color: context.customTextTheme.color),
                                  ),
                                ],
                              ),
                            )
                          : builderOrderStatusDetails(
                              orderDetails,
                              context,
                            ),
                    ),
                    verticalSpaceRegular,
                    buildOrderSummaryContainer(context, orderDetails),
                    verticalSpaceSmall,
                    _buildOrderAddressDetails(orderDetails, context),
                    verticalSpaceLarge,
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildOrderAddressDetails(
    OrderDetailsModel orderDetails,
    // UserLoginResponse customerDetails,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.kCardBackground2
            : AppColors.kWhite,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            spreadRadius: 0,
            blurRadius: 8.0,
            offset: Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 22.0,
        vertical: 20.0,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Assets.lib.assets.icons.deliveryAddress.svg(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.kWhite
                      : null,
                ),
                horizontalSpaceSmall,
                Text(
                  orderDetails.isTakeaway ? "Bill address" : "Delivery address",
                  style: context.customTextTheme.text16W600.copyWith(
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                      color: context.customTextTheme.color),
                ),
              ],
            ),
            verticalSpaceSmall,
            SizedBox(
              width: constraints.maxWidth * 0.8,
              child: Text(
                orderDetails.deliveryAddress?.customerName ?? "",
                style: context.customTextTheme.text16W500
                    .copyWith(color: context.customTextTheme.color),
              ),
            ),
            Text(
              orderDetails.phone ?? "",
              style: context.customTextTheme.text16W500
                  .copyWith(color: context.customTextTheme.color),
            ),
            Text(
              orderDetails.deliveryAddress?.customerFullAddress ?? "",
              style: context.customTextTheme.text16W500
                  .copyWith(color: context.customTextTheme.color),
            ),
          ],
        );
      }),
    );
  }

  Widget buildOrderSummaryContainer(
    BuildContext context,
    OrderDetailsModel orderDetails,
  ) {
    return ClipPath(
      clipper: RPSCustomClipper(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 20.0,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 18.0),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.kCardBackground2
              : AppColors.kWhite,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              spreadRadius: 0,
              blurRadius: 10.0,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Order Summary',
              style: context.customTextTheme.text16W700.copyWith(
                  decoration: TextDecoration.underline,
                  color: context.customTextTheme.color),
            ),
            verticalSpaceTiny,
            ...orderDetails.orderDishes?.map((dish) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  maxLines: 2,
                                  "${dish.quantity} x ${dish.name}",
                                  style: context.customTextTheme.text16W700
                                      .copyWith(
                                          color: context.customTextTheme.color),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  "${dish.totalPrice}",
                                  style: context.customTextTheme.text16W700
                                      .copyWith(
                                    color: context.customTextTheme.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (dish.variationName != null)
                                Text(
                                  "(${dish.variationName})",
                                  style: context.customTextTheme.text14W500
                                      .copyWith(
                                    color: context.customTextTheme.color,
                                  ),
                                ),
                              if (dish.addons != null)
                                ...dish.addons!.map(
                                  (addon) => Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "+ ${addon.name}",
                                            style: context
                                                .customTextTheme.text14W500
                                                .copyWith(
                                              color:
                                                  context.customTextTheme.color,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          " ${addon.price}",
                                          style: context
                                              .customTextTheme.text14W500
                                              .copyWith(
                                            color:
                                                context.customTextTheme.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          )
                          // Row(
                          //   children: <Widget>[
                          //     Flexible(
                          //       child: SizedBox(
                          //         width: constraints.maxWidth * 0.7,
                          //         child: Text(
                          //           maxLines: 3,
                          //           dish.dishVariationAndModifiers,
                          //           style: context.customTextTheme.text14W500
                          //               .copyWith(
                          //                   color:
                          //                       context.customTextTheme.color),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      );
                    }),
                  );
                }).toList() ??
                [],
            verticalSpaceRegular,
            Assets.lib.assets.icons.zigzag.svg(),
            verticalSpaceLarge,
            _SummaryRow(
              label: "Order Type",
              value: orderDetails.formattedDeliveryType,
              style: context.customTextTheme.text14W600
                  .copyWith(color: context.customTextTheme.color),
            ),
            if (orderDetails.isTakeaway) ...[
              verticalSpaceTiny,
              _SummaryRow(
                label: "Pickup Time",
                value: orderDetails.takeawayTime ?? "",
                style: context.customTextTheme.text14W600
                    .copyWith(color: context.customTextTheme.color),
              ),
            ],
            verticalSpaceTiny,
            _SummaryRow(
              label: "Payment",
              value: orderDetails.paymentGatway ?? "",
              style: context.customTextTheme.text14W600
                  .copyWith(color: context.customTextTheme.color),
            ),
            verticalSpaceRegular,
            Text(
              "Bill Details",
              style: context.customTextTheme.text16W600.copyWith(
                  decoration: TextDecoration.underline,
                  color: context.customTextTheme.color),
            ),
            verticalSpaceSmall,
            _SummaryRow(
              label: "Sub Total",
              value: "${orderDetails.grossAmount}",
              style: context.customTextTheme.text16W600
                  .copyWith(color: context.customTextTheme.color),
            ),
            if (!orderDetails.isTakeaway) ...[
              verticalSpaceTiny,
              _SummaryRow(
                label: "Delivery Charge",
                value: orderDetails.formatDeliveryChargeToDouble == 0.00
                    ? 'Free'
                    : orderDetails.formattedDeliveryCharge ?? "0.00",
                // value:orderDetails.formattedDeliveryCharge ?? "0.00",
                style: context.customTextTheme.text14W600
                    .copyWith(color: context.customTextTheme.color),
              ),
            ],
            verticalSpaceTiny,
            _SummaryRow(
              label: "Discount",
              value: " ${orderDetails.totalDiscount}",
              style: context.customTextTheme.text14W600
                  .copyWith(color: context.customTextTheme.color),
            ),
            verticalSpaceTiny,
            _SummaryRow(
              label: orderDetails.taxLabel ?? 'TAX',
              value: orderDetails.taxTotalAmount ?? '0.00',
              style: context.customTextTheme.text14W600
                  .copyWith(color: context.customTextTheme.color),
            ),
            const Divider(height: 20.0),
            _SummaryRow(
              label: "Total",
              value: orderDetails.netAmount ??
                  "${AppConfig.instance.country.symbol}0.00",
              style: context.customTextTheme.text18W600
                  .copyWith(color: context.customTextTheme.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget builderOrderStatusDetails(
      OrderDetailsModel order, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildStatusWidget(
          "Pending",
          completed: order.orderPending ||
              order.orderAccepted ||
              order.orderDispatched,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Divider(
              color: order.orderAccepted || order.orderDispatched
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              thickness: 1,
            ),
          ),
        ),
        buildStatusWidget(
          "Accepted",
          completed: order.orderAccepted || order.orderDispatched,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Divider(
              color: order.orderDispatched
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              thickness: 1,
            ),
          ),
        ),
        buildStatusWidget("Dispatched", completed: order.orderDispatched),
      ],
    );
  }

  Widget buildStatusWidget(
    String data, {
    bool completed = false,
  }) {
    return Builder(builder: (context) {
      return Column(
        children: <Widget>[
          Icon(
            Icons.adjust_rounded,
            color: completed
                ? Theme.of(context).colorScheme.primary
                : AppColors.kGray7,
            size: 22,
          ),
          verticalSpaceTiny,
          Text(
            data,
            style: context.customTextTheme.text12W400.copyWith(
              color: completed
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.kGray7,
            ),
          )
        ],
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
