String? isValidEmail(value){
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
 
  RegExp regExp = RegExp(pattern);

  return regExp.hasMatch(value ?? '') ? null : 'Ingresa un correo valido';
}

String? isValidPassword(value){
  if(value != null && value.length >= 6 ) return null;

  return 'La contraseña debe tener al menos 6 caracteres';
}
