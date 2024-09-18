import 'package:flutter/material.dart';

class ActionButtonText extends StatelessWidget {
  final String text;
  final String? semantics;

  const ActionButtonText({super.key, required this.text, this.semantics});

  @override
  Widget build(BuildContext context) {
    return Text(
      semanticsLabel: semantics ?? text,
      text.toUpperCase(),
      style: const TextStyle(fontFamily: "OpenSans"),
    );
  }
}
