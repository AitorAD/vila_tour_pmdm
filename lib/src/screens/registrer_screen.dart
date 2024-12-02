import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/register_form_provider.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/ui/input_decorations.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RegistrerScreen extends StatelessWidget {
  static final routeName = 'register_screen';
  const RegistrerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final formKey = GlobalKey<FormState>();

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
                          formKey: formKey,
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
    return BarScreenArrow(
      labelText: "Registrarse",
      onBackPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
    );
  }

  Widget _buildRegisterForm({
    required GlobalKey<FormState> formKey,
    required RegisterFormProvider registerForm,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Usuario:',
            hintText: 'Nombre de usuario',
            onChanged: (value) => registerForm.username = value,
            validator: _validateRequiredField,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'E-mail:',
            hintText: 'ejemplo@ejemplo.com',
            onChanged: (value) => registerForm.email = value,
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Contraseña:',
            hintText: '**********',
            obscureText: true,
            onChanged: (value) => registerForm.password = value,
            validator: _validatePassword,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Repita la contraseña:',
            hintText: '**********',
            obscureText: true,
            onChanged: (value) => registerForm.password = value,
            validator: (value) => _validateRepeatedPassword(value, registerForm.password),
          ),
          const SizedBox(height: 40),
          _buildSubmitButton(formKey),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required FormFieldValidator<String> validator,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textStyleVilaTourTitle(color: Colors.black)),
        TextFormField(
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          decoration: InputDecorations.authInputDecoration(hintText: hintText),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(GlobalKey<FormState> formKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
          text: 'Crear cuenta',
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              // Navega solo si el formulario es válido
              print('Formulario válido');
            } else {
              print('Formulario inválido');
            }
          },
        ),
      ],
    );
  }

  // Funciones validadoras reutilizables
  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty){
      return 'El nombre de usuario es obligatorio';
    } 
    if(value.length > 250){
      return 'El nombre es demasiado largo';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es obligatorio';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if(value.length > 250){
      return 'La contraseña es demasiado larga';
    }
    final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
    if (!regex.hasMatch(value)) {
      return 'Debe contener al menos un número';
    }
    return null;
  }

  String? _validateRepeatedPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Debe repetir la contraseña';
    }
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}
