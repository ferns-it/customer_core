import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';

class BottomSheetDragHandler extends StatelessWidget {
  const BottomSheetDragHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kGray2,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 80,
      height: 7,
    );
  }
}
