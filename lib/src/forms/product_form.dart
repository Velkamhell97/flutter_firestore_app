import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class ProductForm extends StatelessWidget {
  const ProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductFormProvider>(
      builder: (_, form, __) {
        return Form(
          key: form.formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
            child: Column(
              children: [
                ///--------------------------
                /// Product Name TextField
                ///--------------------------
                TextFormField(
                  initialValue: form.product.name,
                  decoration: const InputDecoration(labelText: 'Nombre:'),
                  //-se va actualizando directamente los valores
                  onChanged: (value) => form.product.name = value,
                  validator: (value) => value == null || value.length < 2 ? 'El nombre es obligatorio' : null,
                ),
      
                const  SizedBox(height: 15),
      
                ///--------------------------
                /// Product Price TextField
                ///--------------------------
                TextFormField(
                  initialValue: '${form.product.price}',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                  decoration: const InputDecoration(labelText: 'Precio:'),
                  onChanged: (value) {
                    if(double.tryParse(value) == null) return;
                    form.product.price = double.parse(value);
                  },
                  validator: (value) => value == null || value.isEmpty ? 'El precio es obligatorio' : null,
                ),
      
                const SizedBox(height: 15),
                
                ///--------------------------
                /// Product Available Switch
                ///--------------------------
                SwitchListTile.adaptive(
                  onChanged: (value) => form.toggleAvailability(value),
                  value: form.product.available,
                  title: const Text('Disponible', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}