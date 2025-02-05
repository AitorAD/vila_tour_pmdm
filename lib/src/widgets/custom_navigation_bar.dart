import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/screens/map_screen.dart';
import 'package:vila_tour_pmdm/src/screens/upload_screen.dart';
import 'package:vila_tour_pmdm/src/screens/user_screen.dart';

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
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded), label: 'Add'),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on_rounded), label: 'Map'),
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
            routeName = HomePage.routeName;
            break;
          case 1:
            routeName = UploadRecipe.routeName;
            break;
          case 2:
            routeName = MapScreen.routeName;
            break;
          case 3:
            routeName = UserScreen.routeName;
            break;
          default:
            routeName = HomePage.routeName;
            break;
        }

        // Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
        // Determinar cual de los 2 metodos usar
        Navigator.pushReplacementNamed(context, routeName);
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black54,
      backgroundColor: const Color(0xFF25C1CE),
    );
  }
}
