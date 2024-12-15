import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/register_form_provider.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/login_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

import '../utils/result.dart';


class RegistrerScreen extends StatelessWidget {
  static const routeName = 'register_screen';

  const RegistrerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterFormProvider(),
      child: const _RegisterScreenBody(),
    );
  }
}

class _RegisterScreenBody extends StatelessWidget {
  const _RegisterScreenBody();

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final loginService = Provider.of<LoginService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: WavesWidget()),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: _calculateAvailableHeight(context),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const HeaderLog(),
                      _buildHeaderBar(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 50,
                        ),
                        child: _buildRegisterForm(
                            registerForm: registerForm,
                            loginService: loginService),
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

  double _calculateAvailableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
  }

  Widget _buildHeaderBar(BuildContext context) {
    return BarScreenArrow(labelText: 'Registrarse', arrowBack: true);
  }

  Widget _buildRegisterForm({
    required RegisterFormProvider registerForm,
    required LoginService loginService,
  }) {
    String repeatedPassword = '';

    return Form(
      key: registerForm.formRegisterKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTextField(
            label: 'Usuario:',
            hintText: 'Nombre de usuario',
            onChanged: (value) => registerForm.username = value,
            validator: validateRequiredField,
          ),
          const SizedBox(height: 20),
          buildTextField(
            label: 'E-mail:',
            hintText: 'ejemplo@ejemplo.com',
            onChanged: (value) => registerForm.email = value,
            validator: validateEmail,
          ),
          const SizedBox(height: 20),
          buildTextField(
            label: 'Contraseña:',
            hintText: '**********',
            obscureText: true,
            onChanged: (value) => registerForm.changePassword(value),
            validator: validatePassword,
          ),
          const SizedBox(height: 20),
          buildTextField(
            label: 'Repita la contraseña:',
            hintText: '**********',
            obscureText: true,
            onChanged: (value) => repeatedPassword = value,
            validator: (value) =>
                validateRepeatedPassword(value, registerForm.password),
          ),
          const SizedBox(height: 40),
          // _buildSubmitButton(registerForm, loginService),
          _RegisterButton(
              registerForm: registerForm, loginService: loginService)
        ],
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  RegisterFormProvider registerForm;
  LoginService loginService;

  _RegisterButton({
    super.key,
    required this.registerForm,
    required this.loginService,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Crear cuenta',
      onPressed: () async {
        if (registerForm.isValidForm()) {
          // Mostrar un indicador de carga
          /*
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          */

          // Intentar registrar al usuario
          final result = await loginService.register(
            registerForm.username,
            registerForm.email,
            registerForm.password,
          );

          // Manejar los resultados
          switch (result) {
            case Result.success:
              Navigator.pushReplacementNamed(context, HomePage.routeName);
              break;

            case Result.invalidCredentials:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('El correo ya está en uso.'),
                ),
              );
              break;

            case Result.noConnection:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Sin conexión. Por favor, inténtalo más tarde.'),
                ),
              );
              break;

            case Result.serverError:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error en el servidor. Inténtalo más tarde.'),
                ),
              );
              break;

            case Result.unexpectedError:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ocurrió un error inesperado.'),
                ),
              );
              break;

            default:
              break;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Por favor, completa todos los campos correctamente.'),
            ),
          );
        }
      },
    );
  }
}
