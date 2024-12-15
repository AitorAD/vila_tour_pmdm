import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/recipe.dart';
import 'package:vila_tour_pmdm/src/services/recipe_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RecipesScreen extends StatelessWidget {
  static final routeName = 'recipes_screen';
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService();

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      appBar: CustomAppBar(title: "Recetas"),
      body: Stack(
        children: [
          WavesWidget(),
          FutureBuilder<List<Recipe>>(
            future: recipeService.fetchRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final recipes = snapshot.data ?? [];
                if (recipes.isEmpty) {
                  return const Center(child: Text('No se encontraron recetas.'));
                }
                return Column(
                  children: [
                    SearchBox(), // O puedes eliminarlo si no está implementado
                    Expanded(
                      child: ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          return ArticleBox(article: recipes[index]);
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
