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

    // const defaultTileShade = Color(0xFFedf0ef);

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

  /// Returns `true` when the spice level should be displayed, hiding the
  /// section for "not applicable" type values coming from the backend.
  bool _isSpiceLevelApplicable(String? spiceLevel) {
    if (spiceLevel == null) return false;
    final normalized = spiceLevel.trim().toLowerCase();
    if (normalized.isEmpty) return false;

    const notApplicableValues = {
      'not applicable',
      'n/a',
      'na',
      'none',
      'nil',
      '-',
      '0',
    };

    return !notApplicableValues.contains(normalized);
  }

  Widget buildTileView1(BuildContext context, bool isPlaceHolderUrl) {
    final spiceLevel = product.spiceLevel;
    final spiceLevelIcon =
        context.read<ShopProvider>().spiceLevelIcons?[spiceLevel];
    final canAddToCart = product.isAvailable == true;
    final priceColor = Theme.of(context).colorScheme.primary;

    final isOffering = product.isOfferPrice == 'Yes' &&
        product.offerPriceDetails?.currentOfferPrice != null;
    final offerPrice = product.offerPriceDetails?.currentOfferPrice;
    final displayPrice = offerPrice?.offerPriceFormatted ?? product.price ?? '';
    final originalPrice = product.price ?? '';

    String? discountPercent;
    if (isOffering &&
        offerPrice?.offerPrice != null &&
        originalPrice.isNotEmpty) {
      final newVal = double.tryParse(
          offerPrice!.offerPrice!.replaceAll(RegExp(r'[^0-9.]'), ''));
      final oldVal =
          double.tryParse(originalPrice.replaceAll(RegExp(r'[^0-9.]'), ''));
      if (newVal != null && oldVal != null && oldVal > 0 && newVal < oldVal) {
        discountPercent = '${((oldVal - newVal) / oldVal * 100).round()}%';
      }
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Floating image ----
          Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: isPlaceHolderUrl
                        ? Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: Assets.lib.assets.images.noimage
                                .image(height: 60),
                          )
                        : CachedNetworkImage(
                            imageUrl: product.photo ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: Assets.lib.assets.images.noimage
                                  .image(height: 60),
                            ),
                          ),
                  ),
                ),
                // Discount badge
                // if (isOffering && discountPercent != null)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$discountPercent OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Favourite
                if (showFavIcon)
                  Positioned(
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
                            color: product.isFavourite
                                ? Colors.red
                                : AppColors.kBlack2,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Spice level
                if (spiceLevel != null && _isSpiceLevelApplicable(spiceLevel))
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (spiceLevelIcon != null &&
                              spiceLevelIcon.isNotEmpty)
                            Text(
                              spiceLevelIcon,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          if (spiceLevelIcon != null &&
                              spiceLevelIcon.isNotEmpty)
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
                    ),
                  ),
              ],
            ),
          ),
          // ---- Info ----
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.customTextTheme.text16W700.copyWith(
                    color: context.customTextTheme.color,
                    height: 1.2,
                  ),
                ),
                verticalSpaceSmall,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isOffering)
                            Text(
                              originalPrice,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            displayPrice,
                            style: context.customTextTheme.text14W700.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: priceColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!useSecondaryWidget) ...[
                      horizontalSpaceSmall,
                      SizedBox(
                        height: 40,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: canAddToCart
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            foregroundColor: canAddToCart
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).disabledColor,
                            disabledBackgroundColor: Colors.transparent,
                            disabledForegroundColor:
                                Theme.of(context).disabledColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: BorderSide(
                              color: canAddToCart
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onPressed: canAddToCart ? onPressAddBtn : null,
                          icon: const Icon(Icons.add, size: 20),
                          label: Text(
                            'Add',
                            style: context.customTextTheme.text14W700.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (useSecondaryWidget) ...[
                  verticalSpaceSmall,
                  SizedBox(
                    height: 44,
                    width: double.infinity,
                    child: Center(child: secondaryWidget),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTileView2(BuildContext context, bool isPlaceHolderUrl) {
    final allergens = product.selectedAllergensList;
    final spiceLevel = product.spiceLevel;
    final spiceLevelIcon =
        context.read<ShopProvider>().spiceLevelIcons?[spiceLevel];
    return Card(
      // color: Colors.black12,
      shape: RoundedRectangleBorder(
          // side: BorderSide(
          //     color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isPlaceHolderUrl
                    ? Padding(
                        padding: const EdgeInsets.only(top: 35.0, bottom: 45.0),
                        child:
                            Assets.lib.assets.images.noimage.image(height: 60),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: CachedNetworkImage(
                            // height: 130,
                            imageUrl: product.photo ?? '',

                            errorWidget: (context, url, error) => Padding(
                              padding: const EdgeInsets.only(
                                  top: 35.0, bottom: 45.0),
                              child: Assets.lib.assets.images.noimage.image(),
                            ),
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    product.name ?? '',
                    style: context.customTextTheme.text14W700.copyWith(
                      color: context.customTextTheme.color,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
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
                          color: Theme.of(context).brightness == Brightness.dark
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
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     if (spiceLevel != null &&
                //         _isSpiceLevelApplicable(spiceLevel)) ...[
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           if (spiceLevelIcon != null &&
                //               spiceLevelIcon.isNotEmpty)
                //             Text(
                //               spiceLevelIcon,
                //               style: TextStyle(fontSize: 12, color: Colors.red),
                //             ),
                //           horizontalSpaceTiny,
                //           Text(
                //             spiceLevel,
                //             style: TextStyle(
                //               fontSize: 11,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ]
                //   ],
                // ),
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
                useSecondaryWidget
                    ? SizedBox(
                        height: 50, child: Center(child: secondaryWidget))
                    : FilledButton(
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
                        onPressed:
                            product.isAvailable == true ? onPressAddBtn : null,
                        child: Text(
                          'Add to Cart',
                          style: context.customTextTheme.text14W700.copyWith(
                            fontWeight: FontWeight.bold,
                            color: product.isAvailable == true
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                // verticalSpaceSmall,
              ],
            ),
          ),
          Visibility(
            visible: showFavIcon,
            // child: Positioned(
            //   right: 2,
            //   top: 2,
            //   child: IconButton(
            //     onPressed: onPressFavouriteBtn,
            //     style: IconButton.styleFrom(
            //         backgroundColor: AppColors.kWhite,
            //         foregroundColor: AppColors.kBlack2),
            //     icon: Icon(
            //       product.isFavourite
            //           ? FluentIcons.heart_24_filled
            //           : FluentIcons.heart_24_regular,
            //       color: product.isFavourite ? Colors.red : null,
            //     ),
            //   ),
            // ),
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
          Positioned(
            left: 8,
            top: 120,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (spiceLevel != null &&
                    _isSpiceLevelApplicable(spiceLevel)) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: Offset(0, 3))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (spiceLevelIcon != null && spiceLevelIcon.isNotEmpty)
                          Text(
                            spiceLevelIcon,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        horizontalSpaceTiny,
                        Text(
                          spiceLevel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: context.customTextTheme.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
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
                      _isSpiceLevelApplicable(spiceLevel)) ...[
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
