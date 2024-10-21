// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/bar_screen.dart';
import 'package:vila_tour_pmdm/src/widgets/header_log.dart';
import 'package:vila_tour_pmdm/src/widgets/waves.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                // Background
                Positioned.fill(
                  child: WavesWidget(),
                ),
                Column(
                  children: [
                    // Logo y nombre de la aplicación
                    HeaderLog(),
                    SizedBox(height: 10),
                    // Barra de LogIn
                    BarScreen(labelText: "Log In"),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          InputText(labelText: "E-Mail:"),
                          SizedBox(height: 25),
                          InputText(labelText: "Contraseña:"),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              // Acción para recuperar la contraseña
                            },
                            child: Text(
                              '¿Has olvidado tu contraseña? Haz clic aquí',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class InputText extends StatelessWidget {
  final String labelText;

  const InputText({
    super.key,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              labelText,
              style: TextStyle(
                fontFamily: "PontanoSans",
                fontSize: 20,
              ),
            )
          ],
        ),
        Center(
          child: TextField(),
        ),
      ]
    );
  }
}
