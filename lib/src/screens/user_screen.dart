import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/services.dart';
import 'package:vila_tour_pmdm/src/theme/theme.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class UserScreen extends StatefulWidget {
  static const routeName = 'user_screen';
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.index != 0) {
        isEditing = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final userService = Provider.of<UserService>(context);

    userFormProvider.user = currentUser.copyWith();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      drawer: drawer(context),
      bottomNavigationBar: const CustomNavigationBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BarScreenArrow(
              labelText: AppLocalizations.of(context).translate('profile'),
              arrowBack: false,
              iconRight: iconRightBarMenu(scaffoldKey),
            ),
            _Header(
              userService: userService,
              userFormProvider: userFormProvider,
            ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: AppLocalizations.of(context).translate('details')),
                Tab(text: AppLocalizations.of(context).translate('recipes')),
                Tab(text: AppLocalizations.of(context).translate('favorites')),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ProfileForm(userFormProvider: userFormProvider),
                  _RecipesList(),
                  _FavoritesList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? isEditing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'cancelButton',
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                        });
                        userFormProvider.isEditing = false;
                        userFormProvider.resetForm();
                      },
                      child: const Icon(Icons.cancel),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'saveButton',
                      onPressed: () async {
                        String message;
                        if (userFormProvider.isValidForm()) {
                          bool isModified = await userService.modifyUser(
                              currentUser, userFormProvider.user!);
                          if (isModified) {
                            message = AppLocalizations.of(context)
                                .translate('userModSuccesful');
                            setState(() {
                              isEditing = false;
                            });
                            userFormProvider.isEditing = false;
                          } else {
                            message = AppLocalizations.of(context)
                                .translate('userModError');
                          }
                        } else {
                          message = AppLocalizations.of(context)
                              .translate('fillFields');
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
                    setState(() {
                      isEditing = true;
                    });
                    userFormProvider.isEditing = true;
                  },
                  child: const Icon(Icons.edit),
                )
          : null,
    );
  }

  IconButton iconRightBarMenu(GlobalKey<ScaffoldState> scaffoldKey) {
    return IconButton(
      icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
      onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
    );
  }

  Drawer drawer(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              currentUser.username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              currentUser.email,
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              backgroundImage: currentUser.profilePicture != null &&
                      currentUser.profilePicture!.isNotEmpty
                  ? MemoryImage(decodeImageBase64(currentUser.profilePicture!))
                  : null,
              child: currentUser.profilePicture != null &&
                      currentUser.profilePicture!.isNotEmpty
                  ? null
                  : Text(
                      currentUser.username[0].toUpperCase(),
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
            ),
            decoration: defaultDecoration(0),
          ),
          ListTile(
            leading: themeProvider.themeData == lightMode
                ? const Icon(Icons.sunny, color: Colors.orange)
                : const Icon(Icons.nightlight, color: Colors.blueGrey),
            title: Text(
              AppLocalizations.of(context).translate('theme'),
              style: const TextStyle(fontSize: 16),
            ),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title: Text(
              AppLocalizations.of(context).translate('language'),
              style: const TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.pushNamed(context, LanguagesScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              AppLocalizations.of(context).translate('logout'),
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    final loginService = Provider.of<LoginService>(context, listen: false);
    loginService.logout(context);

    final uiProvider = Provider.of<UiProvider>(context, listen: false);
    uiProvider.selectedMenuOpt = 0;
  }
}

class _RecipesList extends StatelessWidget {
  RecipeService recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recipeService.getUserRecipes(currentUser.id),
      builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final List<Article> recipes = snapshot.data!;
          recipes.sort((a, b) => a.name.compareTo(b.name));

          return ListView.builder(
            padding: const EdgeInsets.only(top: 5),
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              return ArticleBox(article: recipes[index]);
            },
          );
        } else {
          return Center(
            child: Text(AppLocalizations.of(context).translate('myRecipes'),
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          );
        }
      },
    );
  }
}

class _FavoritesList extends StatelessWidget {
  late UserService userService;

  @override
  Widget build(BuildContext context) {
    userService = Provider.of<UserService>(context);
    return FutureBuilder(
      future: userService.getFavorites(currentUser.id),
      builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final List<Article> favorites = snapshot.data!;
          favorites.sort((a, b) => a.name.compareTo(b.name));

          return ListView.builder(
            padding: const EdgeInsets.only(top: 5),
            itemCount: favorites.length,
            itemBuilder: (BuildContext context, int index) {
              return ArticleBox(article: favorites[index]);
            },
          );
        } else {
          return Center(
            child: Text(AppLocalizations.of(context).translate('noFavorites'),
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          );
        }
      },
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
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Form(
        key: userFormProvider.formUserKey,
        child: Column(
          children: [
            buildTextField(
              context: context,
              initialValue: currentUser.username,
              label: ("${AppLocalizations.of(context).translate('username')}:"),
              hintText: currentUser.username,
              onChanged: (value) {
                userFormProvider.user?.username = value;
                userFormProvider.checkForChanges();
              },
              validator: (value) => validateRequiredField(context, value),
              enabled: userFormProvider.isEditing, context: context,
            ),
            const SizedBox(height: 20),
            buildTextField(
              context: context,
              initialValue: currentUser.email,
              label: AppLocalizations.of(context).translate('email'),
              hintText: 'ejemplo@ejemplo.com',
              onChanged: (value) {
                userFormProvider.user?.email = value;
                userFormProvider.checkForChanges();
              },
              validator: (value) => validateEmail(context, value),
              enabled: userFormProvider.isEditing, context: context
            ),
            const SizedBox(height: 20),
            buildTextField(
              context: context,
              initialValue: currentUser.name,
              label: AppLocalizations.of(context).translate('name'),
              hintText: currentUser.name ??
                  AppLocalizations.of(context).translate('yourname'),
              onChanged: (value) {
                if (value.isEmpty) {
                  userFormProvider.user?.name = null;
                } else {
                  userFormProvider.user?.name = value;
                }
                userFormProvider.checkForChanges();
              },
              validator: (value) => validateName(context, value),
              enabled: userFormProvider.isEditing, context: context
            ),
            const SizedBox(height: 20),
            buildTextField(
              context: context,
              initialValue: currentUser.surname,
              label: AppLocalizations.of(context).translate('surname'),
              hintText: currentUser.surname ??
                  AppLocalizations.of(context).translate('yourSurname'),
              onChanged: (value) {
                if (value.isEmpty) {
                  userFormProvider.user?.surname = null;
                } else {
                  userFormProvider.user?.surname = value;
                }
                userFormProvider.checkForChanges();
              },
              validator: (value) => validateSurname(context, value),
              enabled: userFormProvider.isEditing, context: context
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
                backgroundColor: Colors.blue,
                backgroundImage:
                    userFormProvider.user?.profilePicture != null &&
                            userFormProvider.user!.profilePicture!.isNotEmpty
                        ? getImage(userFormProvider.user?.profilePicture)
                        : null,
                child: userFormProvider.user?.profilePicture != null &&
                        userFormProvider.user!.profilePicture!.isNotEmpty
                    ? null
                    : Text(
                        userFormProvider.user?.username
                                .substring(0, 1)
                                .toUpperCase() ??
                            '',
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white),
                      ),
              ),
            ),
            Align(
              alignment: const Alignment(0.35, 0.20),
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
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: imageSource, imageQuality: 100);

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