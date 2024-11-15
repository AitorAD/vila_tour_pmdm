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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: currentIndex,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (int i) {
        uiProvider.selectedMenuOpt = i;

        String routeName;
        switch (i) {
          case 0:
            routeName = '/';
            break;
          case 1:
            routeName = 'uploadRecipe';
            break;
          case 2:
            routeName = 'map';
            break;
          case 3:
            routeName = 'profile';
            break;
          default:
            routeName = '/';
        }

        Navigator.pushNamed(context, routeName);
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black54,
      backgroundColor: const Color(0xFF25C1CE),
    );
  }
}
