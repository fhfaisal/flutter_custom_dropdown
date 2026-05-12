import 'package:flutter/material.dart';

import '../core/dropdown_behavior.dart';
import '../core/dropdown_style.dart';

class DropdownSearchField extends StatelessWidget {
  final TextEditingController controller;

  final DropdownStyle style;

  final DropdownBehavior behavior;

  final VoidCallback? onClear;

  const DropdownSearchField({
    super.key,
    required this.controller,
    required this.style,
    required this.behavior,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      autofocus: behavior.autofocusSearch,
      decoration:
      style.searchDecoration ??
          InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                style.borderRadius * 0.6,
              ),
            ),
            suffixIcon:
            controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClear,
            )
                : null,
          ),
      style: theme.textTheme.bodyMedium,
    );
  }
}