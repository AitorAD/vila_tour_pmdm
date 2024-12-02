import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

/*
class BarScreenArrow extends StatelessWidget {
  final String? labelText;
  final VoidCallback onBackPressed;

  const BarScreenArrow({
    super.key,
    this.labelText,
    required this.onBackPressed, // Este parámetro es obligatorio
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: defaultDecoration(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBackPressed, // Llama al callback al presionar
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            Text(
              labelText ?? "",
              style: textStyleVilaTourTitle(color: Colors.white),
            ),
            Icon(
              Icons.arrow_back,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
*/

class BarScreenArrow extends StatelessWidget {
  final bool arrowBack;
  final String labelText;
  final IconButton? iconRight;

  const BarScreenArrow({
    super.key,
    required this.labelText,
    required this.arrowBack,
    this.iconRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: defaultDecoration(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  labelText,
                  style: textStyleVilaTourTitle(color: Colors.white),
                )),
            if (iconRight != null)
              Align(
                alignment: Alignment.centerRight,
                child: iconRight,
              )
          ],
        ),
      ),
    );
  }
}
