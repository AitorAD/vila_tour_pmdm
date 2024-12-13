import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/user_form_provider.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/bar_decoration.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class UserScreen extends StatelessWidget {
  static final routeName = 'user_screen';
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final userFormProvider = Provider.of<UserFormProvider>(context);

    userFormProvider.loadUser(currentUser);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            _ProfileForm(userFormProvider: userFormProvider),
          ],
        ),
      ),
      floatingActionButton: userFormProvider.haveChanges
          ? FloatingActionButton(
              onPressed: () {
                // modify()
              },
              child: Icon(Icons.save),
            )
          : null,
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
            children: [IconButton(onPressed: () {}, icon: Icon(Icons.sunny))],
          )
        ],
      ),
    );
    // Icons.more_vert
  }
}

class _ProfileForm extends StatelessWidget {
  UserFormProvider userFormProvider;

  _ProfileForm({
    super.key,
    required this.userFormProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: userFormProvider.formLogKey,
        child: Column(
          children: [
            buildTextField(
              label: 'Nombre de usuario:',
              initialValue: userFormProvider.user.username,
              onChanged: (value) => userFormProvider.user.username = value,
              validator: validateRequiredField,
              hintText: '',
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: 'E-mail:',
              initialValue: userFormProvider.user.email,
              onChanged: (value) => userFormProvider.user.email = value,
              validator: validateEmail,
              hintText: '',
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: 'Nombre:',
              initialValue: userFormProvider.user.name,
              onChanged: (value) => userFormProvider.user.name = value,
              validator: validateRequiredField,
              hintText: '',
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: 'Apellidos:',
              initialValue: userFormProvider.user.surname,
              onChanged: (value) => userFormProvider.user.surname = value,
              validator: validateRequiredField,
              hintText: '',
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
