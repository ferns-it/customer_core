import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class StockStatusWidget extends StatelessWidget {
  final String text;

  const StockStatusWidget({
    super.key,
    this.text = 'Out of stock',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          FluentIcons.box_24_regular,
          size: 12,
          color: Colors.red.shade700,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.red.shade700,
          ),
        ),
      ],
    );
  }
}
