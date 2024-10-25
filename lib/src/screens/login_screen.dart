import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_screen.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,  // This prevents the screen from resizing when keyboard appears
      body: Stack(
        children: [
          // Waves widget positioned at the bottom
          Positioned.fill(
            child: WavesWidget(),
          ),
          SafeArea(
            child: SingleChildScrollView( // Wrap entire content in SingleChildScrollView
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputText(labelText: "Correo:"),
                            SizedBox(height: 30),
                            InputText(labelText: "Contraseña:"),
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
                            SizedBox(height: 60),
                            Row(
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
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "  Acceder con  ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  // Acción para iniciar sesión con Google
                                },
                                child: Image.asset(
                                  "assets/google-logo.png",
                                  height: 50,
                                  width: 50,
                                ),
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