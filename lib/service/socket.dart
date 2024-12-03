import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  late Function(String)
      onLocationUpdate; // Callback para las actualizaciones de ubicación
  late Function(String)
      onConnectionStatusChange; // Callback para el estado de la conexión

  // Constructor original con callbacks
  // Constructor con valores predeterminados para los callbacks
  SocketService({
    this.onLocationUpdate = _defaultLocationUpdate,
    this.onConnectionStatusChange = _defaultConnectionStatusChange,
  });

  // Método por defecto para los callbacks
  static void _defaultLocationUpdate(String message) {
    print('Ubicación actualizada: $message');
  }

  static void _defaultConnectionStatusChange(String status) {
    print('Estado de la conexión: $status');
  }

  // Constructor que solo recibe la URL y el roomId
  SocketService.conectar(String url, String roomId) {
    // Llamamos al método de conexión sin necesidad de callbacks
    connect(url, roomId);
    this.onLocationUpdate = _defaultLocationUpdate;
    this.onConnectionStatusChange = _defaultConnectionStatusChange;
  }

  // Método para conectar al servidor de Socket.IO
  void connect(String url, String roomId) {
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
    });

    // Manejar conexión exitosa
    socket.on('connect', (_) {
      onConnectionStatusChange("Conectado al servidor");

      // Unirse a la sala
      socket.emit('setroomgeolocator', {
        'roomId': roomId,
        'username': 'FlutterUser',
      });
    });

    // Manejar errores de conexión
    socket.on('connect_error', (error) {
      onConnectionStatusChange("Error de conexión: $error");
    });

    // Escuchar actualizaciones de ubicación
    socket.on('updatelocationrecived', (data) {
      String locationMessage =
          '${data['lat']} ,${data['long']},${data['user']}';

      onLocationUpdate(locationMessage);
    });
  }

  // Método para emitir la actualización de ubicación
  void emitir(String roomId, double lat, double long, String user) {
    socket.emit('updatelocation', {
      'roomId': roomId,
      'lat': lat,
      'long': long,
      'user': user,
    });
  }

  // Método para desconectar el socket
  void disconnect() {
    socket.disconnect();
  }
}
