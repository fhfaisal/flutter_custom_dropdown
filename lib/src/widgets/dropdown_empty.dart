// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';


class DropdownEmpty extends StatelessWidget {
  final String message;

  const DropdownEmpty({
    super.key,
    this.message = 'No data found',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}