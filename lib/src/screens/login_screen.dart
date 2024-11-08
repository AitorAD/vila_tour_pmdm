import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: WavesWidget(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                           MediaQuery.of(context).padding.top - 
                           MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      HeaderLog(),
                      BarScreenLogin(labelText: "Log In"),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // This spreads out the sections
                          children: [
                            // Input Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InputText(labelText: "Correo:"),
                                  SizedBox(height: 40), // Increased spacing
                                  InputText(labelText: "Contraseña:"),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      print("Recuperar password");
                                    },
                                    child: Text(
                                      '¿Has olvidado tu contraseña? Haz clic aquí',
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Buttons Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CustomButton(
                                    text: 'Entrar',
                                    onPressed: () {
                                      print('Botón "Entrar" presionado');
                                    },
                                  ),
                                  CustomButton(
                                    text: 'Registrarse',
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'registrer_screen');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            // Social Login Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Text(
                                          "Acceder con",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      // Acción para iniciar sesión con Google
                                    },
                                    child: Image.asset(
                                      "assets/google-logo.png",
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}