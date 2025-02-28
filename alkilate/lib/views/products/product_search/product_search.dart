// ignore_for_file: use_build_context_synchronously

import 'package:alkilate/shared/shared.dart';
import 'package:alkilate/views/products/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ProductSearchScreenState createState() => ProductSearchScreenState();
}

class ProductSearchScreenState extends State<ProductSearchScreen> {
  bool showFilters = false;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  // Location filter variables
  double radiusInKm = 5.0;
  bool isLocationEnabled = false;
  bool isLocationLoading = false;
  String? locationErrorMessage;

  String? category;
  double priceRangeMin = 0;
  double priceRangeMax = 3000;
  DateTime? selectedDate;
  List<Product> products = [];

  final FirestoreService _firestoreService = FirestoreService();

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
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch products from Firestore
  fetchedProducts() async {
    dynamic products = await FirestoreService().getProductList();
    return products;
  }

  // Search nearby products based on current location
  Future<void> _searchNearbyProducts(BuildContext dialogContext) async {
    setState(() {
      isLocationLoading = true;
      locationErrorMessage = null;
    });

    try {
      // Get current location
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled');
        }
      }

      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          throw Exception('Location permission not granted');
        }
      }

      LocationData currentLocation = await location.getLocation();

      if (currentLocation.latitude == null ||
          currentLocation.longitude == null) {
        throw Exception('Could not get current location');
      }

      setState(() {
        isLoading = true;
      });

      // Get products by filter
      final locationProducts = await _firestoreService.getProductsByFilter(
        currentLocation.latitude!,
        currentLocation.longitude!,
        radiusInKm,
      );

      setState(() {
        products = locationProducts;
        isLoading = false;
      });

      if (locationProducts.isEmpty) {
        setState(() {
          locationErrorMessage = 'No products found within $radiusInKm km';
        });
      }

      // Close the dialog using the dialog's context
      Navigator.pop(dialogContext);
    } catch (e) {
      setState(() {
        locationErrorMessage = 'Error: $e';
        isLoading = false;
      });
    } finally {
      setState(() {
        isLocationLoading = false;
      });
    }
  }

  // Filter options
  List<String> categories = [
    'Category',
    'Electronics',
    'Fashion',
    'Sports',
    'Toys'
  ];

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

            // Location filter status text if enabled
            if (locationErrorMessage != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                child: Text(
                  locationErrorMessage!,
                  style: TextStyle(color: Colors.red),
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
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Select Filters'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Location-based filters
                    SwitchListTile(
                      title: Text('Enable Location Filter'),
                      value: isLocationEnabled,
                      onChanged: (value) {
                        setDialogState(() {
                          isLocationEnabled = value;
                        });
                      },
                    ),

                    if (isLocationEnabled) ...[
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child:
                                Text('Search radius: ${radiusInKm.toInt()} km'),
                          ),
                        ],
                      ),
                      Slider(
                        value: radiusInKm,
                        min: 1.0,
                        max: 50.0,
                        divisions: 49,
                        label: '${radiusInKm.toInt()} km',
                        onChanged: (value) {
                          setDialogState(() {
                            radiusInKm = value;
                          });
                        },
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: isLocationLoading
                            ? null
                            : () => _searchNearbyProducts(context),
                        child: isLocationLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Find Nearby Products',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      Text('Or use standard filters:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],

                    SizedBox(height: 16),
                    // Original filters remain the same
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
                        setDialogState(() {
                          category = newCategory;
                        });
                      },
                    ),

                    // Rest of your existing filters

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
                    // Apply non-location filters here
                    Navigator.of(context).pop();
                  },
                  child: Text('Apply Filters'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
