import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/application/search/search_provider.dart';
import 'package:customer_core/src/presentation/order_online/home/order_online_home_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:customer_core/src/application/core/api_response.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/application/user/user_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/store/models/product_category_model.dart';
import 'package:customer_core/src/presentation/widgets/product_details_tile.dart';
import 'package:customer_core/src/presentation/widgets/shimmer_product_details_tile.dart';
import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../../../application/cart/cart_provider.dart';
import '../../../domain/store/models/product_details_model.dart';
import '../../widgets/manage_dish_sheets.dart';
import '../../widgets/qty_counter_button.dart';

@RoutePage()
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late ScrollController _subCategoryScrollController;
  TabController? _categoryTabController;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _subCategoryScrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productProvider = context.read<ProductsProvider>();

      if (productProvider.categories.isEmpty) {
        await productProvider.getAllCategories();
        if (!mounted) return;
      }

      _initTabController(productProvider);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final productProvider = context.watch<ProductsProvider>();
    final index = productProvider.selectedCategoryIndex;

    if (_categoryTabController != null &&
        index != null &&
        index < _categoryTabController!.length &&
        _categoryTabController!.index != index) {
      _categoryTabController!.animateTo(index);
    }
  }

  void _initTabController(ProductsProvider productProvider) {
    _categoryTabController?.dispose();

    _categoryTabController = TabController(
      length: productProvider.categories.length,
      vsync: this,
    );

    _categoryTabController
        ?.animateTo(productProvider.selectedCategoryIndex ?? 0);
  }

  void _onScroll() {
    final homeProvider = context.read<HomeProvider>();
    final productProvider = context.read<ProductsProvider>();

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      homeProvider.hideNavBar();
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      homeProvider.showNavBar();
    }

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        productProvider.selectedSubCategory == null &&
        !productProvider.isFetchingProductsFromPagination &&
        productProvider.hasMoreProducts) {
      productProvider.getAllProductsByPagination(
        categoryID: productProvider.selectedCategory?.cID ?? '0',
        isRandom: false,
      );
    }
  }

  @override
  void dispose() {
    _categoryTabController?.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // void _scrollToIndex(int index) {
  //   double itemWidth = 110; / width + 10 margin
  //   double position = index * itemWidth;

  //   _categoryTabController.animateTo(
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final productListener = context.watch<ProductsProvider>();
    final productProvider = context.read<ProductsProvider>();
    final cartProvider = context.watch<CartProvider>();
    final cartListener = context.watch<CartProvider>();
    final homeProvider = context.read<HomeProvider>();
    final userProvider = context.read<UserProvider>();
    final products =
        productListener.filterListableProducts(productListener.productsList);
    final subCategories = productListener.selectedCategory?.childrens
            ?.where((category) => (category.productsCount?.online ?? 0) > 0)
            .toList() ??
        [];
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              TabBar(
                controller: _categoryTabController,
                onTap: (index) async {
                  final category = productListener.categories[index];
                  final cID = category.cID;

                  if (cID == productListener.selectedCategory?.cID) {
                    return;
                  }

                  productProvider.onChangeHasMoreProducts(true);
                  productProvider.onChangeSelectedCategory(category);
                  productProvider.onChangeSelectedCategoryIndex(index);
                  productProvider.onChangeSelectedSubCategory(null);

                  homeProvider.showNavBar();

                  if (cID != null) {
                    await productProvider.getAllProductsByPagination(
                      categoryID: cID,
                      isRandom: false,
                      isRefresh: true,
                    );
                  }
                },
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                dividerColor: Colors.transparent,
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(0.1),
                labelPadding: const EdgeInsets.only(right: 10),
                padding: EdgeInsets.zero,
                tabs: productListener.categories.map((e) {
                  final measured = textWidth(
                    e.name ?? '',
                    const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );

                  return Tab(
                    child: Container(
                      height: 40,
                      width: measured + 24,
                      margin: const EdgeInsets.only(bottom: 5),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: AppConfig.instance.isCategoryImageEnabled == true
                          ? Stack(
                              children: [
                                Positioned.fill(
                                  child: e.image != null
                                      ? CachedNetworkImage(
                                          imageUrl: e.image!,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                              Assets.lib.assets.images.noimage
                                                  .path,
                                              fit: BoxFit.cover,
                                              package: 'customer_core',
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          Assets.lib.assets.images.noimage.path,
                                          fit: BoxFit.cover,
                                          package: 'customer_core',
                                        ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Text(
                                      e.name ?? '',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(0, 1),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  e.name ?? '',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: context.customTextTheme.color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  );
                }).toList(),
              ),
              // _categoryTabController == null
              //     ? const SizedBox.shrink()
              //     : TabBar(
              //         controller: _categoryTabController,
              //         onTap: (index) async {
              //           final category = productListener.categories[index];
              //           final cID = category.cID;

              //           // If same category, still sync controller
              //           if (_categoryTabController!.index != index) {
              //             _categoryTabController!.animateTo(index);
              //           }

              //           if (cID == productListener.selectedCategory?.cID)
              //             return;

              //           productProvider.onChangeHasMoreProducts(true);
              //           productProvider.onChangeSelectedCategory(category);
              //           productProvider.onChangeSelectedCategoryIndex(index);

              //           productProvider.onChangeSelectedSubCategory(null);

              //           homeProvider.showNavBar();

              //           if (cID != null) {
              //             await productProvider.getAllProductsByPagination(
              //               categoryID: cID,
              //               isRandom: false,
              //               isRefresh: true,
              //             );
              //           }
              //         },
              //         tabAlignment: TabAlignment.start,
              //         isScrollable: true,
              //         dividerColor: Colors.transparent,
              //         indicatorColor: Theme.of(context).colorScheme.primary,
              //         tabs: productListener.categories
              //             .mapIndexed((index, e) => AppConfig
              //                         .instance.isCategoryImageEnabled ==
              //                     true
              //                 ? Column(
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       Container(
              //                         height: 50,
              //                         padding: const EdgeInsets.all(2),
              //                         margin: const EdgeInsets.only(bottom: 0),
              //                         // decoration: BoxDecoration(
              //                         // color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              //                         // border: productListner.selectedCategory == e
              //                         //     ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5)
              //                         //     : null,
              //                         // borderRadius: BorderRadius.circular(10)),
              //                         child: e.image != null
              //                             ? Center(
              //                                 child: CachedNetworkImage(
              //                                 imageUrl: e.image ?? '',
              //                                 height: 50,
              //                                 errorWidget:
              //                                     (context, url, error) =>
              //                                         Image(
              //                                   image: AssetImage(
              //                                       Assets.lib.assets.images
              //                                           .noimage.path,
              //                                       package: 'customer_core'),
              //                                   height: 50,
              //                                 ),
              //                               ))
              //                             : SizedBox(
              //                                 height: 60,
              //                                 width: 60,
              //                                 child: Center(
              //                                   child: Image(
              //                                     image: AssetImage(
              //                                         Assets.lib.assets.images
              //                                             .noimage.path,
              //                                         package: 'customer_core'),
              //                                     height: 50,
              //                                   ),
              //                                 ),
              //                               ),
              //                       ),
              //                       Text(
              //                         e.name ?? '',
              //                         maxLines: 1,
              //                         textAlign: TextAlign.center,
              //                         overflow: TextOverflow.ellipsis,
              //                         style: context.customTextTheme.text12W500
              //                             .copyWith(
              //                           color: context.customTextTheme.color,
              //                         ),
              //                       ),
              //                       verticalSpaceSmall,
              //                     ],
              //                   )
              //                 : Column(
              //                     children: [
              //                       Padding(
              //                         padding: const EdgeInsets.symmetric(
              //                             vertical: 10),
              //                         child: Text(
              //                           e.name ?? '',
              //                           maxLines: 1,
              //                           textAlign: TextAlign.center,
              //                           overflow: TextOverflow.ellipsis,
              //                           style: context
              //                               .customTextTheme.text14W500
              //                               .copyWith(
              //                             color: context.customTextTheme.color,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ))
              //             .toList()),
              verticalSpaceSmall,
              Row(
                children: [
                  if (productListener.selectedSubCategory != null) ...[
                    ChoiceChip(
                      label: Text(
                        "Clear",
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: false,
                      avatar: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      labelStyle: const TextStyle(color: AppColors.kBlack),
                      side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3)),
                      onSelected: (selected) async {
                        productProvider.onChangeSelectedSubCategory(null);
                        productProvider.onChangeHasMoreProducts(true);
                        _subCategoryScrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                        await productProvider.getAllProductsByPagination(
                          categoryID:
                              productListener.selectedCategory?.cID ?? '0',
                          isRandom: false,
                          isRefresh: true,
                        );
                      },
                    ),
                    horizontalSpaceSmall,
                  ],
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _subCategoryScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: subCategories.mapIndexed((index, category) {
                              final isSelected =
                                  productListener.selectedSubCategory?.cID ==
                                      category.cID;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ChoiceChip(
                                  checkmarkColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : AppColors.kCardBackground2,
                                  label: Text(
                                    category.name ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : AppColors.kCardBackground2,
                                    ),
                                  ),
                                  selected: isSelected,
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : AppColors.kCardBackground2,
                                  side: BorderSide(
                                    color: isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.3)
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.3),
                                  ),
                                  selectedColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  onSelected: (selected) async {
                                    if (selected) {
                                      productProvider
                                          .onChangeSelectedSubCategory(
                                              category);
                                      _subCategoryScrollController.animateTo(
                                        index * 150.0,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                      await productProvider
                                          .getAllProducts(category.cID ?? '0');
                                    } else {
                                      productProvider
                                          .onChangeSelectedSubCategory(null);
                                      productProvider
                                          .onChangeHasMoreProducts(true);

                                      await productProvider
                                          .getAllProductsByPagination(
                                        categoryID: productListener
                                                .selectedCategory?.cID ??
                                            '0',
                                        isRandom: false,
                                        isRefresh: true,
                                      );
                                    }
                                  },
                                ),
                              );
                            }).toList() ??
                            [],
                      ),
                    ),
                  ),
                ],
              ),
              // productListner.selectedSubCategory != null
              //     ? MaterialBanner(
              //         content: Text(
              //             "Showing results for '${productListner.selectedSubCategory?.name ?? ''}'"),
              //         actions: [
              //           IconButton(
              //             onPressed: () {
              //               productProvider.onChangeSelectedSubCategory(null);
              //               productProvider.getAllProductsByPagination(
              //                 categoryID:
              //                     productListner.selectedCategory?.cID ?? '0',
              //                 isRandom: false,
              //                 isRefresh: true,
              //               );
              //             },
              //             icon: const Icon(Icons.close),
              //           )
              //         ],
              //       )
              //     : const SizedBox.shrink(),

              Expanded(
                child: productListener.productsListAPIResponse.status ==
                        APIResponseStatus.loading
                    ? const ShimmerProductDetailsTile()
                    : products.isEmpty
                        ? const Center(child: Text("No Products Found"))
                        : AlignedGridView.count(
                            padding: const EdgeInsets.only(bottom: 200),
                            controller: _scrollController,
                            crossAxisCount: 2,
                            itemCount: products.length +
                                (productListener
                                        .isFetchingProductsFromPagination
                                    ? 1
                                    : 0),
                            cacheExtent: 200,
                            itemBuilder: (context, index) {
                              if (index >= products.length) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Assets
                                          .lib.assets.lottie.infiniteLoading
                                          .lottie(),
                                      // Or CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                                    ),
                                  ),
                                );
                              }
                              final product = products.elementAt(index);
                              final isExist = context
                                  .watch<CartProvider>()
                                  .isProductExist(product.pID);
                              final productQtyUpdated = context
                                  .watch<CartProvider>()
                                  .getProductQuantity(product.pID);

                              final freshProduct = productListener
                                  .overlayStockFromProductsList(product);
                              final remainingStock =
                                  cartProvider.getRemainingFishStock(freshProduct);
                              final isFishStockEnabled =
                                  freshProduct.stock?.activated == true;
                              final maxQty = isFishStockEnabled
                                  ? productQtyUpdated + remainingStock
                                  : null;
                              return ProductDetailsTile(
                                showFavIcon: cartListener.isUserLoggedIn,
                                freshProduct,
                                secondaryWidget: QtyCounterButton2(
                                    qty: productQtyUpdated,
                                    allowDecrementAtMinimum: true,
                                    maxQty: maxQty,
                                    onDecrementQty: () {
                                      final idx = cartProvider
                                          .getProductCartIndex(freshProduct.pID);
                                      if (idx >= 0) {
                                        cartProvider.decrementCartItemQty(idx);
                                      }
                                    },
                                    onIncrementQty: () {
                                      final idx = cartProvider
                                          .getProductCartIndex(freshProduct.pID);
                                      if (idx >= 0) {
                                        cartProvider
                                            .incrementCartItemQtyWithStockCheck(
                                                idx, freshProduct);
                                      }
                                    },
                                    onIncrementBlocked: () {
                                      AlertDialogs.showError(
                                        'Sorry, this item is currently out of stock.',
                                      );
                                    }),
                                useSecondaryWidget: isExist,
                                onPressed: () {
                                  showItemDetailsBottomSheet(context, freshProduct);
                                },
                                onPressFavouriteBtn: () async {
                                  if (freshProduct.isFavourite) {
                                    await context
                                        .read<ProductsProvider>()
                                        .removeFavourite(
                                            freshProduct.favouriteID!,
                                            context.read<SearchProvider>());
                                  } else {
                                    await context
                                        .read<ProductsProvider>()
                                        .addFavourite(freshProduct.pID!,
                                            context.read<SearchProvider>());
                                  }
                                },
                                onPressAddBtn: () {
                                  if (freshProduct.pID == null) return;
                                  if (freshProduct.variations.isNotEmpty) {
                                    cartProvider.onChangeVariation(
                                      freshProduct.variations.first,
                                    );
                                  }
                                  cartProvider
                                      .updateSelectedItemId(freshProduct.pID!);
                                  showAddItemBottomSheet(context, freshProduct);
                                },
                              );
                            },
                          ),
              ),

              // if (!productListner.isFetchingProductsFromPagination)
              //   CircularProgressIndicator(
              //     color: Theme.of(context).colorScheme.primary,
              //   )

              // verticalSpaceRegular,
              // verticalSpaceRegular,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterDrawerWidget(BuildContext context) {
    final productListner = context.watch<ProductsProvider>();
    final productProvider = context.read<ProductsProvider>();

    List<CategoryData> subCategories =
        List.from(productListner.selectedCategory?.childrens ?? []);

    // final parentCategory = productListner.selectedCategory;

    CategoryData all =
        CategoryData(name: 'All', cID: productListner.selectedCategory?.cID);

    subCategories.insert(0, all);

    return Padding(
      padding: EdgeInsets.only(
        top: (subCategories.length) <= 3
            ? context.screenHeight * 0.65
            : context.screenHeight * 0.5,
        bottom: context.screenHeight * 0.1,
        right: context.screenHeight * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Drawer(
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: subCategories.mapIndexed((index, e) {
                    return ListTile(
                      title: Text(e.name ?? ''),
                      // dense: true,
                      visualDensity: VisualDensity.compact,
                      onTap: () {
                        if (e.name == 'All') {
                          Navigator.pop(context);

                          productProvider.onChangeSelectedSubCategory(null);

                          productProvider.getAllProductsByPagination(
                            categoryID:
                                productListner.selectedCategory?.cID ?? '0',
                            isRandom: false,
                            isRefresh: true,
                          );
                        } else {
                          Navigator.pop(context);
                          productProvider.onChangeSelectedSubCategory(e);
                          // productProvider.onChangeSelectedCategory(e);
                          productProvider.getAllProducts(e.cID ?? '0');
                        }
                      },
                    );
                  }).toList()),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 1.5)),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: const Icon(FluentIcons.search_12_regular,
              color: AppColors.kGray2),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 1,
                color: AppColors.kGray2,
              ),
              horizontalSpaceSmall,
              Icon(Icons.tune_rounded,
                  color: Theme.of(context).colorScheme.primary),
            ],
          ),
          border: InputBorder.none,
          hintText: 'Search...',
          hintStyle: context.customTextTheme.text14W500
              .copyWith(color: AppColors.kGray2),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  void showItemDetailsBottomSheet(
      BuildContext context, ProductDataModel product) {
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

              context.read<CartProvider>().updateSelectedItemId(product.pID!);

              final fresh = context
                  .read<ProductsProvider>()
                  .overlayStockFromProductsList(product);
              showAddItemBottomSheet(context, fresh);
            },
          );
        });
  }

  void showAddItemBottomSheet(BuildContext context, ProductDataModel product) {
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
