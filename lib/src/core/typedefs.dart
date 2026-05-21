import 'package:flutter/material.dart';

/// Converts an item into the display label shown in the field and list.
typedef ItemLabel<T> = String Function(T item);

/// Compares two items for equality when a custom model type is used.
typedef CompareFn<T> = bool Function(T a, T b);

/// Builds a custom dropdown row for an item.
typedef ItemBuilder<T> =
    Widget Function(BuildContext context, T item, bool isSelected);
