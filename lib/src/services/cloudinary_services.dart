import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudinaryServices {
  CloudinaryServices._internal();

  static final CloudinaryServices _instance = CloudinaryServices._internal();

  factory CloudinaryServices() => _instance;

  final Cloudinary _cloudinary = Cloudinary('939227237552849', 'ErEEDpd7aPkDhNzJkg-2de9v0PY', 'dwzr9lray');

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