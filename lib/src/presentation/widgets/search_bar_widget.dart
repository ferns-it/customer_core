import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';
import 'package:customer_core/src/presentation/widgets/custom_search_delegate.dart';
import '../../core/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final roundedBorder = OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(10.0),
    //   borderSide: BorderSide.none,
    // );

    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            const Icon(
              FluentIcons.search_24_filled,
              color: AppColors.kGray4,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Search",
                style: context.customTextTheme.text16W400.copyWith(
                  color: AppColors.kGray4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
