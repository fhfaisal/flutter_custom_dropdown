import 'package:flutter/material.dart';
import 'package:flutter_custom_dropdown/flutter_custom_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SearchableDropdown Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const ExamplesHomePage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Home – navigates to each example
// ---------------------------------------------------------------------------

class ExamplesHomePage extends StatelessWidget {
  const ExamplesHomePage({super.key});

  static const _examples = [
    ('1. Basic (BottomSheet)', BasicExample.new),
    ('2. Dialog Mode', DialogExample.new),
    ('3. Overlay Mode', OverlayExample.new),
    ('4. Custom Object', CustomObjectExample.new),
    ('5. Custom Item Builder', CustomItemBuilderExample.new),
    ('6. Async Items', AsyncItemsExample.new),
    ('7. No Search / No Clear', NoSearchNoClearExample.new),
    ('8. Custom Style', CustomStyleExample.new),
    ('9. Form Validation', FormValidationExample.new),
    ('10. Programmatic Control', ProgrammaticControlExample.new),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SearchableDropdown Examples')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _examples.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final (title, builder) = _examples[i];
          return ListTile(
            title: Text(title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => builder()),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared model
// ---------------------------------------------------------------------------

/// A simple model representing a country.
/// In your real app this would come from an API response or a database.
class Country {
  final int id;
  final String name;
  final String flag;

  const Country({required this.id, required this.name, required this.flag});

  /// Returns a Map so the selected value can be printed in a readable format:
  /// {'id': 1, 'name': "Bangladesh"}
  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  @override
  String toString() => toMap().toString();
}

// ---------------------------------------------------------------------------
// Shared data
// ---------------------------------------------------------------------------

const _countries = [
  Country(id: 1,  name: 'Bangladesh',   flag: '🇧🇩'),
  Country(id: 2,  name: 'Brazil',       flag: '🇧🇷'),
  Country(id: 3,  name: 'Canada',       flag: '🇨🇦'),
  Country(id: 4,  name: 'China',        flag: '🇨🇳'),
  Country(id: 5,  name: 'Egypt',        flag: '🇪🇬'),
  Country(id: 6,  name: 'France',       flag: '🇫🇷'),
  Country(id: 7,  name: 'Germany',      flag: '🇩🇪'),
  Country(id: 8,  name: 'India',        flag: '🇮🇳'),
  Country(id: 9,  name: 'Indonesia',    flag: '🇮🇩'),
  Country(id: 10, name: 'Italy',        flag: '🇮🇹'),
  Country(id: 11, name: 'Japan',        flag: '🇯🇵'),
  Country(id: 12, name: 'Mexico',       flag: '🇲🇽'),
  Country(id: 13, name: 'Nigeria',      flag: '🇳🇬'),
  Country(id: 14, name: 'Pakistan',     flag: '🇵🇰'),
  Country(id: 15, name: 'Russia',       flag: '🇷🇺'),
  Country(id: 16, name: 'Saudi Arabia', flag: '🇸🇦'),
  Country(id: 17, name: 'South Africa', flag: '🇿🇦'),
  Country(id: 18, name: 'South Korea',  flag: '🇰🇷'),
  Country(id: 19, name: 'Turkey',       flag: '🇹🇷'),
  Country(id: 20, name: 'United States',flag: '🇺🇸'),
];

// ---------------------------------------------------------------------------
// Shared result widget – shows the selected object printed as a map
// ---------------------------------------------------------------------------

/// Reusable widget that displays the selected [Country] in map format:
///   {'id': 1, 'name': "Bangladesh"}
class SelectedResult extends StatelessWidget {
  final Country? country;

  const SelectedResult({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    final text = country == null
        ? 'none'
        : country!.toMap().toString(); // e.g. {id: 1, name: Bangladesh}

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text('Selected: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Basic example – BottomSheet (default mode)
// ---------------------------------------------------------------------------

/// The simplest possible usage.
/// Only [items], [itemLabel], [onSelected], [hintText] and [textController]
/// are required. Everything else uses its default.
///
/// Output when Bangladesh is selected:
///   {id: 1, name: Bangladesh}
class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  // You MUST create the TextEditingController in the parent widget so you
  // can read / clear the selected value at any time.
  final TextEditingController _textController = TextEditingController();

  // Store the full selected object so you can access all its fields.
  Country? _selected;

  @override
  void dispose() {
    _textController.dispose(); // Always dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1. Basic (BottomSheet)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdownField<Country>(
              hintText: 'Select Country',
              // The list of items to show inside the dropdown.
              items: _countries,
              // itemLabel controls what appears in the field text AND what the
              // search query is matched against.
              itemLabel: (country) => country.name,
              // The controller that drives the visible text field.
              textController: _textController,
              // onSelected gives you the full typed object – use any field.
              onSelected: (country) {
                setState(() => _selected = country);

                // Print the selected object as a map:
                // {id: 1, name: Bangladesh}
                debugPrint(_selected!.toMap().toString());
              },
            ),
            const SizedBox(height: 16),
            // Displays: {id: 1, name: Bangladesh}
            SelectedResult(country: _selected),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Dialog mode
// ---------------------------------------------------------------------------

/// Use [DropdownMode.dialog] to show the list inside a centred dialog instead
/// of a bottom sheet. Useful on tablets or wide-screen layouts.
class DialogExample extends StatefulWidget {
  const DialogExample({super.key});

  @override
  State<DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2. Dialog Mode')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdownField<Country>(
              hintText: 'Select Country',
              items: _countries,
              itemLabel: (country) => country.name,
              textController: _textController,
              // Switch the presentation layer to a dialog.
              mode: DropdownMode.dialog,
              onSelected: (country) {
                setState(() => _selected = country);
                debugPrint(_selected!.toMap().toString());
              },
            ),
            const SizedBox(height: 16),
            SelectedResult(country: _selected),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Overlay mode
// ---------------------------------------------------------------------------

/// Use [DropdownMode.overlay] to show the list as an anchored overlay
/// positioned below the field – similar to a native <select> dropdown.
class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key});

  @override
  State<OverlayExample> createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {
  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3. Overlay Mode')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdownField<Country>(
              hintText: 'Select Country',
              items: _countries,
              itemLabel: (country) => country.name,
              textController: _textController,
              // Anchored overlay; appears directly under the field.
              mode: DropdownMode.overlay,
              onSelected: (country) {
                setState(() => _selected = country);
                debugPrint(_selected!.toMap().toString());
              },
            ),
            const SizedBox(height: 16),
            SelectedResult(country: _selected),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Custom object – using compareFn
// ---------------------------------------------------------------------------

/// The widget is fully generic. Use [compareFn] so the widget can correctly
/// determine which item is "currently selected" when the sheet reopens.
/// Without [compareFn], it falls back to == which requires identical instances.
class CustomObjectExample extends StatefulWidget {
  const CustomObjectExample({super.key});

  @override
  State<CustomObjectExample> createState() => _CustomObjectExampleState();
}

class _CustomObjectExampleState extends State<CustomObjectExample> {
  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4. Custom Object')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdownField<Country>(
              hintText: 'Select Country',
              items: _countries,
              // Show flag + name in the list and the text field.
              itemLabel: (country) => '${country.flag} ${country.name}',
              textController: _textController,
              // compareFn tells the widget which items are equal.
              // This is important when using custom objects so the currently
              // selected item is highlighted correctly inside the sheet.
              compareFn: (a, b) => a.id == b.id,
              onSelected: (country) {
                setState(() => _selected = country);

                // Full object printed as a map:
                // {id: 8, name: India}
                debugPrint(_selected!.toMap().toString());
              },
            ),
            const SizedBox(height: 16),
            SelectedResult(country: _selected),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Custom item builder
// ---------------------------------------------------------------------------

/// Provide [itemBuilder] to replace the default list tile with any widget.
/// The callback receives the item and [isSelected] so you can highlight
/// the currently chosen entry.
class CustomItemBuilderExample extends StatefulWidget {
  const CustomItemBuilderExample({super.key});

  @override
  State<CustomItemBuilderExample> createState() =>
      _CustomItemBuilderExampleState();
}

class _CustomItemBuilderExampleState extends State<CustomItemBuilderExample> {
  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5. Custom Item Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdownField<Country>(
              hintText: 'Select Country',
              items: _countries,
              itemLabel: (country) => country.name,
              textController: _textController,
              compareFn: (a, b) => a.id == b.id,
              onSelected: (country) {
                setState(() => _selected = country);
                debugPrint(_selected!.toMap().toString());
              },
              // Replace the default ListTile with a fully custom widget.
              // [isSelected] is true when this item is the current selection.
              itemBuilder: (context, country, isSelected) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 26),
                    ),
                    title: Text(country.name),
                    // Show the id as a subtitle so you can see it in the UI.
                    subtitle: Text('ID: ${country.id}'),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            SelectedResult(country: _selected),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Async items (remote search)
// ---------------------------------------------------------------------------

/// Use [asyncItems] when items come from an API or database.
/// The callback receives the current search query and must return a
/// Future<List<T>>. The widget shows a loading indicator automatically.
class AsyncItemsExample extends StatefulWidget {
  const AsyncItemsExample({super.key});

  @override
  State<AsyncItemsExample> createState() => _AsyncItemsExampleState();
}

class _AsyncItemsExampleState extends State<AsyncItemsExample> {
  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  /// Simulates a network call that filters countries by query.
  Future<List<Country>> _fetchCountries(String query) async {
    // Replace this with your real API call, e.g.:
    //   final response = await http.get(Uri.parse('/api/countries?q=$query'));
    //   final list = jsonDecode(response.body) as List;
    //   return list.map((e) => Country.fromMap(e)).toList();
    await Future.delayed(const Duration(milliseconds: 600)); // fake latency
    if (query.isEmpty) return _countries;
    return _countries
        .where(
          (c) => c.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('6. Async Items')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdownField<Country>(
              hintText: 'Search Country (async)',
              // Pass an empty list here; items are loaded via asyncItems.
              items: const [],
              itemLabel: (country) => country.name,
              textController: _textController,
              compareFn: (a, b) => a.id == b.id,
              // Called on every keystroke (debounced internally by 300 ms).
              asyncItems: _fetchCountries,
              onSelected: (country) {
                setState(() => _selected = country);
                // Output: {id: 3, name: Canada}
                debugPrint(_selected!.toMap().toString());
              },
            ),
            const SizedBox(height: 16),
            SelectedResult(country: _selected),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Behavior flags – no search bar, not clearable
// ---------------------------------------------------------------------------

/// [DropdownBehavior] lets you toggle individual UX flags:
/// • [enableSearch]     – show/hide the search field inside the sheet
/// • [clearable]        – show/hide the ✕ clear button on the field
/// • [closeOnSelect]    – close the sheet automatically after picking
/// • [autofocusSearch]  – autofocus the search field when the sheet opens
/// • [enableAnimations] – animate item list changes
class NoSearchNoClearExample extends StatefulWidget {
  const NoSearchNoClearExample({super.key});

  @override
  State<NoSearchNoClearExample> createState() => _NoSearchNoClearExampleState();
}

class _NoSearchNoClearExampleState extends State<NoSearchNoClearExample> {
  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7. No Search / No Clear')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdownField<Country>(
              hintText: 'Select Country',
              items: _countries,
              itemLabel: (country) => country.name,
              textController: _textController,
              compareFn: (a, b) => a.id == b.id,
              behavior: const DropdownBehavior(
                enableSearch: false,   // hides the search field
                clearable: false,      // hides the ✕ button on the text field
                closeOnSelect: true,   // default: closes sheet on pick
                autofocusSearch: true, // default: focuses search on open
              ),
              onSelected: (country) {
                setState(() => _selected = country);
                debugPrint(_selected!.toMap().toString());
              },
            ),
            const SizedBox(height: 16),
            SelectedResult(country: _selected),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. Custom style
// ---------------------------------------------------------------------------

/// [DropdownStyle] controls the visual appearance of both the dropdown sheet
/// and the text field.
class CustomStyleExample extends StatefulWidget {
  const CustomStyleExample({super.key});

  @override
  State<CustomStyleExample> createState() => _CustomStyleExampleState();
}

class _CustomStyleExampleState extends State<CustomStyleExample> {
  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('8. Custom Style')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdownField<Country>(
              hintText: 'Select Country',
              items: _countries,
              itemLabel: (country) => '${country.flag} ${country.name}',
              textController: _textController,
              compareFn: (a, b) => a.id == b.id,
              onSelected: (country) {
                setState(() => _selected = country);
                debugPrint(_selected!.toMap().toString());
              },
              style: DropdownStyle(
                // Rounded corners of the bottom sheet / dialog.
                borderRadius: 28,
                // Background color of the sheet.
                backgroundColor: const Color(0xFF1C1B2E),
                // Text style for each item row.
                itemTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
                // Title at the top of the sheet ("Select Item").
                titleStyle: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
                // Decoration of the search field INSIDE the sheet.
                searchDecoration: const InputDecoration(
                  hintText: 'Type to search…',
                  hintStyle: TextStyle(color: Colors.white38),
                  prefixIcon: Icon(Icons.search, color: Colors.white38),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigoAccent),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                // Decoration of the OUTER text field on the page.
                fieldDecoration: InputDecoration(
                  hintText: 'Select Country',
                  filled: true,
                  fillColor: const Color(0xFF1C1B2E),
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.expand_more, color: Colors.white38),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SelectedResult(country: _selected),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. Form validation
// ---------------------------------------------------------------------------

/// Wrap [SearchableDropdownField] inside a [Form] and supply a [validator].
/// It works exactly like any other [FormField] widget.
class FormValidationExample extends StatefulWidget {
  const FormValidationExample({super.key});

  @override
  State<FormValidationExample> createState() => _FormValidationExampleState();
}

class _FormValidationExampleState extends State<FormValidationExample> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // At this point _selected is guaranteed non-null.
      // Send _selected!.id to your API.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submitted: ${_selected!.toMap()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('9. Form Validation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchableDropdownField<Country>(
                hintText: 'Select Country *',
                items: _countries,
                itemLabel: (country) => country.name,
                textController: _textController,
                compareFn: (a, b) => a.id == b.id,
                onSelected: (country) {
                  setState(() => _selected = country);
                  debugPrint(_selected!.toMap().toString());
                },
                // Provide a validator just like any TextFormField.
                validator: (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please select a country'
                        : null,
                // Show errors immediately when the user leaves the field.
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              SelectedResult(country: _selected),
              const SizedBox(height: 24),
              FilledButton(onPressed: _submit, child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. Programmatic control via SearchableDropdownController
// ---------------------------------------------------------------------------

/// [SearchableDropdownController] lets you open, close, or clear the dropdown
/// from anywhere in your code – e.g. from a button, another widget, or
/// a state management layer (GetX / Bloc / Provider).
class ProgrammaticControlExample extends StatefulWidget {
  const ProgrammaticControlExample({super.key});

  @override
  State<ProgrammaticControlExample> createState() =>
      _ProgrammaticControlExampleState();
}

class _ProgrammaticControlExampleState
    extends State<ProgrammaticControlExample> {
  // 1. Create the controller in your StatefulWidget state.
  final SearchableDropdownController<Country> _dropdownController =
      SearchableDropdownController<Country>();

  final TextEditingController _textController = TextEditingController();
  Country? _selected;

  @override
  void dispose() {
    // 2. Always dispose both controllers.
    _dropdownController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10. Programmatic Control')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 3. Pass your controller to the widget.
            SearchableDropdownField<Country>(
              hintText: 'Select Country',
              items: _countries,
              itemLabel: (country) => country.name,
              textController: _textController,
              compareFn: (a, b) => a.id == b.id,
              controller: _dropdownController,
              onSelected: (country) {
                setState(() => _selected = country);

                // Full object printed as a map:
                // {id: 1, name: Bangladesh}
                debugPrint(_selected!.toMap().toString());
              },
              // Optional: reset state when the user hits ✕.
              onClear: () => setState(() => _selected = null),
            ),

            const SizedBox(height: 16),
            SelectedResult(country: _selected),
            const SizedBox(height: 24),

            // 4. Drive the dropdown programmatically.
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open'),
                  // Opens the bottom sheet / dialog / overlay.
                  onPressed: _dropdownController.open,
                ),
                FilledButton.tonal(
                  // Clears selection and the text field at once.
                  onPressed: () {
                    _dropdownController.clear();
                    setState(() => _selected = null);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
