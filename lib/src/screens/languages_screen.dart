import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/language_provider.dart';

class LanguagesScreen extends StatelessWidget {
  static final routeName = 'languages_screen';

  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: ListView(
        children: [
          ListTile(
            title: Text('English'),
            onTap: () {
              languageProvider.setLanguage('en');
            },
          ),
          ListTile(
            title: Text('Español'),
            onTap: () {
              languageProvider.setLanguage('es');
            },
          ),
           ListTile(
            title: Text('Valenciano'),
            onTap: () {
              languageProvider.setLanguage('vl');
            },
          ),
          ListTile(
            title: Text('Galego'),
            onTap: () {
              languageProvider.setLanguage('gl');
            },
          ),
        ],
      ),
    );
  }
}
