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
  static final routeName = 'login_screen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginService = Provider.of<LoginService>(context);

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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Input Section
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _LoginForm(),
                                  SizedBox(height: 10),
                                  _RecoveryPassword(),
                                ],
                              ),
                            ),
                            // Buttons Section
                            _Botones(),
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
  const _LoginForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
          key: loginForm.formLogKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Usuario:',
                  style: textStyleVilaTourTitle(color: Colors.black)),
              TextFormField(
                validator: (value) {
                  // VALIDA
                  if (value == null || value.isEmpty) {
                    return 'El nombre de usuario es obligatorio';
                  }
                  return null; // Validación exitosa
                },
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre de Usuario'),
                onChanged: (value) => loginForm.username = value,
              ),
              SizedBox(height: 30),
              Text('Contraseña:',
                  style: textStyleVilaTourTitle(color: Colors.black)),
              TextFormField(
                validator: (value) {
                  // VALIDA
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
                  if (!regex.hasMatch(value)) {
                    return 'Debe contener al menos un numero';
                  }
                  return null;
                },
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '**********'),
                onChanged: (value) => loginForm.password = value,
              )
            ],
          )),
    );
  }
}

class _RecoveryPassword extends StatelessWidget {
  const _RecoveryPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Recuperar password");
      },
      child: Text(
        '¿Has olvidado tu contraseña? Haz click aquí',
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _Botones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginBtn(loginForm: loginForm),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'registrer_screen');
              },
              child: RichText(
                text: TextSpan(
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
                        color: const Color.fromARGB(210, 11, 145, 185),
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

  const LoginBtn({super.key, required this.loginForm});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Entrar',
      onPressed: () {
        // Ver como hacer la conexion, validarla y que pase
        print('Botón "Entrar" presionado');
      },
    );
  }
}
