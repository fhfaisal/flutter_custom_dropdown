import 'package:flutter/material.dart';

import 'dropdown_state.dart';

/// Controls a [SearchableDropdownField] programmatically.
class SearchableDropdownController<T> {
  /// Notifies listeners when loading state, selected item, or filtered items change.
  final ValueNotifier<DropdownState<T>> stateNotifier = ValueNotifier(
    DropdownState<T>(filteredItems: [], loading: false),
  );

  VoidCallback? _open;

  VoidCallback? _close;

  VoidCallback? _clear;

  /// Attaches callbacks from the widget so the controller can operate it.
  void attach({VoidCallback? open, VoidCallback? close, VoidCallback? clear}) {
    _open = open;
    _close = close;
    _clear = clear;
  }

  /// Opens the dropdown if it is attached to a widget.
  void open() => _open?.call();

  /// Closes the dropdown if it is attached to a widget.
  void close() => _close?.call();

  /// Clears the current selection if it is attached to a widget.
  void clear() => _clear?.call();

  /// Clears the selected item in the controller state.
  void clearSelection() {
    stateNotifier.value = stateNotifier.value.copyWith(clearSelectedItem: true);
  }

  /// Replaces the currently visible items.
  void updateItems(List<T> items) {
    stateNotifier.value = stateNotifier.value.copyWith(filteredItems: items);
  }

  /// Updates the loading state used by async item sources.
  void setLoading(bool value) {
    stateNotifier.value = stateNotifier.value.copyWith(loading: value);
  }

  /// Marks an item as selected in the controller state.
  void select(T item) {
    stateNotifier.value = stateNotifier.value.copyWith(selectedItem: item);
  }

  /// Disposes the internal notifier.
  void dispose() {
    stateNotifier.dispose();
  }
}
