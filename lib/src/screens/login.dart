// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Logo y nombre de la aplicación
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("assets/logo.ico", scale: 2),
                  Text(
                    'VILATOUR',
                    style: TextStyle(
                      fontFamily: 'PontanoSans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            //Barra de LogIn
            Container(
              height: 50,
              decoration: defaultBoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log In",
                    style: Utils.textStyleVilaTourTitle,
                  ),
                ],
              ),
            ),
            // Formulario de inicio de sesión
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text("E-Mail:",
                      style: TextStyle(
                      fontFamily: 'PontanoSans',
                      fontSize: 20
                    )
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'E-mail:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                   Text("Contraseña:",
                      style: TextStyle(
                      fontFamily: 'PontanoSans',
                      fontSize: 20
                    )
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      // Acción para recuperar la contraseña
                    },
                    child: Text(
                      '¿Has olvidado tu contraseña? Haz clic aquí',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botones de "Entrar" y "Registrarse"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                        // Acción para iniciar sesión
                        },
                        child: Text('Entrar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: Size(150, 50),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción para registrarse
                        },
                        child: Text('Registrarse'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[200],
                          minimumSize: Size(150, 50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Acceder con'),
                  SizedBox(height: 10),
                  // Botón de Google
                  ElevatedButton.icon(
                    onPressed: () {
                      // Acción al presionar el botón de Google
                    },
                    icon: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png',
                      height: 24,
                      width: 24,
                    ),
                    label: Text('Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
