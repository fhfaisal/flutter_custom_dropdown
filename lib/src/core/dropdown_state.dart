class DropdownState<T> {
  final List<T> filteredItems;

  final bool loading;

  final T? selectedItem;

  const DropdownState({
    required this.filteredItems,
    required this.loading,
    this.selectedItem,
  });

  /// Use [clearSelectedItem] = true to explicitly set [selectedItem] to null.
  /// Passing a non-null [selectedItem] always takes precedence.
  DropdownState<T> copyWith({
    List<T>? filteredItems,
    bool? loading,
    T? selectedItem,
    bool clearSelectedItem = false,
  }) {
    return DropdownState<T>(
      filteredItems: filteredItems ?? this.filteredItems,
      loading: loading ?? this.loading,
      selectedItem: clearSelectedItem ? null : (selectedItem ?? this.selectedItem),
    );
  }
}