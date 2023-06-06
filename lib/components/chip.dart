import 'package:flutter/material.dart';

class VoxActionChip extends StatelessWidget {
  final Widget child;
  final String text;
  final Icon icon;
  const VoxActionChip({super.key, required this.text, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: icon,
      label: Text(text),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return child;
          },
        );
      },
    );
  }
}
