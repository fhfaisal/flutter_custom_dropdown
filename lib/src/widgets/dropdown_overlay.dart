import 'package:flutter/material.dart';

class DropdownOverlay {
  OverlayEntry? _overlayEntry;

  void show({
    required BuildContext context,
    required LayerLink layerLink,
    required Widget child,
  }) {
    hide();

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Positioned(
          width: 320,
          child: CompositedTransformFollower(
            link: layerLink,
            offset: const Offset(
              0,
              52,
            ),
            showWhenUnlinked: false,
            child: Material(
              elevation: 8,
              borderRadius:
              BorderRadius.circular(16),
              child: child,
            ),
          ),
        );
      },
    );

    Overlay.of(
      context,
    ).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  bool get isShowing =>
      _overlayEntry != null;
}