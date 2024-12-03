import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Importa esta librería
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class BackgroundService with ChangeNotifier {
  bool _isServiceRunning = false;

  bool get isServiceRunning => _isServiceRunning;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FlutterBackgroundService service = FlutterBackgroundService();

  // Método para iniciar el servicio en segundo plano
  Future<void> start() async {
    if (_isServiceRunning) {
      return;
    } // Si ya está en ejecución, no hacer nada

    // Configurar el canal de notificación para Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_notification_channel_id', // ID del canal
      'MY FOREGROUND SERVICE', // Título
      description: 'This channel is used for important notifications.',
      importance: Importance
          .low, // Asegúrate de que la importancia esté configurada correctamente
    );

    // Crear el canal en Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Configurar el servicio
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart, // Función que se ejecutará cuando el servicio inicie
        isForegroundMode: true, // El servicio debe estar en modo primer plano
        notificationChannelId:
            'your_notification_channel_id', // Canal configurado aquí
        initialNotificationTitle: 'Servicio en segundo plano',
        initialNotificationContent: 'Compartiendo ubicación...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(),
    );

    // Iniciar el servicio
    service.startService();

    _isServiceRunning = true;
    notifyListeners(); // Notificar a los oyentes que el estado ha cambiado
  }

  // Método para detener el servicio en segundo plano
  Future<void> stop() async {
    print('intentado detener el servicio');
    print('estado = $_isServiceRunning');
    if (!_isServiceRunning) {
      return; // Si el servicio no está corriendo, no hacer nada
    }
    // final service = FlutterBackgroundService();
    // Usamos invoke con el código "stopService" para detener el servicio
    service.invoke("stopService");

    _isServiceRunning = false;
    notifyListeners(); // Notificar a los oyentes que el estado ha cambiado
    print('estado despues = $_isServiceRunning');
  }

  // Esta función es llamada cuando el servicio se inicia
  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();
    service.on('stopService').listen((event) {
      service.stopSelf();
      // Detener el servicio cuando se recibe el evento 'stopService'
      print("Servicio detenido");
    });
    // Aquí puedes empezar a compartir la ubicación periódicamente
    _shareLocationPeriodically(service);
  }

  void onStop() {
    // Aquí puedes hacer cualquier limpieza necesaria
    print("Servicio detenido");
    _isServiceRunning = false;
    notifyListeners(); // Notifica que el servicio ha terminado
  }

  // Método para compartir la ubicación periódicamente (puedes personalizar esta lógica)
  static void _shareLocationPeriodically(ServiceInstance service) async {
    while (true) {
      // Obtener la ubicación
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // Imprimir la ubicación en la consola
      print(
          'Ubicación desde el provider: ${position.latitude}, ${position.longitude}');

      // Esperar un segundo antes de obtener la siguiente ubicación
      await Future.delayed(Duration(seconds: 1));
    }
  }
}
