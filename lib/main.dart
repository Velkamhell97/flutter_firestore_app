import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'src/providers/providers.dart';
import 'src/services/services.dart';
import 'src/screens/screens.dart';
import 'src/models/models.dart';
import 'src/widgets/widgets.dart';

/// [Listener] de las notificaciones cuando la app esta en [background] o [terminada]  
/// 
/// Para reaccionar al tapde las notificaciones se usa el [onMessageOpenedApp] y el [getInitialMessage]
/// respectivamente, si se recibe un [NotificationMessages] (titulo y cuerpo) se muestra la notificacion
/// por defecto de firebase si se recibe un [DataMessage] (solo data) no se muestra notificacion
/// y puede utilizarse las [LocalNotifications]
Future<void> onBackgroundTerminated(RemoteMessage message) async {
  await PushNotificationsService().showNotification(message);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await PushNotificationsService().init();

  /// [Listener] de los mensajes en [background] y [terminada]
  /// 
  /// Debe definirse fuera de cualquier clase (main) y su argumento debe ser una [TopLevelFunction]
  FirebaseMessaging.onBackgroundMessage(onBackgroundTerminated);

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        Provider(create: (_) => ProductServices()), 
        Provider(create: (_) => AuthServices()), 
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pushNotifications = PushNotificationsService();

  Future<void> _onNotificationTap(Map<String, dynamic>? payload) async{
    if(payload == null) return;

    final productId = payload['id'];

    if(productId == null) return;

    final user = FirebaseAuth.instance.currentUser;

    /// Si no ha iniciado sesion no navega
    if(user == null) return ;

    final query = await usersRef.doc(user.uid).products.whereId(isEqualTo: productId).get();

    final product = query.docs.single;

    /// Tambien se puede enviar por argumentos el payload y crear la vista en un screen especifica
    /// para recibir las notificaciones
    NotificationServices.navigatorKey.currentState!.pushNamed('product', arguments: product.data);
  }

  @override
  void initState() {
    super.initState();

    /// [Callback] de los mensaje FCM con la app [terminada]
    FirebaseMessaging.instance.getInitialMessage().then(pushNotifications.showNotification);

    /// [Listener] de los mensajes en [foreground]
    /// 
    /// Estos no tienen notificacion con FCM por lo que se utiliza [las LocalNotifications]
    FirebaseMessaging.onMessage.listen(pushNotifications.showNotification);

    /// [Callback] de los mensajes FCM con la app [activeBackground]
    /// 
    /// Si la notificacion se mostro con FCM esta funcion manejara el evento, si se mostro con
    /// [LocalNotifications] el evento la manejara su funcion OnTap
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {});

    /// [Callback] de los mensjaes locales con la app [terminada]
    /// 
    /// Es similar a el [getInitial] de FCM, pero aqui no utilizamos la funcion de [showNotifications]
    /// porque no recibimos un [RemoteMessage] sino otro tipo de dato, por esta razon ejecutamos
    /// directamente el [callback] que se le pasa el stream de las [LocalNotifications]
    FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails().then((details) {
      if(details != null && details.didNotificationLaunchApp && details.payload != null){
        _onNotificationTap(json.decode(details.payload!));
      }
    });

    /// [Stream] que escucha los tap de las [LocalNotifications] con la app en [foreground] o [background]
    /// 
    /// Siempre que se da tap a una notificacion local se agrega la data de la notificacion a este
    /// stream y con esa data es que ejecutamos el [callback], tener en cuenta que lo que recibe este
    /// [callback] ya no es un [RemoteMessage] sino un mapa con el [payload] de la notificacion
    pushNotifications.notificationStream.listen(_onNotificationTap);
  }

  @override
  void dispose() {
    pushNotifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationServices.messengerKey,
      navigatorKey: NotificationServices.navigatorKey,
      title: 'Form Validation App',
      initialRoute: 'check',
      home: const CheckAuthScreen(),
      /// Forma de mantener la ruta activa en un variable
      /// 
      /// Para este caso que solo se evaluan las rutas autenticadas o no esta forma no es muy practica
      /// ya que se puede hacer lo mismo preguntando si el usuario esta logeado o no
      onGenerateRoute: (settings) {
        final connectionProvider = Provider.of<ConnectionProvider>(context, listen: false);

        if(settings.name == 'home' || settings.name == 'product'){
          connectionProvider.route = 'app';
        } else if(settings.name == 'login' || settings.name == 'register') {
          connectionProvider.route = 'auth';
        }

        Widget route;

        switch(settings.name){
          case "check":
            route = const CheckAuthScreen();
            break;
          case "home":
            route = const HomeScreen();
            break;
          case "product":
            route = const ProductScreen();
            break;
          case "login":
            route = const LoginScreen();
            break;
          case "register":
            route = const RegisterScreen();
            break;
          default: 
            route = const CheckAuthScreen();
            break;
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (context) => route,
        );
      },
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            const OverlayWidget(),
          ],
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurple,
          onSecondary: Colors.white,
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.deepPurple)
      ),
    );
  }
}