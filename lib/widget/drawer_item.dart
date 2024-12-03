import 'package:flutter/material.dart';

final List<Map<String, dynamic>> drawerItems = [
  {
    'title': 'Inicio',
    'icon': Icons.home,
    'route': '/inicio',
  },
  {
    'title': 'Mensajes',
    'icon': Icons.message,
    'route': '/mensajes',
  },
  {
    'title': 'Usuarios de confianza',
    'icon': Icons.verified_user,
    'route': '/usuario-confianza',
  },
  {
    'title': 'Historial',
    'icon': Icons.history,
    'route': '/historial',
  },
  {
    'title': 'Grabaciones',
    'icon': Icons.mic_outlined,
    'route': '/grabaciones',
  },
  {
    'title': 'Ajustes',
    'icon': Icons.settings,
    'route': '/ajustes',
  },
  {
    'title': 'Cerrar sesión',
    'icon': Icons.logout,
    'route': '/',
  },
];
