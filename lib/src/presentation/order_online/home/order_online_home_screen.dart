import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/rendering.dart';
import 'package:customer_core/src/application/core/api_response.dart';
import 'package:customer_core/src/application/search/search_provider.dart';
import 'package:customer_core/src/infrastructure/notification/notification_shared_prefs_repo.dart';
import 'package:customer_core/src/infrastructure/store/recent_search_product_prefs.dart';
import 'package:customer_core/src/presentation/widgets/animated_search_bar.dart';

import 'package:customer_core/src/presentation/widgets/qty_counter_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/presentation/widgets/manage_dish_sheets.dart';
import 'package:customer_core/src/presentation/widgets/shimmer_product_details_tile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../application/home/home_provider.dart';
import '../../../application/promotion/promotions_provider.dart';

import '../../../domain/store/models/product_details_model.dart';
import '../../widgets/product_details_tile.dart';

@RoutePage()
class OrderOnlineHomeScreen extends StatefulWidget {
  const OrderOnlineHomeScreen({super.key});

  @override
  State<OrderOnlineHomeScreen> createState() => _OrderOnlineHomeScreenState();
}

class _OrderOnlineHomeScreenState extends State<OrderOnlineHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late ScrollController _scrollController;
  int notificationCount = 0;

  // final isNewView = true;
  final List<String> imageUrlsForBanner = UiConfig.instance.bannerImages;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductsProvider>();

      if (productProvider.productsList.isNotEmpty) {
        _setupTabController(productProvider.categories);
      } else {
        productProvider.getAllCategories().then((_) {
          if (!mounted) return;
          _setupTabController(productProvider.categories);
        });
      }
      NotificationSharedPrefs.getNotification().then(
        (value) {
          setState(() {
            notificationCount = value.length;
          });
        },
      );
    });
  }

  void _onScroll() {
    final provider = context.read<HomeProvider>();

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      provider.hideNavBar();
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      provider.showNavBar();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _setupTabController(List categories) {
    final totalCategories = categories.length;
    setState(() {
      _tabController = TabController(length: totalCategories, vsync: this);
    });
    _tabController?.addListener(() {
      final categoryId = categories.elementAt(_tabController!.index).cID;
      if (categoryId != null) {
        context.read<ProductsProvider>().getAllProductsByPagination(
            categoryID: categoryId, isRandom: false, isRefresh: true);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController?.animateTo(
          Provider.of<ProductsProvider>(context, listen: false)
                  .selectedCategoryIndex ??
              0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.read<ProductsProvider>();
    final productListener = context.watch<ProductsProvider>();
    final cartProvider = context.read<CartProvider>();
    // final cartListener = context.watch<CartProvider>();
    final promotionListner = context.watch<PromotionsProvider>();

    // final shopProvider = context.read<ShopProvider>();
    // final shopListener = context.watch<ShopProvider>();
    final hideThreshold = context.screenHeight * 0.15; // 10%
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
        onPopInvokedWithResult: (_, __) {
          Future.delayed(const Duration(milliseconds: 100), () {
            productProvider.resetValues();
          });
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator.adaptive(
            onRefresh: () async {
              // productProvider.onChangeHasMoreProducts(true);

              Future.wait([
                productProvider.getFeaturedPopularProducts(),
                cartProvider.listCartItems(),
              ]);
            },
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    expandedHeight: 65,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    title: Row(
                      children: [
                        isDark
                            ? Image.asset(
                                UiConfig.instance.logo,
                                height: 45,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                UiConfig.instance.logo,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                        horizontalSpaceSmall,
                        Expanded(
                          child: AnimatedSearchBar(
                            onTap: () {
                              showSearch(
                                  context: context,
                                  delegate: ProductSearchDelegate());
                            },
                          ),
                        ),
                        // horizontalSpaceSmall,
                      ],
                    ),
                    actions: [
                      InkWell(
                        onTap: () {
                          context.router.push(const NotificationScreenRoute());
                        },
                        child: Badge.count(
                          count: notificationCount,
                          isLabelVisible: notificationCount > 0,
                          offset: const Offset(-5, 0),
                          child: Container(
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Icon(
                                FluentIcons.alert_20_regular,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ),
                          // child: IconButton(
                          //   onPressed: () {
                          //     context.router
                          //         .push(const NotificationScreenRoute());
                          //   },
                          //   icon: const Icon(FluentIcons.alert_24_regular),
                          // ),
                        ),
                      ),
                      horizontalSpaceSmall,
                    ],
                  ),
                  // SliverPersistentHeader(
                  //   pinned: true,
                  //   floating: true,
                  //   delegate: SearchBarHeaderDelegate(),
                  // ),

                  // Body content (the same buildContent)
                  SliverToBoxAdapter(
                    child: buildContent(context),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = context.read<CartProvider>();
    final productProvider = context.read<ProductsProvider>();
    final productListener = context.read<ProductsProvider>();

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible:
                cartProvider.cartDetailsModel?.paymentOptions?.shopStatus ==
                        'closed' &&
                    cartProvider.cartItems.isNotEmpty,
            child: MaterialBanner(
              content: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FluentIcons.warning_20_regular, color: Colors.white),
                  horizontalSpaceSmall,
                  Text(
                    "Sorry, We're closed now",
                  ),
                ],
              ),
              dividerColor: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 10),
              contentTextStyle: const TextStyle(color: Colors.white),
              backgroundColor: Colors.red.shade600,
              actions: const [SizedBox.shrink()],
            ),
          ),
          buildImageForBanners(),
          verticalSpaceSmall,
          buildCategories(productListener, productProvider),
          if (productListener.featuredPopularProductsAPIResponse.status ==
              APIResponseStatus.loading) ...[
            const ShimmerProductDetailsTile(count: 4),
          ] else ...[
            verticalSpaceSmall,
            buildFeaturedProducts(
                productListener, cartProvider, productProvider),
            verticalSpaceMedium,
            if (productListener.featuredPopularProductsAPIResponse.data
                    ?.popularProducts?.isNotEmpty ==
                true)
              buildPopularProducts(context),
          ],
          Visibility(
            visible: !productProvider.isFetchingProductsFromPagination,
            child: TextButton.icon(
                icon: const Icon(Icons.arrow_forward),
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  context.read<HomeProvider>().onChangeCurrentPage(1);
                  context.read<HomeProvider>().showNavBar();

                  final initialcategoryID =
                      productListener.categories.first.cID;
                  if (initialcategoryID != null) {
                    productProvider.onChangeHasMoreProducts(true);

                    // await productProvider.getAllProducts(initialcategoryID);
                    productProvider.getAllProductsByPagination(
                      categoryID: initialcategoryID,
                      isRandom: false,
                      isRefresh: true,
                    );
                  }
                },
                label: const Text("Explore More")),
          ),
          verticalSpaceXLarge,
          verticalSpaceXLarge,
        ],
      ),
    );
  }

  Row buildAppbar() {
    return Row(
      children: [
        horizontalSpaceSmall,
        SizedBox(
          height: 100,
          // width: 110,
          child: Image(
            image: AssetImage(UiConfig.instance.logo),
            // height: MediaQuery.of(context).size.height * 0.1,
            fit: BoxFit.cover,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            showSearch(context: context, delegate: ProductSearchDelegate());
          },
          child: const Icon(FluentIcons.search_24_regular),
        ),
        // IconButton(
        //     onPressed: () {
        //       showSearch(context: context, delegate: ProductSearchDelegate());
        //     },
        //     icon: const Icon(Icons.search)),
        horizontalSpaceRegular,
        horizontalSpaceSmall,
        // Flexible(
        //   flex: 2,
        //   child: Container(
        //     margin: const EdgeInsets.only(right: 10),
        //     decoration: BoxDecoration(
        //         color: AppColors.kWhite,
        //         borderRadius: BorderRadius.circular(30),
        //         border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5)),
        //     child: TextField(
        //       textAlignVertical: TextAlignVertical.center,
        //       decoration: InputDecoration(
        //         prefixIcon: const Icon(FluentIcons.search_12_regular,
        //             color: AppColors.kGray2),
        //         suffixIcon: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Container(
        //               height: 20,
        //               width: 1,
        //               color: AppColors.kGray2,
        //             ),
        //             horizontalSpaceSmall,
        //             const Icon(Icons.tune_rounded,
        //                 color: Theme.of(context).colorScheme.primary),
        //           ],
        //         ),
        //         border: InputBorder.none,
        //         hintText: 'Search...',
        //         hintStyle: context.customTextTheme.text14W500
        //             .copyWith(color: AppColors.kGray2),
        //         enabledBorder: InputBorder.none,
        //         focusedBorder: InputBorder.none,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }

//For banners
  Widget buildImageForBanners() {
    return CarouselSlider(
      options: CarouselOptions(
        disableCenter: true,
        height: MediaQuery.of(context).size.height * 0.15,
        viewportFraction: 1,
        enableInfiniteScroll: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlay: true,
        pauseAutoPlayOnTouch: true,
        enlargeCenterPage: true,
      ),
      items: imageUrlsForBanner.map((imageUrl) {
        return Container(
          margin: const EdgeInsets.only(right: 10.0, left: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(imageUrl, fit: BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }

  //for sliders

  Widget buildDealsWidget(ProductsProvider productListener,
      CartProvider cartProvider, ProductsProvider productProvider) {
    // final listOfItems = ['Hot Deals', 'Best Seller', 'Top Rated'];
    final products = productProvider.productsList;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          // Row(
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "Deals 🔥",
          //       style: context.customTextTheme.text16W600,
          //     ),
          //     horizontalSpaceSmall,
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          //       decoration: BoxDecoration(
          //         color: Theme.of(context).colorScheme.primary,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Center(
          //         child: Text(
          //           listOfItems[0],
          //           style: context.customTextTheme.text14W400
          //               .copyWith(color: AppColors.kWhite),
          //         ),
          //       ),
          //     ),
          //     horizontalSpaceSmall,
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          //       decoration: BoxDecoration(
          //         // color: AppColors.kGray3,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Center(
          //         child: Text(
          //           listOfItems[1],
          //           style: context.customTextTheme.text14W400
          //               .copyWith(color: AppColors.kBlack),
          //         ),
          //       ),
          //     ),
          //     horizontalSpaceSmall,
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          //       decoration: BoxDecoration(
          //         // color: AppColors.kGray3,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Center(
          //         child: Text(
          //           listOfItems[2],
          //           style: context.customTextTheme.text14W400
          //               .copyWith(color: AppColors.kBlack),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          verticalSpaceRegular,
          productListener.productsListAPIResponse.status ==
                  APIResponseStatus.initial
              ? const SizedBox.shrink()
              : productListener.productsListAPIResponse.status ==
                      APIResponseStatus.loading
                  ? const CupertinoActivityIndicator()
                  : Column(
                      children: [
                        products.isEmpty
                            ? const Center(child: Text("No products found"))
                            : AlignedGridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 8.0,
                                itemCount: 4,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final product = productListener
                                      .productsListRandom
                                      .getRange(8, 12)
                                      .elementAt(index);
                                  final isExist =
                                      cartProvider.isProductExist(product.pID);
                                  final productQtyUpdated = cartProvider
                                      .getProductQuantity(product.pID);
                                  final cartIndex = cartProvider
                                      .getProductCartIndex(product.pID);

                                  return ProductDetailsTile(
                                    product,
                                    onPressFavouriteBtn: () async {
                                      if (product.isFavourite) {
                                        await context
                                            .read<ProductsProvider>()
                                            .removeFavourite(
                                                product.favouriteID!);
                                      } else {
                                        await context
                                            .read<ProductsProvider>()
                                            .addFavourite(product.pID!);
                                      }
                                    },
                                    secondaryWidget: QtyCounterButton2(
                                        qty: productQtyUpdated,
                                        onDecrementQty: () {
                                          cartProvider
                                              .decrementCartItemQty(cartIndex);
                                          cartProvider
                                              .clearSelectedAddressSecondary();
                                          cartProvider.clearSelectedAddress();
                                        },
                                        onIncrementQty: () {
                                          cartProvider
                                              .incrementCartItemQty(cartIndex);
                                          cartProvider
                                              .clearSelectedAddressSecondary();
                                          cartProvider.clearSelectedAddress();
                                        }),
                                    useSecondaryWidget: isExist,
                                    onPressed: () {
                                      showItemDetailsBottomSheet(product);
                                    },
                                    onPressAddBtn: () {
                                      if (product.pID == null) return;
                                      if (product.variations.isNotEmpty) {
                                        cartProvider.onChangeVariation(
                                          product.variations.first,
                                        );
                                      }
                                      cartProvider
                                          .updateSelectedItemId(product.pID!);
                                      // cartProvider.addItemToCart().then((added) {
                                      //   if (added) {
                                      //     cartProvider.resetValues();
                                      //   }
                                      // });
                                      showAddItemBottomSheet(product);
                                    },
                                  );
                                },
                              ),
                      ],
                    )
        ],
      ),
    );
  }

  Widget buildFeaturedProducts(ProductsProvider productListener,
      CartProvider cartProvider, ProductsProvider productProvider) {
    final products = productProvider
            .featuredPopularProductsAPIResponse.data?.featuredProducts ??
        [];
    final showFavIcon = cartProvider.isUserLoggedIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Our Featured Products",
            style: context.customTextTheme.text16W600,
          ),
        ),
        // verticalSpaceSmall,
        productListener.featuredPopularProductsAPIResponse.status ==
                APIResponseStatus.initial
            ? const SizedBox.shrink()
            : productListener.featuredPopularProductsAPIResponse.status ==
                    APIResponseStatus.loading
                ? const CupertinoActivityIndicator()
                : products.isEmpty
                    ? const Center(child: Text("No products found"))
                    : AlignedGridView.count(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.0,
                        mainAxisSpacing: 0.0,
                        
                        itemCount: products.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final product = products.elementAt(index);
                          final isExist =
                              cartProvider.isProductExist(product.pID);
                          final productQtyUpdated =
                              cartProvider.getProductQuantity(product.pID);
                          final cartIndex =
                              cartProvider.getProductCartIndex(product.pID);

                          return ProductDetailsTile(
                            product,
                            showFavIcon: showFavIcon,
                            onPressFavouriteBtn: () async {
                              if (product.isFavourite) {
                                await context
                                    .read<ProductsProvider>()
                                    .removeFavourite(product.favouriteID!);
                              } else {
                                await context
                                    .read<ProductsProvider>()
                                    .addFavourite(product.pID!);
                              }
                            },
                            secondaryWidget: QtyCounterButton2(
                                qty: productQtyUpdated,
                                onDecrementQty: () {
                                  cartProvider.decrementCartItemQty(cartIndex);
                                  cartProvider.clearSelectedAddressSecondary();
                                  cartProvider.clearSelectedAddress();
                                },
                                onIncrementQty: () {
                                  cartProvider.incrementCartItemQty(cartIndex);
                                  cartProvider.clearSelectedAddressSecondary();
                                  cartProvider.clearSelectedAddress();
                                }),
                            useSecondaryWidget: isExist,
                            onPressed: () {
                              showItemDetailsBottomSheet(product);
                            },
                            onPressAddBtn: () {
                              if (product.pID == null) return;
                              if (product.variations.isNotEmpty) {
                                cartProvider.onChangeVariation(
                                  product.variations.first,
                                );
                              }
                              cartProvider.updateSelectedItemId(product.pID!);
                              // cartProvider.addItemToCart().then((added) {
                              //   if (added) {
                              //     cartProvider.resetValues();
                              //   }
                              // });
                              showAddItemBottomSheet(product);
                            },
                          );
                        },
                      ),
      ],
    );
  }

  Widget buildPopularProducts(BuildContext context) {
    final cartListener = context.watch<CartProvider>();
    final cartProvider = context.read<CartProvider>();
    final productListner = context.watch<ProductsProvider>();

    final products = productListner
            .featuredPopularProductsAPIResponse.data?.popularProducts ??
        [];
    final showFavIcon = cartListener.isUserLoggedIn;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Popular Products",
            style: context.customTextTheme.text16W600,
          ),
        ),
        // verticalSpaceSmall,
        productListner.featuredPopularProductsAPIResponse.status ==
                APIResponseStatus.initial
            ? const SizedBox.shrink()
            : productListner.featuredPopularProductsAPIResponse.status ==
                    APIResponseStatus.loading
                ? const ShimmerProductDetailsTile()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      products.isEmpty
                          ? const Center(child: Text("No products found"))
                          : AlignedGridView.count(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 0.0,
                              itemCount: products.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final product = products.elementAt(index);
                                final isExist =
                                    cartProvider.isProductExist(product.pID);
                                final productQtyUpdated = cartProvider
                                    .getProductQuantity(product.pID);
                                final cartIndex = cartProvider
                                    .getProductCartIndex(product.pID);

                                return ProductDetailsTile(
                                  product,
                                  showFavIcon: showFavIcon,
                                  onPressFavouriteBtn: () async {
                                    if (product.isFavourite) {
                                      await context
                                          .read<ProductsProvider>()
                                          .removeFavourite(
                                              product.favouriteID!);
                                    } else {
                                      await context
                                          .read<ProductsProvider>()
                                          .addFavourite(product.pID!);
                                    }
                                  },
                                  secondaryWidget: QtyCounterButton2(
                                      qty: productQtyUpdated,
                                      onDecrementQty: () {
                                        cartProvider
                                            .decrementCartItemQty(cartIndex);
                                        cartProvider
                                            .clearSelectedAddressSecondary();
                                        cartProvider.clearSelectedAddress();
                                      },
                                      onIncrementQty: () {
                                        cartProvider
                                            .incrementCartItemQty(cartIndex);
                                        cartProvider
                                            .clearSelectedAddressSecondary();
                                        cartProvider.clearSelectedAddress();
                                      }),
                                  useSecondaryWidget: isExist,
                                  onPressed: () {
                                    showItemDetailsBottomSheet(product);
                                  },
                                  onPressAddBtn: () {
                                    if (product.pID == null) return;
                                    if (product.variations.isNotEmpty) {
                                      cartProvider.onChangeVariation(
                                        product.variations.first,
                                      );
                                    }
                                    cartProvider
                                        .updateSelectedItemId(product.pID!);
                                    // cartProvider.addItemToCart().then((added) {
                                    //   if (added) {
                                    //     cartProvider.resetValues();
                                    //   }
                                    // });
                                    showAddItemBottomSheet(product);
                                  },
                                );
                              },
                            ),
                    ],
                  )
      ],
    );
  }

  Widget buildCategories(
    ProductsProvider productListner,
    ProductsProvider productProvider,
  ) {
    const labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return productListner.categoriesListAPIResponse.status ==
            APIResponseStatus.loading
        ? const BuildProductsCategoryShimmer()
        : Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DefaultTabController(
                length: productListner.categories.length,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "What are you looking for?",
                          style: context.customTextTheme.text16W600,
                        ),
                        InkWell(
                          onTap: () async {
                            context.read<HomeProvider>().onChangeCurrentPage(1);

                            final selectedCategory =
                                Provider.of<ProductsProvider>(context,
                                        listen: false)
                                    .selectedCategory;
                            final selectedIndex =
                                productListner.selectedCategoryIndex;

                            final category = selectedCategory ??
                                productListner.categories.first;

                            final index = selectedIndex ??
                                productListner.categories.indexOf(category);

                            if (category.cID != null) {
                              productProvider.onChangeHasMoreProducts(true);
                              productProvider.onChangeSelectedSubCategory(null);
                              productProvider
                                  .onChangeSelectedCategoryIndex(index);

                              await productProvider.getAllProductsByPagination(
                                categoryID: category.cID!,
                                isRandom: false,
                                isRefresh: true,
                              );
                            }
                          },
                          child: Text(
                            "See All",
                            style: context.customTextTheme.text16W600.copyWith(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceSmall,

                    TabBar(
                      onTap: (index) async {
                        final category =
                            productListner.categories.elementAt(index);
                        final cID = category.cID;
                        productProvider.onChangeHasMoreProducts(true);

                        if (cID != null) {
                          productProvider.onChangeSelectedCategory(category);
                          productProvider.onChangeSelectedSubCategory(null);
                          productProvider.onChangeSelectedCategoryIndex(index);
                          context.read<HomeProvider>().onChangeCurrentPage(1);
                          context.read<HomeProvider>().showNavBar();

                          await productProvider.getAllProductsByPagination(
                            categoryID: cID,
                            isRandom: false,
                            isRefresh: true,
                          );

                          // await productProvider.getAllProducts(cID);
                        }
                      },
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.transparent,
                      labelPadding: const EdgeInsets.only(right: 10),
                      padding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      controller: _tabController,
                      labelColor: AppColors.kBlack,
                      unselectedLabelColor: AppColors.kBlack,
                      tabs: productListner.categories.map((e) {
                        final measured = textWidth(e.name ?? '', labelStyle);

                        return Tab(
                          child: Container(
                            height: 40,
                            width: measured + 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: e.image != null
                                      ? CachedNetworkImage(
                                          imageUrl: e.image!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          Assets.lib.assets.images.noimage.path,
                                          fit: BoxFit.cover,
                                          package: 'customer_core',
                                        ),
                                ),

                                // Dark overlay – fades stronger when selected
                                Positioned.fill(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),

                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Text(
                                      e.name ?? '',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(0, 1), // x, y
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: productListner.categories
                    //         .mapIndexed((index, e) => InkWell(
                    //               onTap: () async {
                    //                 final cID = e.cID;

                    //                 if (cID != null) {
                    //                   productProvider.onChangeSelectedCategory(e);
                    //                   productProvider.onChangeSelectedCategoryIndex(index);
                    //                   context.read<HomeProvider>().onChangeCurrentPage(1);
                    //                   context.read<HomeProvider>().showNavBar();

                    //                   await productProvider.getAllProducts(cID);
                    //                 }
                    //               },
                    //               child: Container(
                    //                 width: 100,
                    //                 // height: 100,
                    //                 margin: const EdgeInsets.only(right: 10.0),
                    //                 padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    //                 decoration: BoxDecoration(
                    //                     border: Border.all(
                    //                         color:
                    //                             //  productListner.selectedCategory == e
                    //                             //     ? AppColors.kprimary
                    //                             //     :
                    //                             AppColors.kLightWhite2,
                    //                         width: 1.5),
                    //                     borderRadius: BorderRadius.circular(15)),
                    //                 child: Center(
                    //                   child: Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.center,
                    //                     mainAxisAlignment: MainAxisAlignment.center,
                    //                     children: [
                    //                       e.image != null
                    //                           ? CachedNetworkImage(
                    //                               imageUrl: e.image ?? '',
                    //                               height: 30,
                    //                             )
                    //                           : Image(
                    //                               image: AssetImage(Assets.images.noimage.path),
                    //                               height: 30,
                    //                             ),
                    //                       verticalSpaceTiny,
                    //                       Text(
                    //                         e.name ?? '',
                    //                         style: context.customTextTheme.text12W500.copyWith(color: AppColors.kBlack),
                    //                         overflow: TextOverflow.ellipsis,
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ))
                    //         .toList(),
                    //   ),
                    // )
                  ],
                ),
              ),
            );
          });
  }

  Widget buildSliderPromotions(PromotionsProvider promotionListener) {
    return Visibility(
      visible: promotionListener.listOfPromotionImagesSlider.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: CarouselSlider(
          options: CarouselOptions(
              height: 120.0,
              viewportFraction: 1,
              autoPlay: true,
              enlargeCenterPage: true),
          items: promotionListener.listOfPromotionImagesSlider.map((imageUrl) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.fitWidth,
                          )
                        : const Placeholder(
                            strokeWidth: 1.0,
                            fallbackHeight: 100.0,
                            fallbackWidth: double.infinity,
                          )));
          }).toList(),
        ),
      ),
    );
  }

  void showItemDetailsBottomSheet(ProductDataModel product) {
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
          return DishDetailBottomSheet(
            product: product,
            onRequestOrderDish: () {
              if (product.pID == null) return;

              if (product.variations.isNotEmpty) {
                context.read<CartProvider>().onChangeVariation(
                      product.variations.first,
                    );
              }
              context.read<CartProvider>().clearSelectedAddressSecondary();
              context.read<CartProvider>().updateSelectedItemId(product.pID!);

              showAddItemBottomSheet(product);
            },
          );
        });
  }

  void showAddItemBottomSheet(ProductDataModel product) {
    final sheetFuture = showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (context) {
          return AddDishBottomSheet(
            product: product,
          );
        });

    sheetFuture.whenComplete(() {
      context.read<CartProvider>().resetValues();
    });
  }

  // Widget _buildVegAndNonVegBtn() {
  //   return Builder(builder: (context) {
  //     final productProvider = context.read<ProductsProvider>();
  //     final productListener = context.watch<ProductsProvider>();
  //     return Row(
  //       children: [
  //         OutlinedButton.icon(
  //           onPressed: () {
  //             productProvider.onChangeFoodType(FoodType.veg);
  //           },
  //           label: const Text("Veg"),
  //           style: OutlinedButton.styleFrom(
  //             foregroundColor:
  //                 productListener.selectedFoodType != FoodType.veg ? AppColors.kGray5 : AppColors.kTealGreen,
  //             side: BorderSide(
  //                 color: productListener.selectedFoodType != FoodType.veg ? AppColors.kGray5 : AppColors.kTealGreen),
  //           ),
  //           icon: Assets.icons.veg.svg(
  //             color: productListener.selectedFoodType != FoodType.veg ? AppColors.kGray5 : null,
  //           ),
  //         ),
  //         horizontalSpaceSmall,
  //         OutlinedButton.icon(
  //           onPressed: () {
  //             productProvider.onChangeFoodType(FoodType.nonVeg);
  //           },
  //           label: const Text("Non Veg"),
  //           style: OutlinedButton.styleFrom(
  //             foregroundColor:
  //                 productListener.selectedFoodType != FoodType.nonVeg ? AppColors.kGray5 : AppColors.kDarkRed,
  //             side: BorderSide(
  //                 color: productListener.selectedFoodType != FoodType.nonVeg ? AppColors.kGray5 : AppColors.kDarkRed),
  //           ),
  //           icon: Assets.icons.nonVeg.svg(
  //             color: productListener.selectedFoodType != FoodType.nonVeg ? AppColors.kGray5 : null,
  //           ),
  //         )
  //       ],
  //     );
  //   });
  // }
}

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    final searchProvider = context.read<SearchProvider>();

    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchProvider.clearSearchData();
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
            titleLarge: TextStyle(
              color: isDark ? Colors.white : AppColors.kBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : AppColors.kBlack,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: isDark ? Colors.white : AppColors.kBlack,
      ),
    );
  }

  @override
  TextStyle get searchFieldStyle =>
      const TextStyle(fontWeight: FontWeight.w500);

  @override
  Widget? buildLeading(BuildContext context) {
    // return IconButton(
    //   icon: const Icon(Icons.arrow_back_ios_rounded),
    //   onPressed: () {
    //     close(context, null);
    //   },
    // );
    return _buildCustomBackButton(context);
  }

  InkWell _buildCustomBackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios_rounded,
        size: 20,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    RecentSearchProductPrefs.saveSearch(query);
    return _SearchResults(query: query); // Pass query to _SearchResults
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: RecentSearchProductPrefs.readSearch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final previousSearches = snapshot.data!;
        final suggestions = query.isEmpty
            ? previousSearches
            : previousSearches
                .where((search) =>
                    search.toLowerCase().contains(query.toLowerCase()))
                .toList();

        if (suggestions.isEmpty) return const SizedBox();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ListTile(
              title: Text(
                suggestion,
                style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color),
              ),
              leading: Icon(
                Icons.history,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () {
                query = suggestion;
                showResults(context); // Trigger search
              },
            );
          },
        );
      },
    );
  }
}

