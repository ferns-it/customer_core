import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/application/shop/shop_provider.dart';
import 'package:dartx/dartx.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/auth/auth_provider.dart';
import 'package:customer_core/src/application/theme/theme_provider.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/core/utils/utils.dart';
import 'package:customer_core/src/presentation/widgets/button_progress.dart';
import 'package:customer_core/src/presentation/widgets/custom_close_icon.dart';
import 'package:customer_core/src/presentation/widgets/qty_counter_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../application/cart/cart_provider.dart';
import '../../domain/store/models/product_details_model.dart';
import 'get_provider_view.dart';

class DishDetailBottomSheet extends StatelessWidget {
  final ProductDataModel product;
  final VoidCallback onRequestOrderDish;

  const DishDetailBottomSheet({
    super.key,
    required this.product,
    required this.onRequestOrderDish,
  });

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;
    final allergens = product.selectedAllergensList;

    return SafeArea(
      bottom: false,
      maintainBottomViewPadding: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const RoundedCloseIcon(),
          verticalSpaceRegular,
          Flexible(
            child: SingleChildScrollView(
              child: Theme(
                data: Theme.of(context).copyWith(
                  textTheme:
                      GoogleFonts.quicksandTextTheme(baseTextTheme).apply(
                    displayColor: AppColors.kBlack2,
                    bodyColor: AppColors.kBlack2,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                      // vertical: 10,
                      // horizontal: 15,
                      ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // verticalSpaceTiny,
                      AppConfig.instance.isCategoryImageEnabled == true
                          ? _ProductImageWidget(product: product)
                          : SizedBox.shrink(),
                      verticalSpaceRegular,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: _ProductNameWidget(product: product),
                      ),
                      // _RatingAndTimeWidget(product: product),
                      product.description != null &&
                              product.description!.isNotEmpty
                          ? verticalSpaceSmall
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: _DescriptionWidget(product: product),
                      ),

                      product.description != null &&
                              product.description!.isNotEmpty
                          ? verticalSpaceRegular
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Wrap(
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
                                          : AppColors.kGray3.withOpacity(0.3),
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
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey.shade800
                                      : AppColors.kGray3.withOpacity(0.3),
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
                      ),
                      verticalSpaceRegular,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: _IngredientsWidget(product: product),
                      ),

                      _OrderSectionWidget(
                        product: product,
                        onRequestOrderDish: onRequestOrderDish,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddDishBottomSheet extends StatefulWidget {
  final ProductDataModel product;

  const AddDishBottomSheet({super.key, required this.product});

  @override
  State<AddDishBottomSheet> createState() => _AddDishBottomSheetState();
}

class _AddDishBottomSheetState extends State<AddDishBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final _variationKey = GlobalKey();
  late final List<GlobalKey> _masterAddonKeys;

  ProductDataModel get product => widget.product;

  @override
  void initState() {
    super.initState();
    _masterAddonKeys =
        List.generate(product.masterAddons.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Returns the [GlobalKey] of the first required section that is not
  /// satisfied, or `null` when every required section is satisfied.
  GlobalKey? _firstInvalidSectionKey(CartProvider cart) {
    // Variation section is required whenever the product offers multiple
    // variations and none has been selected yet.
    if (product.hasMultipleVariation && cart.selectedItemVariation == null) {
      return _variationKey;
    }

    for (var i = 0; i < product.masterAddons.length; i++) {
      final modifier = product.masterAddons[i];
      final minimumRequired = int.tryParse(modifier.minimumRequired ?? '') ?? 0;
      final maximumRequired = int.tryParse(modifier.maximumRequired ?? '') ?? 0;

      // No min/max constraint means this section is not required.
      if (minimumRequired == 0 && maximumRequired == 0) continue;

      final selectedModifier = cart.selectedMasterAddons.firstOrNullWhere(
        (e) => e.id == modifier.id,
      );
      final selectedCount = selectedModifier?.options.length ?? 0;

      if (selectedCount < minimumRequired) return _masterAddonKeys[i];
      if (maximumRequired != 0 && selectedCount > maximumRequired) {
        return _masterAddonKeys[i];
      }
    }

    return null;
  }

  /// Scrolls the sheet to the first invalid required section.
  /// Returns `true` when such a section exists (and add-to-cart should be
  /// blocked), `false` when everything required is satisfied.
  bool _scrollToFirstInvalidSection(CartProvider cart) {
    final key = _firstInvalidSectionKey(cart);
    if (key == null) return false;

    final sectionContext = key.currentContext;
    if (sectionContext == null) return false;

    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      alignment: 0.1,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final cartListener = context.watch<CartProvider>();
    final allergens = product.selectedAllergensList;

    final baseTextTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    List<String> getSelectedVariationAllergens(CartProvider cartListener) {
      final variation = cartListener.selectedItemVariation;
      if (variation == null) {
        return allergens;
      }
      if (variation.selectedallergens?.isNotEmpty == true) {
        if (variation.allergensMaster?.isNotEmpty == true) {
          return variation.allergensMaster!
              .where((e) => variation.selectedallergens!.contains(e['id']))
              .map((e) => e['name'].toString())
              .where((e) => e.isNotEmpty)
              .toList();
        }
        return variation.allergens
                ?.where((allergen) =>
                    variation.selectedallergens!.contains(allergen.id))
                .map((e) => e.name ?? '')
                .where((e) => e.isNotEmpty)
                .toList() ??
            [];
      }
      return [];
    }

    final selectedVariationAllergens =
        getSelectedVariationAllergens(cartListener);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const RoundedCloseIcon(),
        verticalSpaceRegular,
        Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.quicksandTextTheme(baseTextTheme).apply(
              displayColor: AppColors.kBlack2,
              bodyColor: AppColors.kBlack2,
            ),
          ),
          child: ListTileTheme(
            contentPadding: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              constraints: BoxConstraints(
                maxHeight: context.screenHeight * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  verticalSpaceTiny,
                  Row(
                    children: [
                      AppConfig.instance.isCategoryImageEnabled
                          ? Expanded(
                              child: _ProductImageWidget(product: product))
                          : SizedBox.shrink(),
                      AppConfig.instance.isCategoryImageEnabled
                          ? horizontalSpaceSmall
                          : SizedBox.shrink(),
                      AppConfig.instance.isCategoryImageEnabled
                          ? Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _ProductNameWidget(product: product),
                                  if (selectedVariationAllergens.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Wrap(
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: selectedVariationAllergens
                                            .map(
                                              (e) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.grey.shade800
                                                      : AppColors.kGray3
                                                          .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: context
                                                        .customTextTheme.color,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  // _RatingAndTimeWidget(product: product),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ProductNameWidget(product: product),
                                  if (selectedVariationAllergens.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Wrap(
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: selectedVariationAllergens
                                            .map(
                                              (e) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.grey.shade800
                                                      : AppColors.kGray3
                                                          .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: context
                                                        .customTextTheme.color,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  verticalSpaceSmall,
                                ],
                              ),
                            ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProductPriceWidget(product: product),
                      QtyCounterButton2(
                        qty: cartListener.selectedItemQty,
                        onIncrementQty: cartListener.incrementQty,
                        onDecrementQty: cartListener.decrementQty,
                      ),
                    ],
                  ),
                  product.description != null && product.description!.isNotEmpty
                      ? verticalSpaceSmall
                      : const SizedBox.shrink(),
                  _DescriptionWidget(product: product),
                  verticalSpaceSmall,
                  Flexible(
                    flex: 2,
                    child: ListView(
                      controller: _scrollController,
                      shrinkWrap: true,
                      children: [
                        _IngredientsWidget(product: product),
                        verticalSpaceSmall,
                        _FoodVariationSection(product, key: _variationKey),
                        verticalSpaceRegular,
                        _FoodAddonsSection(
                          product,
                          addonKeys: _masterAddonKeys,
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  Center(
                    child: AddToCartButton(
                      product,
                      onValidationFailed: () =>
                          _scrollToFirstInvalidSection(cartListener),
                    ),
                  ),
                  verticalSpaceTiny,
                  SizedBox(height: bottomInset > 0 ? bottomInset : 0)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CloseIconWidget extends StatelessWidget {
  const _CloseIconWidget();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerRight,
      child: RoundedCloseIcon(),
    );
  }
}

class _ProductImageWidget extends StatelessWidget {
  final ProductDataModel product;
  final bool small;

  const _ProductImageWidget({
    required this.product,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: product.photo != null
            ? CachedNetworkImage(
                imageUrl: product.photo!,
                fit: BoxFit.cover,
                width: small ? 150 : double.infinity,
              )
            : const Text("No Image"),
      ),
    );
  }
}

class _ProductNameWidget extends StatelessWidget {
  final ProductDataModel product;

  const _ProductNameWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    final spiceLevel = product.spiceLevel;
    final spiceLevelIcon =
        context.read<ShopProvider>().spiceLevelIcons?[spiceLevel];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            (product.name ?? "").capitalize(),
            style: context.customTextTheme.text20W600.copyWith(
              color: context.customTextTheme.color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        horizontalSpaceSmall,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (spiceLevel != null &&
                Utils.isSpiceLevelApplicable(spiceLevel)) ...[
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      // BoxShadow(
                      //     color: Colors.black.withOpacity(0.12), blurRadius: 6)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: Utils.spiceLevelColor(context, spiceLevel)
                        .withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (spiceLevelIcon != null && spiceLevelIcon.isNotEmpty)
                      Text(
                        ['Medium', 'Hot', 'Extra Hot'].contains(spiceLevel)
                            ? '🌶️'
                            : spiceLevelIcon,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    // Text(
                    //   spiceLevelIcon,
                    //   style: TextStyle(fontSize: 12, color: Colors.red),
                    // ),
                    horizontalSpaceTiny,
                    Text(
                      spiceLevel,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color:
                              Utils.spiceLevelTextColor(context, spiceLevel)),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }
}

// class _RatingAndTimeWidget extends StatelessWidget {
//   final ProductDataModel product;

//   const _RatingAndTimeWidget({required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         const Icon(
//           Icons.star,
//           color: AppColors.kSunRiseOrange,
//           size: 16,
//         ),
//         horizontalSpaceTiny,
//         Text(
//           '4.5',
//           style: context.customTextTheme.text14W700
//               .copyWith(color: AppColors.kGray),
//         ),
//         horizontalSpaceSmall,
//         const Icon(
//           Icons.history,
//           size: 16,
//         ),
//         horizontalSpaceTiny,
//         Text(
//           '26 mins',
//           style: context.customTextTheme.text14W700
//               .copyWith(color: AppColors.kGray),
//         ),
//         horizontalSpaceSmall,
//         product.type == "veg"
//             ? Assets.icons.veg.svg()
//             : Assets.icons.nonVeg.svg(),
//       ],
//     );
//   }
// }

class _DescriptionWidget extends StatelessWidget {
  final ProductDataModel product;

  const _DescriptionWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    return product.description != null && product.description!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Utils.removeExtraSpaces(
                  Utils.removeHtmlTags(product.description ?? ''),
                ),
                style: context.customTextTheme.text14W400.copyWith(
                    fontWeight: FontWeight.normal,
                    color: context.customTextTheme.color,
                    fontSize: 15),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                maxLines: 3,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _IngredientsWidget extends StatelessWidget {
  final ProductDataModel product;

  const _IngredientsWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    return product.ingredients != null && product.ingredients!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredients',
                    style: context.customTextTheme.text16W600,
                  ),
                  verticalSpaceSmall,
                  Text(
                    Utils.removeHtmlTags(product.ingredients ?? 'N/A'),
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  )
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }
}

class _OrderSectionWidget extends StatelessWidget {
  final ProductDataModel product;
  final VoidCallback onRequestOrderDish;

  const _OrderSectionWidget({
    required this.product,
    required this.onRequestOrderDish,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0).copyWith(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ProductPriceWidget(product: product),
          InkWell(
            onTap: product.isAvailable == false
                ? null
                : () {
                    Navigator.pop(context);
                    onRequestOrderDish();
                  },
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: product.isAvailable == false
                    ? AppColors.kGray
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: context.screenWidth * 0.4,
              child: Center(
                child: Text(
                  product.isAvailable == false ? 'Not Available' : 'Order Now',
                  style: context.customTextTheme.text14W600
                      .copyWith(color: AppColors.kWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductPriceWidget extends StatelessWidget {
  const _ProductPriceWidget({
    required this.product,
  });

  final ProductDataModel product;

  @override
  Widget build(BuildContext context) {
    return product.isOfferPrice == 'Yes' &&
            product.offerPriceDetails?.currentOfferPrice != null
        ? RichText(
            text: TextSpan(
              text:
                  "${product.offerPriceDetails?.currentOfferPrice?.offerPriceFormatted} ",
              style: TextStyle(
                  color: context.customTextTheme.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: product.price ?? '',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
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
              fontSize: 20,
              color: context.customTextTheme.color,
            ),
          );
  }
}

// ADD DISH WIDGETS
class _FoodVariationSection extends GetProviderView<CartProvider> {
  const _FoodVariationSection(this.item, {super.key});

  final ProductDataModel item;

  @override
  Widget build(BuildContext context) {
    final cartProvider = notifier(context);
    final cartListener = listener(context);
    final themeListener = context.watch<ThemeProvider>();

    if (!item.hasMultipleVariation) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Choose One Variation",
              style: context.customTextTheme.text16W600,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 3.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.kGray3.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: Text(
                  "REQUIRED",
                  style: context.customTextTheme.text12W600.copyWith(
                    color: context.customTextTheme.color,
                  ),
                ),
              ),
            )
          ],
        ),
        ...item.variations.mapIndexed((index, variation) {
          return RadioListTile(
            value: cartListener.selectedItemVariation == variation,
            groupValue: true,
            title: Text(
              (variation.name ?? "").capitalize(),
              style: context.customTextTheme.text14W600.copyWith(
                color: context.customTextTheme.color,
              ),
            ),
            subtitle: variation.offerPriceEnabled == 'Yes' &&
                    variation.offerPriceDetails?.currentOfferPrice != null
                ? RichText(
                    text: TextSpan(
                      text:
                          "${variation.offerPriceDetails?.currentOfferPrice?.offerPriceFormatted} ",
                      style: TextStyle(
                          color: context.customTextTheme.color, fontSize: 15),
                      children: [
                        TextSpan(
                          text: variation.displayPrice ?? '',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),
                  )
                : Text(
                    variation.displayPrice ?? '',
                    style: context.customTextTheme.text14W700.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: context.customTextTheme.color,
                    ),
                  ),
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.primary; // selected color
              }
              return Colors.grey; // 👈 unselected color
            }),
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: (_) => cartProvider.onChangeVariation(variation),
            visualDensity: VisualDensity.compact,
          );
        }),
      ],
    );
  }
}

class _FoodAddonsSection extends GetProviderView<CartProvider> {
  const _FoodAddonsSection(this.item, {super.key, this.addonKeys});

  final ProductDataModel item;
  final List<Key?>? addonKeys;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cartProvider = notifier(context);
    final themeListener = context.watch<ThemeProvider>();

    return Column(
      children: [
        Column(
          children: item.masterAddons.mapIndexed((index, modifier) {
            return Column(
              key: addonKeys?[index],
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Choose ${modifier.name}",
                  style: context.customTextTheme.text16W600,
                ),
                (modifier.minimumRequired?.isEmpty == true ||
                            modifier.minimumRequired == "0") &&
                        (modifier.maximumRequired?.isEmpty == true ||
                            modifier.maximumRequired == "0")
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${modifier.minimumRequired == "0" ? '' : 'Min ${modifier.minimumRequired}'}${modifier.minimumRequired != "0" && modifier.maximumRequired != "0" ? ', ' : ''}${modifier.maximumRequired == "0" ? '' : 'Max ${modifier.maximumRequired}'}",
                            style: textTheme.labelSmall!
                                .copyWith(color: context.customTextTheme.color),
                          ),
                          Visibility(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 3.0,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.kGray3.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Center(
                                child: Text(
                                  "REQUIRED",
                                  style: context.customTextTheme.text12W600
                                      .copyWith(
                                    color: context.customTextTheme.color,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                verticalSpaceSmall,
                ...modifier.options.map((option) {
                  return CheckboxListTile(
                    checkColor: Theme.of(context).colorScheme.onSurface,
                    value: cartProvider.checkMasterOptionsIsSelected(
                        modifier, option),
                    title: Text(
                      (option.text ?? "").capitalize(),
                      style: context.customTextTheme.text14W600
                          .copyWith(color: context.customTextTheme.color),
                    ),
                    subtitle: Text(
                      '${AppConfig.instance.country.symbol} ${option.price}',
                      style: context.customTextTheme.text14W500.copyWith(
                        color: context.customTextTheme.color,
                      ),
                    ),
                    side: const BorderSide(color: Colors.grey),
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (_) =>
                        cartProvider.onSelectMasterAddon(modifier, option),
                  );
                }),
              ],
            );
          }).toList(),
        ),
        Column(
          children: item.addons.map((modifier) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Choose ${modifier.name}",
                  style: context.customTextTheme.text16W600,
                ),
                ...modifier.options.map((option) {
                  return CheckboxListTile(
                    value:
                        cartProvider.checkOptionsIsSelected(modifier, option),
                    title: Text(
                      (option.text ?? "").capitalize(),
                      style: context.customTextTheme.text14W600.copyWith(
                        color: context.customTextTheme.color,
                      ),
                    ),
                    subtitle: Text(
                      '${AppConfig.instance.country.symbol} ${option.price}',
                      style: context.customTextTheme.text14W500.copyWith(
                        color: context.customTextTheme.color,
                      ),
                    ),
                    side: const BorderSide(color: Colors.grey),
                    checkColor: Theme.of(context).colorScheme.onSurface,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (_) =>
                        cartProvider.onSelectAddon(modifier, option),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AddToCartButton extends GetProviderView<CartProvider> {
  const AddToCartButton(this.product, {super.key, this.onValidationFailed});

  final ProductDataModel product;

  /// Called when a required section is not satisfied. It should scroll the
  /// sheet to the first invalid required section. Returns `true` when such a
  /// section exists (so add-to-cart is blocked), `false` otherwise.
  final bool Function()? onValidationFailed;

  @override
  Widget build(BuildContext context) {
    final cartProvider = notifier(context);
    final cartListener = listener(context);
    final authProvider = notifier2<AuthProvider>(context);
    final authListener = listener2<AuthProvider>(context);
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: product.isAvailable == false
          ? null
          : () async {
              final isLogged = await authProvider.checkUserIsLogged();
              if (!isLogged) {
                final guestID = cartListener.guestID;
                if (guestID == null) {
                  final randomID = Utils.getRandomNumber().toString();
                  cartProvider.onChangeGuestID(randomID);
                }
              }
              final validationResult =
                  cartProvider.validateRequiredModifiers(product);
              final hasInvalidSection = onValidationFailed?.call() ?? false;
              if (validationResult && !hasInvalidSection) {
                cartProvider.addItemToCart(isGuest: !isLogged).then((added) {
                  if (added) {
                    cartProvider.clearSelectedAddressSecondary();
                    cartProvider.clearSelectedAddress();
                    Navigator.pop(context);
                    cartProvider.resetValues();
                  }
                });
              }
            },
      icon: cartListener.addItemLoading
          ? null
          : Icon(
              FluentIcons.cart_24_regular,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      label: !cartListener.addItemLoading
          ? Text(
              product.isAvailable == false ? 'Not Available' : 'Add To Cart',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            )
          : showButtonProgress(Theme.of(context).colorScheme.onSurface),
    );
    // return SwipeButton(
    //   thumb: const Icon(
    //     FluentIcons.cart_24_filled,
    //     color: AppColors.kBlack3,
    //   ),
    //   activeTrackColor: AppColors.kBlack3,
    //   inactiveThumbColor: AppColors.kWhite,
    //   thumbPadding: const EdgeInsets.all(2),
    //   activeThumbColor: AppColors.kWhite,
    //   width: cartListener.addItemLoading
    //       ? context.widthPx * 0.6
    //       : context.widthPx * 0.7,
    //   inactiveTrackColor: AppColors.kGray6,
    //   enabled: !cartListener.addItemLoading,
    //   onSwipe: () {
    //     final validationResult =
    //         cartProvider.validateRequiredModifiers(product);
    //     if (validationResult) {
    //       cartProvider.addItemToCart().then((added) {
    //         if (added) {
    //           Navigator.pop(context);
    //           cartProvider.resetValues();
    //         }
    //       });
    //     }
    //   },
    //   child: cartListener.addItemLoading
    //       ? showButtonProgress()
    //       : Padding(
    //           padding: EdgeInsets.only(
    //             left: context.widthPx * 0.15,
    //             right: context.widthPx * 0.05,
    //           ),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               Text(
    //                 "${AppConfig.instance.country.symbol}${cartListener.selectedItemPrice}",
    //                 style: context.customTextTheme.text20W600
    //                     .copyWith(color: AppColors.kWhite),
    //               ),
    //               const Spacer(),
    //               Text(
    //                 "Add To Cart",
    //                 style: context.customTextTheme.text18W600.copyWith(
    //                   color: AppColors.kWhite,
    //                 ),
    //               ),
    //               horizontalSpaceTiny,
    //               const Icon(
    //                 Icons.arrow_forward_ios,
    //                 color: AppColors.kWhite,
    //                 size: 20.0,
    //               )
    //             ],
    //           ),
    //         ),
    // );
  }
}
