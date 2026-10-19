import 'package:customer_core/src/domain/store/models/product_details_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class ProductDetailsTileSearch extends StatelessWidget {
  const ProductDetailsTileSearch(
    this.product, {
    super.key,
    required this.onPressed,
    required this.onPressAddBtn,
    this.useSecondaryWidget = false,
    required this.secondaryWidget,
  });

  final ProductDataModel product;
  final VoidCallback onPressed;
  final VoidCallback onPressAddBtn;
  final bool useSecondaryWidget;
  final Widget secondaryWidget;

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;

    // final isPlaceHolderUrl = product.photo?.contains("dish_placeholder.png") ?? false;

    // const defaultTileShade = Color(0xFFedf0ef);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.quicksand().fontFamily,
          displayColor: AppColors.kBlack2,
          bodyColor: AppColors.kBlack2,
        ),
      ),
      // data: Theme.of(context).copyWith(
      //   textTheme: GoogleFonts.quicksandTextTheme(baseTextTheme).apply(
      //     displayColor: AppColors.kBlack2,
      //     bodyColor: AppColors.kBlack2,
      //   ),
      // ),
      child: InkWell(
        onTap: onPressed,
        child: Card(
          color: AppColors.kCardBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              verticalSpaceRegular,
              CircleAvatar(
                backgroundColor: AppColors.kWhite,
                radius: MediaQuery.of(context).size.width * 0.12,
                backgroundImage: CachedNetworkImageProvider(
                  product.photo ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 5, bottom: 5.0),
                child: Text(
                  product.name ?? '',
                  style: context.customTextTheme.text14W700.copyWith(
                    color: AppColors.kBlack,
                  ),
                  maxLines: 2,
                ),
              ),
              // verticalSpaceRegular,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Text(
                    // product.price ?? '',
                    '',
                    style: context.customTextTheme.text14W700.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  useSecondaryWidget
                      ? SizedBox(
                          height: 40,
                          child: Center(child: secondaryWidget),
                        )
                      : InkWell(
                          onTap: onPressAddBtn,
                          child: Container(
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.kWhite,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                'Add',
                                style: context.customTextTheme.text14W700
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
