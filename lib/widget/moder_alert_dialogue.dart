import 'package:flutter/material.dart';

class ModernAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const ModernAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isWideScreen ? 22 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(fontSize: isWideScreen ? 18 : 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            textStyle: TextStyle(
              fontSize: isWideScreen ? 16 : 14,
              color: Colors.grey[700],
            ),
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            textStyle: TextStyle(fontSize: isWideScreen ? 16 : 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
