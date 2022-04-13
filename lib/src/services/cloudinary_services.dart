import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryServices {
  CloudinaryServices._internal();

  static final CloudinaryServices _instance = CloudinaryServices._internal();

  factory CloudinaryServices() => _instance;

  final Cloudinary _cloudinary = Cloudinary(
    dotenv.env['CLOUDINARY_API_KEY']!, 
    dotenv.env['CLOUDINARY_API_SECRET']!, 
    dotenv.env['CLOUDINARY_CLOUD_NAME']!
  );

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<String?> uploadImage(String? filePath, String? fileName) async {
    final res = await _cloudinary.uploadFile(
      filePath: filePath,
      resourceType: CloudinaryResourceType.image,
      folder: 'flutter-apps/products-app/$_uid',  
      fileName: fileName,
    );

    return res.secureUrl;
  }
}