import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/screens/favorites.dart';
import 'package:movie_bank_mobile/screens/search.dart';

void navigateToPage(int currentPage, int navigateTo, BuildContext context) {
  if (navigateTo == currentPage) {
    return;
  } else if (navigateTo == 0) {
    Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );
  } else if (navigateTo == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Search(),
      ),
    );
  } else if (navigateTo == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Favorites(),
      ),
    );
  }
}

Widget getBottomNavigationBar(int currentPage, BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Color(0xff323143).withOpacity(0.8),
    unselectedItemColor: Colors.white.withOpacity(0.5),
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search_outlined),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.star_border),
        label: 'Favorites',
      ),
    ],
    currentIndex: currentPage,
    selectedItemColor: Colors.white,
    onTap: (index) => navigateToPage(currentPage, index, context),
  );
}
