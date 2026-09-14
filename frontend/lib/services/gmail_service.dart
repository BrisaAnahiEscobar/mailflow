import 'dart:convert';
import 'package:flutter/foundation.dart';

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

  // ============================================================
  // LISTAR CORREOS
  // ============================================================

  Future<List<Email>> listarCorreos({int maxResults = 10}) async {
    if (_api == null) {
      throw StateError(
        'GmailService no está configurado. '
        'Llamar configurarCliente() primero.',
      );
    }

    final listado = await _api!.users.messages.list(
      'me',
      maxResults: maxResults,
    );

    final mensajes = listado.messages ?? [];

    // Las solicitudes de metadata se realizan en paralelo.
    final resultados = await Future.wait(
      mensajes.where((mensaje) => mensaje.id != null).map((mensaje) async {
        try {
          final detalle = await _api!.users.messages.get(
            'me',
            mensaje.id!,
            format: 'metadata',
            metadataHeaders: ['From', 'Subject'],
          );

          return _mapearEmail(detalle);
        } catch (e) {
          debugPrint('No se pudo cargar el correo ${mensaje.id}: $e');

          return null;
        }
      }),
    );

    return resultados.whereType<Email>().toList();
  }

  // ============================================================
  // OBTENER DETALLE
  // ============================================================

  Future<Email> obtenerDetalle(String id) async {
    if (_api == null) {
      throw StateError(
        'GmailService no está configurado. '
        'Llamar configurarCliente() primero.',
      );
    }

    final mensaje = await _api!.users.messages.get('me', id, format: 'full');

    final headers = mensaje.payload?.headers ?? [];

    final remitenteCrudo =
        _buscarHeader(headers, 'From') ?? 'Remitente desconocido';

    final asuntoCrudo = _buscarHeader(headers, 'Subject');

    final asunto = (asuntoCrudo == null || asuntoCrudo.trim().isEmpty)
        ? 'Sin asunto'
        : asuntoCrudo;

    final cuerpo = _extraerCuerpo(mensaje.payload);

    final idioma = _detectarIdioma(cuerpo);

    DateTime? fecha;

    if (mensaje.internalDate != null) {
      fecha = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(mensaje.internalDate!) ?? 0,
      ).toLocal();
    }

    return Email(
      id: mensaje.id ?? id,
      remitente: _limpiarRemitente(remitenteCrudo),
      asunto: asunto,
      cuerpo: cuerpo,
      snippet: mensaje.snippet,
      fecha: fecha,
      idioma: idioma,
      leido: !(mensaje.labelIds?.contains('UNREAD') ?? false),
    );
  }

  // ============================================================
  // MAPEAR EMAIL DE LA BANDEJA
  // ============================================================

  Email _mapearEmail(gmail.Message mensaje) {
    final headers = mensaje.payload?.headers ?? [];

    final remitenteCrudo =
        _buscarHeader(headers, 'From') ?? 'Remitente desconocido';

    final asuntoCrudo = _buscarHeader(headers, 'Subject');

    final asunto = (asuntoCrudo == null || asuntoCrudo.trim().isEmpty)
        ? 'Sin asunto'
        : asuntoCrudo;

    DateTime? fecha;

    if (mensaje.internalDate != null) {
      final milliseconds = int.tryParse(mensaje.internalDate!);

      if (milliseconds != null) {
        fecha = DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
      }
    }

    return Email(
      id: mensaje.id,
      remitente: _limpiarRemitente(remitenteCrudo),
      asunto: asunto,
      snippet: mensaje.snippet,
      fecha: fecha,
      leido: !(mensaje.labelIds?.contains('UNREAD') ?? false),
      idioma: '',
    );
  }

  // ============================================================
  // EXTRAER CUERPO
  // ============================================================

  String? _extraerCuerpo(gmail.MessagePart? payload) {
    if (payload == null) {
      return null;
    }

    // ----------------------------------------------------------
    // Caso simple:
    // payload = text/plain
    // ----------------------------------------------------------

    if (payload.mimeType == 'text/plain' &&
        payload.body?.data != null &&
        payload.body!.data!.isNotEmpty) {
      final texto = _decodificarBase64(payload.body!.data!);

      if (texto.isNotEmpty) {
        return _limpiarCuerpo(texto);
      }
    }

    // ----------------------------------------------------------
    // Caso multipart:
    // buscamos text/plain recursivamente.
    // ----------------------------------------------------------

    final parts = payload.parts;

    if (parts != null) {
      for (final part in parts) {
        final resultado = _extraerCuerpo(part);

        if (resultado != null && resultado.isNotEmpty) {
          return resultado;
        }
      }
    }

    return null;
  }

  // ============================================================
  // DECODIFICAR BASE64URL
  // ============================================================

  String _decodificarBase64(String data) {
    try {
      return utf8.decode(base64Url.decode(data));
    } catch (e) {
      debugPrint(
        'Fallp base64Url.decode. '
        'Se intenta fallback para formato irregular: $e',
      );

      // Fallback para datos con formato irregular
      // o padding incorrecto.
      try {
        final normalizado = data.replaceAll('-', '+').replaceAll('_', '/');

        return utf8.decode(base64.decode(base64.normalize(normalizado)));
      } catch (e) {
        debugPrint(
          'No se pudo decodificar el cuerpo '
          'del correo: $e',
        );

        return '';
      }
    }
  }

  // ============================================================
  // LIMPIAR CUERPO
  // ============================================================

  String _limpiarCuerpo(String texto) {
    return texto
        // Normalizar saltos de línea.
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        // Entidades HTML comunes.
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        // Eliminar espacios innecesarios
        // al final de las líneas.
        .split('\n')
        .map((linea) => linea.trimRight())
        .join('\n')
        // Evitar más de dos saltos
        // consecutivos.
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        // Evitar espacios consecutivos.
        .replaceAll(RegExp(r'[ \t]{2,}'), ' ')
        .trim();
  }

  // ============================================================
  // DETECTAR IDIOMA
  // ============================================================

  String _detectarIdioma(String? texto) {
    if (texto == null || texto.isEmpty) {
      return 'es-ES';
    }
    // Caracteres característicos del español.
    final esSpanish = RegExp(r'[áéíóúñü¿¡]', caseSensitive: false);

    return esSpanish.hasMatch(texto) ? 'es-ES' : 'en-US';
  }

  // ============================================================
  // BUSCAR HEADER
  // ============================================================

  String? _buscarHeader(List<gmail.MessagePartHeader> headers, String nombre) {
    for (final header in headers) {
      if (header.name?.toLowerCase() == nombre.toLowerCase()) {
        return header.value;
      }
    }
    return null;
  }

  // ============================================================
  // LIMPIAR REMITENTE
  // ============================================================

  String _limpiarRemitente(String remitenteCrudo) {
    final match = RegExp(r'^(.*?)\s*<.*>$').firstMatch(remitenteCrudo);

    if (match != null &&
        match.group(1) != null &&
        match.group(1)!.trim().isNotEmpty) {
      return match.group(1)!.trim();
    }

    return remitenteCrudo;
  }
}
