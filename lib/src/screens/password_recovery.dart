import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

import 'package:flutter/material.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({Key? key}) : super(key: key);

  static final routeName = 'recovery_password_screen';

  @override
  State<PasswordRecovery> createState() => _PasswordRecoveryState();
}


class _PasswordRecoveryState extends State<PasswordRecovery> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: !_emailSent
                                  ? _buildEmailForm()
                                  : _buildSuccessMessage(),
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

  // Formulario para el correo electrónico
  Widget _buildEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "Correo de recuperación",
            style: textStyleVilaTourTitle(color: Colors.black),
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
            ),
            validator: EmailValidator.validateEmail,
          ),
          SizedBox(height: 100),
          CustomButton(
            text: 'Enviar',
            onPressed: _sendRecoveryEmail,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  // Mensaje de éxito cuando el correo se envía
  Widget _buildSuccessMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
        SizedBox(height: 20),
        Text(
          'Correo de recuperación enviado.',
          style: textStyleVilaTourTitle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Por favor, revisa tu correo para continuar.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // **Método principal para enviar la solicitud de recuperación**
  Future<void> _sendRecoveryEmail() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final userService = UserService();

      print("Aqui llego");

      try {
        // Comprueba si el correo existe en el backend
        final emailExists = await userService.checkIfEmailExists(email);
        if (emailExists) {
          setState(() {
            _emailSent = true;
          });
        } else {
          _showErrorDialog(context);
        }
      } catch (e) {
        print("Error al enviar el correo: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hubo un error, intenta más tarde."))
        );
      }
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Correo no encontrado'),
          content: Text(
            'El correo ingresado no está registrado. Por favor, verifica e intenta de nuevo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

class EmailValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Por favor ingresa tu correo';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Correo no válido';
    return null;
  }
}
