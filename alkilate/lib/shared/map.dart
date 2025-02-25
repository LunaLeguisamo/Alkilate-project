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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestLocationPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error requesting location permission'));
        } else {
          return SizedBox(
            height: 200, // Set a fixed height for the map
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(-34.9011, -56.1645), // Montevideo, Uruguay
                zoom: 12,
              ),
              myLocationEnabled: true, // Enable My Location button
              myLocationButtonEnabled: true, // Show My Location button
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
                        markerId: MarkerId('selectedLocation'),
                        position: _selectedLocation!,
                        icon: BitmapDescriptor
                            .defaultMarker, // Use default marker
                      ),
                    },
            ),
          );
        }
      },
    );
  }
}

Future<void> requestLocationPermission() async {
  Location location = Location();
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  PermissionStatus permissionStatus = await location.hasPermission();
  if (permissionStatus == PermissionStatus.denied) {
    permissionStatus = await location.requestPermission();
    if (permissionStatus != PermissionStatus.granted) {
      return;
    }
  }
}
