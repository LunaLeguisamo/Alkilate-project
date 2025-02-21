import 'package:alkilate/shared/shared.dart';
import 'package:alkilate/views/products/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ProductSearchScreenState createState() => ProductSearchScreenState();
}

class ProductSearchScreenState extends State<ProductSearchScreen> {
  bool showFilters = false;
  bool isLoading = true; // Track loading state
  TextEditingController searchController = TextEditingController();

  String? category;
  String? brand;
  String? model;
  double priceRangeMin = 0;
  double priceRangeMax = 3000;
  DateTime? selectedDate;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      List<Product> products = await fetchedProducts();
      setState(() {
        this.products = products;
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  // Fetch products from Firestore
  fetchedProducts() async {
    dynamic products = await FirestoreService().getProductList();
    return products;
  }

  // Filter options
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
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 45,
            ),
            Container(
              height: 30,
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SearchBar(
                leading: SvgPicture.asset(
                  'assets/svg/search.svg',
                  width: 14.4,
                  height: 14.4,
                ),
                trailing: <Widget>[
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Tooltip(
                      message: 'Filter',
                      child: SvgPicture.asset(
                        'assets/svg/filters.svg',
                        width: 20,
                        height: 19,
                      ),
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
            // Display loading spinner or product grid
            isLoading
                ? Column(
                    children: [
                      SizedBox(height: 150),
                      Loader(),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductDetailScreen(
                                        product: products[index]),
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
                                // Image
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  child: Image.network(
                                    products[index].pictures[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                // Gradient overlay
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 60, // 1/3 of the card height
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0x99000000),
                                          Colors
                                              .transparent, // Transparent at the top
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Text overlay
                                Positioned(
                                  bottom: 8.5,
                                  left: 12.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index].name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '\$${products[index].price} / Day',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
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

              // Date filter
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
