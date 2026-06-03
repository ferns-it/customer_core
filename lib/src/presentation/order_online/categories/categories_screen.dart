import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/application/search/search_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:customer_core/src/application/core/api_response.dart';
import 'package:customer_core/src/application/home/home_provider.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
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
    final productListner = context.watch<ProductsProvider>();
    final productProvider = context.read<ProductsProvider>();
    final cartProvider = context.read<CartProvider>();
    final cartListener = context.read<CartProvider>();
    final homeProvider = context.read<HomeProvider>();
    final userProvider = context.read<UserProvider>();
    // final products = productProvider.productsList;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              _categoryTabController == null
                  ? const SizedBox.shrink()
                  : TabBar(
                      controller: _categoryTabController,
                      onTap: (index) async {
                        final category = productListner.categories[index];
                        final cID = category.cID;

                        // If same category, still sync controller
                        if (_categoryTabController!.index != index) {
                          _categoryTabController!.animateTo(index);
                        }

                        if (cID == productListner.selectedCategory?.cID) return;

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
                      tabs: productListner.categories
                          .mapIndexed((index, e) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.only(bottom: 0),
                                    // decoration: BoxDecoration(
                                    // color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    // border: productListner.selectedCategory == e
                                    //     ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5)
                                    //     : null,
                                    // borderRadius: BorderRadius.circular(10)),
                                    child: e.image != null
                                        ? Center(
                                            child: CachedNetworkImage(
                                            imageUrl: e.image ?? '',
                                            height: 50,
                                            errorWidget:
                                                (context, url, error) => Image(
                                              image: AssetImage(
                                                  Assets.lib.assets.images
                                                      .noimage.path,
                                                  package: 'customer_core'),
                                              height: 50,
                                            ),
                                          ))
                                        : SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: Center(
                                              child: Image(
                                                image: AssetImage(
                                                    Assets.lib.assets.images
                                                        .noimage.path,
                                                    package: 'customer_core'),
                                                height: 50,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Text(
                                    e.name ?? '',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.customTextTheme.text12W500
                                        .copyWith(
                                      color: context.customTextTheme.color,
                                    ),
                                  ),
                                  verticalSpaceSmall,
                                ],
                              ))
                          .toList()),
              verticalSpaceSmall,
              Row(
                children: [
                  if (productListner.selectedSubCategory != null) ...[
                    ChoiceChip(
                      label: const Text("Clear"),
                      selected: false,
                      avatar: const Icon(
                        Icons.close,
                        color: Colors.black,
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
                              productListner.selectedCategory?.cID ?? '0',
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
                        children: productListner.selectedCategory?.childrens
                                ?.mapIndexed((index, category) {
                              final isSelected =
                                  productListner.selectedSubCategory?.cID ==
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
                                        categoryID: productListner
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
                child: productListner.productsListAPIResponse.status ==
                        APIResponseStatus.loading
                    ? const ShimmerProductDetailsTile()
                    : productListner.productsList.isEmpty
                        ? const Text("No Products Found")
                        : AlignedGridView.count(
                            padding: const EdgeInsets.only(bottom: 200),
                            controller: _scrollController,
                            crossAxisCount: 2,
                            itemCount: productListner.productsList.length +
                                (productListner.isFetchingProductsFromPagination
                                    ? 1
                                    : 0),
                            cacheExtent: 200,
                            itemBuilder: (context, index) {
                              if (index >= productListner.productsList.length) {
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
                              final product =
                                  productListner.productsList.elementAt(index);
                              final isExist =
                                  cartProvider.isProductExist(product.pID);
                              final productQtyUpdated =
                                  cartProvider.getProductQuantity(product.pID);
                              final cartIndex =
                                  cartProvider.getProductCartIndex(product.pID);
                              return ProductDetailsTile(
                                showFavIcon: cartListener.isUserLoggedIn,
                                product,
                                secondaryWidget: QtyCounterButton2(
                                    qty: productQtyUpdated,
                                    onDecrementQty: () {
                                      cartProvider
                                          .decrementCartItemQty(cartIndex);
                                      cartProvider
                                          .clearSelectedAddressSecondary();
                                      cartProvider.clearSelectedAddress();
                                      setState(() {});
                                    },
                                    onIncrementQty: () {
                                      cartProvider
                                          .incrementCartItemQty(cartIndex);
                                      cartProvider
                                          .clearSelectedAddressSecondary();
                                      cartProvider.clearSelectedAddress();
                                      setState(() {});
                                    }),
                                useSecondaryWidget: isExist,
                                onPressed: () {
                                  showItemDetailsBottomSheet(context, product);
                                },
                                onPressFavouriteBtn: () async {
                                  if (product.isFavourite) {
                                    await context
                                        .read<ProductsProvider>()
                                        .removeFavourite(product.favouriteID!,
                                            context.read<SearchProvider>());
                                  } else {
                                    await context
                                        .read<ProductsProvider>()
                                        .addFavourite(product.pID!,
                                            context.read<SearchProvider>());
                                  }
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
                                  showAddItemBottomSheet(context, product);
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

              showAddItemBottomSheet(context, product);
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
