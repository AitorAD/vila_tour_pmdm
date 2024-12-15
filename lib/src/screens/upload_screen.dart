import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/ingredients_provider.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/services/recipe_service.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/recipe_image.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class UploadRecipe extends StatefulWidget {
  static const routeName = 'upload_recipe';
  UploadRecipe({super.key});

  @override
  State<UploadRecipe> createState() => _UploadRecipeState();
}

class _UploadRecipeState extends State<UploadRecipe> {
  final ValueNotifier<List<Ingredient>> _selectedIngredients =
      ValueNotifier([]);
  String? selectedImage;
  bool _isSearchFocused = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IngredientsProvider>(context, listen: false)
          .loadIngredients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Subir Receta'),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const CustomNavigationBar(),
      body: Stack(
        children: [
          WavesWidget(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProductImageStack(
                      selectedImage: selectedImage,
                      onImageSelected: (String? image) {
                        setState(() {
                          selectedImage = image;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre de la receta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Ingredientes',
                      style: textStyleVilaTourTitle(
                          color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    FocusScope(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          _isSearchFocused = hasFocus;
                        });
                      },
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar ingredientes...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          ingredientsProvider.filterIngredients(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isSearchFocused)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final filteredIngredients = ingredientsProvider
                              .filteredIngredients
                              .where((ingredient) => !_selectedIngredients.value
                                  .contains(ingredient))
                              .toList();
                          final itemCount = filteredIngredients.length;
                          final containerHeight =
                              (itemCount > 3 ? 3 : itemCount) * 50.0;

                          return Container(
                            height: containerHeight,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: itemCount,
                              itemBuilder: (context, index) {
                                final ingredient = filteredIngredients[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ingredient.name,
                                          style: textStyleVilaTour(
                                              color: Colors.black)),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          _selectedIngredients.value = List
                                              .from(_selectedIngredients.value)
                                            ..add(ingredient);
                                          ingredientsProvider.filterIngredients(
                                              ingredientsProvider
                                                  .currentFilter);
                                          ingredientsProvider
                                              .removeIngredientFromAvailable(
                                                  ingredient);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
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
                                  Text(ingredient.name,
                                      style: textStyleVilaTour(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0))),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      _selectedIngredients.value =
                                          List.from(_selectedIngredients.value)
                                            ..remove(ingredient);
                                      ingredientsProvider.filterIngredients(
                                          ingredientsProvider.currentFilter);
                                      ingredientsProvider
                                          .addIngredientToAvailable(ingredient);
                                    },
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
                    const SizedBox(height: 20),
                    Text(
                      'Elaboración',
                      style: textStyleVilaTourTitle(
                          color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Escribe la descripción de la receta...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la descripción de la receta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: "Enviar",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        '¿Estás seguro de enviar la receta?'),
                                    content: const Text(
                                        'Una vez enviada, la receta irá a revisión.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(
                                              color: Colors
                                                  .black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(false);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Enviar',
                                          style: TextStyle(
                                              color: Colors
                                                  .black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(true);
                                        }
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                final recipe = Recipe(
                                  type: "recipe",
                                  id: 0,
                                  creationDate: DateTime.now(),
                                  lastModificationDate: DateTime.now(),
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  ingredients: _selectedIngredients.value,
                                  averageScore: 1.2,
                                  reviews: [],
                                  approved: false,
                                  recent: true,
                                  creator: currentUser,
                                );

                                try {
                                  final recipeService = RecipeService();
                                  await recipeService.createRecipe(recipe);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Receta enviada a revisión'),
                                      duration: Duration(
                                          seconds: 2),
                                    ),
                                  );

                                  Navigator.pushReplacementNamed(
                                      context, HomePage.routeName);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Error al enviar la receta'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

class _ProductImageStack extends StatelessWidget {
  const _ProductImageStack({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
  });

  final String? selectedImage;
  final Function(String?) onImageSelected;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: source, imageQuality: 100);
    if (pickedFile != null) {
      onImageSelected(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RecipeImage(url: selectedImage),
        _IconPositionedButton(
          icon: Icons.photo_library_outlined,
          onPressed: () => _pickImage(ImageSource.gallery),
          position: const Offset(65, 12),
        ),
        _IconPositionedButton(
          icon: Icons.camera_alt_outlined,
          onPressed: () => _pickImage(ImageSource.camera),
          position: const Offset(15, 12),
        ),
      ],
    );
  }
}

class _IconPositionedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Offset position;

  const _IconPositionedButton({
    required this.icon,
    required this.onPressed,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      right: position.dx,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, size: 45),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
