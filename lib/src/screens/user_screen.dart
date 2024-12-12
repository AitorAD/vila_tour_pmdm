import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/bar_decoration.dart';
import 'package:vila_tour_pmdm/src/widgets/button.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';

class UserScreen extends StatelessWidget {
  static final routeName = 'user_screen';
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      bottomNavigationBar: CustomNavigationBar(),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BarScreenArrow(
              labelText: 'Perfil',
              arrowBack: false,
              iconRight: iconRightBarMenu(_scaffoldKey),
            ),
            _Header(),
            _ProfileForm(),
            CustomButton(text: 'Guardar', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  IconButton iconRightBarMenu(GlobalKey<ScaffoldState> _scaffoldKey) {
    return IconButton(
      icon: Icon(Icons.more_vert, color: Colors.white, size: 28),
      onPressed: () {
        _scaffoldKey.currentState
            ?.openDrawer(); // Abrir el Drawer al presionar el icono
      },
    );
  }

  Drawer drawer() {
    return Drawer(
      width: double.infinity,
      child: Column(
        children: [
          BarScreenArrow(labelText: 'Configuración', arrowBack: true),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.sunny))

            ],
          )
          
        ],
      ),
    );
    // Icons.more_vert
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
              initialValue: currentUser.username,
              label: 'Usuario:',
              hintText: 'Nombre de usuario',
              onChanged: (value) {},
              // onChanged: (value) => registerForm.username = value,
              validator: validateRequiredField,
            ),
            const SizedBox(height: 20),
            buildTextField(
              initialValue: currentUser.email,
              label: 'E-mail:',
              hintText: 'ejemplo@ejemplo.com',
              onChanged: (value) {},
              //onChanged: (value) => registerForm.email = value,
              validator: validateEmail,
            ),
            const SizedBox(height: 20),
            buildTextField(
              initialValue: currentUser.password,
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
                backgroundImage:
                    MemoryImage(decodeImageBase64(currentUser.profilePicture!)),

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
                '@${currentUser.username}',
                style: TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }
}
