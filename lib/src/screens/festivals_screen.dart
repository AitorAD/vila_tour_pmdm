import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/models/image.dart' as customImage;
import 'package:vila_tour_pmdm/src/services/festival_service.dart';
import 'package:vila_tour_pmdm/src/services/image_service.dart';
import '../widgets/widgets.dart';

class FestivalsScreen extends StatelessWidget {
  static final routeName = 'festivals_screen';
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final festivalService = FestivalService();

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      appBar: CustomAppBar(title: 'Festivales y Tradiciones'),
      body: Stack(
        children: [
          WavesWidget(),
          FutureBuilder<List<Festival>>(
            future: festivalService.getFestivals(),
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
