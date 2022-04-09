import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../services/services.dart';
import '../helpers/helpers.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  static const _buttonPadding = EdgeInsets.symmetric(horizontal: 40, vertical: 15);

  @override
  Widget build(BuildContext context) {
    final registerForm = context.watch<AuthFormProvider>();

    return Form(
      key: registerForm.formKey,
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
            onChanged: (value) => registerForm.data['email'] = value,
            validator: (value) => isValidEmail(value)
          ),
    
          const SizedBox(height: 20),
    
          ///-----------------------
          /// Password TextField
          ///-----------------------
          TextFormField(
            obscureText: registerForm.obscureText,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => registerForm.obscureText = !registerForm.obscureText,
                splashRadius: 25,
                icon: Icon(registerForm.obscureText ? Icons.visibility : Icons.visibility_off),
              )
            ),
            onChanged: (value) => registerForm.data['password'] = value,
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
                onPressed: (registerForm.isLoading || !online) ? null : () async {
                  FocusScope.of(context).unfocus();
                
                  if(!registerForm.validate()) return;
            
                  final authServices = context.read<AuthServices>();
                
                  registerForm.isLoading = true;
            
                  final String? error = await authServices.signup(registerForm.data);
            
                  if(error == null){
                    Navigator.pushReplacementNamed(context, 'home');
                  } else {
                    NotificationServices.showSnackBar(error);
                  }

                  registerForm.isLoading = false;
                } , 
                child: Text(registerForm.isLoading ? 'Cargando...' : !online ? 'No conectado' : 'Registrase')
              );
            },
          )
        ],
      ),
    );
  }
}