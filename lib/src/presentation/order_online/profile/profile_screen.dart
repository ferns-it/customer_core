import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:customer_core/src/application/order/order_provider.dart';
import 'package:auto_route/auto_route.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/application/theme/theme_provider.dart';
// Import flutter_svg to handle SVG
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/auth/login_screen.dart';
import 'package:customer_core/src/presentation/order_online/profile/delete_account_screen.dart';
import 'package:customer_core/src/presentation/widgets/bottom_sheet_drag_handler.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:provider/provider.dart';

// import 'package:random_avatar/random_avatar.dart';

import '../../../application/auth/auth_provider.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/user/models/order_history_raw_data_model.dart';
import '../../widgets/button_progress.dart';

@RoutePage()
class ProfileScreen extends GetProviderView<UserProvider> {
  const ProfileScreen(this.isFromHome, this.onTap, {super.key});
  final bool isFromHome;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    notifier(context);
    final userListner = listener(context);
    final userProvider = notifier(context);
    final orderProvider = notifier2<OrderProvider>(context);
    final orderListener = listener2<OrderProvider>(context);
    final cartProvider = context.read<CartProvider>();
    final cartListener = context.watch<CartProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
          future: orderProvider.checkUserIsLogged(),
          builder: (context, snapshot) {
            final isLogged = snapshot.data ?? false;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBioWidget(userListner, context),
                    // verticalSpaceRegular,
                    // Text(
                    //   'Appearance',
                    //   style: context.customTextTheme.text16W600,
                    // ),
                    // verticalSpaceSmall,
                    // _buildAppAppearance(context),
                    Visibility(
                      visible: true,
                      child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: _buildAppAppearance(context),
                          )),
                    ),

                    if (isLogged) ...[
                      Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            verticalSpaceSmall,
                            _buildActiveOrders(context),
                            // Divider(
                            //   color: isDark
                            //       ? AppColors.kCardBackground2
                            //       : Colors.grey.shade100,
                            //   indent: 15,
                            //   endIndent: 15,
                            // ),
                            // _buildNotifications(context),
                            Divider(
                              color: isDark
                                  ? AppColors.kCardBackground2
                                  : Colors.grey.shade100,
                              indent: 15,
                              endIndent: 15,
                            ),
                            _buildNotificationsPreference(context),
                            Divider(
                              color: isDark
                                  ? AppColors.kCardBackground2
                                  : Colors.grey.shade100,
                              indent: 15,
                              endIndent: 15,
                            ),
                            _buildFavouriteProducts(context),
                            Divider(
                              color: isDark
                                  ? AppColors.kCardBackground2
                                  : Colors.grey.shade100,
                              indent: 15,
                              endIndent: 15,
                            ),
                            _buildUpdateAddress(context),
                            verticalSpaceSmall,
                          ],
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            verticalSpaceSmall,
                            _buildDeleteAccount(context),
                            Divider(
                              color: isDark
                                  ? AppColors.kCardBackground2
                                  : Colors.grey.shade100,
                              indent: 15,
                              endIndent: 15,
                            ),
                            _buildSettingOptions(context),
                            verticalSpaceSmall,
                          ],
                        ),
                      ),
                    ] else
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.lib.assets.images.userpassword
                              .image(height: 300),
                          Text(
                            !isLogged ? "Please log in to continue" : "",
                            style: context.customTextTheme.text16W400
                                .copyWith(color: context.customTextTheme.color),
                          ),
                          verticalSpaceSmall,
                          FilledButton(
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
                                await userListner.getUserData();
                                await userListner.getAddressList();
                                await orderProvider.fetchAllOrders();
                                if (cartListener.cartItems.isNotEmpty) {
                                  await cartProvider.transferCart();
                                }
                              }
                            },
                            style: FilledButton.styleFrom(
                                disabledBackgroundColor: Colors.transparent,
                                disabledForegroundColor:
                                    Theme.of(context).disabledColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                fixedSize: const Size(double.infinity, 30),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(color: AppColors.kWhite),
                            ),
                          )
                        ],
                      )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buidOrdderHistoryWidget(List<OrderDetailsModel> data) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
          itemCount: 1,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          itemBuilder: (context, index) {
            final order = data.elementAt(index);
            return InkWell(
              // onTap: () {
              //   if (order.orderID == null) return;
              //   orderProvider.updateViewOrderId(order.orderID!);
              //   context.router.push(const ViewOrderScreenRoute());
              // },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildHeader(context),
                      verticalSpaceSmall,
                      buildTitleCard(order, context),
                      // Divider(color: Colors.grey.shade200),
                      verticalSpaceSmall,
                      buildOrderDetails(order, context),
                      verticalSpaceSmall,
                      // Divider(color: Colors.grey.shade200),
                      verticalSpaceSmall,
                      buildFooterDetails(order, context),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildNoOrderWidget(BuildContext context) {
    return const Center(
      child: Text("No Orders Found"),
    );
  }

  Row buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My Orders',
          style: context.customTextTheme.text16W600,
        ),
        TextButton(
            onPressed: () {
              // context.router.push(OrderHistoryScreenRoute(isFromProfileScreen: true));
              context.read<HomeProvider>().onChangeCurrentPage(3);
            },
            child: Text(
              'See All',
              style: context.customTextTheme.text14W500
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ))
      ],
    );
  }

  Widget _buildDeleteAccount(BuildContext context) {
    final themeListener = context.watch<ThemeProvider>();

    return ListTile(
      dense: true,
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DeleteAccountScreen()),
        );
      },
      leading: const Icon(
        FluentIcons.delete_24_regular,
        color: AppColors.kGray,
      ),
      title: Text(
        'Delete Account',
        style: context.customTextTheme.text14W500
            .copyWith(color: context.customTextTheme.color),
      ),
    );
  }

  Widget _buildActiveOrders(BuildContext context) {
    final orderProvider = context.read<OrderProvider>();
    final themeListener = context.watch<ThemeProvider>();

    return ListTile(
      dense: true,
      onTap: () async {
        // context.read<Theme>()
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return orderProvider.getActiveOrders.isEmpty
                ? _buildNoOrderWidget(context)
                : SingleChildScrollView(
                    child: Column(
                      children: orderProvider.getActiveOrders
                          .map((e) => InkWell(
                              onTap: () {
                                orderProvider.updateViewOrderId(e.orderID!);
                                context.router
                                    .push(const ViewOrderScreenRoute());
                              },
                              child: historyOrderCard2(e, context)))
                          .toList(),
                    ),
                  );
          },
        );
      },
      leading: const Icon(
        FluentIcons.food_20_regular,
        color: AppColors.kGray,
      ),
      title: Text(
        'Active Orders',
        style: context.customTextTheme.text14W500
            .copyWith(color: context.customTextTheme.color),
      ),
    );
  }

  Widget historyOrderCard2(
    OrderDetailsModel order,
    BuildContext context,
  ) {
    final themeListener = context.watch<ThemeProvider>();
    final listOfProducts = order.orderDishes ?? [];
    final isMoreThanThreeItems = listOfProducts.length > 3;
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                        order.formattedAmount != null
                            ? ' • ${order.formattedAmount}'
                            : '',
                        style: context.customTextTheme.text14W700
                            .copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       FluentIcons.share_24_regular,
              //     ))
            ],
          ),
          Divider(color: Theme.of(context).dividerColor),
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
          Divider(color: Theme.of(context).dividerColor),
          Text(
              "Order Placed On: ${DateTimeUtils.formatDateTimeToDate(order.orderedAt)}, ${DateTimeUtils.formatTimeMinimal(order.orderedAt)}",
              style: context.customTextTheme.text14W400
                  .copyWith(color: context.customTextTheme.color)),
          Divider(color: Theme.of(context).dividerColor),
          verticalSpaceSmall,
          buildFooterDetails(order, context),
        ],
      ),
    );
  }

  Widget _buildAppAppearance(BuildContext context) {
    final themeListener = context.watch<ThemeProvider>();
    return Visibility(
      visible:
          AppConfig.instance.themeMode == AppThemeMode.system ? true : false,
      child: ListTile(
        dense: true,
        leading: const Icon(
          FluentIcons.dark_theme_24_regular,
          color: AppColors.kGray,
        ),
        title: Text(
          'Dark Mode',
          style: context.customTextTheme.text14W500
              .copyWith(color: context.customTextTheme.color),
        ),
        trailing: CupertinoSwitch(
          activeColor: Theme.of(context).colorScheme.primary,
          value: context.watch<ThemeProvider>().isDarkMode,
          onChanged: (val) {
            context
                .read<ThemeProvider>()
                .toggleTheme(val ? ThemeMode.dark : ThemeMode.light);
          },
        ),
      ),
    );
  }

  Widget _buildUpdateAddress(BuildContext context) {
    final themeListener = context.watch<ThemeProvider>();
    return ListTile(
      dense: true,
      onTap: () async {
        context.router.push(const UserAddressScreenRoute());
        await context.read<UserProvider>().getAddressList();
      },
      leading: const Icon(
        FluentIcons.location_24_regular,
        color: AppColors.kGray,
      ),
      title: Text(
        'Update Address',
        style: context.customTextTheme.text14W500
            .copyWith(color: context.customTextTheme.color),
      ),
    );
  }

  Widget _buildNotifications(BuildContext context) {
    context.read<AuthProvider>();

    return ListTile(
      dense: true,
      onTap: () async {
        context.router.push(const NotificationScreenRoute());

        // await context.read<ProductsProvider>().getFavouriteProductList();
      },
      leading: const Icon(
        FluentIcons.alert_24_regular,
        color: AppColors.kGray,
      ),
      title: Text(
        'Notifications',
        style: context.customTextTheme.text14W500,
      ),
    );
  }

  Widget _buildNotificationsPreference(BuildContext context) {
    final themeListener = context.watch<ThemeProvider>();

    return ListTile(
      dense: true,
      onTap: () async {
        context.router.push(const NotificationPreferenceScreenRoute());
        await context.read<UserProvider>().getUserConsent();
      },
      leading: const Icon(
        FluentIcons.alert_24_regular,
        color: AppColors.kGray,
      ),
      title: Text(
        'Notification Preferences',
        style: context.customTextTheme.text14W500
            .copyWith(color: context.customTextTheme.color),
      ),
    );
  }

  Widget _buildFavouriteProducts(BuildContext context) {
    final themeListener = context.watch<ThemeProvider>();

    return ListTile(
      dense: true,
      onTap: () async {
        context.router.push(const FavouriteProductsScreenRoute());

        await context.read<ProductsProvider>().getFavouriteProductList();
      },
      leading: const Icon(
        FluentIcons.heart_24_regular,
        color: AppColors.kGray,
      ),
      title: Text(
        'Favourite Products',
        style: context.customTextTheme.text14W500
            .copyWith(color: context.customTextTheme.color),
      ),
    );
  }

  Widget buildShopInfo(BuildContext context) {
    context.read<AuthProvider>();

    return Container(
      // margin: EdgeInsets.symmetric(horizontal: isFromHome ? 20.0 : 0.00),
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(10.0),
        // border: Border.all(color: Theme.of(context).colorScheme.primary)
        boxShadow: [
          BoxShadow(
            color: AppColors.kGray2.withOpacity(0.5),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () async {},
            leading: const Icon(
              FluentIcons.call_24_regular,
              color: AppColors.kGray,
            ),
            title: Text(
              AppIdentifiers.kShopInfoPh.map((e) => e.toString()).join(', '),
              style: context.customTextTheme.text14W500
                  .copyWith(color: AppColors.kBlack3),
            ),
          ),
          ListTile(
            onTap: () async {},
            leading: const Icon(
              FluentIcons.mail_24_regular,
              color: AppColors.kGray,
            ),
            title: Text(
              AppIdentifiers.kShopInfoEmail,
              style: context.customTextTheme.text14W500
                  .copyWith(color: AppColors.kBlack3),
            ),
          ),
          ListTile(
            onTap: () async {},
            leading: const Icon(
              FluentIcons.location_24_regular,
              color: AppColors.kGray,
            ),
            title: Text(
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              AppIdentifiers.kShopInfoAddress,
              style: context.customTextTheme.text14W500
                  .copyWith(color: AppColors.kBlack3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOptions(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final themeListener = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          onTap: () async {
            authProvider.onChangeSelectedAuthView(AuthView.forgotPassword);
            context.router.push(LoginScreenRoute(isFromProfile: true));
          },
          leading: const Icon(
            FluentIcons.lock_closed_12_regular,
            color: AppColors.kGray,
          ),
          title: Text(
            'Change Password',
            style: context.customTextTheme.text14W500
                .copyWith(color: context.customTextTheme.color),
          ),
        ),
        Divider(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.kCardBackground2
              : Colors.grey.shade100,
          indent: 15,
          endIndent: 15,
        ),
        // ListTile(
        //   onTap: () {},
        //   leading: const Icon(
        //     FluentIcons.alert_24_regular,
        //     color: AppColors.kGray,
        //   ),
        //   title: Text(
        //     'Notifications',
        //     style: context.customTextTheme.text14W600,
        //   ),
        // ),
        ListTile(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)
                              .copyWith(bottom: 30),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppColors.kWhite
                                    : AppColors.kCardBackground2,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const BottomSheetDragHandler(),
                              verticalSpaceMedium,
                              Container(
                                width: context.screenWidth * 0.2,
                                height: context.screenWidth * 0.2,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(
                                  Icons.logout_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 50,
                                ),
                              ),
                              verticalSpaceMedium,
                              Text(
                                'Confirm Logout',
                                style:
                                    context.customTextTheme.text14W600.copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.kBlack
                                      : Colors.white,
                                ),
                              ),
                              verticalSpaceSmall,
                              Text(
                                'Are you sure you want to logout?',
                                style: context.customTextTheme.text14W700,
                              ),
                              verticalSpaceMedium,
                              Consumer<CartProvider>(
                                builder: (context, value, child) {
                                  return value.isClearCartProgress ||
                                          value.cartLoading
                                      ? showButtonProgress()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: FilledButton(
                                                style: FilledButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.transparent
                                                          : AppColors.kWhite,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Not Now',
                                                  style: context.customTextTheme
                                                      .text14W600
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                ),
                                              ),
                                            ),
                                            horizontalSpaceSmall,
                                            Flexible(
                                              child: FilledButton(
                                                onPressed: () async {
                                                  await context
                                                      .read<CartProvider>()
                                                      .clearCart();
                                                  await context
                                                      .read<CartProvider>()
                                                      .listCartItems();

                                                  await authProvider
                                                      .logoutUser()
                                                      .then((_) {
                                                    Navigator.pop(context);
                                                    context
                                                        .read<UserProvider>()
                                                        .clearAllData();
                                                    context
                                                        .read<OrderProvider>()
                                                        .clearData();
                                                    context
                                                        .read<CartProvider>()
                                                        .checkUserIsLogged();
                                                  });

                                                  context.router.replace(
                                                      OrderOnlineScreenRoute());
                                                },
                                                style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                child: Text(
                                                  'Logout',
                                                  style: context.customTextTheme
                                                      .text14W500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                },
                              ),
                              verticalSpaceSmall,
                            ],
                          )),
                    ),
                  );
                });
          },
          leading: const Icon(
            Icons.logout,
            color: AppColors.kSecondaryColor2,
          ),
          dense: true,
          title: Text(
            'Logout',
            style: context.customTextTheme.text14W500
                .copyWith(color: AppColors.kSecondaryColor2),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertBox() {
    return AlertDialog(
      title: const Text('Logout this app'),
      actions: <Widget>[
        OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
        ElevatedButton(
          style: const ButtonStyle(
            elevation: WidgetStatePropertyAll(0),
          ),
          onPressed: () {},
          child: const Text('Logout'),
        ),
      ],
    );
  }

  Widget _buildMyOrderButtons(BuildContext context, VoidCallback onTap) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.kBlack3;
                  }
                  return AppColors.kWhite;
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.kWhite;
                  }
                  return AppColors.kBlack3;
                },
              ),
              side: WidgetStateProperty.all(
                const BorderSide(color: AppColors.kGray),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              elevation: WidgetStateProperty.all(0),
            ),
            onPressed: onTap,
            // onPressed: () {
            // context.router.push(const OrderOnlineScreenRoute());

            // },
            child: Text(
              'Order History',
              style: context.customTextTheme.text14W700,
            ),
          ),
        ),
        horizontalSpaceMedium,
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.kWhite;
                  }
                  return Theme.of(context).colorScheme.primary;
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.kBlack3;
                  }
                  return AppColors.kWhite;
                },
              ),
              side: WidgetStateProperty.all(
                BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              elevation: WidgetStateProperty.all(0),
            ),
            onPressed: () {
              context.router.push(const OrderOnlineScreenRoute());
            },
            child: Text(
              'Order Online',
              style: context.customTextTheme.text14W700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioWidget(UserProvider userListener, BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // verticalSpaceLarge,
          // Image(
          //     height: 100,
          //     image: AssetImage(
          //       Assets.images.profilePhoto.path,
          //     )),

          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary),
            child: Icon(
              FluentIcons.person_48_regular,
              size: MediaQuery.of(context).size.height * 0.05,
              color: AppColors.kWhite,
            ),
          ),
          verticalSpaceSmall,
          Text(
            userListener.userFullName,
            style: context.customTextTheme.text20W600
                .copyWith(color: context.customTextTheme.color),
          ),
          verticalSpaceSmall,
          Text(
            (userListener.userData?.user.userEmail?.isNotEmpty ?? false)
                ? userListener.userData!.user.userEmail!
                : '',
            style: context.customTextTheme.text16W400,
          ),
          verticalSpaceTiny,
          // Text(
          //   (userListener.userData?.user.userMobile?.isNotEmpty ?? false)
          //       ? userListener.userData!.user.userMobile!
          //       : 'No phone number',
          //   style: context.customTextTheme.text14W400,
          // ),
        ],
      ),
    );
  }

  // Widget _buildCustomPadding(Widget child) {
  //   return child;
  // }

  Widget _buildCustomBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.kGray2),
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
        ),
      ),
    );
  }

  Row _buildAppBar(String userId, BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      isFromHome ? _buildCustomBackButton(context) : const SizedBox(),
      isFromHome ? horizontalSpaceMedium : const SizedBox(),
      // Container(
      //   // margin: const EdgeInsets.only(),
      //   decoration: BoxDecoration(
      //     shape: BoxShape.circle,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.1),
      //         blurRadius: 4.0,
      //         offset: const Offset(0, 2),
      //       ),
      //     ],
      //   ),
      //   child: CircleAvatar(
      //     radius: 20,
      //     backgroundColor: Colors.white,
      //     //
      //     backgroundImage: AssetImage(Assets.images.profilePhoto.path),
      //   ),
      // ),
      // horizontalSpaceSmall,
      // Container(
      //   padding: const EdgeInsets.symmetric(
      //     horizontal: 20,
      //     vertical: 8,
      //   ),
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(20),
      //       color: AppColors.kBlack3,
      //       border: Border.all(color: AppColors.kGray2)),
      //   child: Text(
      //     'Profile Info',
      //     style: context.customTextTheme.text14W700.copyWith(color: AppColors.kWhite),
      //   ),
      // ),
    ]);
  }

  // String _getAvatarForUser(String userId) {
  // Logic to determine avatar based on user ID
  // For simplicity, we return the same svgString for now
  // You can replace this with actual logic to fetch or generate avatars
  //   return RandomAvatarString(
  //     userId,
  //     trBackground: true,
  //   );
  // }

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
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary
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
        const Icon(FluentIcons.calendar_20_regular),
        horizontalSpaceSmall,
        Text(
          DateTimeUtils.formatDateTimeToDate(order.orderedAt),
          style: context.customTextTheme.text14W600.copyWith(
            color: AppColors.kBlack,
          ),
        ),
        const Spacer(),
        const Icon(FluentIcons.clock_20_regular),
        horizontalSpaceSmall,
        Text(
          DateTimeUtils.formatTimeMinimal(order.orderedAt),
          style: context.customTextTheme.text14W600.copyWith(
            color: AppColors.kBlack,
          ),
        ),
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
              ? AppColors.kWhite
              : AppColors.kBlack,
        ),
        horizontalSpaceSmall,
        Text(
          ('${order.paymentType ?? 'N/A'} Payment'),
          style: context.customTextTheme.text14W500.copyWith(
            color: context.customTextTheme.color,
          ),
        ),
        const Spacer(),
        Text(
          order.formattedAmount ?? '',
          style: context.customTextTheme.text16W500.copyWith(
            color: context.customTextTheme.color,
          ),
        ),
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
              style: context.customTextTheme.text14W700,
            ),
          ],
        ),
        horizontalSpaceSmall,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.kCardBackground2
                : AppColors.kWhite,
            // border: Border.all(color: AppColors.kGray),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              order.isTakeaway
                  ? Assets.lib.assets.icons.takeAway.image(
                      height: 22,
                      width: 22,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.kWhite
                          : AppColors.kBlack,
                    )
                  : Assets.lib.assets.icons.fastDelivery.image(
                      height: 22,
                      width: 22,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.kWhite
                          : AppColors.kBlack,
                    ),
              horizontalSpaceVerySmall,
              Text(
                order.isTakeaway ? "Pickup: ${order.takeawayTime}" : "Delivery",
                style: context.customTextTheme.text14W500
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 21,
          color: AppColors.kGray3,
        ),
        horizontalSpaceSmall,
        Expanded(
          child: Text(
            text,
            style: isExpand
                ? context.customTextTheme.text12W400
                    .copyWith(color: context.customTextTheme.color)
                : context.customTextTheme.text14W400
                    .copyWith(color: context.customTextTheme.color),
            maxLines: isExpand ? 3 : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
