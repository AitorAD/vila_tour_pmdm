import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_confirmation_screen.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';


class RegistrerScreen extends StatelessWidget {

 const  RegistrerScreen({super.key});

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
                  BarScreenArrow(
                    labelText: "Registrarse",
                    onBackPressed: () {
                      // Navega a LoginScreen al presionar el botón de retroceso
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 70), // Reduce el espacio aquí para ajustar
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
                          SizedBox(height: 25),
                          // Input 2
                          InputText(labelText: "Repetir contraseña:"),
                          SizedBox(height: 15),
                          SizedBox(
                              height:
                                  30), // Espacio entre el texto y los botones
                          // Fila Botones
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomButton(
                                text:
                                    'Crear cuenta', // Texto que aparecerá en el botón
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegistrerConfirmationScreen()
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
                                "  Registrarse con  ",
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