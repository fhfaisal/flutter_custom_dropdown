import 'package:flutter/widgets.dart';

import 'dropdown_mode.dart';

/// Sizing for the [DropdownMode.bottomSheet] sheet.
///
/// By default the sheet sizes itself to its content (capped at 85% of the
/// screen). Setting [initialChildSize] opens the sheet at that fraction of the
/// available height instead, regardless of how many items it holds, and lets
/// the user grow it up to [maxChildSize] by scrolling the list. The sheet
/// never shrinks below [initialChildSize], and coming back down to it does not
/// close the sheet.
///
/// ```dart
/// // Opens at 60%, stops at 75% and 90% when scrolled.
/// const DropdownSheetSize(
///   initialChildSize: 0.6,
///   maxChildSize: 0.9,
///   snapSizes: [0.75],
/// )
/// ```
class DropdownSheetSize {
  /// Fraction of the available height the sheet opens at, or `null` for a
  /// content-sized sheet.
  final double? initialChildSize;

  /// Fraction of the available height the sheet can grow to when scrolled.
  /// Only used when [initialChildSize] is set.
  final double maxChildSize;

  /// Whether the sheet settles at the nearest snap size after the user lets
  /// go. Only used when [initialChildSize] is set.
  final bool snap;

  /// Extra sizes the sheet can settle at, in addition to [initialChildSize]
  /// and [maxChildSize], which are always snap sizes. Must be in ascending
  /// order and between [initialChildSize] and [maxChildSize] (asserted by
  /// [DraggableScrollableSheet] in debug builds). Only used when [snap] is
  /// true and [initialChildSize] is set.
  final List<double>? snapSizes;

  /// Duration of the snap animation, or `null` for a duration derived from
  /// the fling velocity. Only used when [snap] is true and [initialChildSize]
  /// is set.
  final Duration? snapAnimationDuration;

  /// Creates a sizing configuration for the bottom sheet.
  const DropdownSheetSize({
    this.initialChildSize,
    this.maxChildSize = 0.85,
    this.snap = true,
    this.snapSizes,
    this.snapAnimationDuration,
  }) : assert(
         initialChildSize == null ||
             (initialChildSize > 0 && initialChildSize <= maxChildSize),
         'initialChildSize must be in (0, maxChildSize]',
       ),
       assert(maxChildSize > 0 && maxChildSize <= 1),
       assert(
         snapAnimationDuration == null || snapAnimationDuration > Duration.zero,
       );

  /// Whether the sheet uses a fixed, scroll-expandable height.
  bool get isDraggable => initialChildSize != null;
}
