import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _online = true;
  bool get online => _online;
  set online(bool online) {
    _online = online;
    notifyListeners();
  }

  String route = 'app';

  ConnectionProvider(){
    Connectivity().checkConnectivity().then((value) {
      /// Detecta primera conexion de la app
      online = value != ConnectivityResult.none;

      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        online = result != ConnectivityResult.none;
      });
    });
  }
}