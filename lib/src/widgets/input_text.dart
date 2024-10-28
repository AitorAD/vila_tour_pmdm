import 'package:flutter/material.dart';


class InputText extends StatelessWidget {
  final String labelText;

  const InputText({
    super.key,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              labelText,
              style: TextStyle(
                fontFamily: "PontanoSans",
                fontSize: 20,
              ),
            )
          ],
        ),
        Center(
          child: TextField(),
        ),
      ]
    );
  }
}
