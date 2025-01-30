import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

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
                      BarScreenArrow(
                          labelText: AppLocalizations.of(context)
                              .translate('recoveryPassword'),
                          arrowBack: true),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
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
            AppLocalizations.of(context).translate('recoveryEmail'),
            style: textStyleVilaTourTitle(color: Colors.black),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate('email'),
            ),
            validator: (value) => EmailValidator.validateEmail(context, value),
          ),
          SizedBox(height: 100),
          CustomButton(
            text: AppLocalizations.of(context).translate('send'),
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
          AppLocalizations.of(context).translate('recoveryEmailSended'),
          style: textStyleVilaTourTitle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          AppLocalizations.of(context).translate('checkEmail'),
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

      try {
        // Comprueba si el correo existe en el backend
        final emailExists = await userService.checkIfEmailExists(email);
        if (emailExists) {
          print("Que si que existe");
          final emailSent = await userService.sendRecoveryEmail(email);
          if (emailSent) {
            print("Se ha enviado");
            setState(() {
              _emailSent = true;
            });
          } else {
            _showErrorDialog(context);
          }
        }
      } catch (e) {
        print("Error al enviar el correo: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          AppLocalizations.of(context).translate('unexpectedError'),
        )));
      }
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate('email404'),
          ),
          content: Text(
            AppLocalizations.of(context).translate('emailNotRegistered'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).translate('accept'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EmailValidator {
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).translate('putEmail');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return AppLocalizations.of(context).translate('emailNotValid');
    }
    return null;
  }
}
