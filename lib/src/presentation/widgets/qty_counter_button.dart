import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:customer_core/src/core/theme/custom_text_styles.dart';

import '../../core/theme/app_colors.dart';

class QtyCounterButton extends StatefulWidget {
  const QtyCounterButton({
    super.key,
    this.onDecrementQty,
    this.hideDefaultAddBtn = false,
    this.onIncrementQty,
    this.qty = 0,
    this.previousQty = -1,
    this.gap,
  });

  final VoidCallback? onDecrementQty;
  final VoidCallback? onIncrementQty;
  final Widget? gap;
  final bool hideDefaultAddBtn;
  final int qty, previousQty;

  @override
  State<QtyCounterButton> createState() => _QtyCounterButtonState();
}

class _QtyCounterButtonState extends State<QtyCounterButton> {
  // late int _previousQty;
  bool _isAnimating = false;
  late int _displayQty;

  @override
  void initState() {
    super.initState();
    _displayQty = widget.qty;
  }

  @override
  void didUpdateWidget(covariant QtyCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qty != widget.qty) {
      _displayQty = widget.qty;
    }
  }

  void _updateQty({required bool isIncrement}) {
    if (_isAnimating) return;

    _isAnimating = true;
    HapticFeedback.vibrate();

    final nextQty = isIncrement ? _displayQty + 1 : _displayQty - 1;
    setState(() {
      _displayQty = nextQty;
    });

    if (isIncrement && widget.onIncrementQty != null) {
      widget.onIncrementQty!();
    } else if (!isIncrement && widget.onDecrementQty != null) {
      widget.onDecrementQty!();
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      _isAnimating = false;
    });
  }

  void incrementQty() {
    _updateQty(isIncrement: true);
  }

  void decrementQty() {
    _updateQty(isIncrement: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      constraints: const BoxConstraints(minWidth: 100),
      decoration: BoxDecoration(
        color: AppColors.kBlack3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: decrementQty,
              child: Container(
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
            ),
            Text(
              "$_displayQty",
              style: context.customTextTheme.text14W700.copyWith(
                color: Colors.white,
              ),
            ),
            InkWell(
              onTap: incrementQty,
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

class QtyCounterButton2 extends StatefulWidget {
  const QtyCounterButton2({
    super.key,
    this.onDecrementQty,
    this.hideDefaultAddBtn = false,
    this.onIncrementQty,
    this.qty = 0,
    this.previousQty = -1,
    this.gap,
    this.maxQty,
    this.allowDecrementAtMinimum = false,
  });

  final VoidCallback? onDecrementQty;
  final VoidCallback? onIncrementQty;
  final Widget? gap;
  final bool hideDefaultAddBtn;
  final int qty, previousQty;
  final int? maxQty;
  final bool allowDecrementAtMinimum;

  @override
  State<QtyCounterButton2> createState() => _QtyCounterButton2State();
}

class _QtyCounterButton2State extends State<QtyCounterButton2> {
  bool _isAnimating = false;
  late int _displayQty;

  @override
  void initState() {
    super.initState();
    _displayQty = widget.qty;
  }

  @override
  void didUpdateWidget(covariant QtyCounterButton2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qty != widget.qty) {
      _displayQty = widget.qty;
    }
  }

  void _updateQty({required bool isIncrement}) {
    if (_isAnimating) return;

    _isAnimating = true;
    HapticFeedback.lightImpact();

    final isDecrementDisabled =
        widget.allowDecrementAtMinimum ? _displayQty <= 0 : _displayQty <= 1;
    final isIncrementDisabled =
        widget.maxQty != null && _displayQty >= widget.maxQty!;
    if (isIncrement && !isIncrementDisabled) {
      if (widget.onIncrementQty != null) widget.onIncrementQty!();
    } else if (!isIncrement && !isDecrementDisabled) {
      if (widget.onDecrementQty != null) widget.onDecrementQty!();
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      _isAnimating = false;
    });
  }

  void incrementQty() {
    if (widget.maxQty != null && _displayQty >= widget.maxQty!) return;
    _updateQty(isIncrement: true);
  }

  void decrementQty() {
    _updateQty(isIncrement: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDecrementDisabled =
        widget.allowDecrementAtMinimum ? _displayQty <= 0 : _displayQty <= 1;
    final isIncrementDisabled =
        widget.maxQty != null && _displayQty >= widget.maxQty!;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: isDecrementDisabled ? null : decrementQty,
              splashColor: isDecrementDisabled ? Colors.transparent : null,
              highlightColor: isDecrementDisabled ? Colors.transparent : null,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: AppColors.kGray.withOpacity(0.15),
                    )),
                child: Icon(
                  Icons.remove_rounded,
                  color: isDecrementDisabled
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Text(
              "$_displayQty",
              style: context.customTextTheme.text14W700.copyWith(
                color: context.customTextTheme.color,
              ),
            ),
            InkWell(
              onTap: isIncrementDisabled ? null : incrementQty,
              splashColor: isIncrementDisabled ? Colors.transparent : null,
              highlightColor: isIncrementDisabled ? Colors.transparent : null,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isIncrementDisabled
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
