import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/login_form_provider.dart';
import 'package:vila_tour_pmdm/src/ui/input_decorations.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_screen.dart';
import 'package:vila_tour_pmdm/src/services/login_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginService = Provider.of<LoginService>(context, listen: false);
    final loginForm = Provider.of<LoginFormProvider>(context, listen: false);

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
                      const HeaderLog(),
                      const BarScreenLogin(labelText: "Log In"),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Input Section
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _LoginForm(
                                    key: Key('login_form_${loginForm.hashCode}'),
                                    loginForm: loginForm,
                                  ),
                                  const SizedBox(height: 10),
                                  const _RecoveryPassword(),
                                ],
                              ),
                            ),
                            // Buttons Section
                            const _Botones(),
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

class _LoginForm extends StatelessWidget {
  final LoginFormProvider loginForm;
  const _LoginForm({Key? key, required this.loginForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginForm.formLogKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usuario:',
              style: textStyleVilaTourTitle(color: Colors.black)),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre de usuario es obligatorio';
              }
              return null;
            },
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Nombre de Usuario',
            ),
            onChanged: (value) => loginForm.username = value,
          ),
          const SizedBox(height: 30),
          Text('Contraseña:',
              style: textStyleVilaTourTitle(color: Colors.black)),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La contraseña es obligatoria';
              }
              final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
              if (!regex.hasMatch(value)) {
                return 'Debe contener al menos un número';
              }
              return null;
            },
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: '**********',
            ),
            onChanged: (value) => loginForm.password = value,
          ),
        ],
      ),
    );
  }
}

class _RecoveryPassword extends StatelessWidget {
  const _RecoveryPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("Recuperar password");
      },
      child: Text(
        '¿Has olvidado tu contraseña? Haz click aquí',
        style: const TextStyle(
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _Botones extends StatelessWidget {
  const _Botones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginBtn(
              key: Key('login_button_${loginForm.hashCode}'),
              loginForm: loginForm,
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RegistrerScreen.routeName);
              },
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '¿No tienes cuenta? ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Regístrate',
                      style: TextStyle(
                        color: Color.fromARGB(210, 11, 145, 185),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBtn extends StatelessWidget {
  final LoginFormProvider loginForm;

  const LoginBtn({Key? key, required this.loginForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Entrar',
      onPressed: () {
        if (loginForm.isValidForm()) {
          print('Formulario válido. Procesando login.');
        } else {
          print('Formulario inválido.');
        }
      },
    );
  }
}
