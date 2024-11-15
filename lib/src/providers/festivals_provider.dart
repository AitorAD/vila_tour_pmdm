import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';

class FestivalsProvider with ChangeNotifier {
  String _baseUrl = 'http://10.0.2.2:8080'; // En Android Emulator
  // String _baseUrl = 'http://192.168.x.x:8080'; // En Dispositivo físico
  // String _baseUrl = 'http://localhost:8080'; // En iOS o navegador

  List<Festival> _festivals = [];
  List<Festival> get festivals => _festivals;
  set festivals(List<Festival> list) => _festivals = list;

  FestivalsProvider() {
    loadFestivals();
    _deleteAllFestivals();
    _makeFestivals();
    print('Festivals Provider Iniciado');
  }

  Future<String> _getJsonData(String endpoint) async {
    var url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url);
    return response.body;
  }

  void loadFestivals() async {
    final jsonData = await _getJsonData('festivals');
    print('JSON recibido: $jsonData');
    final festivalList = Festival.fromJsonList(json.decode(jsonData));
    // print('Festival list: ${festivalList}');
    festivals = festivalList;
    notifyListeners();
  }

  /*
  void toggleFavorite(Festival festival) {
    festival.favourite = !festival.favourite;
    notifyListeners();
  }
  */

  Future<void> _addFestival(Festival festival) async {
    final url = Uri.parse('$_baseUrl/festivals');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(festival.toMap()),
    );
    notifyListeners();
  }

  Future<void> _deleteFestival(int festivalId) async {
    final url = Uri.parse('$_baseUrl/festivals/$festivalId');
    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
    );
    notifyListeners();
  }

  void _deleteAllFestivals() {
    loadFestivals();
    festivals.forEach((f) => _deleteFestival(f.id));
  }

  void _makeFestivals() {
    List<Festival> festivales = [
      Festival(
        id: 0,
        name: "Moros y Cristianos",
        description:
            "La fiesta principal de Villajoyosa, en la que se recrea la batalla entre moros y cristianos, incluyendo un espectacular desembarco en la playa.",
        imagensPaths: [
          'https://upload.wikimedia.org/wikipedia/commons/2/2b/Jaleo_en_Mercadal_5.jpg',
        ],
        averageScore: 4.8,
        creationDate: DateTime.parse("2024-11-14T20:28:24"),
        lastModificationDate: DateTime.parse("2024-11-14T20:28:24"),
        reviews: [],
        startDate: DateTime.parse("2024-07-24"),
        endDate: DateTime.parse("2024-07-31"),
        coordinade: null,
      ),
      Festival(
        id: 0,
        name: "Fiesta de Santa Marta",
        description:
            "Fiesta en honor a Santa Marta, patrona de Villajoyosa, con procesiones y eventos religiosos y culturales.",
        imagensPaths: [
          'https://upload.wikimedia.org/wikipedia/commons/2/2b/Jaleo_en_Mercadal_5.jpg',
        ],
        averageScore: 4.6,
        creationDate: DateTime.parse("2024-11-14T20:28:24"),
        lastModificationDate: DateTime.parse("2024-11-14T20:28:24"),
        reviews: [],
        startDate: DateTime.parse("2024-07-25"),
        endDate: DateTime.parse("2024-07-29"),
        coordinade: null,
      ),
      Festival(
        id: 0,
        name: "Semana Santa",
        description:
            "Celebración religiosa que incluye procesiones tradicionales por las calles de Villajoyosa.",
        imagensPaths: [
          'https://upload.wikimedia.org/wikipedia/commons/2/2b/Jaleo_en_Mercadal_5.jpg',
        ],
        averageScore: 4.3,
        creationDate: DateTime.parse("2024-11-14T20:28:24"),
        lastModificationDate: DateTime.parse("2024-11-14T20:28:24"),
        reviews: [],
        startDate: DateTime.parse("2024-03-25"),
        endDate: DateTime.parse("2024-04-01"),
        coordinade: null,
      ),
      Festival(
        id: 0,
        name: "Fiesta de San Antonio",
        description:
            "Festividad popular en honor a San Antonio, con actividades tradicionales y bendición de animales.",
        imagensPaths: [
          'https://upload.wikimedia.org/wikipedia/commons/2/2b/Jaleo_en_Mercadal_5.jpg',
        ],
        averageScore: 4.1,
        creationDate: DateTime.parse("2024-11-14T20:28:24"),
        lastModificationDate: DateTime.parse("2024-11-14T20:28:24"),
        reviews: [],
        startDate: DateTime.parse("2024-01-17"),
        endDate: DateTime.parse("2024-01-17"),
        coordinade: null,
      ),
      Festival(
        id: 0,
        name: "Carnaval de Villajoyosa",
        description:
            "Desfiles y celebraciones en las calles para celebrar el carnaval, incluyendo disfraces y música.",
        imagensPaths: [
          'https://upload.wikimedia.org/wikipedia/commons/2/2b/Jaleo_en_Mercadal_5.jpg',
        ],
        averageScore: 4.2,
        creationDate: DateTime.parse("2024-11-14T20:28:24"),
        lastModificationDate: DateTime.parse("2024-11-14T20:28:24"),
        reviews: [],
        startDate: DateTime.parse("2024-02-09"),
        endDate: DateTime.parse("2024-02-11"),
        coordinade: null,
      ),
    ];
    festivales.forEach((f) => _addFestival(f));
    loadFestivals();
  }
}

