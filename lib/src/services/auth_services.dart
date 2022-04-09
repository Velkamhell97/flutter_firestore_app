import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class AuthServices {
  /// Procurar siempre utilizar getters cuando se trabaje con firebase para tener la instancia actual
  FirebaseAuth get _auth => FirebaseAuth.instance;
  static const _storage = FlutterSecureStorage();

  Future<String?> signin(Map<String, dynamic> data) async{
    try {
      final userData = await _auth.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password']
      );

      /// Podemos almacenar el JWT o el uid del usuario que tambien es unico, como no necesitamos el JWT
      /// Para las peticiones posteriores porque estas validaciones las hace el paquete de firebase y
      /// Las reglas en el firestore, no hay diferencia mayor a que el JWT es mas largo
      // final firebaseToken = userData.user!.getIdToken();

      await _storage.write(key: 'firebaseToken', value: userData.user!.uid);
      
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      print(e);
      return 'error: ${e.toString()}';
    }
  }

  Future<String?> signup(Map<String, dynamic> data) async{
    try {
      final userData = await _auth.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password']
      );

      final uid = userData.user!.uid;

      // final firebaseToken = userData.user!.getIdToken();

      await _storage.write(key: 'firebaseToken', value: uid);

      /// [Token] unico para la recepcion de mensajes FCM
      /// 
      /// Generalmente los mensajes se envian a todos los usuarios de la app o a diferentes [subjects]
      /// pero si se desea enviar un mensaje especificamente a un dispositivo o grupo de disposivitos
      /// se puede almacenar este token en la db o en firestore y posteriormente usarse
      final fcmToken = await FirebaseMessaging.instance.getToken();

      /// [Ejemplo] de como suscribirse y desuscribirse a [subjects] con FCM;
      /// 
      // await FirebaseMessaging.instance.subscribeToTopic('weather');
      // await FirebaseMessaging.instance.unsubscribeFromTopic('weather');

      await usersRef.doc(uid).set(User(uid: uid, email: data['email'], google: false, fcmToken: fcmToken!));

      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      print(e);
      return 'error: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await _storage.delete(key: 'firebaseToken');
  }

  Future<bool> isLoged() async {
    final hasKey = await _storage.read(key: 'firebaseToken');
    return hasKey != null && _auth.currentUser != null;
  }

  /// Funcion para hacer un signin con google
  /// 
  /// Si el usuario ya tiene una cuenta con el correo que no ha iniciado sesion con google se le
  /// lanza la advertencia, luego si es la primera vez que ingresa con google se graba en firebase
  Future<String?> signInGoogle() async {
    try {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();

      if(googleUser == null) return 'Seleccion cancelada';

      final refGoogle = await usersRef.whereEmail(isEqualTo: googleUser.email).whereGoogle(isEqualTo: false).get();
      
      if(refGoogle.docs.isNotEmpty) {
        GoogleSignIn().signOut();
        return 'Ya tienes un usuario registrado con este correo';
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      final userData = await FirebaseAuth.instance.signInWithCredential(credential);
      
      final uid = userData.user!.uid;

      // final firebaseToken = userData.user!.getIdToken();

      await _storage.write(key: 'firebaseToken', value: uid);

      final refUsers = await usersRef.whereEmail(isEqualTo: googleUser.email).get();

      if(refUsers.docs.isEmpty){
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await usersRef.doc(uid).set(User(uid: uid, email: googleUser.email, google: true, fcmToken: fcmToken!));
      }

      return null;
    } on PlatformException catch (e){
      GoogleSignIn().signOut();
      return e.code;
    } catch (e) {
      print('error: ${e.toString()}');
      GoogleSignIn().signOut();
      return e.toString();
    }
  }
}