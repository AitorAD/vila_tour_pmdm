import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_confirmation_screen.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RegistrerScreen extends StatelessWidget {
  static final routeName = 'register_screen';
  const RegistrerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // This prevents the screen from resizing when keyboard appears
      body: Stack(
        children: [
          // Waves widget positioned at the bottom
          Positioned.fill(
            child: WavesWidget(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              // Wrap entire content in SingleChildScrollView
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  //BODY
                  child: Column(
                    children: [
                      HeaderLog(),
                      BarScreenArrow(
                          labelText: "Registrarse",
                          onBackPressed: () => LoginScreen),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputText(labelText: "Correo:"),
                            SizedBox(height: 30),
                            InputText(labelText: "Contraseña:"),
                            SizedBox(height: 30),
                            InputText(labelText: "Escriba de nuevo la Contraseña:"),
                            SizedBox(height: 60),
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
                                            builder: (context) =>
                                                RegistrerConfirmationScreen()));
                                    print('Botón "Registrar" presionado');
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
