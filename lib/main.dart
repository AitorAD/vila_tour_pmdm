import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/login_service.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.instance.initPrefs();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LoginFormProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => RegisterFormProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => LoginService()),
      ChangeNotifierProvider(create: (_) => FestivalsProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => ThemeProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => RecipeFormProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => UiProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => IngredientsProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => UserService(), lazy: false),
      ChangeNotifierProvider(create: (_) => UserFormProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => PlacesProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => ReviewProvider(), lazy: false),
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userPreferences = UserPreferences.instance;

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'VILATOUR',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('es', 'ES')],
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => userPreferences.token != null
              ? const HomePage()
              : const LoginScreen(),
        );
      },
      home: SessionManager(
        child: userPreferences.token != null
            ? const HomePage()
            : const LoginScreen(),
      ),
    );
  }
}

class SessionManager extends StatefulWidget {
  final Widget child;

  const SessionManager({Key? key, required this.child}) : super(key: key);

  @override
  _SessionManagerState createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  @override
  void initState() {
    super.initState();
    _checkTokenExpiration();
  }

  Future<void> _checkTokenExpiration() async {
    final userPreferences = UserPreferences.instance;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (!userPreferences.isTokenValid()) {
        _showSessionExpiredDialog();
        break;
      }
    }
  }

  void _showSessionExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sesión expirada'),
          content: const Text('Tu sesión ha expirado. Por favor, inicia sesión de nuevo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    final loginService = Provider.of<LoginService>(context, listen: false);
    await loginService.logout(context);
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}