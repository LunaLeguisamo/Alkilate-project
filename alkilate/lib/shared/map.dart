import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  GoogleMapWidgetState createState() => GoogleMapWidgetState();
}

class GoogleMapWidgetState extends State<GoogleMapWidget> {
  // ignore: unused_field
  late GoogleMapController _controller;
  final Set<Marker> _markers = {}; // Para marcar lugares en el mapa

  // Ubicación inicial para centrar el mapa
  static const LatLng _center = LatLng(37.7749, -122.4194); // San Francisco

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  // Agregar un marcador en el mapa
  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(37.7749, -122.4194), // Coordenadas de un lugar
          infoWindow: InfoWindow(
            title: 'Ubicación',
            snippet: 'Este es un marcador de ejemplo.',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps en Flutter'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0, // Nivel de zoom inicial
        ),
        markers: _markers, // Mostrar los marcadores en el mapa
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMarkerButtonPressed,
        child: Icon(Icons.add_location),
      ),
    );
  }
}
