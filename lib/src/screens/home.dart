import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/menu.dart';
import 'package:vila_tour_pmdm/src/providers/theme_provider.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_app_bar.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

import '../providers/providers.dart';

class HomePage extends StatelessWidget {
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
        // appBar: AppBar(title: const Text('VILATOUR')),
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
    final uiProvider = Provider.of<UiProvider>(context);

    switch (uiProvider.selectedMenuOpt) {
      case 0:
        _lista();
        break;
      case 2:
        return MapScreen();
      default:
        _lista();
        break;
    }

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
