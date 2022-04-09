import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class PushNotificationsService {
  PushNotificationsService._internal();

  static final PushNotificationsService _instance = PushNotificationsService._internal();

  factory PushNotificationsService() => _instance;

  final _pushNotifications = FlutterLocalNotificationsPlugin();

  /// Es necesario utilizar el stream de rxdart ya que este almacena en cache el ultimo valor
  /// Escuchado lo cual lo hace ideal para cuando la notificacion llega con el app cerrada
  final _notificationStreamController = BehaviorSubject<Map<String, dynamic>?>();
  Stream<Map<String, dynamic>?> get notificationStream => _notificationStreamController.stream;

  void onSelectedNotification(String? payload) => _notificationStreamController.add(json.decode(payload!));

  /// Crea un canal de notificaciones en android con unas caracteristicas
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', 
    'High Importance Notifications', 
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('lets_duel')
  );

  Future<void> init() async {
    const android = AndroidInitializationSettings('triforce');
    // final ios = IOSInitializationSettings(...);

    const settings = InitializationSettings(android: android);

    //-Para android
    await  _pushNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);

    await _pushNotifications.initialize(settings, onSelectNotification: onSelectedNotification);
  }

  void dispose() {
    _notificationStreamController.close();
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<void> showNotification(RemoteMessage? message) async {
    if(message == null) return;

    /// Se debe definir si las notificaciones recibidas en la app seran de tipo [NotificationMessage]
    /// o [DataMessage] aqui se evaluan ambas, pero tener en cuenta que si se utilizan las primeras
    /// se mostrara doble notificacion entonces para sacar el potencial del [LocalNotifications] lo
    /// mas recomendable es usar [DataMessages]
    final data = message.data;
    final notification = message.notification;

    /// Si tiene imagenes, podemos detereminar si van a un costado o son expandibles
    StyleInformation? styleInformation;
    ByteArrayAndroidBitmap? image;

    /// Convierte los link de la url a un icono de la notificacion, tambien se pueden mostrar imagenes locales
    if(data['urlImage'] != null){
      image = ByteArrayAndroidBitmap(await _getByteArrayFromUrl(data['urlImage']));

      styleInformation = BigPictureStyleInformation(
        image,
        largeIcon: image,
        hideExpandedLargeIcon: true
      );
    }

    _pushNotifications.show(
      data.hashCode, /// Podria id un ID unico
      notification?.title ?? data['title'] ?? 'No Title', 
      notification?.body ?? data['body'] ?? 'No Body',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          // icon: 'yugioh',
          channelDescription: _channel.description,
          color: Colors.brown,
          largeIcon: image,
          styleInformation: styleInformation
        )
      ),
      payload: json.encode(data['payload'] ?? data)
    );
  }
}