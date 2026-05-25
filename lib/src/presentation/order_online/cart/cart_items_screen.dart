import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/cart/cart_provider.dart';
import '../../../core/utils/ui_utils.dart';
import '../../widgets/qty_counter_button.dart';

class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({super.key});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  @override
  Widget build(BuildContext context) {
    final cartListener = context.watch<CartProvider>();
    final cartProvider = context.read<CartProvider>();
    // final userListener = context.watch<UserProvider>();
    // final userProvider = context.read<UserProvider>();
    final shopProvider = context.read<ShopProvider>();
    // final shopListener = context.watch<ShopProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          verticalSpaceRegular,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Icon(
              //   Icons.drag_indicator,
              //   color: Colors.grey,
              // ),
              // horizontalSpaceSmall,
              Text(
                '<<< Slide to delete >>>',
                style: context.customTextTheme.text14W700
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
              )
            ],
          ),
          // verticalSpaceRegular,
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10)
                  .copyWith(bottom: 150),
              itemCount: cartListener.cartItems.length,
              itemBuilder: (context, index) {
                final product = cartListener.cartItems.elementAt(index);
                return Dismissible(
                  background: Container(
                    padding: const EdgeInsets.only(right: 10.0),
                    color: Colors.red.shade700,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'DELETE',
                        style: context.customTextTheme.text16W600
                            .copyWith(color: AppColors.kWhite),
                      ),
                    ),
                  ),
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    await cartProvider.removeCartItem(product.cartID);
                    log('direction: $direction');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        product.productPhoto != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                    imageUrl: product.productPhoto!),
                              )
                            : const SizedBox.shrink(),
                        product.productPhoto != null
                            ? horizontalSpaceSmall
                            : const SizedBox.shrink(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                product.variation != null
                                    ? SizedBox(
                                        width: context.screenWidth * 0.5,
                                        child: Tooltip(
                                          message:
                                              "${product.productName ?? 'N/A'} (${product.variation ?? 'N/A'})",
                                          triggerMode: TooltipTriggerMode.tap,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${product.productName ?? 'N/A'} (${product.variation ?? 'N/A'})",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: context
                                                    .customTextTheme.text16W700
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: context
                                                            .customTextTheme
                                                            .color),
                                              ),
                                              product.amountDetails
                                                          ?.isOfferApplied ==
                                                      true
                                                  ? Row(children: [
                                                      Text(
                                                        product
                                                                .amountDetails
                                                                ?.display
                                                                ?.totalAmountWithAddon ??
                                                            product
                                                                .amountDetails
                                                                ?.display
                                                                ?.totalAmountWithAddon ??
                                                            'N/A',
                                                        style: context
                                                            .customTextTheme
                                                            .text14W600
                                                            .copyWith(
                                                                color: context
                                                                    .customTextTheme
                                                                    .color),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        product
                                                                .amountDetails
                                                                ?.display
                                                                ?.totalAmountWithAddonNormal ??
                                                            'N/A',
                                                        style: context
                                                            .customTextTheme
                                                            .text14W600
                                                            .copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                decorationColor:
                                                                    Colors.grey,
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                    ])
                                                  : Text(
                                                      product.product_total_price ??
                                                          'N/A',
                                                      style: context
                                                          .customTextTheme
                                                          .text14W600
                                                          .copyWith(
                                                              color: context
                                                                  .customTextTheme
                                                                  .color),
                                                    ),
                                            ],
                                          ),
                                        ))
                                    : SizedBox(
                                        width: context.screenWidth * 0.5,
                                        child: Tooltip(
                                          message: product.variation != null
                                              ? "${product.productName ?? 'N/A'} (${product.variation ?? 'N/A'})"
                                              : product.productName ?? 'N/A',
                                          triggerMode: TooltipTriggerMode.tap,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.productName
                                                        ?.capitalize() ??
                                                    'N/A',
                                                style: context
                                                    .customTextTheme.text16W700
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: context
                                                            .customTextTheme
                                                            .color),
                                              ),
                                              product.amountDetails
                                                          ?.isOfferApplied ==
                                                      true
                                                  ? Row(children: [
                                                      Text(
                                                        product
                                                                .amountDetails
                                                                ?.display
                                                                ?.totalAmountWithAddon ??
                                                            product
                                                                .amountDetails
                                                                ?.itemDetails
                                                                ?.display
                                                                ?.totalAmount ??
                                                            product
                                                                .product_total_price ??
                                                            'N/A',
                                                        style: context
                                                            .customTextTheme
                                                            .text14W600
                                                            .copyWith(
                                                                color: context
                                                                    .customTextTheme
                                                                    .color),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        product
                                                                .amountDetails
                                                                ?.display
                                                                ?.totalAmountWithAddonNormal ??
                                                            'N/A',
                                                        style: context
                                                            .customTextTheme
                                                            .text14W600
                                                            .copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                decorationColor:
                                                                    Colors.grey,
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                    ])
                                                  : Text(
                                                      product.product_total_price ??
                                                          'N/A',
                                                      style: context
                                                          .customTextTheme
                                                          .text14W600
                                                          .copyWith(
                                                              color: context
                                                                  .customTextTheme
                                                                  .color),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                // const Spacer(),
                              ],
                            ),
                            product.master_addon_apllied.isNotEmpty == true
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: product.master_addon_apllied
                                        .map(
                                          (addon) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      CrossAxisAlignment.start,
                                                  children: addon.choosedOption
                                                      .map((option) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0.0),
                                                            child: Row(
                                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "+ ${option.text}",
                                                                  style: TextStyle(
                                                                      color: isDark
                                                                          ? Colors
                                                                              .white
                                                                          : null),
                                                                ),
                                                                // const Spacer(),
                                                                horizontalSpaceSmall,
                                                                Text(
                                                                  option.price ??
                                                                      'N/A',
                                                                  style: TextStyle(
                                                                      color: isDark
                                                                          ? Colors
                                                                              .white
                                                                          : null),
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
                            product.addon_apllied.isNotEmpty == true
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: product.addon_apllied
                                        .map(
                                          (addon) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      CrossAxisAlignment.start,
                                                  children: addon.choosedOption
                                                      .map((option) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0.0),
                                                            child: Row(
                                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "+ ${option.text}",
                                                                  style: TextStyle(
                                                                      color: isDark
                                                                          ? Colors
                                                                              .white
                                                                          : null),
                                                                ),
                                                                // const Spacer(),
                                                                horizontalSpaceSmall,
                                                                Text(
                                                                  option.price ??
                                                                      'N/A',
                                                                  style: TextStyle(
                                                                      color: isDark
                                                                          ? Colors
                                                                              .white
                                                                          : null),
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
                        QtyCounterButton2(
                            onDecrementQty: () async {
                              cartProvider.clearSelectedAddressSecondary();
                              cartProvider.clearSelectedAddress();
                              shopProvider.clearSelectedDeliverySlot();
                              cartProvider.clearDiscountValue();
                              await cartProvider.decrementCartItemQty(index);
                            },
                            previousQty: 0,
                            qty: product.quantity ?? 0,
                            onIncrementQty: () async {
                              cartProvider.clearSelectedAddressSecondary();
                              cartProvider.clearSelectedAddress();
                              shopProvider.clearSelectedDeliverySlot();
                              cartProvider.clearDiscountValue();

                              await cartProvider.incrementCartItemQty(index);
                              if (mounted) setState(() {});
                            }),
                        horizontalSpaceRegular
                      ],
                    ),
                  ),
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
  }
}
