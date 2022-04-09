import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';
import '../services/services.dart';

/// Utilizamos [getters] para que siempre que se llamen se traiga el valor actualizado en este caso
/// del usuario logeado en el momento y de su coleccion correspondiente. No olvidar establecer
/// las reglas en firebase para que los usuarios no autenticados no puedan hacer operaciones en 
/// firestore
class ProductServices {
  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  
  ProductCollectionReference get _productsRef => usersRef.doc(_uid).products;

  final _cloudinary = CloudinaryServices();

  /// Para agregar timeouts a las peticiones
  // final Duration _timeoutDuration = Duration(seconds: 5);
  // FutureOr<DocumentReference<Product>> _timeoutError() => throw TimeoutException('Se agoto el tiempo de espera, verifica tu conexion');

  Future<String?> saveProduct(Product product, bool isConnected) async {
    try { 
      /// Validacion Unique en el campo number
      /// 
      /// Verifica que no haya otro producto con ese nombre al parecer tambien funciona offline
      final ref = await _productsRef.whereName(isEqualTo: product.name).get();
      
      final dbProduct = ref.docs.isEmpty ? null : ref.docs.single;

      /// Solo cuando hay un producto con ese nombre y es diferente al mencionado producto
      /// Se muestra la excepcion
      if((dbProduct != null && dbProduct.id != product.id)){
        throw FirebaseException(
          plugin: 'firestore/unique-restriction',
          message: 'There is already a product with the name: \'${product.name}\' in the database.'
        );
      }

      if(isConnected){
        await _createOrUpdateProduct(product);
      } else {
        await _createOrUpdateProductOffline(product);
      }

      return null;
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  /// Funcion para crear o actualizar un producto
  /// 
  /// Cuando se trabaja con el ODM este crea sus propios converters, por lo que al traer los datos
  /// de firebase estos no traen el id, necesario para actualizar un producto, por esta razon se
  /// deben hacer dos operaciones una de [add] y otro de [update]. Aunque el converter puede modificarse
  /// en el archivo generado por el build runner, se deja asi para mostrar las transactions
  Future<void> _createOrUpdateProduct(Product product) async {
    /// Como esto es un servicio aparte no podemos evitar que se suba si la transaccion sale mal
    /// Lo unico que se podria hacer es que en el cath del try se borre
    product.picture = await _uploadImage(product.picture, product.lastPicture);
  
    if (product.id == null) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final newProduct = await _productsRef.add(product);
        transaction.update(newProduct.reference, {'id': newProduct.id});
      });

    } else {
      /// Como no se sabe que campo se actualizara se pasa todo
      await _productsRef.doc(product.id).update( 
        picture: product.picture, 
        name: product.name, 
        price: product.price, 
        available: product.available
      );
    }
  }

  /// Persistencia Offline Firebase
  /// 
  /// -* No se pueden hacer con transacciones
  /// -* Se usa el then, la respuesta de este es el proceso que se ejecutara una vez vuelva la conexion
  /// -* Como no se genera un id se debe crear uno (como hive) aqui utilizamos uuid  
  /// -* Una vez vuelva La conexion se crea el producto con este id (con el set) y se sube la imagen
  Future<void> _createOrUpdateProductOffline(Product product) async {
    /// Si es nuevo hacemos el set con el id y al reconectarse subimos la imagen y actualizamos el url
    if (product.id == null) {
      product.id = const Uuid().v4();

      _productsRef.doc(product.id).set(product).then((_) {
        _uploadImage(product.picture, null).then((imageUrl) {
          if(imageUrl != null){
            _productsRef.doc(product.id).update(picture: imageUrl);
          }
        });
      });
    } else { /// Si se actualiza se espera que se reconecte para subir la imagen
      _productsRef.doc(product.id).update(
        picture: product.picture, 
        name: product.name, 
        price: product.price, 
        available: product.available
      ).then((_) {
        _uploadImage(product.picture, product.lastPicture).then((imageUrl) {
          if(imageUrl != null){
            _productsRef.doc(product.id).update(picture: imageUrl);
          }
        });
      });
    }
  }

  /// Para eliminar producto basta con pasar el id de ese producto
  Future<String?> deleteProduct(Product product) async {
    try {
      await _productsRef.doc(product.id).delete();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _uploadImage(String? image, String? lastImage) async {
    if(image == null) return null;

    if(image.contains('http')) return null;

    final fileName = lastImage?.split('/').last.split('.').first;

    final imageUrl = await _cloudinary.uploadImage(image, fileName);

    return imageUrl;
  }
}
