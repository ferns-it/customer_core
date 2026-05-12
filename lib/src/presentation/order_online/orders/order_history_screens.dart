import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/order/order_provider.dart';
import 'package:customer_core/src/application/theme/theme_provider.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/app_theme.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/date_utils.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/user/models/order_history_raw_data_model.dart';
import 'package:customer_core/src/presentation/auth/login_screen.dart';
import 'package:customer_core/src/presentation/widgets/button_progress.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';

import '../../../core/routes/routes.gr.dart';

@RoutePage()
class OrderHistoryScreen extends GetProviderView<OrderProvider> {
  const OrderHistoryScreen(this.isFromProfileScreen, {super.key});

  final bool isFromProfileScreen;

  @override
  Widget build(BuildContext context) {
    final orderProvider = notifier(context);
    final orderListener = listener(context);
    final themeListener = listener2<ThemeProvider>(context);
    final cartListener = context.watch<CartProvider>();
    final cartProvider = context.read<CartProvider>();
    final userListener = context.watch<UserProvider>();

    return Theme(
      data: quickSandTextTheme(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // appBar: AppBar(
        //   centerTitle: true,
        //   leading: isFromProfileScreen
        //       ? const CustomBackButton()
        //       : const SizedBox.shrink(),
        //   // leading: const CustomBackButton(),
        //   backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        //   automaticallyImplyLeading: false,
        //   leadingWidth: 70,
        //   title:
        //       Text("Orders History", style: context.customTextTheme.text18W600),
        //   bottom: PreferredSize(
        //     preferredSize: const Size.fromHeight(1.0),
        //     child: Container(
        //       color: AppColors.kLightGray2,
        //       height: 1.0,
        //     ),
        //   ),
        // ),
        body: FutureBuilder(
          future: orderProvider.checkUserIsLogged(),
          builder: (context, snapshot) {
            final isLogged = snapshot.data ?? false;
            return orderListener.ordersResponse.when(
              initial: () => Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLogged) ...[
                    Assets.lib.assets.images.userlogin.image(height: 300),
                    Text(
                      !isLogged ? "Please log in to continue" : "No Orders",
                      style: context.customTextTheme.text16W400
                          .copyWith(color: AppColors.kWhite),
                    ),
                    verticalSpaceSmall,
                    Visibility(
                      visible: !isLogged,
                      child: TextButton(
                        onPressed: () async {
                          // context.router.replace(LoginScreenRoute());
                          final result = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LoginScreen(
                                  showBackButton: true,
                                ),
                              ));

                          if (result) {
                            Future.wait([
                              userListener.getUserData(),
                              userListener.getAddressList(),
                              orderProvider.fetchAllOrders(),
                              if (cartListener.cartItems.isNotEmpty) ...[
                                cartProvider.transferCart(),
                              ],
                            ]);
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('LOGIN'),
                      ),
                    )
                  ],
                  if (isLogged) ...[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.lib.assets.images.noOrders.image(
                            width: context.screenWidth * 0.4,
                            height: context.screenHeight * 0.2,
                          ),
                          verticalSpaceSmall,
                          Text(
                            'No orders found..',
                            style: context.customTextTheme.text16W700.copyWith(
                              color: AppColors.kWhite,
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
                ],
              )),
              loading: () => Center(
                  child: showButtonProgress(
                      Theme.of(context).colorScheme.primary)),
              completed: (_) {
                final data = orderListener.orders;
                final orderHistory = data
                    .where((e) => e.orderDispatched || e.orderRejected)
                    .toList();
                // if (data.isEmpty) {
                //   return SafeArea(
                //     child: Column(
                //       // mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         buildSearchFilterWidget(context),
                //         SizedBox(height: context.screenHeight * 0.2),
                //         Assets.images.noOrders.image(
                //           width: context.screenWidth * 0.4,
                //           height: context.screenHeight * 0.2,
                //         ),
                //         verticalSpaceSmall,
                //         Text(
                //           'No orders found..',
                //           style: context.customTextTheme.text16W700.copyWith(
                //             color: Theme.of(context).colorScheme.primary,
                //           ),
                //         ),
                //       ],
                //     ),
                //   );
                // }

                return SafeArea(
                  child: DefaultTabController(
                    length: 2,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Column(children: [
                          TabBar(
                            tabs: const [
                              Tab(text: "Active Orders"),
                              Tab(text: "History"),
                            ],
                            dividerColor: Colors.transparent,
                            labelColor: Theme.of(context).colorScheme.primary,
                            unselectedLabelColor:
                                Theme.of(context).disabledColor,
                          ),
                          Expanded(
                              child: TabBarView(
                            children: [
                              RefreshIndicator(
                                onRefresh: () {
                                  return orderProvider.fetchAllOrders();
                                },
                                child: Column(
                                  children: [
                                    verticalSpaceRegular,
                                    buildSearchFilterWidget(context),
                                    Expanded(
                                      child: orderListener
                                              .getActiveOrders.isEmpty
                                          ? const Center(
                                              child: Text("No orders found",
                                                  style: TextStyle(
                                                      color: AppColors.kWhite)),
                                            )
                                          : ListView.builder(
                                              itemCount: orderListener
                                                  .getActiveOrders.length,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              itemBuilder: (context, index) {
                                                final order = orderListener
                                                    .getActiveOrders
                                                    .elementAt(index);
                                                return InkWell(
                                                  onTap: () {
                                                    if (order.orderID == null) {
                                                      return;
                                                    }
                                                    orderProvider
                                                        .updateViewOrderId(
                                                            order.orderID!);
                                                    context.router.push(
                                                        const ViewOrderScreenRoute());
                                                  },
                                                  child: historyOrderCard2(
                                                      order,
                                                      context,
                                                      themeListener),
                                                );
                                              }),
                                    ),
                                  ],
                                ),
                              ),
                              RefreshIndicator(
                                  onRefresh: () {
                                    return orderProvider.fetchAllOrders();
                                  },
                                  child: Column(
                                    children: [
                                      verticalSpaceRegular,
                                      buildSearchFilterWidget(context),
                                      Expanded(
                                        child: orderHistory.isEmpty
                                            ? const Center(
                                                child: Text("No orders found",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.kWhite)),
                                              )
                                            : ListView.builder(
                                                itemCount: orderHistory.length,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                itemBuilder: (context, index) {
                                                  final order = orderHistory
                                                      .elementAt(index);
                                                  return InkWell(
                                                    onTap: () {
                                                      if (order.orderID ==
                                                          null) {
                                                        return;
                                                      }
                                                      orderProvider
                                                          .updateViewOrderId(
                                                              order.orderID!);
                                                      context.router.push(
                                                          const ViewOrderScreenRoute());
                                                    },
                                                    child: historyOrderCard2(
                                                        order,
                                                        context,
                                                        themeListener),
                                                  );
                                                }),
                                      )
                                    ],
                                  ))
                            ],
                          ))
                        ])),
                  ),
                );
              },
              error: (message, exception) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message ?? "Something went wrong",
                      style: context.customTextTheme.text16W400
                          .copyWith(color: AppColors.kWhite),
                    ),
                    TextButton(
                        onPressed: () {
                          orderProvider.fetchAllOrders();
                        },
                        child: const Text("Try Again"))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSearchFilterWidget(BuildContext context) {
    final orderProvider = notifier(context);

    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    FluentIcons.search_20_regular,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade600
                        : Colors.grey.shade700,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: orderProvider.searchController,
                      onChanged: (value) {
                        orderProvider.searchOrders(value);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Search for orders',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          onTap: () {
            final currentYear = DateTime.now().year;
            final years = List.generate(5, (i) => currentYear - i);

            if (Platform.isIOS) {
              showCupertinoModalPopup(
                context: context,
                builder: (_) => CupertinoActionSheet(
                  title: const Text("Select Year",
                      style: TextStyle(color: Colors.white)),
                  actions: years
                      .map(
                        (year) => CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);

                            orderProvider.fetchAllOrders(year: year.toString());
                          },
                          child: Text(year.toString()),
                        ),
                      )
                      .toList(),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Navigator.pop(context),
                    isDefaultAction: true,
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
              );
            } else {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => ListView(
                  shrinkWrap: true,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Select Year",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ...years.map(
                      (year) => ListTile(
                        title: Center(
                          child: Text(year.toString()),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          orderProvider.fetchAllOrders(year: year.toString());
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(CupertinoIcons.slider_horizontal_3,
                color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget historyOrderCard2(OrderDetailsModel order, BuildContext context,
      ThemeProvider themeListener) {
    final listOfProducts = order.orderDishes ?? [];
    final isMoreThanThreeItems = listOfProducts.length > 3;
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: themeListener.isDarkMode
            ? AppColors.kCardBackground2
            : AppColors.kWhite,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    order.customerOrderID ?? "",
                    style: context.customTextTheme.text16W700
                        .copyWith(color: context.customTextTheme.color),
                  ),
                  Row(
                    children: [
                      Text(
                        order.isTakeaway ? "Pickup" : "Delivery",
                        style: context.customTextTheme.text14W700
                            .copyWith(color: Colors.grey.shade600),
                      ),
                      Text(
                        order.netAmount != null ? ' • ${order.netAmount}' : '',
                        style: context.customTextTheme.text14W700
                            .copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                order.orderAccepted
                    ? "Accepted"
                    : order.orderPending
                        ? "Pending"
                        : order.orderDispatched
                            ? "Dispatched"
                            : order.orderRejected
                                ? "Rejected"
                                : "N/A",
                style: context.customTextTheme.text14W600
                    .copyWith(color: Colors.red
                        // color: order.orderAccepted
                        //     ? Colors.green
                        //     : order.orderPending
                        //         ? Colors.orange
                        //         : order.orderDispatched
                        //             ? Colors.red
                        //             : order.orderRejected
                        //                 ? Colors.amber
                        //                 : Colors.grey,
                        ),
              )
            ],
          ),
          Divider(
              color: themeListener.isDarkMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.grey.shade200),
          Column(
            children: listOfProducts
                .take(3)
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: buildTextIconWidget(
                      context: context,
                      text:
                          '${e.quantity} x ${e.name} ${e.variationName != null ? '(${e.variationName})' : ''}',
                      icon: FluentIcons.food_24_regular,
                    ),
                  ),
                )
                .toList(),
          ),
          Column(
            children: [
              isMoreThanThreeItems
                  ? Text(
                      '+ ${listOfProducts.length - 3} more items',
                      style: context.customTextTheme.text14W400
                          .copyWith(color: context.customTextTheme.color),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Divider(
              color: themeListener.isDarkMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.grey.shade200),
          Text(
              "Order Placed On: ${DateTimeUtils.formatDateTimeToDate(order.orderedAt)}, ${DateTimeUtils.formatTimeMinimal(order.orderedAt)}",
              style: context.customTextTheme.text14W400
                  .copyWith(color: context.customTextTheme.color)),
          // Divider(
          //     color: themeListener.isDarkMode
          //         ? Theme.of(context).scaffoldBackgroundColor
          //         : Colors.grey.shade200),
          // verticalSpaceSmall,
          // buildFooterDetails(order, context),
        ],
      ),
    );
  }

  Widget historyOrderCard(OrderDetailsModel order, BuildContext context,
      ThemeProvider themeListener) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: themeListener.isDarkMode
            ? AppColors.kCardBackground2
            : AppColors.kWhite,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildTitleCard(order, context),
            Divider(
                color: themeListener.isDarkMode
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.grey.shade200),
            verticalSpaceSmall,
            buildOrderDetails(order, context),
            verticalSpaceRegular,
            buildOrderFooter(order, context),
            verticalSpaceSmall,
            Divider(
                color: themeListener.isDarkMode
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.grey.shade200),
            buildFooterDetails(order, context),
          ],
        ),
      ),
    );
  }

  Widget buildFooterDetails(OrderDetailsModel order, BuildContext context) {
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

  Widget buildOrderFooter(OrderDetailsModel order, BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(FluentIcons.calendar_20_regular,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : null),
        horizontalSpaceSmall,
        Text(DateTimeUtils.formatDateTimeToDate(order.orderedAt),
            style: context.customTextTheme.text14W600
                .copyWith(color: context.customTextTheme.color)),
        const Spacer(),
        Icon(FluentIcons.clock_20_regular,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : null),
        horizontalSpaceSmall,
        Text(DateTimeUtils.formatTimeMinimal(order.orderedAt),
            style: context.customTextTheme.text14W600
                .copyWith(color: context.customTextTheme.color)),
      ],
    );
  }

  Widget buildOrderDetails(OrderDetailsModel order, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Assets.lib.assets.icons.moneyBlack.image(
            height: 24,
            width: 24,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : null),
        horizontalSpaceSmall,
        Text(('${order.paymentType ?? 'N/A'} Payment'),
            style: context.customTextTheme.text14W600
                .copyWith(color: context.customTextTheme.color)),
        const Spacer(),
        Text(order.formattedAmount ?? '',
            style: context.customTextTheme.text16W600
                .copyWith(color: context.customTextTheme.color)),
      ],
    );
  }

  Widget buildTitleCard(OrderDetailsModel order, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Assets.lib.assets.images.shopid.image(
                width: 20,
                height: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : null),
            horizontalSpaceSmall,
            Text(
              order.customerOrderID ?? "",
              style: context.customTextTheme.text14W700
                  .copyWith(color: context.customTextTheme.color),
            ),
          ],
        ),
        horizontalSpaceSmall,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.kCardBackground2
                : null,
            border: Border.all(color: AppColors.kGray),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              order.isTakeaway
                  ? Assets.lib.assets.icons.takeAway.image(
                      height: 22,
                      width: 22,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.kBlack,
                    )
                  : Assets.lib.assets.icons.fastDelivery.image(
                      height: 22,
                      width: 22,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.kBlack,
                    ),
              horizontalSpaceVerySmall,
              Text(
                order.isTakeaway ? "Pickup: ${order.takeawayTime}" : "Delivery",
                style: context.customTextTheme.text14W600
                    .copyWith(color: context.customTextTheme.color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextIconWidget({
    required BuildContext context,
    required String text,
    required IconData icon,
    bool isExpand = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 21,
          color: AppColors.kGray3,
        ),
        horizontalSpaceSmall,
        isExpand
            ? Expanded(
                child: Text(
                  text,
                  style: context.customTextTheme.text12W400
                      .copyWith(color: context.customTextTheme.color),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              )
            : Text(
                text,
                style: context.customTextTheme.text14W400
                    .copyWith(color: context.customTextTheme.color),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
      ],
    );
  }
}
