# Changelog

All notable changes to `custom_dropdown_pro` will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
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
