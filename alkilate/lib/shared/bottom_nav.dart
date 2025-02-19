import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/product-search');
        break;
      case 2:
        Navigator.pushNamed(context, '/add-product');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-orders');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(17, 0, 0, 0),
            blurRadius: 9,
            spreadRadius: 0.1,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(40), // Rounded top corners
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          unselectedItemColor: const Color(0xFFB5B5B5),
          selectedItemColor: const Color(0xFF87AAE4),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house, size: 20),
              activeIcon: Icon(FontAwesomeIcons.house, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.magnifyingGlass, size: 20),
              activeIcon: Icon(FontAwesomeIcons.magnifyingGlass, size: 24),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.plus, size: 20),
              activeIcon: Icon(FontAwesomeIcons.plus, size: 24),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bagShopping, size: 20),
              activeIcon: Icon(FontAwesomeIcons.bagShopping, size: 24),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user, size: 20),
              activeIcon: Icon(FontAwesomeIcons.user, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
