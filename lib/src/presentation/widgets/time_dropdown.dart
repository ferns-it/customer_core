import 'package:customer_core/src/core/utils/ui_utils.dart';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../application/core/time_dropdown_provider.dart';
import '../../core/theme/app_colors.dart';

class TimeDropdown extends StatelessWidget {
  const TimeDropdown({super.key, this.hintText = "Select Time"});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<TimeDropdownProvider>();
    final listener = context.watch<TimeDropdownProvider>();
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: AppColors.kLightWhite2,
      ),
      child: DropdownButtonFormField<String>(
        hint: Text(hintText),
        value: listener.selectedTime,
        padding: EdgeInsets.zero,
        isExpanded: true,
        menuMaxHeight: context.screenHeight / 2,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: const InputDecoration(
          isDense: true,
        ),
        items: listener.timeSlots.map((String time) {
          return DropdownMenuItem<String>(
            value: time,
            child: Text(time),
          );
        }).toList(),
        onChanged: (String? newValue) {
          notifier.updateSelectedTime(newValue);
        },
      ),
    );
  }
}
