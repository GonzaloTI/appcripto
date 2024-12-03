import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapService {
  // Atributos
  late Completer<GoogleMapController> _mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> path = []; // Lista para almacenar el camino (ubicaciones)
  double zoomLevel = 19;
  LatLng? lastLocation; // Almacena la última ubicación

  // Constructor
  MapService() {
    _mapController = Completer();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        null); // Utilizar el estilo normal proporcionado por Google Maps
    _mapController.complete(controller);
  }

  // Método para inicializar el mapa y configurar el controlador
  void initializeMapController(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  // Método para agregar un marcador en una ubicación
  void addMarker(LatLng position, String markerId) {
    final Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: 'Marker: $markerId'),
    );
    markers.add(marker);
  }

  // Método para mover la cámara a una nueva ubicación
  Future<void> moveCamera(LatLng target) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(target, this.zoomLevel),
    );
  }

  // Método para eliminar un marcador
  void removeMarker(String markerId) {
    markers.removeWhere((marker) => marker.markerId.value == markerId);
  }

  // Método que maneja la creación de nuevos marcadores si la distancia es considerable
  Future<void> handleLocationUpdate(String location) async {
    // Suponiendo que el formato de location es "lat, long, user"
    List<String> parts = location.split(",");
    double lat = double.parse(parts[0].trim());
    double long = double.parse(parts[1].trim());
    String user = parts[2].trim();
    LatLng newLocation = LatLng(lat, long);

    // Si lastLocation es null, significa que no se ha creado un marcador antes
    if (lastLocation == null) {
      // La primera vez que recibimos la ubicación, creamos el marcador
      _createNewMarker(newLocation, user);
    } else if (_isDistanceConsiderable(lastLocation!, newLocation)) {
      // Si la distancia es considerable, creamos un nuevo marcador
      _createNewMarker(newLocation, user);
    }
  }

  // Función para calcular si la distancia entre dos ubicaciones es considerable (por ejemplo, 10 metros)
  bool _isDistanceConsiderable(LatLng oldLocation, LatLng newLocation) {
    // Usamos Geolocator para calcular la distancia
    double distance = Geolocator.distanceBetween(
      oldLocation.latitude,
      oldLocation.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );
    return distance > 10; // 10 metros de diferencia, puedes ajustar esto
  }

  // Método para crear un nuevo marcador y mover la cámara
  void _createNewMarker(LatLng newLocation, String user) {
    // Generar un nuevo ID único para el marcador (usando el usuario o algo aleatorio)
    String markerId =
        '${DateTime.now().millisecondsSinceEpoch}'; // Usar timestamp para ID único

    // Crear el nuevo marcador
    final newMarker = Marker(
      markerId: MarkerId(markerId),
      position: newLocation,
      infoWindow: InfoWindow(
        title: 'Usuario: $user',
        snippet: 'Ubicación: ${newLocation.latitude}, ${newLocation.longitude}',
      ),
    );

    // Agregar el nuevo marcador al conjunto
    markers.add(newMarker);
// Agregar la nueva ubicación al camino
    path.add(newLocation);

    // Actualizar la última ubicación
    lastLocation = newLocation;
    // Crear o actualizar el Polyline
    _updatePolyline();
    // Mover la cámara a la nueva ubicación
    moveCamera(newLocation);
  }

  // Método para crear o actualizar el Polyline
  void _updatePolyline() {
    if (path.length > 1) {
      // Crear un nuevo Polyline con el camino
      final polyline = Polyline(
        polylineId: PolylineId('path'),
        points: path,
        color: Colors.blue,
        width: 5,
      );
      polylines.add(polyline);
    }
  }
}
