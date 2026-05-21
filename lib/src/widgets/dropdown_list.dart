// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';


import '../core/dropdown_behavior.dart';
import '../core/dropdown_style.dart';
import '../core/typedefs.dart';
import 'dropdown_empty.dart';
import 'dropdown_item.dart';
import 'dropdown_loading.dart';

class DropdownList<T> extends StatelessWidget {
  final List<T> items;

  final T? selectedItem;

  final ItemLabel<T> itemLabel;

  final CompareFn<T>? compareFn;

  final ItemBuilder<T>? itemBuilder;

  final void Function(T item) onItemSelected;

  final DropdownStyle style;

  final DropdownBehavior behavior;

  final bool loading;

  final WidgetBuilder? emptyBuilder;

  final WidgetBuilder? loadingBuilder;

  const DropdownList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.itemLabel,
    required this.onItemSelected,
    required this.style,
    required this.behavior,
    required this.loading,
    this.compareFn,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
  });

  bool _isSelected(T item) {
    if (selectedItem == null) {
      return false;
    }

    if (compareFn != null) {
      return compareFn!(
        item,
        selectedItem as T,
      );
    }

    return item == selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadingBuilder?.call(context) ??
          const DropdownLoading();
    }

    if (items.isEmpty) {
      return emptyBuilder?.call(context) ??
          const DropdownEmpty();
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];

        final selected = _isSelected(item);

        if (itemBuilder != null) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onItemSelected(item),
              child: itemBuilder!(
                context,
                item,
                selected,
              ),
            ),
          );
        }

        return DropdownItem<T>(
          item: item,
          isSelected: selected,
          label: itemLabel(item),
          onTap: () => onItemSelected(item),
          style: style,
          behavior: behavior,
        );
      },
    );
  }
}