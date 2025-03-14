import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RecipeDetails extends StatefulWidget {
  static const routeName = 'general_recipe';
  const RecipeDetails({super.key});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showFab = false; // Controla la visibilidad del botón

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 1, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange); // Limpia el listener
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      showFab =
          _tabController.index == 2; // Muestra el botón solo en el índice 2
    });
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    final filteredReviews =
        recipe.reviews.where((review) => review.rating > 0).toList();
    final double averageScore = filteredReviews.isNotEmpty
        ? filteredReviews
                .map((review) => review.rating)
                .reduce((a, b) => a + b) /
            filteredReviews.length
        : 0;

    return Scaffold(
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButtonLocation: showFab
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: showFab
          ? ElevatedCustomButton(
              text: AppLocalizations.of(context).translate('addReview'),
              radius: 20,
              onPressed: () {
                Navigator.pushNamed(context, AddReviewScreen.routeName,
                    arguments: recipe);
              },
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (recipe.creator.id == currentUser.id)
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      UploadRecipe.routeName,
                      arguments: recipe,
                    );
                  },
                  child: const Icon(Icons.edit),
                ),
                const SizedBox(width: 10),
                FavoriteFloatingActionButton(article: recipe),
              ],
            ),
      body: Stack(children: [
        const WavesWidget(),
        Column(
          children: [
            BarScreenArrow(labelText: recipe.name, arrowBack: true),
            TabBar(
              controller: _tabController,
              indicatorColor: const Color.fromARGB(255, 54, 71, 71),
              tabs: [
                Tab(text: AppLocalizations.of(context).translate('recipe')),
                Tab(
                    text: AppLocalizations.of(context)
                        .translate('generalVision')),
                Tab(text: AppLocalizations.of(context).translate('reviews')),
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
                            indent: 0,
                            endIndent: 0,
                          ),
                          const SizedBox(height: 10),
                          Text(
                              AppLocalizations.of(context)
                                  .translate('preparation'),
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            recipe.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tab 2: Visión General
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          recipe.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        Hero(
                          tag: recipe.id, // Mismo tag que en ArticleBox
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage(
                              placeholder: const AssetImage('assets/logo.ico'),
                              image: recipe.images.isNotEmpty
                                  ? MemoryImage(decodeImageBase64(
                                      recipe.images.first.path))
                                  : const AssetImage(
                                          'assets/logo_foreground.png')
                                      as ImageProvider,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Row for rating stars
                        RatingRow(
                          averageScore: averageScore,
                          reviewCount: filteredReviews.length,
                        ),

                        const SizedBox(height: 10),
                        // Label for creator's name
                        Text(
                          '${AppLocalizations.of(context).translate('created_by')} ${recipe.creator.username}',
                          style: const TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        ),

                        const Divider(height: 20),

                        IngredientsWrap(ingredients: recipe.ingredients),
                      ],
                    ),
                  ),

                  // Tab 3: Reseñas
                  ReviewsInfo(reviews: recipe.reviews)
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class IngredientsWrap extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientsWrap({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate('ingredients'),
          style: Theme.of(context).textTheme.titleLarge,
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
