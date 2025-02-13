import 'package:alkilate/views/products/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/shared/shared.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ProductSearchScreenState createState() => ProductSearchScreenState();
}

class ProductSearchScreenState extends State<ProductSearchScreen> {
  bool showFilters = false;
  TextEditingController searchController = TextEditingController();

  String? category;
  String? brand;
  String? model;
  double priceRangeMin = 0;
  double priceRangeMax = 3000;
  DateTime? selectedDate;

  // Lista de productos con imágenes locales
  List<Map<String, String>> products = [
    {'name': 'Cars', 'image': 'assets/images/car.jpg'},
    {'name': 'treadmill', 'image': 'assets/images/cami.png'},
  ];

  // Opciones de filtros
  List<String> categories = [
    'Category',
    'Electronics',
    'Fashion',
    'Sports',
    'Toys'
  ];
  List<String> brands = ['Brand', 'Brand 1', 'Brand 2', 'Brand 3'];
  List<String> models = ['Model', 'Model 1', 'Model 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Product Search', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search products',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Botón de filtrado al lado de la barra de búsqueda
                  IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.black),
                    onPressed: () {
                      _showFilterDialog();
                    },
                  ),
                ],
              ),
            ),

            // Lista de productos
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProductDetailScreen(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: Image.asset(
                              products[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.6),
                              child: Text(
                                products[index]['name']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Filters'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: category ?? categories[0],
                items: categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newCategory) {
                  setState(() {
                    category = newCategory;
                  });
                },
              ),
              SizedBox(height: 16),

              DropdownButton<String>(
                isExpanded: true,
                value: brand ?? brands[0],
                items: brands.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newBrand) {
                  setState(() {
                    brand = newBrand;
                  });
                },
              ),
              SizedBox(height: 16),

              DropdownButton<String>(
                isExpanded: true,
                value: model ?? models[0],
                items: models.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newModel) {
                  setState(() {
                    model = newModel;
                  });
                },
              ),
              SizedBox(height: 16),

              // Filtro por fecha
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Text(
                  selectedDate == null
                      ? 'Select Rent Date'
                      : 'Selected Date: ${selectedDate!.toLocal()}'
                          .split(' ')[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Apply Filters'),
            ),
          ],
        );
      },
    );
  }
}
