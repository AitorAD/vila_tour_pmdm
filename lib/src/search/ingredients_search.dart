import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/ingredients_provider.dart';
import 'package:provider/provider.dart';

class IngredientSearchDelegate extends SearchDelegate<Ingredient> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Ingredient(id: 1, name: "", category: "")); // Cierra el buscador
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Aquí puedes mostrar los resultados de búsqueda (cuando el usuario presione Enter)
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(context);
    final filteredIngredients = ingredientsProvider.filteredIngredients;

    final suggestions = query.isEmpty
        ? filteredIngredients
        : filteredIngredients
            .where((ingredient) => ingredient.name
                .toLowerCase()
                .contains(query.toLowerCase())) // Filtrar por nombre
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final ingredient = suggestions[index];
        return ListTile(
          title: Text(ingredient.name),
          onTap: () {
            close(context, ingredient); // Selecciona el ingrediente
          },
        );
      },
    );
  }
}
