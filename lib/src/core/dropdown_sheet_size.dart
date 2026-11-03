import 'dropdown_mode.dart';

/// Sizing for the [DropdownMode.bottomSheet] sheet.
///
/// By default the sheet sizes itself to its content (capped at 85% of the
/// screen). Setting [initialChildSize] opens the sheet at that fraction of the
/// available height instead, regardless of how many items it holds, and lets
/// the user grow it up to [maxChildSize] by scrolling the list. The sheet
/// never shrinks below [initialChildSize].
class DropdownSheetSize {
  /// Fraction of the available height the sheet opens at, or `null` for a
  /// content-sized sheet.
  final double? initialChildSize;

  /// Fraction of the available height the sheet can grow to when scrolled.
  /// Only used when [initialChildSize] is set.
  final double maxChildSize;

  /// Whether the sheet settles at [initialChildSize] or [maxChildSize] after
  /// the user lets go. Only used when [initialChildSize] is set.
  final bool snap;

  /// Creates a sizing configuration for the bottom sheet.
  const DropdownSheetSize({
    this.initialChildSize,
    this.maxChildSize = 0.85,
    this.snap = true,
  }) : assert(
         initialChildSize == null ||
             (initialChildSize > 0 && initialChildSize <= maxChildSize),
         'initialChildSize must be in (0, maxChildSize]',
       ),
       assert(maxChildSize > 0 && maxChildSize <= 1);

  /// Whether the sheet uses a fixed, scroll-expandable height.
  bool get isDraggable => initialChildSize != null;
}
