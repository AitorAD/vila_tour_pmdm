import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';


class PasswordRecovery extends StatelessWidget {
  const PasswordRecovery ({super.key});

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
                      "Se ha registrado correctamente",
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    CustomButton(
                      text: "Siguiente",
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage()
                          )
                        );
                      }
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
