import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_core/customer_core.dart';
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

    return SafeArea(
      bottom: false,
      maintainBottomViewPadding: false,
      child: Column(
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
                  _ProductImageWidget(product: product),
                  verticalSpaceRegular,
                  _ProductNameWidget(product: product),
                  // _RatingAndTimeWidget(product: product),
                  product.description != null && product.description!.isNotEmpty
                      ? verticalSpaceSmall
                      : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: _DescriptionWidget(product: product),
                  ),

                  product.description != null && product.description!.isNotEmpty
                      ? verticalSpaceRegular
                      : const SizedBox.shrink(),
                  _OrderSectionWidget(
                    product: product,
                    onRequestOrderDish: onRequestOrderDish,
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

class AddDishBottomSheet extends GetProviderView<CartProvider> {
  final ProductDataModel product;

  const AddDishBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartListener = listener(context);

    final baseTextTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

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
                      Expanded(child: _ProductImageWidget(product: product)),
                      horizontalSpaceSmall,
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _ProductNameWidget(product: product),
                            // _RatingAndTimeWidget(product: product),
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
                      shrinkWrap: true,
                      children: [
                        _FoodVariationSection(product),
                        verticalSpaceRegular,
                        _FoodAddonsSection(product),
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  Center(child: AddToCartButton(product)),
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
    return Padding(
      padding: const EdgeInsets.all(15.0).copyWith(bottom: 0),
      child: Text(
        (product.name ?? "").capitalize(),
        style: context.customTextTheme.text20W600.copyWith(
          color: context.customTextTheme.color,
        ),
      ),
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
      padding: const EdgeInsets.all(15.0),
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
  const _FoodVariationSection(this.item);

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
                    color: themeListener.isDarkMode
                        ? Colors.white
                        : AppColors.kBlack2,
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
                color:
                    themeListener.isDarkMode ? Colors.white : AppColors.kBlack,
              ),
            ),
            subtitle: variation.offerPriceEnabled == 'Yes' &&
                    variation.offerPriceDetails?.currentOfferPrice != null
                ? RichText(
                    text: TextSpan(
                      text:
                          "${variation.offerPriceDetails?.currentOfferPrice?.offerPriceFormatted} ",
                      style: TextStyle(
                          color: themeListener.isDarkMode
                              ? Colors.white
                              : AppColors.kBlack,
                          fontSize: 15),
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
            // subtitle: Text(
            //   (variation.offerPriceEnabled == 'Yes'
            //               ? variation.offerPriceDetails?.currentOfferPrice
            //                   ?.offerPriceFormatted
            //               : variation.name ?? "")
            //           ?.capitalize() ??
            //       '',
            //   style: context.customTextTheme.text14W500.copyWith(
            //     color:
            //         themeListener.isDarkMode ? Colors.white : AppColors.kBlack,
            //   ),
            // ),
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
  const _FoodAddonsSection(this.item);

  final ProductDataModel item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cartProvider = notifier(context);
    final themeListener = context.watch<ThemeProvider>();

    return Column(
      children: [
        Column(
          children: item.masterAddons.map((modifier) {
            return Column(
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
                            style: textTheme.labelSmall!.copyWith(
                              color: themeListener.isDarkMode
                                  ? Colors.white
                                  : AppColors.kBlack2,
                            ),
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
                                    color: themeListener.isDarkMode
                                        ? Colors.white
                                        : AppColors.kBlack2,
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
                      style: context.customTextTheme.text14W600.copyWith(
                        color: themeListener.isDarkMode
                            ? Colors.white
                            : AppColors.kBlack,
                      ),
                    ),
                    subtitle: Text(
                      '${AppConfig.instance.country.symbol} ${option.price}',
                      style: context.customTextTheme.text14W500.copyWith(
                        color: themeListener.isDarkMode
                            ? Colors.white
                            : AppColors.kBlack,
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
                        color: themeListener.isDarkMode
                            ? Colors.white
                            : AppColors.kBlack,
                      ),
                    ),
                    subtitle: Text(
                      '${AppConfig.instance.country.symbol} ${option.price}',
                      style: context.customTextTheme.text14W500.copyWith(
                        color: themeListener.isDarkMode
                            ? Colors.white
                            : AppColors.kBlack,
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
  const AddToCartButton(this.product, {super.key});

  final ProductDataModel product;

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
              if (validationResult) {
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
