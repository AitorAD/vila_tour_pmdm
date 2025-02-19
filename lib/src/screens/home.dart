import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/services/services.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home_screen';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Índice actual del slider

  late Future<List<Article>> _futureArticles; // Define el future aquí

  @override
  void initState() {
    super.initState();
    _futureArticles =
        ArticleService().getLastArticles(); // Asigna el future solo una vez
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavigationBar(),
      body: Stack(
        children: [
          const WavesWidget(),
          SingleChildScrollView(
            child: Column(
              children: [
                BarScreenArrow(labelText: 'VILATOUR', arrowBack: false),
                SizedBox(
                  height: 320,
                  child: FutureBuilder(
                    future: _futureArticles,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        List<Article> articles = snapshot.data!;

                        return Column(
                          children: [
                            CarouselSlider.builder(
                              options: carouselOptions(),
                              itemCount: articles.length,
                              itemBuilder: (context, index, realIndex) {
                                var article = articles[index];
                                return ImageCarousel(article: article);
                              },
                            ),
                            const SizedBox(height: 10),
                            DockIndex(
                              articles: articles,
                              currentIndex: _currentIndex,
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(AppLocalizations.of(context).translate('noArticles')),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
                const _MainContent()
              ],
            ),
          ),
        ],
      ),
    );
  }

  CarouselOptions carouselOptions() {
    return CarouselOptions(
      height: 300,
      autoPlay: true, // Reproducción automática
      autoPlayInterval: const Duration(seconds: 3), // Intervalo
      enlargeCenterPage: true, // Resalta la diapositiva central
      viewportFraction: 0.9, // Ocupa el 90% del ancho de la pantalla
      onPageChanged: (index, reason) {
        setState(() {
          _currentIndex = index; // Actualiza el índice actual
        });
      },
    );
  }
}

class DockIndex extends StatelessWidget {
  const DockIndex({
    super.key,
    required this.articles,
    required int currentIndex,
  }) : _currentIndex = currentIndex;

  final List<Article> articles;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        articles.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 12 : 8, // Tamaño del punto
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? Colors.blueAccent // Color activo
                : Colors.grey, // Color inactivo
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            _SingleCard(
              route: PlacesScreen.routeName,
              color: Colors.blueAccent,
              icon: Icons.place,
              text: AppLocalizations.of(context).translate('places'),
            ),
            _SingleCard(
              route: FestivalsScreen.routeName,
              color: Colors.pinkAccent,
              icon: Icons.celebration,
              text: AppLocalizations.of(context).translate('festivals'),
            ),
          ],
        ),
        TableRow(
          children: [
            _SingleCard(
              route: RecipesScreen.routeName,
              color: Colors.purpleAccent,
              icon: Icons.restaurant_menu,
              text: AppLocalizations.of(context).translate('recipes'),
            ),
            _SingleCard(
              route: RoutesScreen.routeName,
              color: Colors.purple,
              icon: Icons.map,
              text: AppLocalizations.of(context).translate('routes'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String route;

  const _SingleCard({
    required this.icon,
    required this.color,
    required this.text,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: 100,
              height: 160,
              decoration: defaultDecoration(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: color,
                    child: Icon(icon, size: 35, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
