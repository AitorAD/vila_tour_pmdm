import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/models/image.dart' as customImage;
import 'package:vila_tour_pmdm/src/services/image_service.dart';
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
      appBar: CustomAppBar(title: 'Recetas'),
      body: Stack(
        children: [
          WavesWidget(),
          FutureBuilder<List<Recipe>>(
            future: recipeService.getRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No se encontraron recetas.'));
              } else {
                List<Recipe> recipes = snapshot.data!;

                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return ArticleBox(article: recipe);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
