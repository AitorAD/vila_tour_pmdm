import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RegistrerConfirmationScreen extends StatelessWidget {
  const RegistrerConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              // Background
              Positioned.fill(
                child: WavesWidget(),
              ),
              // BODY
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/ok240.png',
                        height: 180,
                        width: 180,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('succesfulRegistrer'),
                        style: TextStyle(fontSize: 18),
                      ),
                      CustomButton(
                          text: AppLocalizations.of(context).translate('next'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          }),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
