import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/ui/input_decorations.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';


Widget buildTextField({
  String? initialValue,
  required String label,
  required String hintText,
  required FormFieldValidator<String> validator,
  required ValueChanged<String> onChanged,
  bool obscureText = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: textStyleVilaTourTitle(color: Colors.black)),
      TextFormField(
        initialValue: initialValue,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecorations.authInputDecoration(hintText: hintText),
      ),
    ],
  );
}

// Funciones validadoras reutilizables
String? validateRequiredField(String? value) {
  if (value == null || value.isEmpty) {
    return 'El nombre de usuario es obligatorio';
  }
  if (value.length > 250) {
    return 'El nombre es demasiado largo';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El email es obligatorio';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Ingrese un email válido';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value.length > 250) {
    return 'La contraseña es demasiado larga';
  }
  final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
  if (!regex.hasMatch(value)) {
    return 'Debe contener al menos un número';
  }
  return null;
}

String? validateRepeatedPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Debe repetir la contraseña';
  }
  if (value != password) {
    return 'Las contraseñas no coinciden';
  }
  return null;
}