// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';


import '../core/debounce.dart';
import '../core/dropdown_behavior.dart';
import '../core/dropdown_controller.dart';
import '../core/dropdown_search_service.dart';
import '../core/dropdown_state.dart';
import '../core/dropdown_style.dart';
import '../core/typedefs.dart';

import 'dropdown_list.dart';
import 'dropdown_search_field.dart';

class DropdownBottomSheet<T> extends StatefulWidget {
  final List<T> items;

  final T? selectedItem;

  final ItemLabel<T> itemLabel;

  final CompareFn<T>? compareFn;

  final ItemBuilder<T>? itemBuilder;

  final Future<List<T>> Function(String query)? asyncItems;

  final void Function(T item) onSelected;

  final DropdownStyle style;

  final DropdownBehavior behavior;

  final SearchableDropdownController<T> controller;

  final WidgetBuilder? emptyBuilder;

  final WidgetBuilder? loadingBuilder;

  /// Called when the dropdown should be dismissed after selecting an item.
  /// For [DropdownMode.bottomSheet] and [DropdownMode.dialog] this is left
  /// null and [Navigator.pop] is used. For [DropdownMode.overlay] the parent
  /// passes [_overlay.hide] so the page is never accidentally popped.
  final VoidCallback? onClose;

  const DropdownBottomSheet({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.itemLabel,
    required this.onSelected,
    required this.style,
    required this.behavior,
    required this.controller,
    this.compareFn,
    this.itemBuilder,
    this.asyncItems,
    this.emptyBuilder,
    this.loadingBuilder,
    this.onClose,
  });

  @override
  State<DropdownBottomSheet<T>> createState() => _DropdownBottomSheetState<T>();
}

class _DropdownBottomSheetState<T> extends State<DropdownBottomSheet<T>> {
  final TextEditingController _searchController = TextEditingController();

  late final Debouncer _debouncer;

  late final DropdownSearchService<T> _searchService;

  @override
  void initState() {
    super.initState();

    _debouncer = Debouncer(const Duration(milliseconds: 300));

    _searchService = DropdownSearchService<T>();

    widget.controller.updateItems(widget.items);

    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _debouncer.dispose();

    _searchController.removeListener(_onSearch);

    _searchController.dispose();

    super.dispose();
  }

  void _onSearch() {
    _debouncer.run(() async {
      final query = _searchController.text;

      if (widget.asyncItems != null) {
        widget.controller.setLoading(true);

        final results = await widget.asyncItems!(query);

        if (!mounted) return;

        widget.controller.setLoading(false);

        widget.controller.updateItems(results);

        return;
      }

      final filtered = _searchService.filter(items: widget.items, query: query, mapper: widget.itemLabel);

      widget.controller.updateItems(filtered);
    });
  }

  void _selectItem(T item) {
    widget.controller.select(item);

    widget.onSelected(item);

    if (widget.behavior.closeOnSelect) {
      // Use the provided onClose callback when available (e.g. overlay mode).
      // Fall back to Navigator.pop for bottomSheet / dialog modes.
      if (widget.onClose != null) {
        widget.onClose!.call();
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: widget.style.backgroundColor ?? theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(widget.style.borderRadius)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, borderRadius: BorderRadius.circular(20)),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Select Item', style: widget.style.titleStyle ?? theme.textTheme.titleMedium),
          ),

          const SizedBox(height: 16),

          if (widget.behavior.enableSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownSearchField(
                controller: _searchController,
                style: widget.style,
                behavior: widget.behavior,
                onClear: () {
                  _searchController.clear();
                },
              ),
            ),

          const SizedBox(height: 12),

          Divider(height: 1, color: theme.colorScheme.outlineVariant),

          Expanded(
            child: ValueListenableBuilder<DropdownState<T>>(
              valueListenable: widget.controller.stateNotifier,
              builder: (context, state, _) {
                return DropdownList<T>(
                  items: state.filteredItems,
                  selectedItem: state.selectedItem ?? widget.selectedItem,
                  itemLabel: widget.itemLabel,
                  compareFn: widget.compareFn,
                  itemBuilder: widget.itemBuilder,
                  onItemSelected: _selectItem,
                  style: widget.style,
                  behavior: widget.behavior,
                  loading: state.loading,
                  emptyBuilder: widget.emptyBuilder,
                  loadingBuilder: widget.loadingBuilder,
                );
              },
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}
