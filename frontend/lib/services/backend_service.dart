import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/email.dart';
import '../models/preferencias.dart';

class SesionBackend {
  final String token;
  final String email;
  final int usuarioId;

  SesionBackend({
    required this.token,
    required this.email,
    required this.usuarioId,
  });
}

class BackendException implements Exception {
  final int? statusCode;
  final String mensaje;

  BackendException(this.mensaje, {this.statusCode});

  @override
  String toString() => 'BackendException($statusCode): $mensaje';
}

class SesionExpiradaException extends BackendException {
  SesionExpiradaException() : super('Sesión expirada', statusCode: 401);
}

class BackendService {
  static const _timeout = Duration(seconds: 10);

  final String _baseUrl;
  final http.Client _client;
  String? _jwt;

  BackendService({required String baseUrl, http.Client? client})
    : _baseUrl = baseUrl,
      _client = client ?? http.Client();

  void establecerToken(String? jwt) => _jwt = jwt;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_jwt != null) 'Authorization': 'Bearer $_jwt',
  };

  Uri _uri(String ruta) => Uri.parse('$_baseUrl/api/v1$ruta');

  dynamic _procesar(http.Response r) {
    final cuerpo = r.bodyBytes.isEmpty
        ? null
        : jsonDecode(utf8.decode(r.bodyBytes));
    if (r.statusCode == 401) throw SesionExpiradaException();
    if (r.statusCode >= 400) {
      final msg = (cuerpo is Map && cuerpo['mensaje'] is String)
          ? cuerpo['mensaje'] as String
          : 'Error del servidor';
      throw BackendException(msg, statusCode: r.statusCode);
    }
    return cuerpo;
  }

  // ---------------- Auth ----------------
  Future<SesionBackend> loginConGoogle(String idToken) async {
    final r = await _client
        .post(
          _uri('/auth/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'idToken': idToken}),
        )
        .timeout(_timeout);
    final json = _procesar(r) as Map<String, dynamic>;
    final sesion = SesionBackend(
      token: json['token'] as String,
      email: json['email'] as String,
      usuarioId: (json['usuarioId'] as num).toInt(),
    );
    _jwt = sesion.token;
    return sesion;
  }

  // ---------------- Preferencias ----------------
  Future<Preferencias> obtenerPreferencias() async {
    final r = await _client
        .get(_uri('/preferencias'), headers: _headers)
        .timeout(_timeout);
    return Preferencias.fromJson(_procesar(r) as Map<String, dynamic>);
  }

  Future<Preferencias> actualizarPreferencias(Preferencias p) async {
    final r = await _client
        .put(
          _uri('/preferencias'),
          headers: _headers,
          body: jsonEncode(p.toJson()),
        )
        .timeout(_timeout);
    return Preferencias.fromJson(_procesar(r) as Map<String, dynamic>);
  }

  // ---------------- Historial ----------------
  Future<void> registrarEscucha(Email correo) async {
    if (correo.id == null) return;
    final r = await _client
        .post(
          _uri('/historial'),
          headers: _headers,
          body: jsonEncode({
            'gmailMessageId': correo.id,
            'asunto': correo.asunto,
            'remitente': correo.remitente,
          }),
        )
        .timeout(_timeout);
    _procesar(r);
  }
}
