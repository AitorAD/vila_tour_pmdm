import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailsFestival extends StatefulWidget {
  static const routeName = 'general_festival';
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
    _tabController =
        TabController(length: 2, vsync: this); // 2 pestañas: General y Reviews
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
      showFab = _tabController.index ==
          1; // Muestra el botón solo en la pestaña de reseñas
    });
  }

  @override
  Widget build(BuildContext context) {
    final Festival festival =
        ModalRoute.of(context)!.settings.arguments as Festival;

    final filteredReviews =
        festival.reviews.where((review) => review.rating > 0).toList();
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
                    arguments: festival);
              },
            )
          : FavoriteFloatingActionButton(article: festival),
      body: Stack(children: [
        const WavesWidget(),
        Column(
          children: [
            BarScreenArrow(labelText: festival.name, arrowBack: true),
            TabBar(
              controller: _tabController,
              labelColor: const Color.fromARGB(255, 2, 110, 96),
              indicatorColor: const Color(0xFF01C2A9),
              tabs: [
                Tab(text: AppLocalizations.of(context).translate('general')),
                Tab(text: AppLocalizations.of(context).translate('reviews')),
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
                                autoPlayInterval: const Duration(seconds: 5),
                                enlargeCenterPage: true,
                                viewportFraction: 0.85,
                              ),
                              items: festival.images.map((image) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FadeInImage(
                                    placeholder:
                                        const AssetImage('assets/logo.ico'),
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
                            style: Theme.of(context).textTheme.titleLarge,
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
                          child: Text(festival.description,
                              style: Theme.of(context).textTheme.bodyLarge),
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
                                style: Theme.of(context).textTheme.titleLarge
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
