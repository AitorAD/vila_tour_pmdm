import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/menu.dart';
import 'package:vila_tour_pmdm/src/providers/theme_provider.dart';
import 'package:vila_tour_pmdm/src/screens/festivals_screen.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/screens/recipes_screen.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

import '../providers/providers.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/theme_provider.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';

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
              text: 'Lugares de Interés',
            ),
            _SingleCard(
              route: FestivalsScreen.routeName,
              color: Colors.pinkAccent,
              icon: Icons.celebration,
              text: 'Festivales',
            ),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
              route: RecipesScreen.routeName,
              color: Colors.purpleAccent,
              icon: Icons.restaurant_menu,
              text: 'Recetas',
            ),
            _SingleCard(
              route: LoginScreen.routeName,
              color: Colors.purple,
              icon: Icons.map,
              text: 'Rutas',
            ),
          ],
        ),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  IconData icon;
  Color color;
  String text;
  String route;

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

/*
class HomePage extends StatelessWidget {
  static final routeName = 'home_screen';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomNavigationBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          child: Icon(Icons.dark_mode),
        ),
        appBar: CustomAppBar(title: 'VILATOUR'),
        body: home(context));
  }

  Widget _lista() {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
            children: _listaItems(snapshot.data!, context),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<Widget> _listaItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];
    for (var opt in data) {
      final widgetTemp = ListTile(
        title: Text(opt['texto']),
        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.blue),
        onTap: () {
          Navigator.pushNamed(context, opt['ruta']);
        },
      );

      opciones
        ..add(widgetTemp)
        ..add(const Divider());
    }

    return opciones;
  }

  Widget home(context) {

    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
            children: _listaItems(snapshot.data!, context),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
*/