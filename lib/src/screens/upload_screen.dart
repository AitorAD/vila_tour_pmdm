import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/ingredients_provider.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class UploadRecipe extends StatelessWidget {
  UploadRecipe({super.key});

  final ValueNotifier<String?> _imagePath = ValueNotifier(null);
  final ValueNotifier<List<Ingredient>> _selectedIngredients = ValueNotifier([]);

  void _selectImage() {
    _imagePath.value = 'assets/logo_foreground.png'; // Imagen de ejemplo
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
                    style: textStyleVilaTourTitle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(height: 10),

                  // Barra de búsqueda para ingredientes usando SearchBar
                  SearchBar<Ingredient>(
                    hintText: 'Buscar Ingrediente',
                    onSearch: (query) async {
                      ingredientsProvider.filterIngredients(query);
                      return ingredientsProvider.filteredIngredients;
                    },
                    onItemSelected: (ingredient) {
                      _selectedIngredients.value = List.from(_selectedIngredients.value)
                        ..add(ingredient);
                      _selectedIngredients.notifyListeners();
                    },
                    itemBuilder: (context, ingredient) {
                      return ListTile(
                        title: Text(ingredient.name),
                        onTap: () {
                          _selectedIngredients.value = List.from(_selectedIngredients.value)
                            ..add(ingredient);
                          _selectedIngredients.notifyListeners();
                        },
                      );
                    },
                    noItemsFoundBuilder: (context) => _emptyContainer(),
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
                                  onTap: () => _addOrRemoveIngredient(ingredient),
                                  child: const Icon(Icons.close, size: 16, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _selectImage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFF25C1CE),
                    ),
                    child: const Text('Cargar foto'),
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
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
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
    _selectedIngredients.value = List.from(_selectedIngredients.value)..remove(ingredient);
    _selectedIngredients.notifyListeners();
  }
}
