import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/recipe_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RecipesScreen extends StatefulWidget {
  static final routeName = 'recipes_screen';
  const RecipesScreen({super.key});

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<Recipe>> _recipesFuture;
  List<Recipe> _filteredRecipes = [];
  String _selectedAttribute = 'name'; // Atributo inicial para filtrar

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    final recipeService = RecipeService();
    setState(() {
      _recipesFuture = recipeService.getRecipes();
    });
  }

  void _filterRecipes(String query, List<Recipe> recipes) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecipes = recipes;
      } else {
        _filteredRecipes = recipes.where(
          (recipe) {
            final value = _getAttributeValue(recipe, _selectedAttribute);
            return value != null &&
                value.toLowerCase().contains(query.toLowerCase());
          },
        ).toList();
      }
    });
  }

  String? _getAttributeValue(Recipe recipe, String attribute) {
    switch (attribute) {
      case 'name':
        return recipe.name;
      case 'description':
        return recipe.description;
      case 'averageScore':
        return recipe.averageScore.toString();
      case 'ingredients':
        return recipe.ingredients.map((ingredient) => ingredient.name).join(', ');
      default:
        return null;
    }
  }

  void _showFilterOptions() {
    final Map<String, String> filterOptions = {
      'Nombre': 'name',
      'Descripción': 'description',
      'Puntuación': 'averageScore',
      'Ingredientes': 'ingredients',
    };

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: filterOptions.keys.map((label) {
                final attribute = filterOptions[label]!;
                return CheckboxListTile(
                  title: Text(label), // Muestra el nombre en español
                  value: _selectedAttribute == attribute,
                  onChanged: (isSelected) {
                    setState(() {
                      // Actualiza el estado de las opciones
                      _selectedAttribute =
                          isSelected ?? false ? attribute : _selectedAttribute;

                      // Aplicar el filtro
                      _recipesFuture.then((recipes) {
                        _filterRecipes(searchController.text, recipes);
                      });
                    });

                    Navigator.pop(context);
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: WavesWidget(),
          ),
          Column(
            children: [
              BarScreenArrow(labelText: AppLocalizations.of(context).translate('recipes'), arrowBack: true),
              SearchBox(
                hintText: AppLocalizations.of(context).translate('searchRecipes'),
                controller: searchController,
                onChanged: (text) {
                  _recipesFuture.then((recipes) => _filterRecipes(text, recipes));
                },
                onFilterPressed: _showFilterOptions,
              ),
              Expanded(
                child: FutureBuilder<List<Recipe>>(
                  future: _recipesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return  Center(
                          child: Text(AppLocalizations.of(context).translate('norecipes')));
                    } else {
                      final recipes = _filteredRecipes.isEmpty
                          ? snapshot.data!
                          : _filteredRecipes;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          return ArticleBox(article: recipe);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}