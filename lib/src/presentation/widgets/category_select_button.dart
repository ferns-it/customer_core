import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/core/utils/ui_utils.dart';
import 'package:customer_core/src/domain/store/models/product_category_model.dart';

import '../../core/theme/app_colors.dart';

class CategorySelectButton extends StatelessWidget {
  const CategorySelectButton({
    super.key,
    required this.category,
    required this.selected,
    required this.onTapCategory,
  });

  final CategoryData category;
  final bool selected;
  final VoidCallback onTapCategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCategory,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 110,
            padding: const EdgeInsets.all(4.0),
            decoration: _buildBoxDecoration(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCategoryName(context),
                  const Spacer(),
                  _buildIcon(),
                  verticalSpaceTiny,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: selected ? AppColors.kBlack3 : AppColors.kOffWhite4,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: selected
              ? const Color.fromRGBO(74, 74, 75, 1)
              : const Color.fromRGBO(200, 200, 200, 0.25),
          offset: Offset(0, selected ? 2 : 4),
          blurRadius: selected ? 4 : 10,
        ),
      ],
    );
  }

  Widget _buildCategoryName(BuildContext context) {
    return FittedBox(
      child: Text(
        category.name ?? "",
        style: context.customTextTheme.text16W400.copyWith(
          color: selected ? AppColors.kOffWhite4 : AppColors.kGray5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 20,
      height: 20,
      padding: EdgeInsets.all(selected ? 0.0 : 3.0),
      decoration: const BoxDecoration(
        color: AppColors.kGray5,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FittedBox(
          child: Icon(
            !selected
                ? Icons.arrow_forward_ios_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: !selected ? AppColors.kOffWhite4 : AppColors.kBlack2,
          ),
        ),
      ),
    );
  }
}
