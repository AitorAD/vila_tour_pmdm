import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/ui_provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: 'add'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'person')
      ],
      currentIndex: currentIndex,
      elevation: 0,
      onTap: (int i) => uiProvider.selectedMenuOpt = i,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
