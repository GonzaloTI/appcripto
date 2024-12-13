import 'dart:convert';

ResponseApi userModelFromMap(String str) =>
    ResponseApi.fromMap(json.decode(str));
String userModelToMap(ResponseApi data) => json.encode(data.toMap());

class ResponseApi {
  final String message;
  final String error;
  final bool success;
  final dynamic data;

  ResponseApi(
      {required this.message,
      required this.error,
      required this.success,
      required this.data});

  ResponseApi copyWith({
    String? message,
    String? error,
    bool? success,
    dynamic data,
  }) {
    return ResponseApi(
      message: message ?? this.message,
      error: error ?? this.error,
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }

  factory ResponseApi.fromMap(Map<String, dynamic> json) {
    return ResponseApi(
      message: json["message"] ?? '',
      error: json["error"] ?? '',
      success: json["success"] ?? '',
      data: json["data"] ?? '',
    );
  }
  factory ResponseApi.fromJson(String source) =>
      ResponseApi.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "success": success,
      "error": error,
      "data": data,
    };
  }
}
