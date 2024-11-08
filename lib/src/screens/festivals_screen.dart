import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_app_bar.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

import '../providers/festivals_provider.dart';

class FestivalsScreen extends StatelessWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provisional hasta conectar con la API
    final festivasProvider = Provider.of<FestivalsProvider>(context);

    return Scaffold(
        appBar: CustomAppBar(title: 'Festivales y Tradiciones'),
        body: Stack(
          children: [
            WavesWidget(),
            Column(
              children: [
                SearchBox(),
                Expanded(
                  child: ListView.builder(
                    itemCount: festivasProvider.festivals.length,
                    itemBuilder: (context, index) {
                      return ArticleBox(article: festivasProvider.festivals[index],);
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
