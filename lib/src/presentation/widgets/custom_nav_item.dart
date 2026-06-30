// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:customer_core/gen/assets.gen.dart';

class CustomNavItem extends StatelessWidget {
  final bool selected;
  final LottieGenImage icon;
  final String label;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;

  const CustomNavItem({
    super.key,
    required this.selected,
    required this.label,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currentTextColor = selected
        ? (activeTextColor ?? activeColor)
        : (inactiveTextColor ?? inactiveColor);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 1.5,
              // width: selected ? null : 0,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: selected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Icon(
            //   icon,
            //   color: selected ? activeColor : inactiveColor,
            // ),
            AnimatedLottieIcon(
              selected: selected,
              asset: icon,
              
            ),
            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: currentTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedLottieIcon extends StatefulWidget {
  final bool selected;
  final LottieGenImage asset;
  final double size;

  const AnimatedLottieIcon({
    Key? key,
    required this.selected,
    required this.asset,
    this.size = 28,
  }) : super(key: key);

  @override
  State<AnimatedLottieIcon> createState() => _AnimatedLottieIconState();
}

class _AnimatedLottieIconState extends State<AnimatedLottieIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant AnimatedLottieIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selected && !oldWidget.selected) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
     return widget.asset.lottie(
      controller: _controller,
      height: widget.size,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ['**'],
            value: widget.selected ?  Theme.of(context).colorScheme.primary: Colors.grey,
          ),
          ValueDelegate.strokeColor(
            const ['**'],
            value: widget.selected ?  Theme.of(context).colorScheme.primary : Colors.grey,
          ),
        ],
      ),
      onLoaded: (composition) {
        _controller.duration = composition.duration;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
