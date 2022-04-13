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
    return Consumer<AuthFormProvider>(
      builder: (_, form, __) {
        return Form(
          key: form.formKey,
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
                onChanged: (value) => form.data['email'] = value,
                validator: (value) => isValidEmail(value)
              ),
        
              const SizedBox(height: 20),
        
              ///-----------------------
              /// Password TextField
              ///-----------------------
              TextFormField(
                obscureText: form.obscureText,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => form.obscureText = !form.obscureText,
                    splashRadius: 25,
                    icon: Icon(form.obscureText ? Icons.visibility : Icons.visibility_off),
                  )
                ),
                onChanged: (value) => form.data['password'] = value,
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
                    onPressed: (form.isLoading || !online) ? null : () async {
                      FocusScope.of(context).unfocus();
                    
                      if(!form.validate()) return;
                
                      form.isLoading = true;
                
                      final String? error = await context.read<AuthServices>().signup(form.data);
                
                      if(error == null){
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        NotificationServices.showSnackBar(error);
                      }
      
                      form.isLoading = false;
                    } , 
                    child: Text(form.isLoading ? 'Cargando...' : !online ? 'No conectado' : 'Registrase')
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}