import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
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
                            context: context,
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
    return BarScreenArrow(
        labelText: AppLocalizations.of(context).translate('registerVerb'),
        arrowBack: true);
  }

  Widget _buildRegisterForm({
    required BuildContext context,
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
            context: context,
              label: AppLocalizations.of(context).translate('User'),
              hintText: AppLocalizations.of(context).translate('Username'),
              onChanged: (value) => registerForm.username = value,
              validator: (value) => validateRequiredField(context, value),
              enabled: true, context: context),
          const SizedBox(height: 20),
          buildTextField(
            context: context,
              label: AppLocalizations.of(context).translate('email'),
              hintText: 'ejemplo@ejemplo.com',
              onChanged: (value) => registerForm.email = value,
              validator: (value) => validateEmail(context, value),
              enabled: true, context: context),
          const SizedBox(height: 20),
          buildTextField(
            context:  context,
              label: AppLocalizations.of(context).translate('password'),
              hintText: '**********',
              obscureText: true,
              onChanged: (value) => registerForm.changePassword(value),
              validator: (value) => validatePassword(context, value),
              enabled: true, context: context),
          const SizedBox(height: 20),
          buildTextField(
            context: context,
              label: AppLocalizations.of(context).translate('repeatPassword'),
              hintText: '**********',
              obscureText: true,
              onChanged: (value) => repeatedPassword = value,
              validator: (value) => validateRepeatedPassword(
                  context, value, registerForm.password),
              enabled: true, context: context),
          const SizedBox(height: 40),
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
      text: AppLocalizations.of(context).translate('createAccount'),
      onPressed: () async {
        if (registerForm.isValidForm()) {
          // Intentar registrar al usuario
          final result = await loginService.register(
            registerForm.username,
            registerForm.email,
            registerForm.password,
          );

          print(result);

          // Manejar los resultados
          switch (result) {
            case Result.success:
              Navigator.pushReplacementNamed(context, HomePage.routeName);
              break;

            case Result.invalidCredentials:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(AppLocalizations.of(context).translate('emailAoU')),
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
                  content: Text(AppLocalizations.of(context)
                      .translate('unexpectedError')),
                ),
              );
              break;

            default:
              break;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context).translate('fillFields')),
            ),
          );
        }
      },
    );
  }
}
