import 'package:flipkart_clone/main.dart';
import 'package:flutter/material.dart';
// import to get navigatorKey (adjust import path if needed)

void showCustomToast(String message) {
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) return;

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 80,
      left: 70,
      right: 70,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 1), () {
    try {
      overlayEntry.remove();
    } catch (_) {
      // ignore if already removed
    }
  });
}
