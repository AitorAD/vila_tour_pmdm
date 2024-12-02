import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    IconData? prefixIcon,
    IconData? sufixIcon,
  }){
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black)),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(255, 12, 163, 223), width: 2)),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red)),
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
      suffixIcon: sufixIcon != null ? Icon(prefixIcon, color: Colors.black) : null
    );
  }
}