import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';

import '../models/user.dart';
import '../widgets/widgets.dart';
import '../services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  /// Procurar siempre utilizar getters cuando se trabaje con firebase para tener la instancia actual
  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  
  static const _itemGap = 20.0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      ///------------------------------
      /// AppBar
      ///------------------------------
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: ()  async {
              context.read<AuthServices>().logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          )
        ],
      ),
      
      ///------------------------------
      /// Stream Products List
      ///------------------------------
      body: FirestoreBuilder<ProductQuerySnapshot>(
        ref: usersRef.doc(_uid).products,
        builder: (context, snapshot, child) {
          if(snapshot.hasError) return _ErrorBuilder(error: snapshot.error.toString());

          if(snapshot.connectionState == ConnectionState.waiting ||snapshot.data == null) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }

          final products = snapshot.data!.docs;

          if(products.isEmpty) return const _EmptyBuilder();

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemExtent: size.height * 0.4 + _itemGap,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index].data;

              return Padding(
                padding: const EdgeInsets.only(bottom: _itemGap),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'product', arguments: product.copyWith()),
                  child: ProductCard(product: product)
                ),
              );
            }
          );
        },
      ),

      //------------------------------
      // FAB
      //------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'product', arguments: Product()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ErrorBuilder extends StatelessWidget {
  final String error;

  const _ErrorBuilder({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.person_off, size: 100, color: Colors.deepPurple),
        const SizedBox(height: 5.0),
        Text(
          'Error: $error', 
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black87),
        )
      ],
    );
  }
}

class _EmptyBuilder extends StatelessWidget {
  const _EmptyBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.inventory_2_outlined, size: 100, color: Colors.deepPurple),
          Text('NO PRODUCTS', style: TextStyle(fontSize: 20, color: Colors.black))
        ],
      ),
    );
  }
}