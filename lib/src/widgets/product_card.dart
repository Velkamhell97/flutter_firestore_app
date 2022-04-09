import 'package:firestore_app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  static const _style1 = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600
  );

  static const _style2 = TextStyle(
    color: Colors.white,
    // fontSize: 14
  );

  static const _boxDecoration =  BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black38,
        blurRadius: 10,
        offset: Offset(0.0, 5.0)
      )
    ]
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _boxDecoration,
      child: Stack(
        children: [
          ///-------------------------
          /// Product Picture
          ///-------------------------
          ProductPicture(product.picture),

          ///-------------------------
          /// Product Not Available
          ///-------------------------
          if(!product.available)
            const Align(
              alignment: Alignment.topLeft,
              child: _RoundedBox(
                radius: BorderRadius.only(bottomRight: Radius.circular(10.0)),
                color: Colors.amber,
                child: Text('No Disponible', style: _style1),
              )
            ),

          ///-------------------------
          /// Product Price
          ///-------------------------
          Align(
            alignment: Alignment.topRight,
            child: _RoundedBox(
              radius: const BorderRadius.only(bottomLeft: Radius.circular(10.0)),
              child: Text(product.price.toString(), style: _style1),
            ),
          ),

          ///-------------------------
          /// Product Detail
          ///-------------------------
          Align(
            alignment: Alignment.bottomLeft,
            child: _RoundedBox(
              radius: const BorderRadius.only(topRight: Radius.circular(10.0)),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(product.name, style: _style1),
                    const SizedBox(height: 3.0),
                    Text(product.id ?? 'no-id', style: _style2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundedBox extends StatelessWidget {
  final BorderRadiusGeometry radius;
  final Color color;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _RoundedBox({
    Key? key,
    required this.radius,
    this.color = Colors.deepPurple,
    this.padding = const EdgeInsets.all(10.0),
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: color,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}