import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/festival_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class FestivalsScreen extends StatefulWidget {
  static final routeName = 'festivals_screen';
  const FestivalsScreen({super.key});

  @override
  _FestivalsScreenState createState() => _FestivalsScreenState();
}

class _FestivalsScreenState extends State<FestivalsScreen> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<Festival>> _festivalsFuture;
  List<Festival> _filteredFestivals = [];
  String _selectedAttribute = 'name'; // Atributo inicial para filtrar

  @override
  void initState() {
    super.initState();
    _loadFestivals();
  }

  void _loadFestivals() {
    final festivalService = FestivalService();
    setState(() {
      _festivalsFuture = festivalService.getFestivals();
    });
  }

  void _filterFestivals(String query, List<Festival> festivals) {
    setState(() {
      if (query.isEmpty) {
        _filteredFestivals = festivals;
      } else {
        _filteredFestivals = festivals.where(
          (festival) {
            final value = _getAttributeValue(festival, _selectedAttribute);
            return value != null &&
                value.toLowerCase().contains(query.toLowerCase());
          },
        ).toList();
      }
    });
  }

  String? _getAttributeValue(Festival festival, String attribute) {
    switch (attribute) {
      case 'name':
        return festival.name;
      case 'description':
        return festival.description;
      case 'coordinate.name':
        return festival.coordinate.name;
      case 'averageScore':
        return festival.averageScore.toString();
      default:
        return null;
    }
  }

  void _showFilterOptions() {
    final Map<String, String> filterOptions = {
      'Nombre': 'name',
      'Descripción': 'description',
      'Ubicación': 'coordinate.name',
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
                      _festivalsFuture.then((festivals) {
                        _filterFestivals(searchController.text, festivals);
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
              BarScreenArrow(
                  labelText: 'Festivales y Tradiciones', arrowBack: true),
              SearchBox(
                hintText: 'Buscar festivales',
                controller: searchController,
                onChanged: (text) {
                  _festivalsFuture
                      .then((festivals) => _filterFestivals(text, festivals));
                },
                onFilterPressed: _showFilterOptions,
              ),
              Expanded(
                child: FutureBuilder<List<Festival>>(
                  future: _festivalsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No se encontraron festivales.'));
                    } else {
                      final festivals = _filteredFestivals.isEmpty
                          ? snapshot.data!
                          : _filteredFestivals;
                      ListView list = ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: festivals.length,
                        itemBuilder: (context, index) {
                          final festival = festivals[index];
                          return ArticleBox(article: festival);
                        },
                      );
                      print("ACABA AQUI: " + DateTime.now().toString());
                      return list;
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