/*
Future<List<Map<String, dynamic>>> _getFestivals() async {
  // Provisional hasta cargar la API
  return [
    {
      "imagePath":
          "https://www.elperiodic.com/archivos/imagenes/noticias/2024/06/15/20240614-221327.jpg",
      "name": "Sant Miquel",
      "location": "Plaza de la Iglesia - La Ermita",
      "date": "26 - 29 Septiembre",
      "averageScore": 4.7,
      "favourite": true,
      "description":
          "La fiesta de Sant Miquel es una celebración que tiene lugar en la Plaza de la Iglesia - La Ermita. Se rinde homenaje al patrón de la localidad con una serie de actividades culturales y religiosas. La festividad incluye una misa solemne, una procesión por las calles del pueblo, danzas tradicionales y una feria gastronómica donde se pueden degustar platos típicos de la región. Durante estos días, los fuegos artificiales iluminan el cielo, creando un ambiente festivo y mágico."
    },
    {
      "imagePath":
          "https://upload.wikimedia.org/wikipedia/commons/2/2b/Jaleo_en_Mercadal_5.jpg",
      "name": "Festa de Sant Marti",
      "location": "Calle Mayor",
      "date": "11 Noviembre",
      "averageScore": 4.5,
      "favourite": false,
      "description":
          "La Festa de Sant Marti se celebra el 11 de noviembre en la Calle Mayor y es una tradición que une a la comunidad en torno a la figura del patrón de los agricultores. La festividad comienza con una misa en honor a Sant Marti, seguida de actividades populares que incluyen música en vivo, danzas folklóricas y ferias de productos locales. Los habitantes visten trajes tradicionales y la celebración culmina con un banquete comunitario donde se disfrutan delicias culinarias de la región."
    },
    {
      "imagePath":
          "https://www.turismolavilajoiosa.com/img/Disfruta/TradicionYFiesta/FiestaMorosYCristianos/PRIMER%20PREMI%20ACTES%20FESTERS%20PEDRO%20MARCET%20BALDO%202011%20.jpg",
      "name": "Fiestas Patronales",
      "location": "Centro Histórico",
      "date": "Del 16 al 24 Julio",
      "averageScore": 4.8,
      "favourite": false,
      "description":
          "Las Fiestas Patronales son una de las celebraciones más grandes de La Vila Joiosa, que se llevan a cabo en el Centro Histórico del pueblo. Durante diez días, la ciudad se llena de vida con procesiones, actuaciones musicales, eventos deportivos y actividades culturales. Los asistentes disfrutan de ferias de comida, conciertos y espectáculos de danzas tradicionales. Esta celebración es un tributo a los patrones de la ciudad, y destaca la historia y la cultura de la comunidad."
    },
    {
      "imagePath":
          "https://estaticos-cdn.prensaiberica.es/clip/b6f460ff-4892-4dba-b8c3-a41f08dc75eb_alta-libre-aspect-ratio_default_0.jpg",
      "name": "Festa del Xocolate",
      "location": "Plaza del Ayuntamiento",
      "date": "Finales de Enero",
      "averageScore": 4.6,
      "favourite": false,
      "description":
          "La Festa del Xocolate se celebra a finales de enero en la Plaza del Ayuntamiento, y es un homenaje a uno de los productos más emblemáticos de la localidad: el chocolate. Durante esta festividad, los visitantes pueden disfrutar de actividades como talleres de cocina, degustaciones de chocolate y competiciones de postres. La feria también incluye música en vivo y espectáculos para toda la familia, convirtiéndola en una experiencia inolvidable para los amantes del dulce."
    },
    {
      "imagePath":
          "https://cf-images.eu-west-1.prod.boltdns.net/v1/static/6057955885001/29433785-3b07-44b4-a9e3-4180c9cdadb8/14513ec2-bcc3-4e92-8129-e0376bb0fd81/1280x720/match/image.jpg",
      "name": "Festa de Santa Cecilia",
      "location": "Auditorio de La Vila Joiosa",
      "date": "22 Noviembre",
      "averageScore": 4.4,
      "favourite": false,
      "description":
          "La Festa de Santa Cecilia, celebrada el 22 de noviembre en el Auditorio de La Vila Joiosa, es una fiesta dedicada a la música y a los músicos. Durante esta festividad, se realizan conciertos, recitales y actuaciones de diversas agrupaciones musicales de la localidad. La comunidad se une para rendir homenaje a Santa Cecilia, la patrona de los músicos, con eventos que promueven la cultura musical y el talento local."
    },
    {
      "imagePath":
          "https://lh3.googleusercontent.com/proxy/4kItJrBjmwrINqVu0PS2O8GGfb_9ywFs25kO9PqxuE5vbWwFf7hCEQDMzOfBtLiiKSBUM4TJJhxnjyGeJ6bm10u3YrBzC44XV1xJhiEGopKJ",
      "name": "Festa de les 800",
      "location": "Plaza de la Vila",
      "date": "Último fin de semana de Febrero",
      "averageScore": 4.3,
      "favourite": false,
      "description":
          "La Festa de les 800 es una celebración única que tiene lugar el último fin de semana de febrero en la Plaza de la Vila. Esta festividad conmemora la historia local con actividades que incluyen recreaciones históricas, ferias de artesanía y gastronomía, y actuaciones de música tradicional. Los visitantes pueden disfrutar de un ambiente festivo mientras exploran la rica historia y cultura de La Vila Joiosa."
    },
    {
      "imagePath":
          "https://www.villajoyosa.com/documentos/imagenes/not_10435_1.jpg",
      "name": "Festa de la Creu",
      "location": "Ermita de la Creu",
      "date": "3 Mayo",
      "averageScore": 4.2,
      "favourite": false,
      "description":
          "La Festa de la Creu se celebra el 3 de mayo en la Ermita de la Creu y es una tradición que une a la comunidad en un evento religioso y festivo. Durante esta celebración, los habitantes decoran la cruz con flores y participan en una misa en honor a la cruz. Después de la ceremonia, la festividad continúa con actividades lúdicas y culturales, incluyendo música y danza, que atraen a visitantes de toda la región."
    },
    {
      "imagePath":
          "https://www.elperiodic.com/archivos/imagenes/noticias/2023/01/23/524b015f-1a39-4151-94df-2d1179a53cba.jpg",
      "name": "Festa de San Antonio",
      "location": "Calle San Antonio",
      "date": "17 Enero",
      "averageScore": 4.5,
      "favourite": false,
      "description":
          "La Festa de San Antonio se celebra el 17 de enero en la Calle San Antonio y es una festividad llena de tradición y devoción. Los habitantes participan en una misa en honor al santo, seguida de una procesión en la que se llevan a cabo danzas y cantos típicos. La celebración incluye actividades culturales, ferias de productos locales y una variedad de espectáculos que mantienen viva la herencia cultural de la comunidad."
    },
    {
      "imagePath":
          "https://estaticos-cdn.prensaiberica.es/clip/33b1a7f6-abf3-419b-96fe-4b88ffc9562e_16-9-discover-aspect-ratio_default_0.jpg",
      "name": "Festa dels Trons",
      "location": "Plaza del Ayuntamiento",
      "date": "Segundo fin de semana de Octubre",
      "averageScore": 4.6,
      "favourite": false,
      "description":
          "La Festa dels Trons, que se celebra el segundo fin de semana de octubre en la Plaza del Ayuntamiento, es una festividad vibrante que destaca por sus impresionantes espectáculos pirotécnicos. Durante este evento, se realizan exhibiciones de fuegos artificiales y tracas que iluminan el cielo y llenan el ambiente de emoción. Los asistentes disfrutan de una variedad de actividades culturales, ferias gastronómicas y música en vivo, convirtiendo la Festa dels Trons en un evento imperdible."
    }
  ];
}
*/