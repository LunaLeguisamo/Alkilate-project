import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    print('Tapped index: $index'); // Debugging
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update _currentIndex based on the current route
    final route = ModalRoute.of(context)?.settings.name;
    switch (route) {
      case '/':
        _currentIndex = 0;
        break;
      case '/product-search':
        _currentIndex = 1;
        break;
      case '/add-product':
        _currentIndex = 2;
        break;
      case '/user-orders':
        _currentIndex = 3;
        break;
      case '/profile':
        _currentIndex = 4;
        break;
      default:
        _currentIndex = 0; // Default to Home
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
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/home.svg',
                width: 35,
                height: 35,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/home_active.svg',
                width: 35,
                height: 35,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/lupa.svg',
                width: 31.8,
                height: 32.7,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/lupa_active.svg',
                width: 31.8,
                height: 32.7,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.plus, size: 35),
              activeIcon: Icon(FontAwesomeIcons.plus, size: 35),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/shopping_bag.svg',
                width: 36.2,
                height: 34.6,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/shopping_bag.svg',
                width: 36.2,
                height: 34.6,
              ),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/user.svg',
                width: 31.7,
                height: 34.6,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/user_active.svg',
                width: 31.7,
                height: 34.6,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
