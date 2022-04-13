import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../forms/forms.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _googleNotifier = ValueNotifier(false);

  static const _titleStyle = TextStyle(fontSize: 30);
  static const _footerStyle = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            AuthBackground(
              /// Header
              header: SizedBox(
                height: size.height * 0.30,
                child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
              ),

              /// Form
              form: FractionallySizedBox(
                widthFactor: 0.9,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                    child: Column(
                      children: [
                        const Text('Login', style: _titleStyle),
                        const SizedBox(height: 10.0),
                        ChangeNotifierProvider(
                          create: (_) => AuthFormProvider(),
                          child: const LoginForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Pre-Footer
              preFooter: Column(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('register'), 
                    child: const Text('Crear nueva cuenta', style: _footerStyle)
                  ),
                  GoogleButton(loading: _googleNotifier, text: 'Sign in With Gogle')
                ],
              ),
              
              /// Footer
              footer: SizedBox(height: size.height * 0.05),
            ),

            ///-----------------------
            /// Google Overlay
            ///-----------------------
            /// Se utilizo un ValueNotifier porque el AuthFormProvider solo se declara en el scope del form
            /// por lo tanto aqui no es accesible
            ValueListenableBuilder<bool>(
              valueListenable: _googleNotifier,
              builder: (_, loading, __) {
                if(loading) {
                  return const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black38),
                      child: Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            )
          ],
        )
      ),
    );
  }
}