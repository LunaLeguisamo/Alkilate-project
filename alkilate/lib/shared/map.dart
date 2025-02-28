import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPickerWidget extends StatefulWidget {
  final Function(LatLng)? onLocationSelected;

  const LocationPickerWidget({super.key, this.onLocationSelected});

  @override
  LocationPickerWidgetState createState() => LocationPickerWidgetState();
}

class LocationPickerWidgetState extends State<LocationPickerWidget> {
  LatLng? _selectedLocation;
  bool _isLoading = true;
  String? _errorMessage;
  LocationData? _currentLocation;
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation != null
                        ? LatLng(
                            _currentLocation!.latitude!,
                            _currentLocation!.longitude!,
                          )
                        : const LatLng(-34.9011, -56.1645), // Default location
                    zoom: 16,
                  ),
                  myLocationEnabled: true, // Enable My Location button
                  myLocationButtonEnabled: true, // Show My Location button
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  onTap: (LatLng location) {
                    print('Tapped location: $location'); // Debugging
                    setState(() {
                      _selectedLocation = location;
                    });
                    if (widget.onLocationSelected != null) {
                      widget.onLocationSelected!(location);
                    }
                  },
                  markers: _selectedLocation == null
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('selectedLocation'),
                            position: _selectedLocation!,
                            icon: BitmapDescriptor.defaultMarker,
                          ),
                        },
                  cloudMapId: 'edaa0dfe7e90088b', // Optional: Custom map style
                ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      await requestLocationPermission();
      await _getCurrentLocation();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> requestLocationPermission() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service is disabled.');
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        throw Exception('Location permission denied.');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    try {
      _currentLocation = await location.getLocation();
      if (_mapController != null && _currentLocation != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
          ),
        );
      }
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }
}
