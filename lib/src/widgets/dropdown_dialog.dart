// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';



class DropdownDialog<T>
    extends StatelessWidget {
  final Widget child;

  const DropdownDialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 500,
        child: child,
      ),
    );
  }
}