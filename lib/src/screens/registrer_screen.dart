import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/register_form_provider.dart';
import 'package:vila_tour_pmdm/src/services/login_service.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

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
  }) {
    String repeatedPassword = '';

    return Form(
      key: registerForm.formRegisterKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _buildSubmitButton(registerForm),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(RegisterFormProvider registerForm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
          text: 'Crear cuenta',
          onPressed: () {
            if (registerForm.isValidForm()) {
              print('Formulario válido');
            } else {
              print('Formulario inválido');
            }
          },
        ),
      ],
    );
  }
}
