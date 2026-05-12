# flutter_custom_dropdown

A highly customizable, fully generic, searchable dropdown field for Flutter.  
Supports **BottomSheet**, **Dialog**, and **Overlay** presentation modes, async data loading, custom item builders, form validation, and programmatic control — all with zero external dependencies.

---

## Features

-  **Built-in search** with 300 ms debounce
-  **Three display modes** — BottomSheet, Dialog, Overlay
-  **Fully generic** `<T>` — use any model class, not just strings
-  **Async items** — load from API / database on every keystroke
-  **Custom item builder** — replace the default tile with any widget
-  **Form-field compatible** — `validator` + `autovalidateMode` support
-  **Programmatic control** — open, close, or clear from code
-  **Clear button** — clears both the text field and the internal selection state
-  **Fully themeable** — `DropdownStyle` covers every visual detail
-  **Zero external dependencies**

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_custom_dropdown: ^0.0.1
```

Then run:

```sh
flutter pub get
```

---

## Quick Start

```dart
import 'package:flutter_custom_dropdown/flutter_custom_dropdown.dart';
```

```dart
// 1. Create a controller in your State
final TextEditingController _textController = TextEditingController();

// 2. Drop the widget into your widget tree
SearchableDropdownField<String>(
  hintText: 'Select Country',
  items: ['Bangladesh', 'India', 'Japan', 'Canada'],
  itemLabel: (item) => item,
  textController: _textController,
  onSelected: (value) => print(value),
)

// 3. Always dispose the controller
@override
void dispose() {
  _textController.dispose();
  super.dispose();
}
```

---

## Usage

### 1. Basic — BottomSheet (default)

```dart
SearchableDropdownField<String>(
  hintText: 'Select Country',
  items: countries,
  itemLabel: (item) => item,
  textController: _textController,
  onSelected: (value) => debugPrint(value),
)
```

---

### 2. Display Modes

Control where the item list appears using `mode`:

```dart
// Center dialog (great for tablets / wide screens)
SearchableDropdownField<String>(
  mode: DropdownMode.dialog,
  ...
)

// Anchored overlay directly below the field
SearchableDropdownField<String>(
  mode: DropdownMode.overlay,
  ...
)
```

| Mode | Description |
|------|-------------|
| `DropdownMode.bottomSheet` | Modal bottom sheet (default) |
| `DropdownMode.dialog` | Centered dialog |
| `DropdownMode.overlay` | Anchored overlay below the field |

---

### 3. Custom Object (Generic `<T>`)

The widget is fully generic — pass any class as `T`.

```dart
class Country {
  final int id;
  final String name;

