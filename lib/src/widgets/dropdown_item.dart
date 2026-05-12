import 'package:flutter/material.dart';

import '../core/dropdown_behavior.dart';
import '../core/dropdown_style.dart';

class DropdownItem<T> extends StatelessWidget {
  final T item;

  final bool isSelected;

  final String label;

  final VoidCallback onTap;

  final DropdownStyle style;

  final DropdownBehavior behavior;

  final Widget? trailing;

  const DropdownItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.label,
    required this.onTap,
    required this.style,
    required this.behavior,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Material(
      color:
      isSelected
          ? colorScheme.secondaryContainer
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child:
        behavior.enableAnimations
            ? AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          padding: style.contentPadding,
          child: _content(theme),
        )
            : Padding(
          padding: style.contentPadding,
          child: _content(theme),
        ),
      ),
    );
  }

  Widget _content(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style:
            style.itemTextStyle ??
                theme.textTheme.bodyMedium
                    ?.copyWith(
                  fontWeight:
                  isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
          ),
        ),

        trailing ??
            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 180,
              ),
              child:
              isSelected
                  ? const Icon(
                Icons.check_rounded,
                key: ValueKey(true),
              )
                  : const SizedBox.shrink(
                key: ValueKey(false),
              ),
            ),
      ],
    );
  }
}