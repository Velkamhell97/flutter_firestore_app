import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';
import '../services/services.dart';

class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  PageRouteBuilder zeroPageRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      /// la duracion debe ser de 0 para que no se perciba el cambio de pantalla
      transitionDuration: const Duration(milliseconds: 0)
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final isAuth = await Provider.of<AuthServices>(context, listen: false).isLoged();
    
      if(!isAuth) {
        Navigator.pushReplacement(context, zeroPageRoute(const LoginScreen()));
      } else {
        Navigator.pushReplacement(context, zeroPageRoute(const HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}