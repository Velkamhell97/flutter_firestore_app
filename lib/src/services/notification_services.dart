import 'package:flutter/material.dart';
import 'dart:async';

class NotificationServices {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static final navigatorKey = GlobalKey<NavigatorState>();

  static showSnackBar(String message) {
    messengerKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  }

  static showBanner(String message) {
    messengerKey.currentState!.showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.deepPurple,
        content: Text(message, style: const TextStyle(color: Colors.white),), 
        actions: [
          TextButton(
            onPressed: () => messengerKey.currentState!.hideCurrentMaterialBanner(),
            child: const Text('Dismiss', style: TextStyle(color: Colors.white))
          )
        ]
      )
    );

    Timer(const Duration(seconds: 3), () {
      messengerKey.currentState!.hideCurrentMaterialBanner();
    });
  }
}