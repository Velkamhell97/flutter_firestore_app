import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../services/services.dart';
import '../helpers/helpers.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  static const _buttonPadding = EdgeInsets.symmetric(horizontal: 40, vertical: 15);

  @override
  Widget build(BuildContext context) {
    final loginForm = context.watch<AuthFormProvider>();

    return Form(
      key: loginForm.formKey,
      child: Column(
        children: [
          ///-----------------------
          /// Email TextField
          ///-----------------------
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              prefixIcon: Icon(Icons.alternate_email_sharp),
            ),
            onChanged: (value) => loginForm.data['email'] = value,
            validator: (value) => isValidEmail(value)
          ),
    
          const SizedBox(height: 20),
    
          ///-----------------------
          /// Password TextField
          ///-----------------------
          TextFormField(
            obscureText: loginForm.obscureText,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => loginForm.obscureText = !loginForm.obscureText,
                splashRadius: 25,
                icon: Icon(loginForm.obscureText ? Icons.visibility : Icons.visibility_off),
              )
            ),
            onChanged: (value) => loginForm.data['password'] = value,
            validator: (value) => isValidPassword(value),
            
          ),
    
          const SizedBox(height: 35),

          ///-----------------------
          /// Submit Button
          ///-----------------------
          Selector<ConnectionProvider, bool>(
            selector: (_, model) => model.online,
            builder: (_, online, __) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(padding: _buttonPadding),
                onPressed: (loginForm.isLoading || !online) ? null : () async {
                  FocusScope.of(context).unfocus();
                
                  if(!loginForm.validate()) return;
            
                  final authServices = context.read<AuthServices>();
                
                  loginForm.isLoading = true;
            
                  final String? error = await authServices.signin(loginForm.data);
            
                  if(error == null){
                    Navigator.pushReplacementNamed(context, 'home');
                  } else {
                    NotificationServices.showSnackBar(error);
                  }

                  loginForm.isLoading = false;
                } , 
                child: Text(loginForm.isLoading ? 'Cargando...' : !online ? 'No conectado' : 'Ingresar')
              );
            },
          )
        ],
      ),
    );
  }
}