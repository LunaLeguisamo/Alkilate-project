import 'package:alkilate/services/models.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  double rating = 3.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/cami.png',
      'assets/images/image2.png',
      'assets/images/image3.png',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Product Detail', style: TextStyle(fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrusel de imágenes
            SizedBox(
              height: 350,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Indicador de página
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.black,
                  dotHeight: 10.0,
                  dotWidth: 10.0,
                ),
              ),
            ),

            // Contenido del producto
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Electric Treadmill for Rent – High-Quality, Adjustable Speed & Incline',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$299.99',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Rating bar
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 28.0,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.black,
                        ),
                        onRatingUpdate: (value) {
                          setState(() {
                            rating = value;
                          });
                        },
                      ),
                      Spacer(),
                      // Botón
                      ElevatedButton.icon(
                        onPressed: () {
                          print('Botón');
                        },
                        icon: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        label: Text(
                          'See availability',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Description:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    'Kickstart your workout routine with this high-quality electric treadmill, now available for rent! Perfect for those who want to exercise at home without committing to long-term investments or taking up too much space.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  // Sección de características principales
                  SizedBox(height: 30),
                  Text('Main Features:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FeatureItem(
                          text:
                              'Adjustable speed: Change the speed to match your fitness level.',
                          icon: Icons.speed),
                      FeatureItem(
                          text:
                              'Adjustable incline: Increase workout intensity by choosing different incline levels.',
                          icon: Icons.arrow_upward),
                      FeatureItem(
                          text:
                              'Digital display: Shows data like speed, distance, time, and calories burned to track your progress.',
                          icon: Icons.screen_search_desktop),
                      FeatureItem(
                          text:
                              'Cushioning system: Reduces joint impact, providing a more comfortable running experience.',
                          icon: Icons.hotel),
                      FeatureItem(
                          text:
                              'Sturdy construction: Made with durable materials, perfect for regular use.',
                          icon: Icons.build),
                      FeatureItem(
                          text:
                              'Easy storage: Folds up easily to save space when not in use.',
                          icon: Icons.storage),
                    ],
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

// Widget para mostrar cada característica
class FeatureItem extends StatelessWidget {
  final String text;
  final IconData icon;
  const FeatureItem({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
