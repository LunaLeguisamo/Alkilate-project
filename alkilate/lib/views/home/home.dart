// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alkilate/shared/shared.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alkilate/views/products/product_search/product_search.dart'; // Adjust path as needed
import 'package:alkilate/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Send search query to suggestions API
  Future<void> _sendSearchQuery(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Sending request to API with query: $query');

      final response = await http.post(
        Uri.parse('https://alkilate-project.onrender.com/suggestions'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'query': query,
        }),
      );

      // Print full response details
      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> rawData = jsonDecode(response.body);

        // Convert to Product objects immediately
        final List<Product> products = rawData
            .map((item) {
              try {
                return Product.fromJson(item);
              } catch (e) {
                print('Error parsing product: $e');
                return Product(); // Return empty product as fallback
              }
            })
            .where((p) => p.id.isNotEmpty)
            .toList(); // Filter valid products

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductSearchScreen(
              searchResults: products,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Failed to get suggestions. Status: ${response.statusCode}';
        });
        print('API Error: ${response.body}');
      }
    } catch (e) {
      print('Exception during API call: $e');
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                    controller: _searchController,
                    leading: _isLoading
                        ? SizedBox(
                            width: 14.4,
                            height: 14.4,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : SvgPicture.asset(
                            'assets/svg/search.svg',
                            width: 14.4,
                            height: 14.4,
                          ),
                    trailing: <Widget>[
                      Tooltip(
                        message: 'Filter',
                        child: SvgPicture.asset(
                          'assets/svg/filters.svg',
                          width: 20,
                          height: 19,
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
                    onSubmitted: (value) {
                      _sendSearchQuery(value);
                    },
                  ),
                ),

                // Show error message if there was an API error
                if (_errorMessage != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),

            // Rest of your UI remains the same
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
                      'Alkilate was born as a solution within the circular economy, optimizing the use of underutilized goods and promoting a more efficient and sustainable consumption model. Through artificial intelligence, we facilitate the ideal match between those who are searching and those who are offering, ensuring secure and seamless transactions. More than just a rental platform, we offer a comprehensive experience that includes support, trust, and personalization, setting us apart from simple marketplaces. Our focus is not just on connecting parties, but on providing a complete solution that transforms the way people access what they need.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF000000),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Image(
                      image: AssetImage('assets/images/about-us.png'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
