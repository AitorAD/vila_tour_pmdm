import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // 2 pestañas: General y Reviews
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Festival festival =
        ModalRoute.of(context)!.settings.arguments as Festival;

    return Scaffold(
      appBar: CustomAppBar(title: festival.name),
      body: Stack(
        children: [
          WavesWidget(),
          Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: const Color.fromARGB(255, 54, 71, 71),
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
                                  borderRadius: BorderRadius.circular(
                                      20),
                                  child: FadeInImage(
                                    placeholder: AssetImage('assets/logo.ico'),
                                    image: image.path.startsWith('assets/')
                                        ? AssetImage(image.path) as ImageProvider
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
                        Container(
                          width: 300,
                          height: 50,
                          decoration: defaultDecoration(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                festival.averageScore.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'PontanoSans',
                                ),
                              ),
                              const SizedBox(width: 4),
                              PaintStars(
                                  rating: festival.averageScore,
                                  color: Colors.yellow),
                              const SizedBox(width: 4),
                              Text(
                                '(${festival.reviews.length})',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Reseñas:',
                          style: textStyleVilaTourTitle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]
      ),
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
