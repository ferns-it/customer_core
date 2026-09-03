import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class StockStatusWidget extends StatelessWidget {
  final bool isProductOutOfStock;
  final int availableStock;

  const StockStatusWidget({
    super.key,
    required this.isProductOutOfStock,
    required this.availableStock,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isProductOutOfStock
        ? Colors.red.shade50
        : availableStock <= 5
            ? Colors.orange.shade50
            : Colors.green.shade50;

    final Color borderColor = isProductOutOfStock
        ? Colors.red.shade200
        : availableStock <= 5
            ? Colors.orange.shade200
            : Colors.green.shade200;

    final Color textColor = isProductOutOfStock
        ? Colors.red.shade700
        : availableStock <= 5
            ? Colors.orange.shade700
            : Colors.green.shade700;

    final IconData icon = isProductOutOfStock
        ? FluentIcons.box_24_regular
        : availableStock <= 5
            ? FluentIcons.warning_24_regular
            : FluentIcons.checkmark_circle_24_regular;

    final String text = isProductOutOfStock
        ? 'Out of stock'
        : availableStock <= 5
            ? 'Only $availableStock left'
            : '$availableStock in stock';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: textColor,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
    // return Align(
    //   alignment: Alignment.centerLeft,
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: 8,
    //       vertical: 4,
    //     ),
    //     decoration: BoxDecoration(
    //       color: backgroundColor,
    //       borderRadius: BorderRadius.circular(6),
    //       border: Border.all(
    //         color: borderColor,
    //       ),
    //     ),
    //     child: Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Icon(
    //           icon,
    //           size: 12,
    //           color: textColor,
    //         ),
    //         const SizedBox(width: 4),
    //         Text(
    //           text,
    //           style: TextStyle(
    //             fontSize: 10,
    //             fontWeight: FontWeight.w700,
    //             color: textColor,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
