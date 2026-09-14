import 'package:flutter/foundation.dart';
import 'package:googleapis/gmail/v1.dart' show DetailedApiRequestError;

import '../models/email.dart';
import '../services/gmail_service.dart';

class GmailProvider extends ChangeNotifier {
  final GmailService _servicio;

  GmailProvider(this._servicio);

  List<Email> _correos = [];

  bool _cargando = false;
  bool _cargandoDetalle = false;

  String? _mensajeError;
  String? _mensajeErrorDetalle;

  bool _requiereReautenticacion = false;

  // ============================================================
  // GETTERS
  // ============================================================

  List<Email> get correos => List.unmodifiable(_correos);

  bool get cargando => _cargando;

  bool get cargandoDetalle => _cargandoDetalle;

  String? get mensajeError => _mensajeError;

  String? get mensajeErrorDetalle => _mensajeErrorDetalle;

  bool get requiereReautenticacion => _requiereReautenticacion;

  bool get bandejaVacia =>
      !_cargando && _mensajeError == null && _correos.isEmpty;

  // ============================================================
  // CONFIGURAR GMAIL
  // ============================================================

  void configurar(String accessToken) {
    _servicio.configurarCliente(accessToken);
  }

  // ============================================================
  // CARGAR BANDEJA
  // ============================================================

  Future<void> cargarBandeja({int maxResults = 10}) async {
    if (_cargando) {
      return;
    }

    _cargando = true;
    _mensajeError = null;
    _requiereReautenticacion = false;

    notifyListeners();

    try {
      _correos = await _servicio.listarCorreos(maxResults: maxResults);
    } on DetailedApiRequestError catch (e) {
      if (e.status == 401 || e.status == 403) {
        _requiereReautenticacion = true;

        _mensajeError =
            'La sesión de Gmail expiró. '
            'Volvé a autorizar el acceso.';
      } else {
        _mensajeError = 'No se pudieron cargar los correos.';
      }

      debugPrint(
        'GmailProvider - error de API '
        '${e.status}: ${e.message}',
      );
    } catch (e) {
      _mensajeError = 'No se pudieron cargar los correos.';

      debugPrint('GmailProvider - error inesperado: $e');
    } finally {
      _cargando = false;

      notifyListeners();
    }
  }

  // ============================================================
  // CARGAR DETALLE DE UN CORREO
  // ============================================================

  Future<Email?> cargarDetalle(String id) async {
    if (_cargandoDetalle) {
      return null;
    }

    _cargandoDetalle = true;
    _mensajeErrorDetalle = null;
    _requiereReautenticacion = false;

    notifyListeners();

    try {
      final detalle = await _servicio.obtenerDetalle(id);

      final indice = _correos.indexWhere((correo) => correo.id == id);

      if (indice != -1) {
        _correos[indice] = detalle;
      } else {
        _correos.add(detalle);
      }

      return detalle;
    } on DetailedApiRequestError catch (e) {
      if (e.status == 401 || e.status == 403) {
        _requiereReautenticacion = true;

        _mensajeErrorDetalle =
            'La sesión de Gmail expiró. '
            'Volvé a autorizar el acceso.';
      } else {
        _mensajeErrorDetalle =
            'No se pudo cargar el contenido '
            'del correo.';
      }

      debugPrint(
        'GmailProvider - error al cargar detalle '
        '${e.status}: ${e.message}',
      );

      return null;
    } catch (e) {
      _mensajeErrorDetalle =
          'No se pudo cargar el contenido '
          'del correo.';

      debugPrint(
        'GmailProvider - error inesperado '
        'al cargar detalle: $e',
      );

      return null;
    } finally {
      _cargandoDetalle = false;

      notifyListeners();
    }
  }
}
