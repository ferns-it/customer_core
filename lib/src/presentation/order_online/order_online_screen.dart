import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:customer_core/customer_core.dart';
import 'package:flutter/services.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/presentation/order_online/categories/categories_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/order/order_provider.dart';
import 'package:customer_core/src/presentation/order_online/home/order_online_home_screen.dart';
import 'package:customer_core/src/presentation/order_online/orders/order_history_screens.dart';
import 'package:customer_core/src/presentation/order_online/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:customer_core/src/presentation/widgets/custom_nav_item.dart';

import '../../application/cart/cart_provider.dart';
import '../../core/theme/app_colors.dart';

@RoutePage()
class OrderOnlineScreen extends StatefulWidget {
  const OrderOnlineScreen({super.key});

  @override
  State<OrderOnlineScreen> createState() => _OrderOnlineScreenState();
}

class _OrderOnlineScreenState extends State<OrderOnlineScreen> {
  final ValueNotifier<int> currentPageNotifier = ValueNotifier(0);

  final pages = <Widget>[
    const OrderOnlineHomeScreen(),
    const CategoriesScreen(),
    // const CartScreen(),
    const OrderHistoryScreen(false),
    ProfileScreen(
      false,
      () {
        // log('fgfg');
      },
    ),
  ];

  bool newNavBar = true;
  bool showConfirmDelete = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchAllOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeListener = context.watch<HomeProvider>();

    return ValueListenableBuilder(
      valueListenable: homeListener.currentPage,
      builder: (context, currentPage, _) {
        // final titleTextStyle = GoogleFonts.quicksand(
        //   textStyle: context.customTextTheme.text16W600.copyWith(
        //     fontWeight: FontWeight.w700,
        //   ),
        // );
        return buildBody(
          Scaffold(
            body: IndexedStack(
              index: currentPage,
              children: pages,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: buildFABWidget(currentPage),
            bottomNavigationBar: buildBottomNavBar(currentPage),
          ),
        );
      },
    );
  }

  Widget buildBottomNavBar(int currentPage) {
    final productListener = context.watch<ProductsProvider>();
    final productProvider = context.read<ProductsProvider>();
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 0),
      child: Consumer<HomeProvider>(
        builder: (_, provider, __) {
          // final extraHeight = Platform.isIOS ? 30 : 25;
          // final isDark = Theme.of(context).brightness == Brightness.dark;
          return AnimatedContainer(
            color: Colors.transparent,
            duration: const Duration(milliseconds: 300),
            height: provider.isVisible ? null : 0,
            child: Container(
              // margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(
                bottom: 25,
              ),
              // decoration: BoxDecoration(
              //   color: Colors.white.withOpacity(0.1),
              // ),
              child: Row(
                children: [
                  CustomNavItem(
                    selected: currentPage == 0,
                    icon: Icons.home,
                    label: "Home",
                    activeTextColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.grey,
                    onTap: () => provider.onChangeCurrentPage(0),
                  ),
                  CustomNavItem(
                    selected: currentPage == 1,
                    icon: Icons.category,
                    label: "Categories",
                    activeTextColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.grey,
                    onTap: () async {
                      provider.onChangeCurrentPage(1);

                      final selectedCategory = productListener.selectedCategory;
                      final selectedIndex =
                          productListener.selectedCategoryIndex;

                      final category =
                          selectedCategory ?? productListener.categories.first;

                      final index = selectedIndex ??
                          productListener.categories.indexOf(category);

                      if (category.cID != null) {
                        productProvider.onChangeHasMoreProducts(true);
                        productProvider.onChangeSelectedSubCategory(null);
                        productProvider.onChangeSelectedCategoryIndex(index);

                        await productProvider.getAllProductsByPagination(
                          categoryID: category.cID!,
                          isRandom: false,
                          isRefresh: true,
                        );
                      }
                    },
                  ),
                  CustomNavItem(
                    selected: currentPage == 2,
                    icon: Icons.history,
                    label: "Orders",
                    activeTextColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.grey,
                    onTap: () => provider.onChangeCurrentPage(2),
                  ),
                  CustomNavItem(
                    selected: currentPage == 3,
                    icon: Icons.person,
                    label: "Profile",
                    activeTextColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.grey,
                    onTap: () => provider.onChangeCurrentPage(3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget? buildFABWidget(int currentPage) {
    final cartListener = context.watch<CartProvider>();
    final homeListener = context.watch<HomeProvider>();

    return ValueListenableBuilder(
        valueListenable: cartListener.isCartEmptyNotifier,
        builder: (context, isVisible, child) {
          return !isVisible && (currentPage == 0 || currentPage == 1)
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // This is the hidden confirmation container
                    if (showConfirmDelete)
                      Positioned(
                        bottom: homeListener.isVisible ? 80 : 0,
                        left: 10,
                        right: 10,
                        child: buildDeleteConfirmUI(context),
                      ),

                    // This is your original container that slides left
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 250),
                      offset: showConfirmDelete
                          ? const Offset(-0.35, 0)
                          : Offset.zero,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8)
                            .copyWith(bottom: homeListener.isVisible ? 80 : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.kCardBackground2
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.kCardBackground2
                                  : Colors.white,
                              blurRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("TOTAL",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.kGray,
                                          fontWeight: FontWeight.w600,
                                        )),
                                Text(
                                  cartListener.totalCartItems > 0
                                      ? '${AppConfig.instance.country.symbol} ${cartListener.cartTotalPrice!.toStringAsFixed(AppConfig.instance.country.decimalPlaces)} | ${cartListener.totalCartItems} item(s)'
                                      : '${AppConfig.instance.country.symbol} 0.00',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : null),
                                ),
                              ],
                            ),
                            const Spacer(),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: AppColors.kWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                context.router.push(const CartScreenRoute());
                                await context
                                    .read<CartProvider>()
                                    .listCartItems();
                              },
                              child: Text(
                                "View Cart",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showConfirmDelete = !showConfirmDelete;
                                });
                              },
                              icon: Icon(
                                showConfirmDelete
                                    ? Icons.close
                                    : FluentIcons.delete_24_regular,
                                color: showConfirmDelete
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: showConfirmDelete
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // if (cartListener.isProductAdded)
                    //   Positioned(
                    //     bottom: 0,
                    //     left: 0,
                    //     right: 0,
                    //     child: IgnorePointer(
                    //       child: Assets.lottie.poppersLottie.lottie(
                    //         repeat: false,
                    //       ),
                    //     ),
                    //   ),
                  ],
                )
              : const SizedBox.shrink();
        });
  }

  Widget buildDeleteConfirmUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 8,
                )
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              await context.read<CartProvider>().clearCart();
              await context.read<CartProvider>().listCartItems();
              setState(() => showConfirmDelete = false);
            },
            child: const Text("Clear Cart"),
          ),
        ],
      ),
    );
  }

  Widget buildBody(Widget child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light, // Android
              statusBarBrightness: Brightness.dark, // iOS
            )
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark, // Android
              statusBarBrightness: Brightness.light, // iOS
            ),
      child: Platform.isIOS ? child : child,
    );
  }
}
