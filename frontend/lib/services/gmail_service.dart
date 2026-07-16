import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;

import '../models/email.dart';

class GmailService {
  gmail.GmailApi? _api;

  void configurarCliente(String accessToken) {
    final credenciales = AccessCredentials(
      AccessToken(
        'Bearer',
        accessToken,
        DateTime.now().toUtc().add(const Duration(minutes: 55)),
      ),
      null,
      ['https://www.googleapis.com/auth/gmail.readonly'],
    );
    final client = authenticatedClient(http.Client(), credenciales);
    _api = gmail.GmailApi(client);
  }

  bool get clienteListo => _api != null;

  Future<List<Email>> listarCorreos({int maxResults = 10}) async {
    if (_api == null) {
      throw StateError(
        'GmailService no está configurado. Llamar configurarCliente() primero.',
      );
    }

    final listado = await _api!.users.messages.list(
      'me',
      maxResults: maxResults,
    );

    final mensajes = listado.messages ?? [];
    final correos = <Email>[];

    for (final resumen in mensajes) {
      if (resumen.id == null) continue;
      final detalle = await _api!.users.messages.get(
        'me',
        resumen.id!,
        format: 'metadata',
        metadataHeaders: ['From', 'Subject'],
      );
      correos.add(_mapearEmail(detalle));
    }

    return correos;
  }

  Email _mapearEmail(gmail.Message mensaje) {
    final headers = mensaje.payload?.headers ?? [];

    final remitenteCrudo =
        _buscarHeader(headers, 'From') ?? 'Remitente desconocido';
    final asuntoCrudo = _buscarHeader(headers, 'Subject');

    final asunto = (asuntoCrudo == null || asuntoCrudo.trim().isEmpty)
        ? 'Sin asunto'
        : asuntoCrudo;

    return Email(
      id: mensaje.id,
      remitente: _limpiarRemitente(remitenteCrudo),
      asunto: asunto,
      leido: !(mensaje.labelIds?.contains('UNREAD') ?? false),
    );
  }

  String? _buscarHeader(List<gmail.MessagePartHeader> headers, String nombre) {
    for (final h in headers) {
      if (h.name == nombre) return h.value;
    }
    return null;
  }

  String _limpiarRemitente(String remitenteCrudo) {
    final match = RegExp(r'^(.*?)\s*<.*>$').firstMatch(remitenteCrudo);
    if (match != null && match.group(1)!.trim().isNotEmpty) {
      return match.group(1)!.trim();
    }
    return remitenteCrudo;
  }
}
