import 'package:custom_dropdown_pro/custom_dropdown_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _screen = Size(800, 1000);

List<String> _items(int count) => [for (var i = 0; i < count; i++) 'Item $i'];

Future<void> _pump(
  WidgetTester tester, {
  List<String>? items,
  String? title,
  DropdownMode mode = DropdownMode.bottomSheet,
  DropdownBehavior behavior = const DropdownBehavior(autofocusSearch: false),
  DropdownSheetSize sheetSize = const DropdownSheetSize(),
  ThemeData? theme,
}) async {
  tester.view.physicalSize = _screen;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final text = TextEditingController();
  addTearDown(text.dispose);

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(
        body: SearchableDropdownField<String>(
          key: const Key('field'),
          items: items ?? _items(2),
          itemLabel: (item) => item,
          onSelected: (_) {},
          hintText: 'Pick',
          textController: text,
          title: title,
          mode: mode,
          behavior: behavior,
          sheetSize: sheetSize,
        ),
      ),
    ),
  );
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('field')));
  await tester.pumpAndSettle();
}

double _sheetHeight(WidgetTester tester) =>
    tester.getSize(find.byType(BottomSheet)).height;

Future<void> _dismiss(WidgetTester tester) async {
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
}

void main() {
  group('default header', () {
    testWidgets('shows the given title, start-aligned', (tester) async {
      await _pump(tester, title: 'Gender');
      await _open(tester);

      expect(find.text('Select Item'), findsNothing);
      final title = find.text('Gender');
      expect(title, findsOneWidget);
      // Same start inset as the search field below it.
      final searchLeft = tester.getTopLeft(find.byType(TextField).last).dx;
      expect(tester.getTopLeft(title).dx, closeTo(searchLeft, 0.5));
    });

    testWidgets('falls back to "Select Item" without a title', (tester) async {
      await _pump(tester);
      await _open(tester);

      expect(find.text('Select Item'), findsOneWidget);
    });

    testWidgets('close button dismisses the bottom sheet', (tester) async {
      await _pump(tester, title: 'Gender');
      await _open(tester);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
      expect(find.byKey(const Key('field')), findsOneWidget);
    });

    testWidgets('close button hides the overlay without popping the page', (
      tester,
    ) async {
      await _pump(tester, title: 'Gender', mode: DropdownMode.overlay);
      await _open(tester);
      expect(find.text('Gender'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Gender'), findsNothing);
      expect(find.byKey(const Key('field')), findsOneWidget);
    });

    testWidgets('showCloseButton: false hides the close button', (
      tester,
    ) async {
      await _pump(
        tester,
        behavior: const DropdownBehavior(
          autofocusSearch: false,
          showCloseButton: false,
        ),
      );
      await _open(tester);

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('a theme drag handle is not added on top of the sheet', (
      tester,
    ) async {
      await _pump(
        tester,
        theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
        ),
      );
      await _open(tester);

      expect(
        find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == '_DragHandle',
        ),
        findsNothing,
      );
    });
  });

  group('sheetSize', () {
    testWidgets('default sheet is content-sized', (tester) async {
      await _pump(tester, items: _items(2));
      await _open(tester);
      final few = _sheetHeight(tester);
      await _dismiss(tester);

      await _pump(tester, items: _items(40));
      await _open(tester);

      expect(few, lessThan(_screen.height * 0.6));
      expect(_sheetHeight(tester), greaterThan(few));
    });

    const fixed = DropdownSheetSize(initialChildSize: 0.6, maxChildSize: 0.9);

    testWidgets(
      'initialChildSize opens at that height for few and many items',
      (tester) async {
        await _pump(tester, items: _items(2), sheetSize: fixed);
        await _open(tester);
        final few = _sheetHeight(tester);
        expect(few, closeTo(_screen.height * 0.6, 0.5));
        await _dismiss(tester);

        await _pump(tester, items: _items(40), sheetSize: fixed);
        await _open(tester);

        expect(_sheetHeight(tester), closeTo(few, 0.5));
      },
    );

    testWidgets('scrolling the list grows the sheet to maxChildSize', (
      tester,
    ) async {
      await _pump(tester, items: _items(40), sheetSize: fixed);
      await _open(tester);

      await tester.drag(find.text('Item 3'), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(_sheetHeight(tester), closeTo(_screen.height * 0.9, 0.5));
    });

    testWidgets('the sheet does not shrink below initialChildSize', (
      tester,
    ) async {
      await _pump(tester, items: _items(40), sheetSize: fixed);
      await _open(tester);

      await tester.drag(find.text('Item 3'), const Offset(0, 200));
      await tester.pumpAndSettle();

      expect(_sheetHeight(tester), closeTo(_screen.height * 0.6, 0.5));
    });

    testWidgets('coming back down to initialChildSize keeps the sheet open', (
      tester,
    ) async {
      await _pump(tester, items: _items(40), sheetSize: fixed);
      await _open(tester);

      await tester.drag(find.text('Item 3'), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(_sheetHeight(tester), closeTo(_screen.height * 0.9, 0.5));

      await tester.drag(find.text('Item 3'), const Offset(0, 400));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(_sheetHeight(tester), closeTo(_screen.height * 0.6, 0.5));
    });

    testWidgets('without snapSizes a short drag settles back at initial', (
      tester,
    ) async {
      await _pump(tester, items: _items(40), sheetSize: fixed);
      await _open(tester);

      await tester.drag(find.text('Item 3'), const Offset(0, -140));
      await tester.pumpAndSettle();

      expect(_sheetHeight(tester), closeTo(_screen.height * 0.6, 0.5));
    });

    testWidgets('snapSizes adds stops between initial and max', (tester) async {
      await _pump(
        tester,
        items: _items(40),
        sheetSize: const DropdownSheetSize(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          snapSizes: [0.75],
        ),
      );
      await _open(tester);

      await tester.drag(find.text('Item 3'), const Offset(0, -140));
      await tester.pumpAndSettle();

      expect(_sheetHeight(tester), closeTo(_screen.height * 0.75, 0.5));
    });

    testWidgets('selecting an item still writes its label and closes', (
      tester,
    ) async {
      await _pump(tester, items: _items(40), sheetSize: fixed);
      await _open(tester);

      await tester.tap(find.text('Item 3'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.controller!.text, 'Item 3');
    });
  });
}
