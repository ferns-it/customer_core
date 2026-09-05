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

/// Quantity stepper used across the home screen, favourites, search results,
/// categories, cart items and the "manage dish" bottom sheet.
///
/// Kept intentionally stateless so it can never drift out of sync with the
/// real value: [qty] is the single source of truth and is always rendered
/// as-is. All consumers (CartProvider/TableProvider) notify their UI
/// synchronously on tap, so the button always reflects the latest quantity
/// without optimistic-update bugs or taps being silently dropped by an
/// internal "animating" lock.
class QtyCounterButton2 extends StatelessWidget {
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

  void _updateQty({required bool isIncrement}) {
    HapticFeedback.lightImpact();

    final isDecrementDisabled = allowDecrementAtMinimum ? qty <= 0 : qty <= 1;
    final isIncrementDisabled = maxQty != null && qty >= maxQty!;

    if (isIncrement && !isIncrementDisabled) {
      onIncrementQty?.call();
    } else if (!isIncrement && !isDecrementDisabled) {
      onDecrementQty?.call();
    }
  }

  void incrementQty() {
    if (maxQty != null && qty >= maxQty!) return;
    _updateQty(isIncrement: true);
  }

  void decrementQty() {
    _updateQty(isIncrement: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDecrementDisabled = allowDecrementAtMinimum ? qty <= 0 : qty <= 1;
    final isIncrementDisabled = maxQty != null && qty >= maxQty!;

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
              "$qty",
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
