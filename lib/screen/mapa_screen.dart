import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; // Importar geolocator
import 'package:permission_handler/permission_handler.dart'; // Usamos PermissionStatus de permission_handler
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../service/constant.dart';
import '../service/servicebackground.dart';
import '../service/socket.dart'; // Importar Provider

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final service = FlutterBackgroundService();
  late GoogleMapController mapController;
  // Usamos Completer para controlar la inicialización del controlador del mapa
  // Completer para el controlador del mapa
  final Completer<GoogleMapController> _mapController = Completer();

  bool _isLocationPermissionGranted = false;
  bool _isSharingLocation =
      false; // Estado para alternar entre compartir/no compartir
  bool _isSharingLocationprovider =
      false; // Estado para alternar entre compartir/no compartir

  Set<Marker> _markers = {};
  Timer? _locationTimer;

  late IO.Socket socket;
  String coderoom =
      'fa8140d6-712c-4cfa-b050-0c04ee7776dd'; // DEBERIA SER EL NUMERO DEL CLIENTE , QUE FUNCIONA COMO ROOMID
  late SocketService socketService; // Instancia de la clase SocketService

  // Método para obtener la ubicación del usuario usando geolocator
  Future<void> _getLocation() async {
    // Verificar permisos usando permission_handler
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      setState(() {
        _isLocationPermissionGranted = true;
      });

      // Obtener la ubicación usando Geolocator
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // Esperar a que el controlador del mapa esté disponible
      final GoogleMapController controller = await _mapController.future;

      setState(() {
        // Agregar un marcador en la ubicación actual
        _markers.add(
          Marker(
            markerId: const MarkerId('user_location3'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Mi Ubicación'),
          ),
        );

        // Actualizar la cámara del mapa con la ubicación del usuario
        controller.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      });
    } else {
      setState(() {
        _isLocationPermissionGranted = false;
      });
      // Puedes mostrar un mensaje o un diálogo al usuario sobre la falta de permisos
    }
  }

  Future<void> _getsocket() async {
    // Constructor que solo recibe la URL y el roomId

    SharedPreferences pref = await SharedPreferences.getInstance();
    String codigoApoderado = pref.getString('roomId') ?? '';
    coderoom = codigoApoderado;
    socketService = SocketService.conectar(
      constserversocket, // URL del servidor
      coderoom, // Room ID
    );
  }

  // Método para alternar entre compartir/no compartir la ubicación

  void _toggleLocationSharing() {
    final backgroundService =
        Provider.of<BackgroundService>(context, listen: false);

    if (!_isSharingLocationprovider) {
      // Iniciar el servicio si no está corriendo
      backgroundService.start();
    } else {
      // Detener el servicio si está corriendo
      backgroundService.stop();
    }

    setState(() {
      _isSharingLocationprovider = !_isSharingLocationprovider;
    });
  }

  // Método para inicializar el mapa
  // Método que se llama cuando el mapa se crea, completando el Completer
  void _onMapCreated(GoogleMapController controller) {
    _mapController
        .complete(controller); // Completar el Completer con el controlador
  }

  // Método para iniciar el envío de la ubicación
  void _startSharingLocation() {
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      // Obtener la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Imprimir la ubicación en la consola
      print(
          "Ubicación actual: Latitud=${position.latitude}, Longitud=${position.longitude}");
      socketService.emitir(
          coderoom, position.latitude, position.longitude, "User");
      // Opcional: Puedes actualizar los marcadores o realizar otra acción aquí
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('live_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Ubicación actualizada'),
          ),
        );
      });
    });
  }

  // Método para detener el envío de la ubicación
  void _stopSharingLocation() {
    _locationTimer?.cancel();
    print("Compartir ubicación detenido.");
  }

  @override
  void dispose() {
    // Asegurarse de detener el Timer al salir de la pantalla
    _locationTimer?.cancel();
    // Asegúrate de limpiar cualquier recurso cuando el widget se destruya
    socketService.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Llamar a la función de obtener la ubicación cuando se inicia la pantalla
    _getLocation();
    _getsocket(); //inicializa el socket
  }

  @override
  Widget build(BuildContext context) {
    final backgroundServiceProvider = Provider.of<BackgroundService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: _isLocationPermissionGranted
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target:
                    LatLng(37.7749, -122.4194), // San Francisco, por ejemplo
                zoom: 12.0,
              ),
              markers: _markers, // Mostrar los marcadores en el mapa
              myLocationEnabled: true, // Habilitar el botón de ubicación
              myLocationButtonEnabled: true, // Habilitar el botón de ubicación
              mapType: MapType.hybrid,
              indoorViewEnabled: false, // Deshabilitar vistas interiores
              trafficEnabled: false, // Opcional: Deshabilitar tráfico
            )
          : const Center(
              child: Text(
                'Permiso de ubicación no concedido',
                style: TextStyle(fontSize: 18),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!_isSharingLocation) {
            // Iniciar el envío de ubicación

            //  backgroundServiceProvider.start();
            _startSharingLocation(); // aqui inicio el provider servicoo
          } else {
            // Detener el envío de ubicación

            //    backgroundServiceProvider.stop();
            // aqui termino el provider servicoo
            _stopSharingLocation();
          }
          setState(() {
            _isSharingLocation = !_isSharingLocation; // Alternar estado
          });
        },
        label: Text(
          _isSharingLocation ? 'Dejar de Compartir' : 'Compartir Ubicación',
        ),
        icon: Icon(
          _isSharingLocation ? Icons.stop : Icons.share_location,
        ),
      ),
    );
  }
}
