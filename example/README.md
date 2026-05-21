# custom_dropdown_pro Example

A comprehensive, interactive demonstration of the `custom_dropdown_pro` package. This example showcases all the core features, configurations, and display modes of the dropdown.

## Features Showcased

1. **Basic (BottomSheet)**: The simplest generic implementation using the default Modal Bottom Sheet mode.
2. **Dialog Mode**: Displays dropdown options in a centered dialog, ideal for tablet or widescreen layouts.
3. **Overlay Mode**: Renders the options in a traditional anchored dropdown overlay underneath the field.
4. **Custom Objects**: Illustrates how to use the dropdown with custom model classes and `compareFn` for item equality matching.
5. **Custom Item Builder**: Replaces the default list tiles with any custom widget structure.
6. **Async Items (Remote Search)**: Simulates fetching and filtering list elements asynchronously from a database or remote API.
7. **Behavior Customization**: Toggles specific flags like disabling search, disabling the clear button, or configuring auto-focus.
8. **Visual Customization**: Tailors the dropdown aesthetics including background colors, text styling, and custom input decorations.
9. **Form Validation**: Incorporates the dropdown inside a `Form` widget with validation rules.
10. **Programmatic Control**: Opens, closes, and clears the dropdown programmatically via a `SearchableDropdownController`.

---

## Getting Started

To run the example application locally on your device:

1. **Navigate to the example folder**:
   ```bash
   cd example
   ```

2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

---

## Code Example

Here is a quick look at the minimal setup:

```dart
import 'package:flutter/material.dart';
import 'package:custom_dropdown_pro/custom_dropdown_pro.dart';

class MyDropdownWidget extends StatefulWidget {
  const MyDropdownWidget({super.key});

  @override
  State<MyDropdownWidget> createState() => _MyDropdownWidgetState();
}

class _MyDropdownWidgetState extends State<MyDropdownWidget> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedValue;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchableDropdownField<String>(
      hintText: 'Select Value',
      items: const ['Apple', 'Banana', 'Orange'],
      itemLabel: (item) => item,
      textController: _textController,
      onSelected: (value) {
        setState(() => _selectedValue = value);
      },
    );
  }
}
```
