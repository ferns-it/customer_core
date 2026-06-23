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

  Widget buildTileView2(BuildContext context, bool isPlaceHolderUrl) {
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
            child: Positioned(
              right: 2,
              top: 2,
              child: IconButton(
                onPressed: onPressFavouriteBtn,
                style: IconButton.styleFrom(
                    backgroundColor: AppColors.kWhite,
                    foregroundColor: AppColors.kBlack2),
                icon: Icon(
                  product.isFavourite
                      ? FluentIcons.heart_24_filled
                      : FluentIcons.heart_24_regular,
                  color: product.isFavourite ? Colors.red : null,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTileView3(BuildContext context) {
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
                  verticalSpaceTiny,
                  Wrap(
                    spacing: 2,
                    runSpacing: 4,
                    children: [
                      ...product.allergensList.take(4).map(
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
                                    color: context.customTextTheme.color),
                              ),
                            ),
                          ),
                      if (product.allergensList.length > 2)
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
                            '+${product.allergensList.length - 4}',
                            style: TextStyle(
                                fontSize: 8,
                                color: context.customTextTheme.color),
                          ),
                        ),
                    ],
                  ),
                  verticalSpaceTiny,
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
                  verticalSpaceTiny,
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
