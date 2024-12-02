import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/button.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_app_bar.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';

class UserScreen extends StatelessWidget {
  static final routeName = 'user_screen';
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Perfil'),
      bottomNavigationBar: CustomNavigationBar(),
      body: Container(
        width: double.infinity,
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Header(),
            _ProfileForm(),
            CustomButton(text: 'Guardar', onPressed: (){}),
          ],
        ),
      ),
    );
  }
}

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: [
            buildTextField(
              label: 'Usuario:',
              hintText: 'Nombre de usuario',
              onChanged: (value) {},
              // onChanged: (value) => registerForm.username = value,
              validator: validateRequiredField,
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: 'E-mail:',
              hintText: 'ejemplo@ejemplo.com',
              onChanged: (value) {},
              //onChanged: (value) => registerForm.email = value,
              validator: validateEmail,
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: 'Contraseña:',
              hintText: '**********',
              obscureText: true,
              onChanged: (value) {},
              //onChanged: (value) => registerForm.password = value,
              validator: validatePassword,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 200,
        height: 150,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg'),

                // child: Text('AA', style: TextStyle(fontSize: 24)),
              ),
            ),
            Align(
              alignment: Alignment(0.35, 0.20),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: defaultDecoration(100, opacity: 1),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '@nombreUser',
                style: TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }
}
