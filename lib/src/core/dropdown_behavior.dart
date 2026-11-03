/// Configures interactive behavior for the dropdown experience.
class DropdownBehavior {
  /// Whether the search field is shown in the dropdown UI.
  final bool enableSearch;

  /// Whether the dropdown closes immediately after an item is selected.
  final bool closeOnSelect;

  /// Whether the selected value can be cleared from the field.
  final bool clearable;

  /// Whether the search input should request focus when opened.
  final bool autofocusSearch;

  /// Whether built-in animations are enabled for the dropdown UI.
  final bool enableAnimations;

  /// Whether the default header shows a close (x) button at its end.
  /// Only used when the dropdown's default header is shown.
  final bool showCloseButton;

  /// Creates a set of behavior flags for the dropdown.
  const DropdownBehavior({
    this.enableSearch = true,
    this.closeOnSelect = true,
    this.clearable = true,
    this.autofocusSearch = true,
    this.enableAnimations = true,
    this.showCloseButton = true,
  });
}