class _SearchResults extends StatefulWidget {
  final String query;
  const _SearchResults({required this.query});

  @override
  State<_SearchResults> createState() => __SearchResultsState();
}

class __SearchResultsState extends State<_SearchResults> {
  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch API on initState
  }

  void _fetchProducts() {
    if (widget.query.isNotEmpty) {
      Future.microtask(() {
        Provider.of<SearchProvider>(context, listen: false)
            .getAllSearchProducts(widget.query);
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final cartListener = context.watch<CartProvider>();

    return Consumer<SearchProvider>(
      builder: (context, value, child) {
        if (value.isSearchLoading) {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ));
        } else if (value.searchResponse == null ||
            value.searchResponse?.isEmpty == true) {
          return const Center(child: Text("No products found"));
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: AlignedGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              itemCount: value.searchResponse?.length ?? 0,
              itemBuilder: (context, index) {
                final product = value.searchResponse?.elementAt(index);
                return Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    final isExist = cartProvider.isProductExist(product!.pID);
                    final productQtyUpdated =
                        cartProvider.getProductQuantity(product.pID);
                    final cartIndex =
                        cartProvider.getProductCartIndex(product.pID);

                    return ProductDetailsTile(product,
                        showFavIcon: cartListener.isUserLoggedIn,
                        onPressed: () {
                          showItemDetailsBottomSheet(product);
                        },
                        useSecondaryWidget: isExist,
                        onPressFavouriteBtn: () async {
                          if (product.isFavourite) {
                            await context
                                .read<ProductsProvider>()
                                .removeFavourite(product.favouriteID!);
                          } else {
                            await context
                                .read<ProductsProvider>()
                                .addFavourite(product.pID!);
                          }
                        },
                        onPressAddBtn: () {
                          if (product.pID == null) return;
                          if (product.variations.isNotEmpty) {
                            cartProvider.onChangeVariation(
                              product.variations.first,
                            );
                          }
                          cartProvider.updateSelectedItemId(product.pID!);
                          // cartProvider.addItemToCart().then((added) {
                          //   if (added) {
                          //     cartProvider.resetValues();
                          //   }
                          // });
                          showAddItemBottomSheet(product);
                        },
                        secondaryWidget: QtyCounterButton2(
                          qty: productQtyUpdated,
                          onIncrementQty: () {
                            cartProvider.incrementCartItemQty(cartIndex);
                          },
                          onDecrementQty: () {
                            cartProvider.decrementCartItemQty(cartIndex);
                          },
                        ));
                  },
                );
              }),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant _SearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query) {
      _fetchProducts(); // Re-fetch if query changes
    }
  }

  void showItemDetailsBottomSheet(ProductDataModel product) {
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
          return DishDetailBottomSheet(
            product: product,
            onRequestOrderDish: () async {
              if (product.pID == null) return;

              if (product.variations.isNotEmpty) {
                context.read<CartProvider>().onChangeVariation(
                      product.variations.first,
                    );
              }

              context.read<CartProvider>().updateSelectedItemId(product.pID!);

              showAddItemBottomSheet(product);
            },
          );
        });
  }

  void showAddItemBottomSheet(ProductDataModel product) {
    final sheetFuture = showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (context) {
          return AddDishBottomSheet(
            product: product,
          );
        });

    sheetFuture.whenComplete(() {
      context.read<CartProvider>().resetValues();
    });
  }
}

double textWidth(String text, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: 2,
  )..layout(maxWidth: double.infinity);

  return painter.size.width;
}

class SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      alignment: Alignment.center,
      child: AnimatedSearchBar(
        onTap: () {
          showSearch(
            context: context,
            delegate: ProductSearchDelegate(),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
