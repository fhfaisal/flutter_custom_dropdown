import 'package:flutter/material.dart';

import 'dropdown_state.dart';

class SearchableDropdownController<T> {
  final ValueNotifier<DropdownState<T>>
  stateNotifier =
  ValueNotifier(
    DropdownState<T>(
      filteredItems: [],
      loading: false,
    ),
  );

  VoidCallback? _open;

  VoidCallback? _close;

  VoidCallback? _clear;

  void attach({
    VoidCallback? open,
    VoidCallback? close,
    VoidCallback? clear,
  }) {
    _open = open;
    _close = close;
    _clear = clear;
  }

  void open() => _open?.call();

  void close() => _close?.call();

  void clear() => _clear?.call();
  void clearSelection() {
    stateNotifier.value =
        stateNotifier.value.copyWith(
          clearSelectedItem: true,
        );
  }

  void updateItems(List<T> items) {
    stateNotifier.value =
        stateNotifier.value.copyWith(
          filteredItems: items,
        );
  }

  void setLoading(bool value) {
    stateNotifier.value =
        stateNotifier.value.copyWith(
          loading: value,
        );
  }

  void select(T item) {
    stateNotifier.value =
        stateNotifier.value.copyWith(
          selectedItem: item,
        );
  }

  void dispose() {
    stateNotifier.dispose();
  }
}