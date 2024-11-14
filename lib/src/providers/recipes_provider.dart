import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class RecipesProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  RecipesProvider() {
    loadRecipes(); 
  }

  Future<void> loadRecipes() async {
    final recipesData = await _getRecipes();
    _recipes = recipesData.map((data) => Recipe.fromMap(data)).toList();
    notifyListeners();
  }

/*
  void toggleFavorite(Recipe recipe) {
    recipe.favourite = !recipe.favourite;
    notifyListeners();
  }
  */
}


Future<List<Map<String, dynamic>>> _getRecipes() async {
  // Provisional hasta cargar la API
  return [
    {
        "id": 1,
        "name": "Pebrereta",
        "description": "1. Freír los pimientos a trozos con los ajos enteros: no hace falta pelarlos, basta con darles a cada uno un golpe con la mano del mortero o hacerles un corte. Reservar. \n\n2. Sofreír la calabaza y echar el tomate pelado y troceado sin semillas. \n\n3. Cuando esté casi hecho, incorporar el sangatxo puesto a remojo desde la víspera. \n\n4. Después de unos minutos, añadir el pimiento y los ajos, probar y añadir sal si fuera necesario",
        "imagePath": "https://www.turismolavilajoiosa.com/img/disfruta/Gastronomia/GastronomiaRecetario/Pebrereta/5.jpg",
        "averageScore": 4.0,
        "reviews": [],
        "approved": true,
        "ingredients": [
            {
                "idIngredient": 7,
                "name": "Sal",
                "category": "DAIRY"
            },
            {
                "idIngredient": 4,
                "name": "Sangatxo",
                "category": "FISH_AND_SEAFOOD"
            },
            {
                "idIngredient": 1,
                "name": "Pimiento verde",
                "category": "FRUITS_AND_VEGETABLES"
            },
            {
                "idIngredient": 2,
                "name": "Calabaza",
                "category": "FRUITS_AND_VEGETABLES"
            },
            {
                "idIngredient": 3,
                "name": "Tomate",
                "category": "FRUITS_AND_VEGETABLES"
            },
            {
                "idIngredient": 5,
                "name": "Aceite de oliva",
                "category": "OILS_AND_FATS"
            },
            {
                "idIngredient": 6,
                "name": "Ajo",
                "category": "SPICES_AND_HERBS"
            }
        ]
    },
    {
      "imagePath":
          "https://www.turismolavilajoiosa.com/img/disfruta/Gastronomia/GastronomiaRecetario/Nardo/nardo.jpg",
      "name": "Nardo",
      "averageScore": 4.5,
      "favourite": false,
      "description":
          "El Nardo es un cóctel popular con café granizado y absenta que se ha convertido en la bebida “típica” de La Vila Joiosa. Debe su nombre a un grupo de vileros, que al regresar de Alicante de ver una actuación de Celia Gámez acudieron al emblemático Café Mercantil. Como es habitual en La Vila mezclar bebidas espirituosas y era verano, decidieron mezclar absenta con café granizado para refrescar. Como cantaron varias veces el tema de “Tenga usted, nardos caballero...” y la mezcla les gustó, pues la bautizaron como Nardo"
    },
    {
      "imagePath":
          "https://www.turismolavilajoiosa.com/img/disfruta/Gastronomia/GastronomiaRecetario/mostralavila2.62.jpg",
      "name": "Bollets a la lloseta",
      "averageScore": 4.7,
      "favourite": true,
      "description":
          "1. Amasar la harina con agua hirviendo y un pellizco de sal. 2. Cocer en agua las acelgas limpias y troceadas, y dejarlas escurrir hasta que estén bien secas. 3. Formar discos delgados de masa, de unos 12 centímetros de diámetro, y cubrir la mitad de ellos de acelgas. 4. Espolvorear con pimentón y con unas migas de melva previamente desalada. 5. Cubrir con los otros discos de pasta y cerrar los bordes. 6. Untar con aceite y asar los 'bollos' en una 'lloseta' o sartén antiadherente."
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
