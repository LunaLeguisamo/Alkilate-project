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
      'assets/images/images.jpg',
      'assets/images/image2.png',
      'assets/images/image3.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrusel de imágenes
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

            // Indicador de página
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.blue,
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                ),
              ),
            ),

            // Contenido del producto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Electric Treadmill for Rent – High-Quality, Adjustable Speed & Incline',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    child: Text(
                      '\$299.99',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        // Estrellas de calificación
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30.0,
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
                        Spacer(), // Espacio para alinear el botón a la derecha
                        // Botón de disponibilidad
                        ElevatedButton.icon(
                          onPressed: () {
                            print('Botón presionado');
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.white, // Cambia el color del icono
                          ),
                          label: Text(
                            'See availability',
                            style: TextStyle(
                                color:
                                    Colors.white), // Cambia el color del texto
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .black, // Cambia el color de fondo del botón
                            foregroundColor: Colors
                                .white, // Cambia el color del texto e icono
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0), // Añade padding si lo deseas
                            shape: RoundedRectangleBorder(
                              // Opción para cambiar la forma del botón
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('Description:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    'Kickstart your workout routine with this high-quality electric treadmill, now available for rent! Perfect for those who want to exercise at home without committing to long-term investments or taking up too much space. This treadmill features a compact and sleek design, making it ideal for any environment.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  // Sección de características principales
                  SizedBox(height: 20), // Espacio antes de la sección
                  Text('Main Features:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeatureItem(
                            text:
                                'Adjustable speed: Change the speed to match your fitness level.'),
                        FeatureItem(
                            text:
                                'Adjustable incline: Increase workout intensity by choosing different incline levels.'),
                        FeatureItem(
                            text:
                                'Digital display: Shows data like speed, distance, time, and calories burned to track your progress.'),
                        FeatureItem(
                            text:
                                'Cushioning system: Reduces joint impact, providing a more comfortable running experience.'),
                        FeatureItem(
                            text:
                                'Sturdy construction: Made with durable materials, perfect for regular use.'),
                        FeatureItem(
                            text:
                                'Easy storage: Folds up easily to save space when not in use.'),
                      ],
                    ),
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

// Widget para mostrar cada característica de forma ordenada
class FeatureItem extends StatelessWidget {
  final String text;
  const FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.black, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
