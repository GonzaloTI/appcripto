import 'dart:convert';
import '../model/Contact.dart';
import '../model/User.dart';
import '../model/api_response.dart';
import 'constant.dart';
import 'package:http/http.dart' as http;

///     login
Future<ApiResponse> login(String email, String password, String token) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'token': token,
      }),
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));

        print('Respuesta recibida: ${response.body}');
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> register({
  required String nombre,
  required String apellido,
  required String sexo,
  required DateTime fechaNacimiento,
  required String telefono,
  required String email,
  required String password,
}) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(registerUrl), // Cambia a la URL de registro
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': nombre,
        'apellido': apellido,
        'sexo': sexo,
        'fechaN':
            "${fechaNacimiento.day.toString().padLeft(2, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.year}",
        'telefono': telefono,
        'email': email,
        'password': password,
      }),
    );

    switch (response.statusCode) {
      case 200: // Código de éxito para creación (registro)
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        print('Registro exitoso: ${response.body}');
        break;
      case 422: // Errores de validación
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403: // Acceso denegado o token inválido
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> registrarApoderado(
    String codigoUsuario, String codigoUsuarioactual) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(registerUrlApoderado), // Asegúrate de definir registerUrl
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'idUser': codigoUsuario,
        'idApoderado': codigoUsuarioactual,
      }),
    );

    // Manejo de respuestas del servidor
    switch (response.statusCode) {
      case 200:
        // Supón que el servidor responde con datos JSON
        apiResponse.data = response.body;
        print('Respuesta recibida: ${response.body}');
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    // Captura errores de red o excepciones
    apiResponse.error = serverError;
    print('Error en el registro: $e');
  }

  return apiResponse;
}

Future<ApiResponse> getprotegidos(String tokenid) async {
  ApiResponse apiResponse = ApiResponse();
// Verifica que 'protegidos' sea un String
  try {
    final response = await http.get(
      Uri.parse('$protegidos$tokenid/protegidos'),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        // Decodifica la respuesta como lista de contactos
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        apiResponse.data =
            jsonResponse.map((item) => Contact.fromJson(item)).toList();

        print('Respuesta recibida: ${response.body}');
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    print('Error en la función protegisdos: $e');
  }

  return apiResponse;
}
