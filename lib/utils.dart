import 'package:flutter/material.dart';

void toastMessage(
    BuildContext context, String state, String title, String message) {
  final snackBar = SnackBar(
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Divider(height: 1),
        Text(message, style: const TextStyle(fontSize: 14))
      ],
    ),
    elevation: 1,
    duration: const Duration(seconds: 3),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    backgroundColor: state == "success"
        ? Colors.lightGreen
        : state == "warning"
            ? Colors.deepOrangeAccent
            : Colors.blueAccent,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
