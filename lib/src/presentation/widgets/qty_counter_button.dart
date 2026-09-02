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

  // @override
  // void initState() {
  //   _previousQty = widget.previousQty;
  //   super.initState();
  // }

  void _updateQty({required bool isIncrement}) {
    if (_isAnimating) return;

    _isAnimating = true;
    HapticFeedback.vibrate();

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
              "${widget.qty}",
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
  });

  final VoidCallback? onDecrementQty;
  final VoidCallback? onIncrementQty;
  final Widget? gap;
  final bool hideDefaultAddBtn;
  final int qty, previousQty;

  /// Optional maximum quantity allowed by the +/- stepper (e.g. fish stock
  /// limit). When set and [qty] reaches it, the '+' button is disabled.
  final int? maxQty;

  @override
  State<QtyCounterButton2> createState() => _QtyCounterButton2State();
}

class _QtyCounterButton2State extends State<QtyCounterButton2> {
  bool _isAnimating = false;

  void _updateQty({required bool isIncrement}) {
    if (_isAnimating) return;

    _isAnimating = true;
    HapticFeedback.lightImpact();

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
    if (widget.maxQty != null && widget.qty >= widget.maxQty!) return;
    _updateQty(isIncrement: true);
  }

  void decrementQty() {
    if (widget.qty <= 1) return;
    _updateQty(isIncrement: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDecrementDisabled = widget.qty <= 1;
    final isIncrementDisabled =
        widget.maxQty != null && widget.qty >= widget.maxQty!;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              // Keep onTap non-null so a disabled button (qty <= 1) still
              // consumes the tap instead of letting it fall through to the
              // parent tile's InkWell (which would open the details sheet).
              onTap: decrementQty,
              splashColor:
                  isDecrementDisabled ? Colors.transparent : null,
              highlightColor:
                  isDecrementDisabled ? Colors.transparent : null,
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
              "${widget.qty}",
              style: context.customTextTheme.text14W700.copyWith(
                color: context.customTextTheme.color,
              ),
            ),
            InkWell(
              // Keep onTap non-null (the guard lives inside incrementQty) so a
              // disabled button doesn't let the tap fall through to the parent.
              onTap: incrementQty,
              splashColor:
                  isIncrementDisabled ? Colors.transparent : null,
              highlightColor:
                  isIncrementDisabled ? Colors.transparent : null,
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
