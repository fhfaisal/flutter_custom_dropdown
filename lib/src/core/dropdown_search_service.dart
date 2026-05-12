class DropdownSearchService<T> {
  List<T> filter({
    required List<T> items,
    required String query,
    required String Function(T item) mapper,
  }) {
    final normalized =
    query.trim().toLowerCase();

    return items.where((item) {
      return mapper(item)
          .toLowerCase()
          .contains(normalized);
    }).toList();
  }
}