import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/gen/assets.gen.dart';
import 'package:customer_core/src/core/utils/utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';

class ProductDetailsTile extends StatelessWidget {
  const ProductDetailsTile(
    this.product, {
    super.key,
    required this.onPressed,
    required this.onPressAddBtn,
    required this.onPressFavouriteBtn,
    this.useSecondaryWidget = false,
    required this.secondaryWidget,
    this.newUI = true,
    this.showFavIcon = false,
  });

  final ProductDataModel product;
  final VoidCallback onPressed;
  final VoidCallback onPressAddBtn;
  final VoidCallback onPressFavouriteBtn;
  final bool useSecondaryWidget;
  final Widget secondaryWidget;
  final bool newUI;
  final bool showFavIcon;

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;
    final isPlaceHolderUrl =
        product.photo?.contains("dish_placeholder.png") ?? false;
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.quicksandTextTheme(baseTextTheme).apply(
          displayColor: AppColors.kBlack2,
          bodyColor: AppColors.kBlack2,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: AppConfig.instance.isCategoryImageEnabled
            ? buildTileView2(context, isPlaceHolderUrl)
            : buildTileView3(context),
      ),
    );
  }

  Widget buildTileView2(BuildContext context, bool isPlaceHolderUrl) {
    final allergens = product.selectedAllergensList;
    final spiceLevel = product.spiceLevel;
    final spiceLevelIcon =
        context.read<ShopProvider>().spiceLevelIcons?[spiceLevel];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isPlaceHolderUrl
                      ? Padding(
                          padding:
                              const EdgeInsets.only(top: 35.0, bottom: 45.0),
                          child: Center(
                            child: Assets.lib.assets.images.noimage
                                .image(height: 60),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: product.photo ?? '',
                            errorWidget: (context, url, error) => Padding(
                              padding: const EdgeInsets.only(
                                  top: 35.0, bottom: 45.0),
                              child: Center(
                                  child:
                                      Assets.lib.assets.images.noimage.image()),
                            ),
                          ),
                        ),
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name ?? '',
                            style: context.customTextTheme.text14W700.copyWith(
                              color: context.customTextTheme.color,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (spiceLevel != null &&
                                Utils.isSpiceLevelApplicable(spiceLevel)) ...[
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      // BoxShadow(
                                      //     color: Colors.black.withOpacity(0.12),
                                      //     blurRadius: 6)
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.10),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (spiceLevelIcon != null &&
                                        spiceLevelIcon.isNotEmpty)
                                      // Text(
                                      //   spiceLevelIcon,
                                      //   style: TextStyle(
                                      //       fontSize: 12, color: Colors.red),
                                      // ),
                                      Text(
                                        ['Medium', 'Hot', 'Extra Hot']
                                                .contains(spiceLevel)
                                            ? '🌶️'
                                            : spiceLevelIcon,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    horizontalSpaceTiny,
                                    Text(
                                      spiceLevel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: context.customTextTheme.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  Wrap(
                    spacing: 2,
                    runSpacing: 4,
                    children: [
                      ...allergens.take(4).map(
                            (e) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: context.customTextTheme.color,
                                ),
                              ),
                            ),
                          ),
                      if (allergens.length > 4)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${allergens.length - 4}',
                            style: TextStyle(
                              fontSize: 8,
                              color: context.customTextTheme.color,
                            ),
                          ),
                        ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: product.isOfferPrice == 'Yes' &&
                                product.offerPriceDetails?.currentOfferPrice !=
                                    null
                            ? RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text:
                                      "${product.offerPriceDetails?.currentOfferPrice?.offerPriceFormatted} ",
                                  style: TextStyle(
                                      color: context.customTextTheme.color,
                                      fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: product.price ?? '',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                product.price ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    context.customTextTheme.text14W700.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: context.customTextTheme.color,
                                ),
                              ),
                      ),
                      horizontalSpaceSmall,
                      useSecondaryWidget
                          ? SizedBox(
                              height: 50, child: Center(child: secondaryWidget))
                          : SizedBox(
                              height: 30,
                              child: FilledButton(
                                  style: FilledButton.styleFrom(
                                      disabledBackgroundColor:
                                          Colors.transparent,
                                      disabledForegroundColor:
                                          Theme.of(context).disabledColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      fixedSize: const Size(80, 30),
                                      side: BorderSide(
                                          color: product.isAvailable == true
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.grey),
                                      backgroundColor:
                                          product.isAvailable == true
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.transparent),
                                  onPressed: product.isAvailable == true
                                      ? onPressAddBtn
                                      : null,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Icon(
                                      //   Icons.add,
                                      //   size: 16,
                                      // ),
                                      // horizontalSpaceTiny,
                                      Text(
                                        'Add',
                                        style: context
                                            .customTextTheme.text14W700
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: product.isAvailable == true
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                              : Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                    ],
                  ),
                  verticalSpaceSmall,
                ],
              ),
            ),
          ),
          Visibility(
            visible: showFavIcon,
            child: Positioned(
              right: 8,
              top: 8,
              child: Material(
                color: Colors.white.withOpacity(0.92),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onPressFavouriteBtn,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      product.isFavourite
                          ? FluentIcons.heart_24_filled
                          : FluentIcons.heart_24_regular,
                      size: 18,
                      color:
                          product.isFavourite ? Colors.red : AppColors.kBlack2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   left: 8,
          //   top: 120,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       if (spiceLevel != null &&
          //           _isSpiceLevelApplicable(spiceLevel)) ...[
          //         Container(
          //           padding:
          //               const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //           decoration: BoxDecoration(
          //             boxShadow: [
          //               BoxShadow(
          //                   color: Colors.black.withOpacity(0.12),
          //                   blurRadius: 10,
          //                   offset: Offset(0, 3))
          //             ],
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               if (spiceLevelIcon != null && spiceLevelIcon.isNotEmpty)
          //                 Text(
          //                   spiceLevelIcon,
          //                   style: TextStyle(fontSize: 12, color: Colors.red),
          //                 ),
          //               horizontalSpaceTiny,
          //               Text(
          //                 spiceLevel,
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 11,
          //                   color: context.customTextTheme.color,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ]
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildTileView3(BuildContext context) {
    final allergens = product.selectedAllergensList;
    final spiceLevel = product.spiceLevel;
    final spiceLevelIcon =
        context.read<ShopProvider>().spiceLevelIcons?[spiceLevel];
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name ?? '',
                          style: context.customTextTheme.text16W700.copyWith(
                            color: context.customTextTheme.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showFavIcon)
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onPressFavouriteBtn,
                            icon: Icon(
                              product.isFavourite
                                  ? FluentIcons.heart_24_filled
                                  : FluentIcons.heart_24_regular,
                              size: 18,
                              color: product.isFavourite ? Colors.red : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                  verticalSpaceTiny,
                  Text(
                    Utils.removeExtraSpaces(
                      Utils.removeHtmlTags(
                        product.description ?? '',
                      ),
                    ),
                    style: TextStyle(
                        fontSize: 12, color: context.customTextTheme.color),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpaceSmall,
                  Wrap(
                    spacing: 2,
                    runSpacing: 4,
                    children: [
                      ...allergens.take(4).map(
                            (e) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: context.customTextTheme.color,
                                ),
                              ),
                            ),
                          ),
                      if (allergens.length > 4)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${allergens.length - 4}',
                            style: TextStyle(
                              fontSize: 8,
                              color: context.customTextTheme.color,
                            ),
                          ),
                        ),
                    ],
                  ),
                  verticalSpaceSmall,
                  if (spiceLevel != null &&
                      Utils.isSpiceLevelApplicable(spiceLevel)) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (spiceLevelIcon != null && spiceLevelIcon.isNotEmpty)
                          Text(
                            spiceLevelIcon,
                            style: TextStyle(color: Colors.red),
                          ),
                        horizontalSpaceTiny,
                        Text(
                          spiceLevel,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.customTextTheme.color,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                  ],
                  verticalSpaceSmall,
                  product.isOfferPrice == 'Yes' &&
                          product.offerPriceDetails?.currentOfferPrice != null
                      ? RichText(
                          text: TextSpan(
                            text:
                                "${product.offerPriceDetails?.currentOfferPrice?.offerPriceFormatted} ",
                            style: TextStyle(
                                color: context.customTextTheme.color,
                                fontSize: 15),
                            children: [
                              TextSpan(
                                text: product.price ?? '',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          product.price ?? '',
                          style: context.customTextTheme.text14W700.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: context.customTextTheme.color,
                          ),
                        ),
                  verticalSpaceSmall,
                  useSecondaryWidget
                      ? SizedBox(
                          height: 50, child: Center(child: secondaryWidget))
                      : SizedBox(
                          height: 30,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                disabledBackgroundColor: Colors.transparent,
                                disabledForegroundColor:
                                    Theme.of(context).disabledColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                fixedSize: const Size(double.infinity, 30),
                                side: BorderSide(
                                    color: product.isAvailable == true
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey),
                                backgroundColor: product.isAvailable == true
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent),
                            onPressed: product.isAvailable == true
                                ? onPressAddBtn
                                : null,
                            child:
                                // Icon(Icons.shopping_cart)
                                Text(
                              'Add to Cart',
                              style: context.customTextTheme.text14W700
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: product.isAvailable == true
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                          : Theme.of(context).disabledColor,
                                      fontSize: 12),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
