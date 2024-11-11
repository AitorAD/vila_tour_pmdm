import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails>
    with SingleTickerProviderStateMixin {
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
      bottomNavigationBar: CustomNavigationBar(),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IngredientsWrap(ingredients: recipe.ingredients),
                        const SizedBox(height: 16),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.0, 
                          indent:
                              0,
                          endIndent:
                              0,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Preparación',
                          style: textStyleVilaTourTitle(color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.description,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab 2: Visión General
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal:
                          16.0), // Agrega el padding a izquierda y derecha
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recipe.name,
                        style: textStyleVilaTourTitle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      Image.network(
                        recipe
                            .imagePath, // Asegúrate de que `Recipe` tiene `imageUrl`
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      IngredientsWrap(ingredients: recipe.ingredients),
                    ],
                  ),
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

class IngredientsWrap extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientsWrap({Key? key, required this.ingredients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredientes',
          style: textStyleVilaTourTitle(color: Colors.black),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: ingredients.map((ingredient) {
            return Container(
              decoration: defaultDecoration(18),
              padding: const EdgeInsets.all(10),
              child: Text(
                ingredient.name,
                style: textStyleVilaTour(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
