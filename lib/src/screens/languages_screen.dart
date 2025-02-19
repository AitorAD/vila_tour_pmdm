import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/languages/language_provider.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class LanguagesScreen extends StatelessWidget {
  static const routeName = 'languages_screen';

  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = {
      'en': 'English',
      'es': 'Español',
      'vl': 'Valenciano',
      'gl': 'Galego',
    };

    return Scaffold(
      body: Column(
        children: [
          BarScreenArrow(
            labelText: AppLocalizations.of(context).translate('selectLanguage'), 
            arrowBack: true
          ),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: languages.entries.map((entry) {
                    bool isSelected = languageProvider.locale.languageCode == entry.key;
                    return Card(
                      elevation: isSelected ? 6 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300, width: 2),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        title: Text(
                          entry.value,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.blue : Colors.black87,
                          ),
                        ),
                        trailing: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.blue, size: 28)
                              : const SizedBox.shrink(),
                        ),
                        onTap: () {
                          languageProvider.setLanguage(entry.key);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
