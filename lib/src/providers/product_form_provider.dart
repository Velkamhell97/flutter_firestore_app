import 'package:flutter/material.dart';

import '../models/user.dart';

class ProductFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  bool _isSaving = false;
  bool get isSaving => _isSaving;
  set isSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void setPicture(String path) {
    if (product.picture != null && product.picture!.contains('http')) {
      product.lastPicture = product.picture;
    }
    
    product.picture = path;
    notifyListeners();
  }

  toggleAvailability(bool value){
    product.available = value;
    notifyListeners();
  }

  bool validate() => formKey.currentState?.validate() ?? false;
}