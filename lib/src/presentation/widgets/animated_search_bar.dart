import 'package:customer_core/customer_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({
    super.key,
    this.onTap,
    this.words,
  });

  final void Function()? onTap;
  final List<String>? words;

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  int index = 0;

  late final List<String> _words = widget.words ??
      (AppConfig.instance.businessType == BusinessType.restaurant
          ? const ["foods", "fruits", "drinks", "snacks"]
          : const ["salmon", "prawns", "tuna", "crab"]);

  @override
  void initState() {
    super.initState();
    _startRotation();
  }

  void _startRotation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => index = (index + 1) % _words.length);
      _startRotation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(FluentIcons.search_20_regular,
                color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 10),

            // Rotating placeholder text
            Flexible(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Text(
                  'Search for "${_words[index]}"',
                  key: ValueKey(_words[index]),
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade600,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
