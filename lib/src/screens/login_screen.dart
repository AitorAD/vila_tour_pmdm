import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_screen.dart';
import 'package:vila_tour_pmdm/src/widgets/bar_login.dart';
import 'package:vila_tour_pmdm/src/widgets/button.dart';
import 'package:vila_tour_pmdm/src/widgets/header_log.dart';
import 'package:vila_tour_pmdm/src/widgets/input_text.dart';
import 'package:vila_tour_pmdm/src/widgets/waves.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              // Background
              Positioned.fill(
                child: WavesWidget(),
              ),
              // BODY
              Column(
                children: [
                  // Logo y nombre de la aplicación
                  HeaderLog(),
                  SizedBox(height: 10),
                  // Barra de LogIn
                  BarScreenLogin(labelText: "Log In"),
                  SizedBox(height: 90), // Reduce el espacio aquí para ajustar
                  // Formulario
                  Expanded(
                    // Usa Expanded para ocupar el espacio restante
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          // Input 1
                          InputText(labelText: "E-Mail:"),
                          SizedBox(height: 25),
                          // Input 2
                          InputText(labelText: "Contraseña:"),
                          SizedBox(height: 15),
                          // Recuperar contraseña
                          GestureDetector(
                            onTap: () {
                              print(
                                  "Recuperar password"); // Llevar a pantalla de recuperar contraseña
                            },
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Alinea el texto a la izquierda
                              child: Text(
                                '¿Has olvidado tu contraseña? Haz clic aquí',
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration
                                      .underline, // Subraya el texto
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  70), // Espacio entre el texto y los botones
                          // Fila Botones
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Boton 1
                              CustomButton(
                                text:
                                    'Entrar', // Texto que aparecerá en el botón
                                onPressed: () {
                                  // Acción para iniciar sesión
                                  print('Botón "Entrar" presionado');
                                },
                              ),
                              // Boton 2
                              CustomButton(
                                text:
                                    'Registrarse', // Texto que aparecerá en el botón
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegistrerScreen()
                                    )
                                  );
                                  print('Botón "Registrar" presionado');
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          // Barra negra y texto
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.black),
                                  height: 2, // Altura más fina
                                ),
                              ),
                              Text(
                                "  Acceder con  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.black),
                                  height: 2, // Altura más fina
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          // Boton Google
                          GestureDetector(
                            onTap: () {
                              //Accion al presionar
                            },
                            child: Image.asset(
                              "assets/google-logo.png",
                              height: 50,
                              width: 50,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
