import 'package:flutter/material.dart';

import '../core/dropdown_behavior.dart';
import '../core/dropdown_controller.dart';
import '../core/dropdown_mode.dart';
import '../core/dropdown_style.dart';
import '../core/typedefs.dart';
import 'dropdown_bottom_sheet.dart';
import 'dropdown_dialog.dart';
import 'dropdown_overlay.dart';

class SearchableDropdownField<T> extends StatefulWidget {
  final List<T> items;

  final T? selectedItem;

  final ItemLabel<T> itemLabel;

  final CompareFn<T>? compareFn;

  final ItemBuilder<T>? itemBuilder;

  final Future<List<T>> Function(String query)? asyncItems;

  final void Function(T item) onSelected;

  final VoidCallback? onClear;

  final SearchableDropdownController<T>? controller;

  final DropdownStyle style;

  final DropdownBehavior behavior;

  final DropdownMode mode;

  final WidgetBuilder? emptyBuilder;

  final WidgetBuilder? loadingBuilder;

  final FormFieldValidator<String>? validator;

  final AutovalidateMode? autovalidateMode;

  final bool enabled;

  final String hintText;

  final TextEditingController textController;

  const SearchableDropdownField({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    required this.hintText,
    required this.textController,
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
  State<SearchableDropdownField<T>> createState() => _SearchableDropdownFieldState<T>();
}

class _SearchableDropdownFieldState<T> extends State<SearchableDropdownField<T>> {
  late final SearchableDropdownController<T> _controller;

  final LayerLink _layerLink = LayerLink();

  final DropdownOverlay _overlay = DropdownOverlay();

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? SearchableDropdownController<T>();

    _controller.attach(open: _openDropdown, close: _closeDropdown, clear: _clearSelection);
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
              ? IconButton(icon: const Icon(Icons.close), onPressed: _clearSelection)
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
