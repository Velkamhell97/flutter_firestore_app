import 'package:flutter/material.dart';

class AuthFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> data = {
    'email': '',
    'password': ''
  };

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  set obscureText(bool showPassword) {
    _obscureText = showPassword;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool validate() => formKey.currentState?.validate() ?? false;
}
