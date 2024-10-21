import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class GeneralFestivalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Visión General', style: Utils.textStyleVilaTour),
          flexibleSpace: DefaultDecoration(),
          foregroundColor: Colors.white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    'https://www.elperiodic.com/archivos/imagenes/noticias/2024/06/15/20240614-212734_xl.jpg',
                    width: 350,
                    height: 150,
                    fit: BoxFit.cover,
                  )),
            ),
            Title(
                color: Colors.black,
                child: Text(
                  'La Pebrereta',
                  style: TextStyle(fontFamily: 'PontanoSans', fontSize: 28),
                )),
            Row(
              children: [
                Text('4.9'),
                Icon(Icons.star, color: Color(0xFFEFCE4A)),
                Icon(Icons.star, color: Color(0xFFEFCE4A)),
                Icon(Icons.star, color: Color(0xFFEFCE4A)),
                Icon(Icons.star, color: Color(0xFFEFCE4A)),
                Text('(281)')
              ],
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(16.0),
              height: 400,
              child: SingleChildScrollView(
                child: Text(
                  'El viernes 14 de junio se celebrará la 30  edición del tradicional Concurso de Pebrereta. Este certamen culinario,  que forma parte de la programación de La Vila Gastronómica que promueve  la concejalía de Turismo, cambia este año de ubicación y se organizará  junto al mar, en el parque de la Antoneta. La concejal de Turismo, Rosa Llorca, expone que “hemos decidido trasladar este popular concurso gastronómico a la orilla del mar, a escasos metros de la ubicación original, puesto  que la plaça de la Llum se ha quedado pequeña para albergar este  certamen, en cuya localización se sobrepasa el aforo y, por ello, no se  pueden garantizar las medidas de seguridad del evento”. La nueva  ubicación conlleva también que aumente el número de participantes.  “Muchos vecinos nos han solicitado participar, porque llevan años  intentando inscribirse, pero las plazas son limitadas debido a la  capacidad de la plaza, por lo que en esta nueva localización vamos a  poder ampliar el número de participantes a todos aquellos que lo  deseen”, añade Llorca. El Concurso de  Pebrereta compartirá escenario con el Maror Festival, el festival de  música pop que se celebrará al día siguiente, 15 de de junio, por lo que el certamen culinario contará con la infraestructura y los servicios ya disponibles del Maror Festival. “Hemos querido aprovechar la organización del Maror Festival para mejorar y completar el Concurso de Pebrereta. Además de la popular competición gastronómica, amenizada por una banda de  música, dispondremos de servicio de restauración con barras y un street  food market y actuaciones musicales por lo que la fiesta se alargará esa noche junto al mar, en un enclave privilegiado”, indica la edil. Otra de las novedades de este año es la presentación del Concurso Infantil  de Pebrereta, que se celebrará esa misma tarde, previamente al concurso  de adultos en la plaça de la Llum. “El barrio del Poble Nou no se  quedará sin su tradicional concurso y por ello, hemos apostado por  organizar en la anterior localización del concurso una edición infantil, puesto que el número de participantes será más reducido que en el de  adultos”, explica Llorca. Con este nuevo concurso culinario, la  concejalía de Turismo pretende divulgar y dar a conocer la cocina  tradicional vilera entre los más pequeños. En este concurso podrán  participar niños y niñas entre 6 y 12 años, que competirán por parejas y acompañados por un adulto, que no intervendrá en la elaboración del  plato, sino que ejercerá de tutor. Los menores participantes serán  orientados por el cocinero profesional vilero Toni Mayor, quien les  guiará en cada paso.',
                  style: TextStyle(
                    fontFamily: 'PontanoSans',
                  ),
                ),
              ),
            ),
            Divider(),
            Row(
              children: [
                Icon(Icons.location_on),
                Text('Plaça de la Llum, 03570 La Vila Joiosa, Alicante')
              ],
            )
          ],
        ));
  }
}
