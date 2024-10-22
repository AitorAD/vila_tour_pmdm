
import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class BarScreen extends StatelessWidget {
  final String? labelText;

  const BarScreen({
    super.key,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: defaultBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            labelText ?? "",
            style: Utils.textStyleVilaTourTitle,
          ),
        ],
      ),
    );
  }
}