import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/festival.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

import '../providers/festivals_provider.dart';

class FestivalsScreen extends StatelessWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provisional hasta conectar con la API
    final festivasProvider = Provider.of<FestivalsProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Festivales y Tradiciones',
            style: Utils.textStyleVilaTour,
          ),
          flexibleSpace: DefaultDecoration(),
          foregroundColor: Colors.white,
        ),
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
