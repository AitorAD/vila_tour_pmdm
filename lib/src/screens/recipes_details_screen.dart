import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/reviews_info.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RecipeDetails extends StatefulWidget {
  static final routeName = 'general_recipe';
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

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showFab
          ? ElevatedCustomButton(
              text: 'Añadir reseña',
              radius: 20,
              onPressed: () {
                Navigator.pushNamed(context, AddReviewScreen.routeName, arguments: recipe);
              },
            )
          : null,
      body: Stack(children: [
        WavesWidget(),
        Column(
          children: [
            BarScreenArrow(labelText: recipe.name, arrowBack: true),
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
                            indent: 0,
                            endIndent: 0,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Preparación',
                            style: textStyleVilaTourTitle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            recipe.description,
                            style: const TextStyle(fontSize: 16),
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
                          style: textStyleVilaTourTitle(color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        Hero(
                          tag: recipe.id, // Mismo tag que en ArticleBox
                          child: FadeInImage(
                            placeholder: AssetImage('assets/logo.ico'),
                            image: recipe.images.isNotEmpty
                                ? MemoryImage(
                                    decodeImageBase64(recipe.images.first.path))
                                : AssetImage('assets/logo_foreground.png')
                                    as ImageProvider,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Row for rating stars
                        Container(
                          width: 300,
                          height: 50,
                          decoration: defaultDecoration(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                recipe.averageScore.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'PontanoSans',
                                ),
                              ),
                              const SizedBox(width: 4),
                              PaintStars(
                                  rating: recipe.averageScore,
                                  color: Colors.yellow),
                              const SizedBox(width: 4),
                              Text(
                                '(${recipe.reviews.length})',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
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
