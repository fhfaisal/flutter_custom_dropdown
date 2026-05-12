import 'package:flutter/material.dart';

typedef ItemLabel<T> = String Function(T item);

typedef CompareFn<T> =
bool Function(T a, T b);

typedef ItemBuilder<T> = Widget Function(
    BuildContext context,
    T item,
    bool isSelected,
    );