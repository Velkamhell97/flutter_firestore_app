import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/services.dart';

class GoogleButton extends StatelessWidget {
  final String text;

  const GoogleButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(FontAwesomeIcons.google, color: Colors.red),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
        primary: Colors.white,
        onPrimary: Colors.black87
      ),
      onPressed: () async {
        final error = await context.read<AuthServices>().signInGoogle();
        
        if(error != null){
          return NotificationServices.showSnackBar(error);
        }

        Navigator.of(context).pushReplacementNamed('home');
      }, 
      label: Text(text),
    );
  }
}