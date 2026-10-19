import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';

class CustomCartIncrementButton extends StatelessWidget {
  const CustomCartIncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.kBlack3,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.kOffWhite2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.remove,
              color: AppColors.kBlack3,
            ),
          ),
          Text(
            "1",
            style: context.customTextTheme.text14W700.copyWith(
              color: Colors.white,
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.kOffWhite2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.kBlack3,
            ),
          ),
        ],
      ),
    );
  }
}
