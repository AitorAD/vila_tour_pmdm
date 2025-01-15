import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/place_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class PlacesScreen extends StatefulWidget {
  static final routeName = 'places_screen';
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<Place>> _placesFuture;
  List<Place> _filteredPlaces = [];
  String _selectedAttribute = 'name'; // Atributo inicial para filtrar

  @override
  void initState() {
    super.initState();
    final placeService = PlaceService();
    _placesFuture = placeService.getPlaces();
  }

  void _filterPlaces(String query, List<Place> places) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = places;
      } else {
        _filteredPlaces = places.where(
          (place) {
            final value = _getAttributeValue(place, _selectedAttribute);
            return value != null &&
                value.toLowerCase().contains(query.toLowerCase());
          },
        ).toList();
      }
    });
  }

  String? _getAttributeValue(Place place, String attribute) {
    switch (attribute) {
      case 'name':
        return place.name;
      case 'description':
        return place.description;
      case 'categoryPlace.name':
        return place.categoryPlace.name;
      case 'averageScore':
        return place.averageScore.toString();
      default:
        return null;
    }
  }

  void _showFilterOptions() {
    final Map<String, String> filterOptions = {
      'Nombre': 'name',
      'Descripción': 'description',
      'Tipo': 'categoryPlace.name',
      'Puntuación': 'averageScore',
    };

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: filterOptions.keys.map((label) {
                final attribute = filterOptions[label]!;
                return CheckboxListTile(
                  title: Text(label), // Muestra el nombre en español
                  value: _selectedAttribute == attribute,
                  onChanged: (isSelected) {
                    setState(() {
                      // Actualiza el estado de las opciones
                      _selectedAttribute =
                          isSelected ?? false ? attribute : _selectedAttribute;

                      // Aplicar el filtro
                      _placesFuture.then((places) {
                        _filterPlaces(searchController.text, places);
                      });
                    });

                    Navigator.pop(context);
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: WavesWidget(),
          ),
          Column(
            children: [
              BarScreenArrow(labelText: 'Lugares', arrowBack: true),
              SearchBox(
                hintText: 'Buscar lugares',
                controller: searchController,
                onChanged: (text) {
                  _placesFuture.then((places) => _filterPlaces(text, places));
                },
                onFilterPressed: _showFilterOptions,
              ),
              Expanded(
                child: FutureBuilder<List<Place>>(
                  future: _placesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No se encontraron lugares.'));
                    } else {
                      final places = _filteredPlaces.isEmpty
                          ? snapshot.data!
                          : _filteredPlaces;

                      return ListView.builder(
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          final place = places[index];
                          return ArticleBox(article: place);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
