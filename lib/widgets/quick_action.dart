import 'package:flutter/material.dart';

class QuickAction extends StatelessWidget {
  final String title;

  const QuickAction({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
