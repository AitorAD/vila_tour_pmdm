import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/recipes_provider.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_app_bar.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RecipesScreen extends StatelessWidget {
  static final routeName = 'recipes_screen';
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provisional hasta conectar con la API
    final recipesProvider = Provider.of<RecipesProvider>(context);

    return Scaffold(
        bottomNavigationBar: CustomNavigationBar(),
        appBar: CustomAppBar(title: "Recetas"),
        body: Stack(
          children: [
            WavesWidget(),
            Column(
              children: [
                SearchBox(),
                Expanded(
                  child: ListView.builder(
                    itemCount: recipesProvider.recipes.length,
                    itemBuilder: (context, index) {
                      return ArticleBox(
                        article: recipesProvider.recipes[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
