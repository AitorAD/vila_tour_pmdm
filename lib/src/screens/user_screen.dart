import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/user_form_provider.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';
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
    final userService = Provider.of<UserService>(context);

    // Inicializar los valores iniciales del formulario
    userFormProvider.user = currentUser.copyWith();

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
            _Header(
              userService: userService,
              userFormProvider: userFormProvider,
            ),
            _ProfileForm(userFormProvider: userFormProvider),
          ],
        ),
      ),
      floatingActionButton: userFormProvider.haveChanges
          ? FloatingActionButton(
              onPressed: () async {
                String message;
                if (userFormProvider.isValidForm()) {
                  bool isModified = await userService.modifyUser(
                      currentUser, userFormProvider.user!);
                  if (isModified) {
                    message = 'Usuario modificado con éxito.';
                  } else {
                    message = 'Error al modificar los datos del usuario.';
                  }
                } else {
                  message =
                      'Por favor, completa todos los campos correctamente.';
                }
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
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
              initialValue: currentUser.username,
              label: 'Nombre de usuario:',
              hintText: currentUser.username,
              onChanged: (value) {
                userFormProvider.user?.name = value;

                userFormProvider.checkForChanges();
              },
              validator: validateRequiredField,
            ),
            const SizedBox(height: 20),
            buildTextField(
              initialValue: currentUser.email,
              label: 'E-mail:',
              hintText: 'ejemplo@ejemplo.com',
              onChanged: (value) {
                userFormProvider.user?.email = value;

                userFormProvider.checkForChanges();
              },
              validator: validateEmail,
            ),
            const SizedBox(height: 20),
            buildTextField(
              initialValue: currentUser.name,
              label: 'Nombre:',
              hintText: currentUser.name ?? 'Tu nombre',
              onChanged: (value) {
                if (value.isEmpty) {
                  userFormProvider.user?.name = null;
                } else {
                  userFormProvider.user?.name = value;
                }
                userFormProvider.checkForChanges();
              },
              validator: validateRequiredField,
            ),
            const SizedBox(height: 20),
            buildTextField(
              initialValue: currentUser.surname,
              label: 'Apellidos:',
              hintText: currentUser.surname ?? 'Tus apellidos',
              onChanged: (value) {
                if (value.isEmpty) {
                  userFormProvider.user?.surname = null;
                } else {
                  userFormProvider.user?.surname = value;
                }
                userFormProvider.checkForChanges();
              },
              validator: validateRequiredField,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  UserService userService;
  UserFormProvider userFormProvider;

  _Header({
    super.key,
    required this.userService,
    required this.userFormProvider,
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
                    getImage(userFormProvider.user?.profilePicture),

                // child: Text('AA', style: TextStyle(fontSize: 24)),
              ),
            ),
            Align(
              alignment: Alignment(0.35, 0.20),
              child: GestureDetector(
                onTap: () {
                  _processImage(
                    userService,
                    userFormProvider,
                    ImageSource.camera,
                  );
                },
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

  Future<void> _processImage(UserService userService,
      UserFormProvider userFormProvider, ImageSource imageSource) async {
    final _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: imageSource, imageQuality: 100);

    if (pickedFile == null) {
      print('No seleccionó nada');
      return;
    }

    userFormProvider.user?.profilePicture =
        await fileToBase64(File(pickedFile.path));

    userFormProvider.checkForChanges();

    userService.modifyUser(currentUser, userFormProvider.user!);
  }

  ImageProvider getImage(String? picture) {
    if (picture != null && picture.isNotEmpty) {
      try {
        // Intentamos decodificar la cadena base64 para convertirla en una imagen.
        return MemoryImage(decodeImageBase64(picture));
      } catch (e) {
        print('Error al decodificar la imagen base64: $e');
        // En caso de error en la decodificación, se muestra la imagen predeterminada.
        return AssetImage('assets/logo.ico');
      }
    } else {
      // Si no hay imagen, mostramos la predeterminada.
      return AssetImage('assets/logo.ico');
    }
  }
}
