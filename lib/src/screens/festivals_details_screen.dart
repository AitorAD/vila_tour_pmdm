import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/screens/add_review_screen.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/favorite_floating_action_button.dart';
import 'package:vila_tour_pmdm/src/widgets/rating_row.dart';
import 'package:vila_tour_pmdm/src/widgets/reviews_info.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vila_tour_pmdm/src/models/image.dart' as customImage;

class DetailsFestival extends StatefulWidget {
  static final routeName = 'general_festival';
  const DetailsFestival({super.key});

  @override
  State<DetailsFestival> createState() => _DetailsFestivalState();
}

class _DetailsFestivalState extends State<DetailsFestival>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showFab = false; // Controla la visibilidad del botón

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 pestañas: General y Reviews
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
      showFab = _tabController.index == 1; // Muestra el botón solo en la pestaña de reseñas
    });
  }

  @override
  Widget build(BuildContext context) {
    final Festival festival = ModalRoute.of(context)!.settings.arguments as Festival;

    final filteredReviews = festival.reviews.where((review) => review.rating > 0).toList();
    final double averageScore = filteredReviews.isNotEmpty
        ? filteredReviews.map((review) => review.rating).reduce((a, b) => a + b) / filteredReviews.length
        : 0;

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButtonLocation: showFab ?
      FloatingActionButtonLocation.centerFloat :
      FloatingActionButtonLocation.endFloat,
      floatingActionButton: showFab
          ? ElevatedCustomButton(
              text: 'Añadir reseña',
              radius: 20,
              onPressed: () {
                Navigator.pushNamed(context, AddReviewScreen.routeName, arguments: festival);
              },
            )
          : FavoriteFloatingActionButton(article: festival),
      body: Stack(children: [
        WavesWidget(),
        Column(
          children: [
            BarScreenArrow(labelText: festival.name, arrowBack: true),
            TabBar(
              controller: _tabController,
              labelColor: const Color.fromARGB(255, 2, 110, 96),
              indicatorColor: const Color(0xFF01C2A9),
              tabs: const [
                Tab(text: 'General'),
                Tab(text: 'Reseñas'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Pestaña 1: General
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Hero(
                          tag: festival.id,
                          child: PageStorage(
                            bucket: PageStorageBucket(),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 350,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 5),
                                enlargeCenterPage: true,
                                viewportFraction: 0.85,
                              ),
                              items: festival.images.map((image) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FadeInImage(
                                    placeholder: AssetImage('assets/logo.ico'),
                                    image: image.path.startsWith('assets/')
                                        ? AssetImage(image.path)
                                            as ImageProvider
                                        : MemoryImage(
                                            decodeImageBase64(image.path)),
                                    width: double.infinity,
                                    height: 400,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Festival title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            festival.name,
                            style: const TextStyle(
                              fontFamily: 'PontanoSans',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Row for rating stars
                        RatingRow(
                          averageScore: averageScore,
                          reviewCount: filteredReviews.length,
                        ),

                        const Divider(),

                        // Festival description
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            festival.description,
                            style: const TextStyle(
                              fontFamily: 'PontanoSans',
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),

                        const Divider(),

                        // Location row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.redAccent),
                              const SizedBox(width: 4),
                              Text(
                                festival.coordinate.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'PontanoSans',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 5)
                      ],
                    ),
                  ),

                  // Pestaña 2: Reseñas
                  ReviewsInfo(reviews: festival.reviews)
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}


/*

      // Floating action button for "favorite"

      // El widget consumer reconstruye automaticamente el floatingActionButton
      // cuando es estado de FestivalsProvider cambia
      floatingActionButton: Consumer<FestivalsProvider>(
        builder: (context, festivalsProvider, child) {
          // Verifica si el festival actual es favorito
          final isFavourite = festivalsProvider.festivals
              .any((f) => f.name == festival.name && f.favourite);

          return FloatingActionButton(
            onPressed: () {
              festivalsProvider.toggleFavorite(festival);
            },
            backgroundColor: isFavourite ? Colors.white : Colors.redAccent,
            child: isFavourite
                ? Icon(Icons.favorite, color: Colors.redAccent)
                : Icon(Icons.favorite_border),
          );
        },
      ),

      */
