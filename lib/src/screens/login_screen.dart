import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/providers/login_form_provider.dart';
import 'package:vila_tour_pmdm/src/screens/password_recovery.dart';
import 'package:vila_tour_pmdm/src/ui/input_decorations.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_screen.dart';
import 'package:vila_tour_pmdm/src/services/login_service.dart';
import 'package:vila_tour_pmdm/src/utils/result.dart';
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
                      BarScreenLogin(
                        labelText:
                            AppLocalizations.of(context).translate('login'),
                      ),
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
                                    key:
                                        Key('login_form_${loginForm.hashCode}'),
                                    loginForm: loginForm,
                                  ),
                                  const SizedBox(height: 10),
                                  const _RecoveryPassword(),
                                ],
                              ),
                            ),
                            // Buttons Section
                            _Botones(
                                loginForm: loginForm,
                                loginService: loginService),
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
          Text(
            AppLocalizations.of(context).translate('username'),
            style: textStyleVilaTourTitle(color: Colors.black),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).translate('completeFields');
              }
              return null;
            },
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
              hintText: AppLocalizations.of(context).translate('enterUsername'),
            ),
            onChanged: (value) => loginForm.username = value,
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context).translate('password'),
            style: textStyleVilaTourTitle(color: Colors.black),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).translate('completeFields');
              }
              /*final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
              if (!regex.hasMatch(value)) {
                return 'Debe contener al menos un número';
              }*/
              return null;
            },
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: AppLocalizations.of(context).translate('enterPassword'),
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
        Navigator.pushNamed(context, PasswordRecovery.routeName);
      },
      child: Text(
        AppLocalizations.of(context).translate('forgotPassword'),
        style: const TextStyle(
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _Botones extends StatelessWidget {
  final LoginFormProvider loginForm;
  final LoginService loginService;
  const _Botones(
      {Key? key, required this.loginForm, required this.loginService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final loginForm = Provider.of<LoginFormProvider>(context, listen: false);

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
              loginService: loginService,
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RegistrerScreen.routeName);
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context).translate('noAccount'),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context).translate('register'),
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
  final LoginService loginService;

  const LoginBtn({
    Key? key,
    required this.loginForm,
    required this.loginService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: AppLocalizations.of(context).translate('loginButton'),
      onPressed: () async {
        if (loginForm.isValidForm()) {
          print('Formulario válido. Procesando login.');

          // Esperar el resultado del login
          final loginResult = await loginService.login(
            loginForm.username,
            loginForm.password,
          );

          print('Resultado del login: $loginResult');

          // Mostrar el mensaje correspondiente según el resultado
          switch (loginResult) {
            case Result.success:
              print('Login exitoso.');
              Navigator.pushReplacementNamed(context, HomePage.routeName);
              break;

            case Result.invalidCredentials:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)
                      .translate('invalidCredentials')),
                ),
              );
              break;

            case Result.noConnection:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).translate('noConnection')),
                ),
              );
              break;

            case Result.serverError:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).translate('serverError')),
                ),
              );
              break;

            case Result.unexpectedError:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('unexpectedError'),
                  ),
                ),
              );
              break;

            default:
              break;
          }
        } else {
          print('Formulario inválido.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalizations.of(context).translate('completeFields')),
            ),
          );
        }
      },
    );
  }
}
