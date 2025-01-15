import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/festival_service.dart';
import '../widgets/widgets.dart';

class FestivalsScreen extends StatefulWidget {
  static final routeName = 'festivals_screen';
  const FestivalsScreen({super.key});

  @override
  _FestivalsScreenState createState() => _FestivalsScreenState();
}

class _FestivalsScreenState extends State<FestivalsScreen> {
  late Future<List<Festival>> _festivalsFuture;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      appBar: CustomAppBar(title: 'Festivales y Tradiciones'),
      body: Stack(
        children: [
          WavesWidget(),
          FutureBuilder<List<Festival>>(
            future: _festivalsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No se encontraron festivales.'));
              } else {
                List<Festival> festivals = snapshot.data!;

                return ListView.builder(
                  itemCount: festivals.length,
                  itemBuilder: (context, index) {
                    final festival = festivals[index];
                    return ArticleBox(article: festival);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
