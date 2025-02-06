import 'package:flutter/material.dart';
import 'package:alkilate/shared/shared.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/homeBanner.png',
                  width: double.infinity,
                  height: 154,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 21),
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    fontWeight: FontWeight.w100, // Thin
                    fontSize: 54,
                    letterSpacing: -0.05, // -5%
                    color: Color(0xFF1B1B1B),
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'assets/images/alkilate.png',
                  width: 210.97,
                  height: 46.1,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 70),
                Container(
                  height: 30,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SearchBar(
                    leading: const Icon(Icons.search),
                    trailing: <Widget>[
                      Tooltip(
                        message: 'Filter',
                        child: Icon(
                          Icons.filter_list_outlined,
                          color: Color(0xFF1B1B1B),
                        ),
                      )
                    ],
                    hintText: 'Search',
                    hintStyle: WidgetStateProperty.all(
                        TextStyle(color: Color(0xFF808080))),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shadowColor: WidgetStateProperty.all(Color(0xFF808080)),
                    elevation: WidgetStateProperty.all(1),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Text(
                      'About Us',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 34,
                        letterSpacing: -0.03,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Vestibulum nec ultricies nunc. Nullam in purus nec nulla '
                      'vulputate lacinia. Nulla facilisi. Nullam in purus nec nulla '
                      'vulputate lacinia. Nulla facilisi.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/orders'),
                    child: const Text('Orders'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/product-detail'),
                    child: const Text('Product Detail'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/product-filter'),
                    child: const Text('Product Filter'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/product-search'),
                    child: const Text('Product Search'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                    child: const Text('Profile'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
