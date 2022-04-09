import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class ProductPicture extends StatelessWidget {
  final String? picture;
  final bool darken;

  const ProductPicture(this.picture, {Key? key, this.darken = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Builder(
        builder: (_) {
          final color = darken ? Colors.black12 : Colors.white;

          if(picture == null){
            return const Image(
              image: AssetImage('assets/no-image.png'),
              fit: BoxFit.cover,
            );
          }
      
          if(picture!.startsWith('http')){
            return CachedNetworkImage(
              placeholder: (_, __) => Image.asset(
                'assets/jar-loading.gif', 
                fit: BoxFit.cover,
              ),
              errorWidget: (_, __, error) => Image.asset('assets/no-image.png'),
              color: color,
              colorBlendMode: BlendMode.darken,
              cacheKey: picture,
              imageUrl: picture!,
              fit: BoxFit.cover,
            );
          }
      
          return Image.file(
            File(picture!),
            color: color,
            colorBlendMode: BlendMode.darken,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}