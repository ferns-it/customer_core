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
import 'package:customer_core/src/application/cart/cart_provider.dart';
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
    final cartProvider = context.watch<CartProvider>();
    final isFishStockEnabled =
        AppConfig.instance.businessType == BusinessType.fish &&
            product.stock?.activated == true;
    final availableStock = isFishStockEnabled
        ? cartProvider.getRemainingFishStock(product)
        : product.stock?.availableStock ?? 0;
    final isProductOutOfStock = isFishStockEnabled && availableStock <= 0;
    final isProductUnavailable =
        product.isAvailable == false || isProductOutOfStock;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isPlaceHolderUrl
                  ? Padding(
                      padding: const EdgeInsets.only(top: 35.0, bottom: 45.0),
                      child: Center(
                        child:
                            Assets.lib.assets.images.noimage.image(height: 60),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: product.photo ?? '',
                        errorWidget: (context, url, error) => Padding(
                          padding:
                              const EdgeInsets.only(top: 35.0, bottom: 45.0),
                          child: Center(
                              child: Assets.lib.assets.images.noimage.image()),
                        ),
                      ),
                    ),
              verticalSpaceSmall,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name ?? '',
                            style: context.customTextTheme.text14W700.copyWith(
                              color: context.customTextTheme.color,
                            ),
                            maxLines: 2,
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
                                    color: Utils.spiceLevelColor(
                                            context, spiceLevel)
                                        .withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(
                                    top: 2, left: 4, right: 4, bottom: 2),
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
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ),
                                    horizontalSpaceTiny,
                                    Text(
                                      spiceLevel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Utils.spiceLevelTextColor(
                                            context, spiceLevel),
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
                                      fontWeight: FontWeight.bold),
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                    if (isFishStockEnabled)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isProductOutOfStock
                                ? Colors.red.shade50
                                : availableStock <= 5
                                    ? Colors.orange.shade50
                                    : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isProductOutOfStock
                                  ? Colors.red.shade200
                                  : availableStock <= 5
                                      ? Colors.orange.shade200
                                      : Colors.green.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isProductOutOfStock
                                    ? FluentIcons.box_24_regular
                                    : availableStock <= 5
                                        ? FluentIcons.warning_24_regular
                                        : FluentIcons
                                            .checkmark_circle_24_regular,
                                size: 12,
                                color: isProductOutOfStock
                                    ? Colors.red.shade700
                                    : availableStock <= 5
                                        ? Colors.orange.shade700
                                        : Colors.green.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isProductOutOfStock
                                    ? 'Out of stock'
                                    : availableStock <= 5
                                        ? 'Only $availableStock left'
                                        : '$availableStock in stock',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isProductOutOfStock
                                      ? Colors.red.shade700
                                      : availableStock <= 5
                                          ? Colors.orange.shade700
                                          : Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (isFishStockEnabled) verticalSpaceTiny,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: product.isOfferPrice == 'Yes' &&
                                  product.offerPriceDetails
                                          ?.currentOfferPrice !=
                                      null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${product.offerPriceDetails?.currentOfferPrice?.offerPriceFormatted} ",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: context.customTextTheme.color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        product.price ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                  ],
                                )
                              : Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      product.price ?? '',
                                      maxLines: 1,
                                      style: context.customTextTheme.text14W700
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        color: context.customTextTheme.color,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        horizontalSpaceSmall,
                        useSecondaryWidget
                            ? Center(child: secondaryWidget)
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
                                                BorderRadius.circular(8.0)),
                                        fixedSize: const Size(80, 30),
                                        side: BorderSide(
                                            color: isProductUnavailable
                                                ? Colors.grey
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                        backgroundColor: isProductUnavailable
                                            ? Colors.transparent
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary),
                                    onPressed: isProductUnavailable
                                        ? null
                                        : onPressAddBtn,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Add',
                                          style: context
                                              .customTextTheme.text14W700
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isProductUnavailable
                                                ? Theme.of(context)
                                                    .disabledColor
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
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
              )
            ],
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
        ],
      ),
    );
  }

  Widget buildTileView3(BuildContext context) {
    final allergens = product.selectedAllergensList;
    final spiceLevel = product.spiceLevel;
    final spiceLevelIcon =
        context.read<ShopProvider>().spiceLevelIcons?[spiceLevel];
    final isFishStockEnabled =
        AppConfig.instance.businessType == BusinessType.fish &&
            product.stock?.activated == true;
    final cartProvider = context.watch<CartProvider>();
    final availableStock = isFishStockEnabled
        ? cartProvider.getRemainingFishStock(product)
        : product.stock?.availableStock ?? 0;
    final isProductOutOfStock = isFishStockEnabled && availableStock <= 0;
    final isProductUnavailable =
        product.isAvailable == false || isProductOutOfStock;
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
                  if (isFishStockEnabled) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isProductOutOfStock
                            ? Colors.red.shade50
                            : availableStock <= 5
                                ? Colors.orange.shade50
                                : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isProductOutOfStock
                              ? Colors.red.shade200
                              : availableStock <= 5
                                  ? Colors.orange.shade200
                                  : Colors.green.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isProductOutOfStock
                                ? FluentIcons.box_24_regular
                                : availableStock <= 5
                                    ? FluentIcons.warning_24_regular
                                    : FluentIcons.checkmark_circle_24_regular,
                            size: 12,
                            color: isProductOutOfStock
                                ? Colors.red.shade700
                                : availableStock <= 5
                                    ? Colors.orange.shade700
                                    : Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isProductOutOfStock
                                ? 'Out of stock'
                                : availableStock <= 5
                                    ? 'Only $availableStock left'
                                    : '$availableStock in stock',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isProductOutOfStock
                                  ? Colors.red.shade700
                                  : availableStock <= 5
                                      ? Colors.orange.shade700
                                      : Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceTiny,
                  ],
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
                                    color: isProductUnavailable
                                        ? Colors.grey
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary),
                                backgroundColor: isProductUnavailable
                                    ? Colors.transparent
                                    : Theme.of(context).colorScheme.primary),
                            onPressed:
                                isProductUnavailable ? null : onPressAddBtn,
                            child: Text(
                              isProductOutOfStock ? 'Sold Out' : 'Add to Cart',
                              style: context.customTextTheme.text14W700
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isProductUnavailable
                                          ? Theme.of(context).disabledColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
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
