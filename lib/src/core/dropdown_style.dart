import 'package:flutter/material.dart';

/// Visual styling for the field, search input, and dropdown content.
class DropdownStyle {
  /// Corner radius used by the dropdown surface.
  final double borderRadius;

  /// Padding used inside dropdown content containers.
  final EdgeInsets contentPadding;

  /// Background color for the dropdown surface.
  final Color? backgroundColor;

  /// Text style for each dropdown item.
  final TextStyle? itemTextStyle;

  /// Text style for title-like content inside the dropdown.
  final TextStyle? titleStyle;

  /// Decoration for the optional search field inside the dropdown.
  final InputDecoration? searchDecoration;

  /// Decoration for the read-only trigger field.
  final InputDecoration? fieldDecoration;

  /// Creates a style configuration for the dropdown UI.
  const DropdownStyle({
    this.borderRadius = 20,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    this.backgroundColor,
    this.itemTextStyle,
    this.titleStyle,
    this.searchDecoration,
    this.fieldDecoration,
  });
}
