import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/ingredients_provider.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class UploadRecipe extends StatelessWidget {
  UploadRecipe({super.key});

  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<List<Ingredient>> _selectedIngredients = ValueNotifier([]);
  final ValueNotifier<String?> _imagePath = ValueNotifier(null);

  void _addOrRemoveIngredient(Ingredient ingredient) {
    _selectedIngredients.value = List.from(_selectedIngredients.value);
    if (_selectedIngredients.value.contains(ingredient)) {
      _selectedIngredients.value.remove(ingredient);
    } else {
      _selectedIngredients.value.add(ingredient);
    }
    _selectedIngredients.notifyListeners();
  }

  void _selectImage() {
    _imagePath.value = 'assets/logo_foreground.png'; // Imagen de ejemplo
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Subir Receta'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ingredientes',
                style: textStyleVilaTourTitle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<List<Ingredient>>(
                valueListenable: _selectedIngredients,
                builder: (context, selectedIngredients, child) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: ingredientsProvider.ingredients.map((ingredient) {
                      final isSelected = selectedIngredients.contains(ingredient);
                      return GestureDetector(
                        onTap: () => _addOrRemoveIngredient(ingredient),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.greenAccent : Colors.grey[300],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ingredient.name,
                                style: textStyleVilaTour(color: Colors.black),
                              ),
                              if (isSelected)
                                const Icon(Icons.close, size: 16, color: Colors.red),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí se manejaría la lógica para guardar la receta
                    Navigator.pushNamed(context, '/nextStep'); // Navega al siguiente paso
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text('Siguiente'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
