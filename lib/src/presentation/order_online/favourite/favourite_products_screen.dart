import 'package:auto_route/auto_route.dart';
import 'package:customer_core/src/application/search/search_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:customer_core/src/application/cart/cart_provider.dart';
import 'package:customer_core/src/application/products/products_provider.dart';
import 'package:customer_core/src/core/routes/routes.gr.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
import 'package:customer_core/src/presentation/widgets/get_provider_view.dart';
import 'package:customer_core/src/presentation/widgets/manage_dish_sheets.dart';
import 'package:customer_core/src/presentation/widgets/product_details_tile.dart';
import 'package:customer_core/src/presentation/widgets/qty_counter_button.dart';

@RoutePage()
class FavouriteProductsScreen extends GetProviderView<ProductsProvider> {
  const FavouriteProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = notifier(context);
    final productListner = listener(context);
    final cartProvider = context.read<CartProvider>();
    final cartListener = context.watch<CartProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favourites'),
          actions: [
            Visibility(
              visible: cartListener.cartItems.isNotEmpty,
              child: Badge.count(
                count: cartListener.cartItems.length,
                offset: const Offset(-4, -2),
                child: IconButton(
                  onPressed: () async {
                    context.pushRoute(const CartScreenRoute());
                    await cartProvider.listCartItems();
                  },
                  icon: const Icon(FluentIcons.cart_20_regular),
                ),
              ),
            ),
            horizontalSpaceSmall,
          ],
        ),
        body: productListner.favouriteProductResponse.when(
          initial: () {
            return const Center(
              child: Text("No Products Found"),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
          completed: (data) {
            final products = data.favouriteList?.productList ?? [];
            if (products.isEmpty) {
              return const Center(
                child: Text("No Favourites"),
              );
            }
            return AlignedGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              itemCount: productListner.favouriteProductResponse.data
                  ?.favouriteList?.productList.length,
              itemBuilder: (context, index) {
                final product = productListner
                    .favouriteProductResponse.data?.favouriteList?.productList
                    .elementAt(index);
                final isExist =
                    context.watch<CartProvider>().isProductExist(product?.pID);
                final productQtyUpdated = context
                    .watch<CartProvider>()
                    .getProductQuantity(product?.pID);
                final cartIndex =
                    cartProvider.getProductCartIndex(product?.pID);
                if (product == null) {
                  return const SizedBox.shrink();
                }

                final stockAwareProduct =
                    productProvider.overlayStockFromProductsList(product);

                return ProductDetailsTile(
                  showFavIcon: cartListener.isUserLoggedIn,
                  stockAwareProduct,
                  secondaryWidget: QtyCounterButton2(
                      qty: productQtyUpdated,
                      allowDecrementAtMinimum: true,
                      onDecrementQty: () {
                        cartProvider.decrementCartItemQty(cartIndex);
                      },
                      onIncrementQty: () {
                        cartProvider.incrementCartItemQtyWithStockCheck(
                            cartIndex, stockAwareProduct);
                      }),
                  useSecondaryWidget: isExist,
                  onPressFavouriteBtn: () async {
                    if (product.isFavourite) {
                      await productListner.removeFavourite(
                          product.favouriteID!, context.read<SearchProvider>());
                    } else {
                      await productListner.addFavourite(
                          product.pID!, context.read<SearchProvider>());
                    }
                  },
                  onPressed: () {
                    showItemDetailsBottomSheet(stockAwareProduct, context);
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
                    showAddItemBottomSheet(stockAwareProduct, context);
                  },
                );
              },
            );
          },
          error: (message, _) {
            return Center(
              child: Text("Error: $message"),
            );
          },
        ));
  }

  void showItemDetailsBottomSheet(
      ProductDataModel product, BuildContext context) {
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

              showAddItemBottomSheet(product, context);
            },
          );
        });
  }

  void showAddItemBottomSheet(ProductDataModel product, BuildContext context) {
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