  const Country({required this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}

Country? _selected;

SearchableDropdownField<Country>(
  hintText: 'Select Country',
  items: countries,          // List<Country>
  itemLabel: (c) => c.name, // drives both display text AND search
  textController: _textController,
  // Required for custom objects: tells the widget which items are equal
  compareFn: (a, b) => a.id == b.id,
  onSelected: (country) {
    _selected = country;
    debugPrint(_selected!.toMap().toString());
    // Output: {id: 1, name: Bangladesh}
  },
)
```

---

### 4. Async Items

Load items from an API on every keystroke. The widget shows a loading indicator automatically.

```dart
Future<List<Country>> _fetchCountries(String query) async {
  final response = await http.get(Uri.parse('/api/countries?q=$query'));
  final list = jsonDecode(response.body) as List;
  return list.map((e) => Country.fromMap(e)).toList();
}

SearchableDropdownField<Country>(
  hintText: 'Search Country',
  items: const [],          // start empty; asyncItems fills the list
  itemLabel: (c) => c.name,
  textController: _textController,
  asyncItems: _fetchCountries, // called on each keystroke (300 ms debounce)
  onSelected: (country) => debugPrint(country.toMap().toString()),
)
```

---

### 5. Custom Item Builder

Replace the default list tile with any widget. `isSelected` lets you highlight the current selection.

```dart
SearchableDropdownField<Country>(
  ...
  itemBuilder: (context, country, isSelected) {
    return Container(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : Colors.transparent,
      child: ListTile(
        title: Text(country.name),
        subtitle: Text('ID: ${country.id}'),
        trailing: isSelected ? const Icon(Icons.check) : null,
      ),
    );
  },
)
```

---

### 6. Form Validation

Works seamlessly inside a `Form` widget.

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      SearchableDropdownField<Country>(
        hintText: 'Select Country *',
        items: countries,
        itemLabel: (c) => c.name,
        textController: _textController,
        onSelected: (country) => _selected = country,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please select a country' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // _selected is guaranteed non-null here
            api.submit(_selected!.id);
          }
        },
        child: const Text('Submit'),
      ),
    ],
  ),
)
```

---

### 7. Programmatic Control

Use `SearchableDropdownController<T>` to open, close, or clear the dropdown from your code — compatible with any state management approach (GetX, Bloc, Provider, etc.).

```dart
// 1. Create the controller
final _dropdownController = SearchableDropdownController<Country>();

// 2. Pass it to the widget
SearchableDropdownField<Country>(
  controller: _dropdownController,
  onClear: () => setState(() => _selected = null),
  ...
)

// 3. Control it from anywhere
_dropdownController.open();   // opens the sheet / dialog / overlay
_dropdownController.clear();  // clears text field + deselects item

// 4. Always dispose
@override
void dispose() {
  _dropdownController.dispose();
  super.dispose();
}
```

---

## Customization

### `DropdownBehavior`

Controls UX interactions:

```dart
SearchableDropdownField(
  behavior: const DropdownBehavior(
    enableSearch: true,      // show search field inside the sheet (default: true)
    clearable: true,         // show ✕ button on the text field (default: true)
    closeOnSelect: true,     // close sheet after picking an item (default: true)
    autofocusSearch: true,   // auto-focus the search field on open (default: true)
    enableAnimations: true,  // animate list changes (default: true)
  ),
  ...
)
```

### `DropdownStyle`

Controls visual appearance:

```dart
SearchableDropdownField(
  style: DropdownStyle(
    borderRadius: 24,                      // sheet corner radius
    backgroundColor: const Color(0xFF1C1B2E), // sheet background
    itemTextStyle: const TextStyle(color: Colors.white), // item text
    titleStyle: const TextStyle(fontWeight: FontWeight.bold), // sheet title
    searchDecoration: InputDecoration(...), // search field decoration (inside sheet)
    fieldDecoration: InputDecoration(...),  // outer text field decoration
  ),
  ...
)
```

---

## API Reference

### `SearchableDropdownField<T>`

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `items` | `List<T>` | ✅ | Static list of items |
| `itemLabel` | `String Function(T)` | ✅ | Converts item to display string |
| `onSelected` | `void Function(T)` | ✅ | Called when user selects an item |
| `hintText` | `String` | ✅ | Placeholder text for the field |
| `textController` | `TextEditingController` | ✅ | Drives the visible text field |
| `selectedItem` | `T?` | | Pre-selected item on first render |
| `compareFn` | `bool Function(T, T)?` | | Equality check for custom objects |
| `itemBuilder` | `Widget Function(context, T, bool)?` | | Custom item tile builder |
| `asyncItems` | `Future<List<T>> Function(String)?` | | Async item loader (API / DB) |
| `onClear` | `VoidCallback?` | | Called when the ✕ button is tapped |
| `controller` | `SearchableDropdownController<T>?` | | Programmatic control handle |
| `mode` | `DropdownMode` | | `bottomSheet` / `dialog` / `overlay` |
| `behavior` | `DropdownBehavior` | | UX interaction flags |
| `style` | `DropdownStyle` | | Visual theming |
| `validator` | `FormFieldValidator<String>?` | | Form validation callback |
| `autovalidateMode` | `AutovalidateMode?` | | When to show validation errors |
| `enabled` | `bool` | | Disable the field (default: `true`) |
| `emptyBuilder` | `WidgetBuilder?` | | Custom empty-state widget |
| `loadingBuilder` | `WidgetBuilder?` | | Custom loading-state widget |

---

## Contributing

Contributions are welcome! Please open an issue before submitting a pull request so we can discuss the change.

1. Fork the repo
2. Create your feature branch: `git checkout -b feat/my-feature`
3. Commit your changes: `git commit -m 'feat: add my feature'`
4. Push to the branch: `git push origin feat/my-feature`
5. Open a Pull Request

---

## License

MIT — see [LICENSE](LICENSE) for details.
