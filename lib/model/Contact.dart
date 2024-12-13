class Contact {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;

  Contact({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
  });

  // Método para convertir un JSON en un Contact
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
    );
  }
}
