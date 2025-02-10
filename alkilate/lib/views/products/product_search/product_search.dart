import 'package:flutter/material.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({Key? key}) : super(key: key);

  @override
  ProductSearchScreenState createState() => ProductSearchScreenState();
}

class ProductSearchScreenState extends State<ProductSearchScreen> {
  bool showFilters = false;
  TextEditingController searchController = TextEditingController();

  String? category;
  double priceRangeMin = 0;
  double priceRangeMax = 500;
  String? brand;
  String? model;
  DateTime? selectedDate;

  List<Map<String, String>> products = [
    {'name': 'Cars', 'image': 'assets/images/imageses.jpg'},
    {'name': 'Birthday', 'image': 'assets/images/cami.png'},
    {'name': 'Sport', 'image': 'assets/images/imageses.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                showFilters = !showFilters;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.black),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search products',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Mostrar los filtros si showFilters es verdadero
            if (showFilters)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtro por categoría
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.category),
                      ),
                      onChanged: (value) {
                        setState(() {
                          category = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Rango de precio
                    Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: RangeValues(priceRangeMin, priceRangeMax),
                      min: 0,
                      max: 1000,
                      divisions: 10,
                      labels: RangeLabels(
                        '\$${priceRangeMin.toStringAsFixed(0)}',
                        '\$${priceRangeMax.toStringAsFixed(0)}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          priceRangeMin = values.start;
                          priceRangeMax = values.end;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Filtro por marca
                    TextField(
                      controller: TextEditingController(text: brand),
                      decoration: InputDecoration(
                        labelText: 'Brand',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.branding_watermark),
                      ),
                      onChanged: (value) {
                        setState(() {
                          brand = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Filtro por modelo
                    TextField(
                      controller: TextEditingController(text: model),
                      decoration: InputDecoration(
                        labelText: 'Model',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.monitor_heart_sharp),
                      ),
                      onChanged: (value) {
                        setState(() {
                          model = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Filtro por fecha
                    ElevatedButton(
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
                            : 'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

            // Lista de productos en formato más estético
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Image.asset(
                            products[index]['image']!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            products[index]['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
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
}
