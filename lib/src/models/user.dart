import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String fcmToken;
  final String email;
  final bool google;

  User({
    required this.uid,
    required this.fcmToken,
    required this.email,
    required this.google
  });
}

/// Lo ideal serian que estas clases fueran constantes y se actualizara con el copyWith
@JsonSerializable()
class Product {
  String? id;
  bool available;
  String name;
  String? picture;
  double price;
  /// Almacena la ultima imagen cargada (http) cuando se va a actualizar por una nueva 
  /// 
  /// Se crea despues del build runner para mantenerla visible solo en nuestra app (no para firebase)
  /// Se define esta variable en el modelo, para tenerla disponible al momento de resubir productos
  /// luego de una reconexion a internet
  String? lastPicture;

  Product({
    this.id,
    this.available = true,
    this.name = '',
    this.picture,
    this.price = 0.0,
    this.lastPicture
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  /// Da un error si se ejecuta el build runner con esto, sin embargo no se necesita
  // Map<String, dynamic> toJson(Product product) => _$ProductToJson(product);

  /// El copyWith se debe implementar manualmente
  Product copyWith({int? id, bool? available, String? name, String? picture, double? price}) {
    return Product(
      id: this.id,
      available: this.available,
      name: this.name,
      picture: this.picture,
      price: this.price
    );
  }

  @override
  String toString() {
    return 'Product: {id:$id, available:$available, name:$name, picture:$picture, price:$price}';
  }
}

/// Definicion de las collecciones y subcolecciones del ODM
/// 
/// Se crea la referencia a los usuarios y tambien sus productos, el * es que hay un documento antes
/// ya que cada usuario tiene un documento que es su id y este contiene la colleccion de productos
@Collection<User>('user-products')
@Collection<Product>('user-products/*/products', name: 'products')
final usersRef = UserCollectionReference();