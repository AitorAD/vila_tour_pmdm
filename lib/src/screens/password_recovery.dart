import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class PasswordRecovery extends StatelessWidget {
  PasswordRecovery({super.key});
  static final routeName = 'recovery_password_screen';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(
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
                      SizedBox(height: 25),
                      const BarScreenArrow(
                          labelText: "Recuperar Contraseña", arrowBack: true),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Input Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _emailInput(),
                                    SizedBox(height: 100),
                                    RecoveryBtn(
                                      formKey: _formKey,
                                      emailController: _emailController,
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            )
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

  Column _emailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Correo de recuperacion",
          style: textStyleVilaTourTitle(color: Colors.black),
        ),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
          ),
          validator: EmailValidator.validateEmail,
        ),
      ],
    );
  }
}

class EmailValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Correo no válido';
    }
    return null;
  }
}

class RecoveryBtn extends StatelessWidget {
  const RecoveryBtn({
    Key? key,
    required this.formKey,
    required this.emailController,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Enviar',
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          final email = emailController.text.trim();

          // Lógica para comprobar si el correo existe
          final emailExists = await checkIfEmailExists(email);

          if (emailExists) {
            // Lógica para enviar el correo de recuperación
            print('Correo de recuperación enviado a $email');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Correo de recuperación enviado.')),
            );
          } else {
            // Mostrar mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El correo no está registrado.')),
            );
          }
        }
      },
    );
  }

  Future<bool> checkIfEmailExists(String email) async {
    // Simulación de llamada a una base de datos o API
    await Future.delayed(Duration(seconds: 1)); // Simula el tiempo de respuesta
    // Aquí deberías implementar tu lógica para verificar si el correo existe
    return email == "usuario@ejemplo.com"; // Simula un correo existente
  }
}
