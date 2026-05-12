import 'package:flutter/material.dart';

class DropdownStyle {
  final double borderRadius;

  final EdgeInsets contentPadding;

  final Color? backgroundColor;

  final TextStyle? itemTextStyle;

  final TextStyle? titleStyle;

  final InputDecoration? searchDecoration;

  final InputDecoration? fieldDecoration;

  const DropdownStyle({
    this.borderRadius = 20,
    this.contentPadding =
    const EdgeInsets.symmetric(
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