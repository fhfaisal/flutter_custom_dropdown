import 'package:custom_dropdown_pro/custom_dropdown_pro.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exports searchable dropdown public API', () {
    expect(SearchableDropdownField<String>, isNotNull);
    expect(DropdownMode.values, isNotEmpty);
  });
}
