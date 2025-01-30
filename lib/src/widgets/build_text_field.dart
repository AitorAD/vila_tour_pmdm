import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/ui/input_decorations.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';


Widget buildTextField({
  String? initialValue,
  required String label,
  required String hintText,
  required FormFieldValidator<String> validator,
  required ValueChanged<String> onChanged,
  required bool enabled,
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
        enabled: enabled,
        style: const TextStyle(
          color: Colors.black, // Asegura que el texto siempre sea negro
        ),
      ),
    ],
  );
}

// Funciones validadoras reutilizables
String? validateRequiredField(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context).translate('passwordNotMatch');
  }
  if (value.length > 40) {
    return AppLocalizations.of(context).translate('usernameToLong');
  }
  return null;
}

String? validateName(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context).translate('requieredName');
  }
  if (value.length > 50) {
    return AppLocalizations.of(context).translate('nameTooLong');
  }
  return null;
}

String? validateSurname(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context).translate('requiredSurname');
  }
  if (value.length > 50) {
    return AppLocalizations.of(context).translate('surnameTooLong');
  }
  return null;
}

String? validateEmail(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context).translate('requieredEmail');
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return AppLocalizations.of(context).translate('emailNotValid');
  }
  return null;
}

String? validatePassword(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context).translate('requiredPassword');
  }
  if (value.length > 250) {
    return AppLocalizations.of(context).translate('passwordTooLong');
  }
  final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
  if (!regex.hasMatch(value)) {
    return AppLocalizations.of(context).translate('password1');
  }
  return null;
}

String? validateRepeatedPassword(BuildContext context, String? value, String password) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context).translate('repeatPassword');
  }
  if (value != password) {
    return AppLocalizations.of(context).translate('passwordNotMatch');
  }
  return null;
}