import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

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
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded), label: 'add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_rounded), label: 'map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'person')
        ],
        currentIndex: currentIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (int i) => uiProvider.selectedMenuOpt = i,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        backgroundColor: Color(0xFF25C1CE));
  }
}
