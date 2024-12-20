import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/ingredients_provider.dart';
import 'package:vila_tour_pmdm/src/providers/login_form_provider.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/providers/register_form_provider.dart';
import 'package:vila_tour_pmdm/src/providers/user_form_provider.dart';
import 'package:vila_tour_pmdm/src/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/festival_service.dart';
import 'package:vila_tour_pmdm/src/services/ingredient_service.dart';
import 'package:vila_tour_pmdm/src/services/login_service.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';

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
      ChangeNotifierProvider(create: (_) => RecipesProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => UiProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => IngredientsProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => UserService(), lazy: false),
      ChangeNotifierProvider(create: (_) => UserFormProvider(), lazy: false),
    ], child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            builder: (BuildContext context) => LoginScreen());
      },
    );
  }
}
