import 'package:flutter/material.dart';

class VoxElevatedCard extends StatelessWidget {
  final Widget child;

  const VoxElevatedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
