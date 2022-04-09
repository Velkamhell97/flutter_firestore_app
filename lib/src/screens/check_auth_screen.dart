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

    /// Segunda solucion para la checkScreen, se espera que pase el primer redibujado para decidir
    /// a que pantalla se navega, ambas soluciones tienen el mismo resultado
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

      /// Primera solucion para la checkScreen, se utiliza el futureBuilder para evaluar si esta logeado
      /// Y con el Future.microtask se espera que se dibuje el widget para decidir a donde navegar
      // body: FutureBuilder<bool>(
      //   future: context.read<AuthServices>().isLoged(),
      //   builder: (_, AsyncSnapshot<bool> snapshot) {
      //     if(!snapshot.hasData){
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //
      //     if(!snapshot.data!){
      //       Future.microtask(() => Navigator.pushReplacement(context, zeroPageRoute(const LoginScreen())));
      //     } else {
      //       Future.microtask(() => Navigator.pushReplacement(context, zeroPageRoute(const HomeScreen())));
      //     }
      //
      //     return const SizedBox();
      //   },
      // ),
    );
  }
}