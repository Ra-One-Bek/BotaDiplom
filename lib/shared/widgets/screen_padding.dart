import 'package:flutter/material.dart';

class ScreenPadding extends StatelessWidget {
  const ScreenPadding({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: child,
    );
  }
}