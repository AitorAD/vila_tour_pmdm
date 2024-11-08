import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_app_bar.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    
    return Scaffold(
      appBar: CustomAppBar(title: recipe.name),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: const Color.fromARGB(255, 54, 71, 71),
            tabs: const [
              Tab(text: 'Receta'),
              Tab(text: 'Visión General'),
              Tab(text: 'Reseñas'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Receta
                Center(child: Text('Contenido de la receta aquí')),
                
                // Tab 2: Visión General
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recipe.name,
                      style: textStyleVilaTourTitle(color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    Image.network(
                      recipe.imagePath, // Asegúrate de que `Recipe` tiene `imageUrl`
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                
                // Tab 3: Reseñas
                Center(child: Text('Contenido de las reseñas aquí')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<RecipesProvider>(
        builder: (context, recipesProvider, child) {
          final isFavourite = recipesProvider.recipes
              .any((r) => r.name == recipe.name && r.favourite);

          return FloatingActionButton(
            onPressed: () {
              recipesProvider.toggleFavorite(recipe);
            },
            backgroundColor: isFavourite ? Colors.white : Colors.redAccent,
            child: isFavourite
                ? Icon(Icons.favorite, color: Colors.redAccent)
                : Icon(Icons.favorite_border),
          );
        },
      ),
    );
  }
}
