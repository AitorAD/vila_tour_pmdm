
import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class BarScreenLogin extends StatelessWidget {
  final String? labelText;

  const BarScreenLogin({
    super.key,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: defaultDecoration(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            labelText ?? "",
            style: textStyleVilaTourTitle,
          ),
        ],
      ),
    );
  }
}