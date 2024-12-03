import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../service/constant.dart';
import '../service/mapservice.dart';
import '../service/socket.dart';

class CodeScreen extends StatefulWidget {
  final String code; // El código que se pasa desde HomeScreen

  const CodeScreen({super.key, required this.code});

  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  late IO.Socket socket;

  late SocketService socketService; // Instancia de la clase SocketService
  String locationUpdate = "Esperando actualizaciones...";
  String connectionStatus = "Conectando...";
  final Completer<GoogleMapController> _mapController = Completer();

  late final MapService mapcontroller;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  // Método que se llama cuando el mapa se crea, completando el Completer
  void _onMapCreated(GoogleMapController controller) {
    mapcontroller.onMapCreated(controller);
  }

  @override
  void initState() {
    super.initState();

    mapcontroller = MapService();
    // Crear una instancia de SocketService y pasarle los callbacks
    socketService = SocketService(
      onLocationUpdate: (location) {
        if (mounted) {
          print('nuevo loc $location');

          // Suponiendo que el formato de location es "lat, long, user"
          /*   List<String> parts = location.split(",");
          double lat = double.parse(parts[0].trim());
          double long = double.parse(parts[1].trim());
          String user = parts[2].trim();
          final newMarker = Marker(
            markerId: MarkerId(user), // Usamos el usuario como ID único
            position: LatLng(lat, long),
            infoWindow: InfoWindow(
              title: 'Usuario: $user',
              snippet: 'Ubicación: $lat, $long',
            ),
          );*/
          mapcontroller.handleLocationUpdate(location);
          setState(() {
            locationUpdate = location;
            //    _markers.add(newMarker);
            _markers = mapcontroller.markers;
          });
          // Mover la cámara a la nueva ubicación
          //  mapcontroller.moveCamera(LatLng(lat, long));
        }
      },
      onConnectionStatusChange: (status) {
        if (mounted) {
          setState(() {
            connectionStatus = status;
          });
        }
      },
    );

    // Conectar al servidor con la URL y el código de la sala
    socketService.connect(constserver, widget.code);
  }

  @override
  void dispose() {
    // Desconectar el socket cuando se destruye el widget
    socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Código Ingresado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Código ingresado: ${widget.code}',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 20),
            Text(
              connectionStatus, // Muestra el estado de la conexión
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: connectionStatus.contains("Error")
                        ? Colors.red
                        : Colors.green,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              locationUpdate, // Mostrar la ubicación recibida
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),

            SizedBox(height: 20),
            // Mapa de Google
            Container(
              height: 300,
              width: double.infinity,
              child: GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(0.0, 0.0), // Ubicación inicial (se puede ajustar)
                  zoom: 19.0, // Nivel de zoom inicial
                ),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true, // Habilitar el botón de ubicación
                myLocationButtonEnabled:
                    true, // Habilitar el botón de ubicación
                markers: _markers, // Pasamos los marcadores actualizados
                polylines: mapcontroller.polylines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
