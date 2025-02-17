import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class BarScreenArrow extends StatelessWidget {
  final bool arrowBack;
  String labelText;
  final Widget? iconRight;

  BarScreenArrow({
    super.key,
    required this.labelText,
    required this.arrowBack,
    this.iconRight,
  });

  @override
  Widget build(BuildContext context) {
    if (labelText.length > 18){
      labelText = '${labelText.substring(0, 18)}...';
    }

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(top: 25),
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Container(
          height: 50,
          decoration: defaultDecoration(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (arrowBack == true)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: Center(
                      child: Text(
                        labelText,
                        style: textStyleVilaTourTitle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                if (iconRight != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: iconRight,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
