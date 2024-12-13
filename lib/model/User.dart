class User {
  String? id;
  String? nombre;
  String? apellido;
  String? sexo;
  DateTime? fechaNacimiento;
  String? telefono;
  String? email;
  String? token;

  User({
    this.id,
    this.nombre,
    this.apellido,
    this.sexo,
    this.fechaNacimiento,
    this.telefono,
    this.email,
    this.token,
  });

  // Constructor para crear un objeto User desde un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['usuario']['id'],
      nombre: json['usuario']['nombre'],
      apellido: json['usuario']['apellido'],
      sexo: json['usuario']['sexo'],
      fechaNacimiento: DateTime(
        json['usuario']['fechaNacimiento'][0],
        json['usuario']['fechaNacimiento'][1],
        json['usuario']['fechaNacimiento'][2],
      ),
      telefono: json['usuario']['telefono'],
      email: json['usuario']['email'],
      token: json['token'],
    );
  }

  // Constructor para crear un objeto User desde un JSON que solo contiene datos de usuario
  factory User.fromJsonUsuario(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      sexo: json['sexo'],
      fechaNacimiento: DateTime(
        json['fechaNacimiento'][0],
        json['fechaNacimiento'][1],
        json['fechaNacimiento'][2],
      ),
      telefono: json['telefono'],
      email: json['email'],
    );
  }

  // Convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {
      "usuario": {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "sexo": sexo,
        "fechaNacimiento": [
          fechaNacimiento?.year,
          fechaNacimiento?.month,
          fechaNacimiento?.day,
        ],
        "telefono": telefono,
        "email": email,
      },
      "token": token,
    };
  }
}
