# Changelog

All notable changes to `custom_dropdown_pro` will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## 0.0.9 — 2026-11-03
- **[FIX] Sheet closing at its initial size** — A scroll-expandable sheet (`sheetSize` with `initialChildSize`) no longer closes when it comes back down from an expanded size to `initialChildSize`. It now stays open there.
- **[FEAT] Custom snap stops** — `DropdownSheetSize.snapSizes` adds stops between `initialChildSize` and `maxChildSize`, e.g. `snapSizes: [0.75]`. `snapAnimationDuration` sets how long the snap animation takes.

## 0.0.8 — 2026-11-03
- **[FEAT] Sheet title** — Added `title` to `SearchableDropdownField` so the default header can show the field's name. It still falls back to `'Select Item'`.
- **[FEAT] Close button** — The default header now shows a close (✕) button at its end. Turn it off with `DropdownBehavior(showCloseButton: false)`.
- **[FEAT] Scroll-expandable bottom sheet** — Added `sheetSize: DropdownSheetSize(initialChildSize: 0.6, maxChildSize: 0.9)`. The sheet opens at a fixed height whatever the item count, grows up to `maxChildSize` when the list is scrolled, and never shrinks below `initialChildSize`. It also stays above the keyboard. The default (`DropdownSheetSize()`) keeps the content-sized sheet.
- **[CHANGE] Header layout** — The default header title is now start-aligned (it was centered).
- **[FIX] Duplicate drag handle** — The bottom sheet no longer gets a second drag handle when the host theme sets `BottomSheetThemeData.showDragHandle: true`.

## 0.0.7 — 2026-06-11
- **[FEAT] Header support** — Added custom `header` widget support and `defaultHeader` toggle to `SearchableDropdownField` for bottom-sheet and dialog modes.
- **[FEAT] Dynamic overlay width** — Adjusted dropdown overlay width to dynamically match the triggering field's width instead of using a hardcoded `320`.
- **[FIX] Bottom-sheet layout** — Improved bottom-sheet height behavior by using `Flexible` and `shrinkWrap: true` to prevent layout issues when headers are custom/varying.

## 0.0.6 — 2026-05-21
- **[FEAT] Documentation & Quality bump** — 100% of exported public API elements now fully documented to satisfy pub.dev publishing guidelines.
- **[FIX] Lint improvements** — Enabled `public_member_api_docs` lint across the package and verified clean analysis.

## 0.0.5 — 2026-05-12
* Fixed repository link in pubspec.

## 0.0.4 — 2026-05-12

### Bug fixes & publish fixes

- **[FIX] Library filename mismatch** — Renamed the primary library entrypoint to match the published package name and updated the `library` declaration accordingly, as required by pub.dev.
- **[FIX] Missing `repository` field** — Added `repository` URL to `pubspec.yaml`.
- **[FIX] Improved package description** — Expanded description to meet pub.dev length guidelines.
- **[BUMP] Version** — Incremented to `0.0.4` to supersede the previously published `0.0.3`.

---

## 0.0.1 — 2026-05-12

### Initial release

**Core widget**
- `SearchableDropdownField<T>` — fully generic searchable dropdown field
- Three display modes: `DropdownMode.bottomSheet`, `DropdownMode.dialog`, `DropdownMode.overlay`
- Built-in search with 300 ms debounce via `Debouncer`
- Async item loading via `asyncItems` callback with automatic loading indicator
- Custom item tile via `itemBuilder` callback
- Form-field support: `validator` and `autovalidateMode`
- Programmatic control via `SearchableDropdownController<T>` (`open`, `close`, `clear`)
- `DropdownBehavior` — configurable UX flags (`enableSearch`, `clearable`, `closeOnSelect`, `autofocusSearch`, `enableAnimations`)
- `DropdownStyle` — full visual theming (background, border radius, item text style, title style, search field decoration, outer field decoration)
- `compareFn` support for equality checking on custom objects

### Bug fixes

- **[FIX] Overlay mode navigates back on item select** — `_selectItem` previously always called `Navigator.pop(context)`. For `DropdownMode.overlay` the content lives in an `OverlayEntry` (not a route), so this incorrectly popped the page. Fixed by introducing an `onClose` callback on `DropdownBottomSheet`; the parent passes `_overlay.hide()` for overlay mode and leaves `null` for bottom-sheet / dialog modes so `Navigator.pop` is used as before.

- **[FIX] Clear button does not deselect item** — Tapping the ✕ clear button cleared the `TextEditingController` text but left the internal `selectedItem` in `DropdownState` intact, so the item remained visually selected when the dropdown was reopened. Fixed in three places:
  1. `DropdownState.copyWith` — introduced `clearSelectedItem` flag to allow explicitly setting `selectedItem` to `null` (the previous `selectedItem ?? this.selectedItem` pattern silently ignored `null`).
  2. `SearchableDropdownController.clearSelection()` — updated to use `copyWith(clearSelectedItem: true)`.
  3. `_SearchableDropdownFieldState._clearSelection()` — now calls `_controller.clearSelection()` in addition to clearing the text field.
