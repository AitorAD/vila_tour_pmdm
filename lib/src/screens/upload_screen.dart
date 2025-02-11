import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/models/image.dart' as customImage;
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/services/image_service.dart';
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
  customImage.Image? selectedImage;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IngredientsProvider>(context, listen: false)
          .loadIngredients();
    });
    Provider.of<RecipeFormProvider>(context, listen: false).recipe = Recipe(
      type: "recipe",
      id: 0,
      creationDate: DateTime.now(),
      lastModificationDate: DateTime.now(),
      name: 'PRUEBA NOMBRE',
      description: 'PRUEBA DESCRIPCIÓN',
      ingredients: _selectedIngredients.value,
      averageScore: 0.0,
      reviews: [],
      approved: false,
      recent: true,
      creator: currentUser,
      images: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService();
    final recipeFormProvider = Provider.of<RecipeFormProvider>(context);
    final ingredientsProvider = Provider.of<IngredientsProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
          title: AppLocalizations.of(context).translate('uploadRecipe')),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const CustomNavigationBar(),
      body: Stack(
        children: [
          WavesWidget(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: recipeFormProvider.formRecipeKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(recipeFormProvider),
                    const SizedBox(height: 15),
                    _buildNameField(recipeFormProvider),
                    const SizedBox(height: 15),
                    _buildIngredientsSection(ingredientsProvider),
                    const SizedBox(height: 20),
                    _buildDescriptionSection(recipeFormProvider),
                    const SizedBox(height: 15),
                    _buildSubmitButton(recipeFormProvider, recipeService),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(RecipeFormProvider recipeFormProvider) {
    return _ProductImageStack(
      selectedImage: selectedImage?.path,
      recipeFormProvider: recipeFormProvider,
      onImageSelected: (customImage.Image? image) {
        setState(() {
          selectedImage = image;
        });
      },
    );
  }

  Widget _buildNameField(RecipeFormProvider recipeFormProvider) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('name'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) {
        recipeFormProvider.setRecipeParams(value, null);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context).translate('requiredName');
        }
        return null;
      },
    );
  }

  Widget _buildIngredientsSection(IngredientsProvider ingredientsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate('ingredients'),
          style: textStyleVilaTourTitle(color: Colors.black, fontSize: 20),
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
              hintText:
                  AppLocalizations.of(context).translate('searchIngredients'),
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
        if (_isSearchFocused) _buildIngredientsList(ingredientsProvider),
        const SizedBox(height: 16),
        _buildSelectedIngredients(),
      ],
    );
  }

  Widget _buildIngredientsList(IngredientsProvider ingredientsProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final filteredIngredients = ingredientsProvider.filteredIngredients
            .where((ingredient) =>
                !_selectedIngredients.value.contains(ingredient))
            .toList();
        final itemCount = filteredIngredients.length;
        final containerHeight = (itemCount > 3 ? 3 : itemCount) * 50.0;

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ingredient.name,
                        style: textStyleVilaTour(color: Colors.black)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _selectedIngredients.value =
                            List.from(_selectedIngredients.value)
                              ..add(ingredient);
                        ingredientsProvider.filterIngredients(
                            ingredientsProvider.currentFilter);
                        ingredientsProvider
                            .removeIngredientFromAvailable(ingredient);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSelectedIngredients() {
    return ValueListenableBuilder<List<Ingredient>>(
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
                          color: const Color.fromARGB(255, 0, 0, 0))),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _selectedIngredients.value =
                          List.from(_selectedIngredients.value)
                            ..remove(ingredient);
                      Provider.of<IngredientsProvider>(context, listen: false)
                          .filterIngredients(Provider.of<IngredientsProvider>(
                                  context,
                                  listen: false)
                              .currentFilter);
                      Provider.of<IngredientsProvider>(context, listen: false)
                          .addIngredientToAvailable(ingredient);
                    },
                    child: const Icon(Icons.close, size: 16, color: Colors.red),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDescriptionSection(RecipeFormProvider recipeFormProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate('elaboration'),
          style: textStyleVilaTourTitle(color: Colors.black, fontSize: 20),
        ),
        const SizedBox(height: 10),
        TextFormField(
          maxLines: 6,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('writeRecipeDesc'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            recipeFormProvider.setRecipeParams(null, value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)
                  .translate('pleaseWriteRecipe');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
      RecipeFormProvider recipeFormProvider, RecipeService recipeService) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: AppLocalizations.of(context).translate('send'),
          onPressed: () async {
            if (recipeFormProvider.formRecipeKey.currentState!.validate()) {
              bool? confirm = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(AppLocalizations.of(context)
                        .translate('confirmRecipe')),
                    content: Text(AppLocalizations.of(context)
                        .translate('sendrecipeMessage')),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                            AppLocalizations.of(context).translate('cancel'),
                            style: const TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text(
                            AppLocalizations.of(context).translate('send'),
                            style: const TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                try {
                  recipeFormProvider.recipe!.ingredients =
                      _selectedIngredients.value;

                  // print('RECETA FORM TO CREATE: ' + recipeFormProvider.recipe!.toString());

                  Recipe createdRecipe = await recipeService
                      .createRecipe(recipeFormProvider.recipe);

                  if (selectedImage != null) {
                    ImageService imageService = ImageService();

                    String base64Image =
                        await fileToBase64(File(selectedImage!.path));

                    // customImage.Image image = customImage.Image(path: base64Image, article: createdRecipe.id);
                    customImage.Image image = customImage.Image(path: base64Image);
                    print('IMAGE ID ARTICLE:' + createdRecipe.id.toString());

                    await imageService.uploadImage(image);
                    // recipeFormProvider.recipe!.images.add(customImage.Image(path: base64Image));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .translate('recipeSended')),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  Navigator.pushReplacementNamed(context, HomePage.routeName);
                } catch (e) {
                  print("RECETAERROR:" + e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .translate('recipeError')),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}

class _ProductImageStack extends StatelessWidget {
  RecipeFormProvider recipeFormProvider;

  _ProductImageStack({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
    required this.recipeFormProvider,
  });

  final String? selectedImage;
  final Function(customImage.Image?) onImageSelected;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 50);

      if (pickedFile != null) {
        // Cargar la imagen sin convertir a base64 inicialmente
        final image = customImage.Image(path: pickedFile.path);

        onImageSelected(image); // Pasar la imagen no codificada
      } else {
        print(AppLocalizations.of(context).translate('noImageSelected'));
      }
    } catch (e) {
      print(AppLocalizations.of(context).translate('errorSelectedImage'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RecipeImage(url: selectedImage),
        _IconPositionedButton(
          icon: Icons.photo_library_outlined,
          onPressed: () => _pickImage(context, ImageSource.gallery),
          position: const Offset(65, 12),
        ),
        _IconPositionedButton(
          icon: Icons.camera_alt_outlined,
          onPressed: () => _pickImage(context, ImageSource.camera),
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
