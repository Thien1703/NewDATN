import 'package:flutter/material.dart';

class WidgetLineBold extends StatelessWidget {
  const WidgetLineBold({
    super.key,
    this.line,
  });
  final int? line;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(25, (index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          width: 7,
          height: 1.5,
          color: const Color.fromARGB(255, 189, 189, 189),
        );
      }),
    );
  }
}
