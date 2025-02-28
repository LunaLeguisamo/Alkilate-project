import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../services/firestore.dart';
import '../services/models.dart' as app_models;

class LocationFilterWidget extends StatefulWidget {
  final Function(List<app_models.Product>) onProductsFound;

  const LocationFilterWidget({super.key, required this.onProductsFound});

  @override
  State<LocationFilterWidget> createState() => _LocationFilterWidgetState();
}

class _LocationFilterWidgetState extends State<LocationFilterWidget> {
  double _radiusInKm = 5.0; // Default radius
  bool _isLoading = false;
  String? _errorMessage;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Radius slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text('Search radius: '),
              Expanded(
                child: Slider(
                  value: _radiusInKm,
                  min: 1.0,
                  max: 50.0,
                  divisions: 49,
                  label: '${_radiusInKm.toStringAsFixed(0)} km',
                  onChanged: (value) {
                    setState(() {
                      _radiusInKm = value;
                    });
                  },
                ),
              ),
              Text('${_radiusInKm.toStringAsFixed(0)} km'),
            ],
          ),
        ),

        // Search button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _searchNearbyProducts,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.search),
            label: Text(_isLoading ? 'Searching...' : 'Find Nearby Products'),
          ),
        ),

        // Error message
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Future<void> _searchNearbyProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
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

      // Get products by filter
      final products = await _firestoreService.getProductsByFilter(
        currentLocation.latitude!,
        currentLocation.longitude!,
        _radiusInKm,
      );

      // Notify parent with found products
      widget.onProductsFound(products);

      if (products.isEmpty) {
        setState(() {
          _errorMessage = 'No products found in the selected radius';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
