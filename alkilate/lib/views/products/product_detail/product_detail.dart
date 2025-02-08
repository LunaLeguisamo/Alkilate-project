import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  // Controlador de la página para manejar la posición del carrusel
  final PageController _pageController = PageController();

  // Variable para manejar la calificación del producto (0 a 5)
  double rating = 3.0;

  @override
  void initState() {
    super.initState();
    // Añadir listener para que la UI se actualice con el cambio de página
    _pageController.addListener(() {
      setState(() {});  // Esto actualizará el estado cada vez que cambie la página
    });
  }

  @override
  void dispose() {
    _pageController.dispose();  // No olvidar liberar recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lista de imágenes para el carrusel
    final List<String> images = [
      'assets/images/banner-profile.jpg',
      'assets/images/image1.png',
      'assets/images/image2.png',
      'assets/images/image3.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Column(
        children: [
          // Carrusel de imágenes
          SizedBox(
            height: 300, // Altura del carrusel
            child: PageView.builder(
              controller: _pageController, // Asignamos el PageController aquí
              itemCount: images.length, // Número de imágenes
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover, // Asegura que la imagen se ajuste bien al tamaño
                  ),
                );
              },
            ),
          ),

          // Indicador de página (SmoothPageIndicator)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SmoothPageIndicator(
              controller: _pageController, // Usamos el mismo PageController
              count: images.length, // Número de imágenes
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.blue, // Color del punto activo
                dotHeight: 8.0, // Altura del punto
                dotWidth: 8.0, // Ancho del punto
              ),
            ),
          ),

          // Contenido (Título, Descripción y Precio)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Detalles del producto a la izquierda
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Title',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Product Description',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Botón de acción (a la derecha)
                // Calificación de estrellas (debajo del precio)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: RatingBar.builder(
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
          ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica del botón (Ejemplo)
                    print('Botón presionado');
                  },
                  icon: Icon(Icons.calendar_month),  // Ícono para el botón
                  label: Text('See availability'),  // Texto del botón
                ),
              ],
            ),
          ),

          // Precio (debajo del título y descripción)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Text(
              '\$299.99', // Ejemplo de precio
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          
        ],
      ),
    );
  }
}
