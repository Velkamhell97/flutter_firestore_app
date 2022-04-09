import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../forms/forms.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const _titleStyle = TextStyle(fontSize: 30);
  static const _footerStyle = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: AuthBackground(
          header: SizedBox(
            height: size.height * 0.30,
            child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
          ),

          form: FractionallySizedBox(
            widthFactor: 0.9,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: Column(
                  children: [
                    const Text('Register', style: _titleStyle),
                    const SizedBox(height: 10.0),
                    ChangeNotifierProvider(
                      create: (_) => AuthFormProvider(),
                      child: const RegisterForm(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          preFooter: TextButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed('login'), 
            child: const Text('Ya tengo una cuenta', style: _footerStyle)
          ),

          footer: SizedBox(height: size.height * 0.05),
        )
      ),
    );
  }
}