import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/ingredients_provider.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class UploadRecipe extends StatefulWidget {
  static final routeName = 'upload_recipe';
  UploadRecipe({super.key});

  @override
  State<UploadRecipe> createState() => _UploadRecipeState();
}

class _UploadRecipeState extends State<UploadRecipe> {
  final ValueNotifier<String?> _imagePath = ValueNotifier(null);

  final ValueNotifier<List<Ingredient>> _selectedIngredients =
      ValueNotifier([]);

  void _selectImage() {
    _imagePath.value =
        'assets/logo_foreground.png'; //Imagen de ejemplo hasta implementar
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Subir Receta'),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          WavesWidget(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputText(labelText: "Nombre"),
                  const SizedBox(height: 16),
                  Text(
                    'Ingredientes',
                    style: textStyleVilaTourTitle(
                        color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(height: 10),

                  SearchAnchor(
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        hintText: 'Buscar ingrediente',
                        onChanged: (query) {
                          ingredientsProvider.filterIngredients(query);
                        },
                        leading: const Icon(Icons.search),
                      );
                    },
                    //TODO esto no funciona
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return ingredientsProvider.filteredIngredients
                          .map((ingredient) {
                        return ListTile(
                          title: Text(ingredient.name),
                          onTap: () {
                            setState(() {
                              _selectedIngredients.value =
                                  List.from(_selectedIngredients.value)
                                    ..add(ingredient);
                              _selectedIngredients.value =
                                  List.from(_selectedIngredients.value);
                              controller.closeView(ingredient.name);
                            });
                          },
                        );
                      }).toList();
                    },
                  ),

                  const SizedBox(height: 16),

                  // Ingredientes seleccionados
                  ValueListenableBuilder<List<Ingredient>>(
                    valueListenable: _selectedIngredients,
                    builder: (context, selectedIngredients, child) {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: selectedIngredients.map((ingredient) {
                          return Container(
                            decoration: defaultDecoration(18),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ingredient.name,
                                  style: textStyleVilaTour(color: Colors.black),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () =>
                                      _addOrRemoveIngredient(ingredient),
                                  child: const Icon(Icons.close,
                                      size: 16, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () => _selectImage(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.blue
                        ),
                        child: const Text('Añadir imagen'),
                      ),
                  ),

                  const SizedBox(height: 16),

                  ValueListenableBuilder<String?>(
                    valueListenable: _imagePath,
                    builder: (context, imagePath, child) {
                      if (imagePath == null) return const SizedBox.shrink();
                      return Center(
                        child: Image.asset(
                          imagePath,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/nextStep');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text('Siguiente'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _emptyContainer() {
    return Center(
      child: Text(
        'No se encontraron ingredientes',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  void _addOrRemoveIngredient(Ingredient ingredient) {
    _selectedIngredients.value = List.from(_selectedIngredients.value)
      ..remove(ingredient);
    _selectedIngredients.value = List.from(
        _selectedIngredients.value); // Reasigna para disparar la notificación
  }
}
