import 'package:flutter/material.dart';

class VoxSnackBar extends StatelessWidget {
  final String text;

  const VoxSnackBar({super.key, required this.text});

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(milliseconds: 3000),
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      duration: const Duration(milliseconds: 5000),
      content: Text(text),
    );
  }
}
