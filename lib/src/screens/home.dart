import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/providers/menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('VILATOUR')), body: _lista());
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

      opciones..add(widgetTemp)..add(const Divider());
    }
    
    return opciones;
  }
}
