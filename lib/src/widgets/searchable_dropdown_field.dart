import 'package:flutter/material.dart';

import '../core/dropdown_behavior.dart';
import '../core/dropdown_controller.dart';
import '../core/dropdown_mode.dart';
import '../core/dropdown_style.dart';
import '../core/typedefs.dart';
import 'dropdown_bottom_sheet.dart';
import 'dropdown_dialog.dart';
import 'dropdown_overlay.dart';

/// A read-only form field that opens a searchable dropdown selector.
class SearchableDropdownField<T> extends StatefulWidget {
  /// The initial list of items available for selection.
  final List<T> items;

  /// The item currently selected when the field is first built.
  final T? selectedItem;

  /// Converts an item into the text displayed to the user.
  final ItemLabel<T> itemLabel;

  /// Custom equality check for complex item types.
  final CompareFn<T>? compareFn;

  /// Optional custom builder for each item row.
  final ItemBuilder<T>? itemBuilder;

  /// Async source used to fetch items for the current query.
  final Future<List<T>> Function(String query)? asyncItems;

  /// Called after the user selects an item.
  final void Function(T item) onSelected;

  /// Called after the user clears the current value.
  final VoidCallback? onClear;

  /// Optional controller for opening, closing, and clearing programmatically.
  final SearchableDropdownController<T>? controller;

  /// Visual style configuration for the field and dropdown.
  final DropdownStyle style;

  /// Interaction flags that control search, clear, and close behavior.
  final DropdownBehavior behavior;

  /// Determines whether the dropdown opens as a sheet, dialog, or overlay.
  final DropdownMode mode;

  /// Builder shown when there are no matching items.
  final WidgetBuilder? emptyBuilder;

  /// Builder shown while async items are loading.
  final WidgetBuilder? loadingBuilder;

  /// Standard form validator for the field text.
  final FormFieldValidator<String>? validator;

  /// Controls when validation messages are shown.
  final AutovalidateMode? autovalidateMode;

  /// Whether the field can be interacted with.
  final bool enabled;

  /// Placeholder text shown when no item is selected.
  final String hintText;

  /// Controller holding the selected label text displayed in the field.
  final TextEditingController textController;

  /// Header widget shown above the search field and item list in the dropdown.
  /// Only used for [DropdownMode.bottomSheet] and [DropdownMode.dialog].
  /// For [DropdownMode.overlay] the parent can include a header in the child
  /// widget passed to the controller.
  /// This is separate from the [DropdownStyle.titleStyle] which is meant for
  /// styling text inside the dropdown content, not a header outside the search field.
  final Widget? header;

  /// Whether to show a default header with the title "Select Item". Only used if [header] is not provided. This is useful for [DropdownMode.overlay] where the parent can not include a header in the child widget passed to the controller.
  final bool defaultHeader;

  /// Creates a searchable dropdown field.
  const SearchableDropdownField({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    required this.hintText,
    required this.textController,
    this.header,
    this.defaultHeader = true,
    this.selectedItem,
    this.compareFn,
    this.itemBuilder,
    this.asyncItems,
    this.controller,
    this.onClear,
    this.style = const DropdownStyle(),
    this.behavior = const DropdownBehavior(),
    this.mode = DropdownMode.bottomSheet,
    this.emptyBuilder,
    this.loadingBuilder,
    this.validator,
    this.autovalidateMode,
    this.enabled = true,
  });

  @override
  State<SearchableDropdownField<T>> createState() =>
      _SearchableDropdownFieldState<T>();
}

class _SearchableDropdownFieldState<T>
    extends State<SearchableDropdownField<T>> {
  late final SearchableDropdownController<T> _controller;

  final LayerLink _layerLink = LayerLink();

  final DropdownOverlay _overlay = DropdownOverlay();

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? SearchableDropdownController<T>();

    _controller.attach(
      open: _openDropdown,
      close: _closeDropdown,
      clear: _clearSelection,
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    _overlay.hide();

    super.dispose();
  }

  void _clearSelection() {
    widget.textController.clear();
    _controller.clearSelection();
    widget.onClear?.call();

    setState(() {});
  }

  Widget _buildDropdownContent({VoidCallback? onClose}) {
    return DropdownBottomSheet<T>(
      header: widget.header,
      defaultHeader: widget.defaultHeader,
      items: widget.items,
      selectedItem: widget.selectedItem,
      itemLabel: widget.itemLabel,
      compareFn: widget.compareFn,
      itemBuilder: widget.itemBuilder,
      asyncItems: widget.asyncItems,
      onSelected: (item) {
        widget.textController.text = widget.itemLabel(item);

        widget.onSelected(item);

        setState(() {});
      },
      style: widget.style,
      behavior: widget.behavior,
      controller: _controller,
      emptyBuilder: widget.emptyBuilder,
      loadingBuilder: widget.loadingBuilder,
      // Passed only for overlay mode so we never accidentally call
      // Navigator.pop on the page route.
      onClose: onClose,
    );
  }

  Future<void> _openDropdown() async {
    if (!widget.enabled) return;

    switch (widget.mode) {
      case DropdownMode.bottomSheet:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _buildDropdownContent(),
        );

      case DropdownMode.dialog:
        await showDialog(
          context: context,
          builder: (_) => DropdownDialog(child: _buildDropdownContent()),
        );

      case DropdownMode.overlay:
        _overlay.show(
          context: context,
          layerLink: _layerLink,
          // Pass _closeDropdown so selecting an item hides the overlay
          // instead of popping the page route.
          child: SizedBox(
            width: 320,
            height: 400,
            child: _buildDropdownContent(onClose: _closeDropdown),
          ),
        );
    }
  }

  void _closeDropdown() {
    _overlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final decoration =
        widget.style.fieldDecoration ??
        InputDecoration(
          hintText: widget.hintText,
          border: const OutlineInputBorder(),
          suffixIcon: widget.textController.text.isEmpty
              ? const Icon(Icons.keyboard_arrow_down_rounded)
              : widget.behavior.clearable
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSelection,
                )
              : null,
        );

    return CompositedTransformTarget(
      link: _layerLink,
      child: Semantics(
        label: widget.hintText,
        button: true,
        child: TextFormField(
          controller: widget.textController,
          readOnly: true,
          enabled: widget.enabled,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          onTap: _openDropdown,
          decoration: decoration,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
