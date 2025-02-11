import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class BarScreenArrow extends StatelessWidget {
  final bool arrowBack;
  final String labelText;
  final Widget? iconRight;

  const BarScreenArrow({
    super.key,
    required this.labelText,
    required this.arrowBack,
    this.iconRight,
  });

  @override
  Widget build(BuildContext context) {
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
            child: Row(
              children: [
                if (arrowBack == true)
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                if (arrowBack == false) const Spacer(),
                Expanded(
                  child: Text(
                    labelText,
                    style: textStyleVilaTourTitle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: arrowBack ? TextAlign.start : TextAlign.center,
                  ),
                ),
                if (arrowBack == false) const Spacer(),
                if (iconRight != null)
                  iconRight!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
