// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';


class DropdownLoading extends StatelessWidget {
  const DropdownLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),
    );
  }
}