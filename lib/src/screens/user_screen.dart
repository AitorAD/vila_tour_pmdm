import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/providers/user_form_provider.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class UserScreen extends StatelessWidget {
  static const routeName = 'user_screen';
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final userService = Provider.of<UserService>(context);

    userFormProvider.user = currentUser.copyWith();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: drawer(context),
      bottomNavigationBar: CustomNavigationBar(),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BarScreenArrow(
              labelText: AppLocalizations.of(context).translate('profile'),
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
      floatingActionButton: userFormProvider.isEditing
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'cancelButton',
                  onPressed: () {
                    userFormProvider.isEditing = false;
                    userFormProvider.resetForm();
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.cancel),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'saveButton',
                  onPressed: () async {
                    String message;
                    if (userFormProvider.isValidForm()) {
                      bool isModified = await userService.modifyUser(
                          currentUser, userFormProvider.user!);
                      if (isModified) {
                        message = AppLocalizations.of(context).translate('userModSuccesful');
                        userFormProvider.isEditing = false;
                      } else {
                        message = AppLocalizations.of(context).translate('userModError');
                      }
                    } else {
                      message = AppLocalizations.of(context).translate('fillFields');
                    }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  },
                  child: const Icon(Icons.save),
                ),
              ],
            )
          : FloatingActionButton(
              heroTag: 'editButton',
              onPressed: () {
                userFormProvider.isEditing = true;
              },
              child: const Icon(Icons.edit),
            ),
    );
  }

  IconButton iconRightBarMenu(GlobalKey<ScaffoldState> _scaffoldKey) {
    return IconButton(
      icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
      onPressed: () {
        _scaffoldKey.currentState
            ?.openDrawer(); // Abrir el Drawer al presionar el icono
      },
    );
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
      width: double.infinity,
      child: Column(
        children: [
          BarScreenArrow(
            labelText: AppLocalizations.of(context)!.translate('settings'),
            arrowBack: true,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.sunny),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, LanguagesScreen.routeName);
            },
            icon: Icon(Icons.language),
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
        key: userFormProvider.formUserKey,
        child: Column(
          children: [
            buildTextField(
              initialValue: currentUser.username,
              label: ("${AppLocalizations.of(context).translate('username')}:"),
              hintText: currentUser.username,
              onChanged: (value) {
                userFormProvider.user?.username = value;
                userFormProvider.checkForChanges();
              },
              validator: (value) => validateRequiredField(context, value),
              enabled: userFormProvider.isEditing,
            ),
            const SizedBox(height: 20),
            buildTextField(
              initialValue: currentUser.email,
              label: AppLocalizations.of(context).translate('email'),
              hintText: 'ejemplo@ejemplo.com',
              onChanged: (value) {
                userFormProvider.user?.email = value;
                userFormProvider.checkForChanges();
              },
              validator: (value) => validateEmail(context, value),
              enabled: userFormProvider.isEditing,
            ),
            const SizedBox(height: 20),
            buildTextField(
              initialValue: currentUser.name,
              label: AppLocalizations.of(context).translate('name'),
              hintText: currentUser.name ?? AppLocalizations.of(context).translate('yourname'),
              onChanged: (value) {
                if (value.isEmpty) {
                  userFormProvider.user?.name = null;
                } else {
                  userFormProvider.user?.name = value;
                }
                userFormProvider.checkForChanges();
              },
              validator: (value) => validateName(context, value),
              enabled: userFormProvider.isEditing,
            ),
            const SizedBox(height: 20),
            buildTextField(
              initialValue: currentUser.surname,
              label: AppLocalizations.of(context).translate('surname'),
              hintText: currentUser.surname ?? AppLocalizations.of(context).translate('yourSurname'),
              onChanged: (value) {
                if (value.isEmpty) {
                  userFormProvider.user?.surname = null;
                } else {
                  userFormProvider.user?.surname = value;
                }
                userFormProvider.checkForChanges();
              },
              validator: (value) => validateSurname(context, value),
              enabled: userFormProvider.isEditing,
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
      child: SizedBox(
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
              ),
            ),
            Align(
              alignment: Alignment(0.35, 0.20),
              child: GestureDetector(
                onTap: () {
                  _processImage(
                    context,
                    userService,
                    userFormProvider,
                    ImageSource.camera,
                  );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: defaultDecoration(100, opacity: 1),
                  child: const Icon(
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
                style: const TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _processImage(BuildContext context, userService,
      UserFormProvider userFormProvider, ImageSource imageSource) async {
    final _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: imageSource, imageQuality: 100);

    if (pickedFile == null) {
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
        return MemoryImage(decodeImageBase64(picture));
      } catch (e) {
        return const AssetImage('assets/logo.ico');
      }
    } else {
      return const AssetImage('assets/logo.ico');
    }
  }
}