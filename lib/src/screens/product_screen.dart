import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../services/services.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../forms/forms.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product;

    return ChangeNotifierProvider(
      create:  (_) => ProductFormProvider(product),
      child: const _ProductBody(),
    );  
  }
}

class _ProductBody extends StatelessWidget {
  const _ProductBody({Key? key}) : super(key: key);

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(45), 
      bottom: Radius.circular(20)
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(0.0, 5.0),
        blurRadius: 10,
      )
    ]
  );

  // static const _duration = Duration(milliseconds: 200);

  /// Recordar que el [productFormProvider] solo se redibuja al cambiar el switch o la imagen o al
  /// estar grabando, de resto al escribir en los [TextField] no se redibuja
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: _cardDecoration,
              child: Column(
                children: [
                  ///----------------------------
                  /// Product Image And Actions
                  ///----------------------------
                  SizedBox(
                    height: size.height * 0.45,
                    child: Stack(
                      children: [
                        /// Se debe utilizar un consumer ya que el [Product] del formulario solo muta
                        /// pero no cambia su estado por lo que un selector no detectaria el cambio
                        Consumer<ProductFormProvider>(
                          builder: (_, form, __) {
                            return ProductPicture(form.product.picture, darken: true);
                          },
                        ),
                        
                        const Positioned(
                          top: 30,
                          left: 0,
                          right: 20,
                          child: _ProductActions()
                        ),
                      ],
                    ),
                  ),

                  ///----------------------------
                  /// Product Form
                  ///----------------------------
                  const ProductForm(),
                ],
              )
            ),
          ),
        ),
    
        floatingActionButton: Selector<ProductFormProvider, bool>(
          selector: (_, model) => model.isSaving,
          builder: (_, saving, __) {
            return FloatingActionButton(
              onPressed: saving ? null : () async{
                FocusScope.of(context).unfocus();

                final form = context.read<ProductFormProvider>();
              
                if(!form.validate()) return;
          
                final productServices = context.read<ProductServices>();
                final connection = context.read<ConnectionProvider>();
          
                form.isSaving = true;
              
                final error = await productServices.saveProduct(form.product, connection.online);
              
                if(error != null) {
                  NotificationServices.showSnackBar(error);
                } else {
                  // NotificationServices.showBanner('Product added!');
                  Navigator.of(context).pop();
                  // Future.delayed(_duration, () => Navigator.of(context).pop());
                }

                form.isSaving = false;
              },
              child: saving ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.save_outlined),
            );
          }
        ),
      ),
    );
  }
}

class _ProductActions extends StatelessWidget {
  const _ProductActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProductFormProvider, bool>(
      selector: (_, model) => model.isSaving,
      builder: (_, saving, __) {
        final color = saving ? Colors.black26 : Colors.white;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: saving ? null : () => Navigator.of(context).pop(), 
              icon: Icon(Icons.arrow_back_ios_new, color: color, size:40)
            ),

            IconButton(
              onPressed: saving ? null :() async {
                final picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
      
                if(pickedFile == null) {
                  return NotificationServices.showSnackBar('SELECCION CANCELADA');
                }
            
                context.read<ProductFormProvider>().setPicture(pickedFile.path);
              }, 
              icon: Icon(Icons.camera_alt_outlined, color: color, size: 40) 
            )
          ],
        );
      },
    );
  }
}