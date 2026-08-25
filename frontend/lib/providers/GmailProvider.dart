import 'package:flutter/foundation.dart';
import 'package:googleapis/gmail/v1.dart' show DetailedApiRequestError;

import '../models/email.dart';
import '../services/gmail_service.dart';

class Gmailprovider extends ChangeNotifier {
  final GmailService _servicio;

  Gmailprovider(this._servicio);

  List<Email> _correos = [];
  bool _cargando = false;
  String? _mensajeError;
  bool _requiereReautenticacion = false;

  List<Email> get correos => List.unmodifiable(_correos);

  bool get cargando => _cargando;

  String? get mensajeError => _mensajeError;

  bool get requiereReautenticacion => _requiereReautenticacion;

  bool get bandejaVacia =>
      !_cargando && _mensajeError == null && _correos.isEmpty;

  void configurar(String accessToken) {
    _servicio.configurarCliente(accessToken);
  }

  Future<void> cargarBandeja({int maxResults = 10}) async {
    if (_cargando) return; // evito duplicados
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
            'La sesion de Gmail expiro. Volve a autorizar el acceso';
      } else {
        _mensajeError = 'No se pudieron cargar los correos';
      }
      debugPrint('GmailProvider error de API ${e.status} ${e.message}');
    } catch (e) {
      _mensajeError = 'No se pudieron cargar los correos';
      debugPrint('GmailProvider error inesperado (faltal error): $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
