import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/providers/theme_provider.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import '../providers/providers.dart';

class HomePage extends StatelessWidget {
  static final routeName = 'home_screen';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VILATOUR'),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        },
        child: Icon(Icons.dark_mode),
      ),
      body: Stack(
        children: [
          WavesWidget(),
          SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/logo.ico'),
                  width: 300,
                  height: 300,
                ),
                _MainContent()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            _SingleCard(
              route: PlacesScreen.routeName,
              color: Colors.blueAccent,
              icon: Icons.place,
              text: AppLocalizations.of(context).translate('places'),
            ),
            _SingleCard(
              route: FestivalsScreen.routeName,
              color: Colors.pinkAccent,
              icon: Icons.celebration,
              text: AppLocalizations.of(context).translate('festivals'),
            ),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
              route: RecipesScreen.routeName,
              color: Colors.purpleAccent,
              icon: Icons.restaurant_menu,
              text: AppLocalizations.of(context).translate('recipes'),
            ),
            _SingleCard(
              route: LoginScreen.routeName,
              color: Colors.purple,
              icon: Icons.map,
              text: AppLocalizations.of(context).translate('routes'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String route;

  _SingleCard({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        margin: EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: 100,
              height: 160,
              decoration: defaultDecoration(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(icon, size: 35, color: Colors.white),
                    backgroundColor: color,
                  ),
                  SizedBox(height: 15),
                  Text(
                    text,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}