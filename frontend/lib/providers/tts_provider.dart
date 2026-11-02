import 'package:flutter/foundation.dart';

import '../models/email.dart';
import '../models/preferencias.dart';
import '../services/tts_service.dart';

class TtsProvider extends ChangeNotifier {
  final TtsService _servicio = TtsService();

  /* --------------------------------------------
                    ESTADO INTERNO
  -------------------------------------------- */
  bool _estaHablando = false;
  bool _inicializado = false;
  Email? _correoActual;
  String? _mensajeError;

  Future<void> Function(Email correo)? onCorreoEscuchado;

  // -------------- getters --------------
  bool get estaHablando => _estaHablando;

  bool get inicializado => _inicializado;

  Email? get correoActual => _correoActual;

  String? get mensajeError => _mensajeError;

  /* --------------------------------------------
                    INICIALIZACION
  -------------------------------------------- */
  Future<void> inicializar() async {
    if (_inicializado) return;
    try {
      _servicio.onCompletado = _alTerminarLectura;
      _servicio.onError = _alFallarLectura;
      await _servicio.inicializar();
      _inicializado = true;
      _mensajeError = null;
    } catch (e) {
      _mensajeError = 'No se pudo inicializar el lector de voz';
      debugPrint('TtsProvider error al inicializar: $e');
    }
    notifyListeners();
  }

  /* --------------------------------------------
                    METODOS PUBLICOS
  -------------------------------------------- */
  Future<void> aplicarPreferencias(Preferencias p) async {
    if (!_inicializado) return;
    await _servicio.aplicarPreferencias(p);
  }

  Future<void> leerCorreo(Email correo) async {
    if (!_inicializado) return;
    try {
      _correoActual = correo;
      _estaHablando = true;
      _mensajeError = null;
      notifyListeners();
      await _servicio.hablar(correo.textoParaLeer(), idioma: correo.idioma);
    } catch (e) {
      _estaHablando = false;
      _mensajeError = 'Error al leer el correo';
      debugPrint('TtsProvider error al leer el correo: $e');
      notifyListeners();
    }
  }

  Future<void> parar() async {
    if (!_inicializado) return;
    try {
      await _servicio.parar();
      _estaHablando = false;
      _correoActual = null;
    } catch (e) {
      debugPrint('TtsProvider error al parar: $e');
    }
    notifyListeners();
  }

  /* --------------------------------------------
                  CALLBACKS DEL SERVICIO
  -------------------------------------------- */
  void _alTerminarLectura() {
    final correo = _correoActual;
    if (!_estaHablando || correo == null) return;
    _estaHablando = false;
    notifyListeners();
    _registrarEscucha(correo);
  }

  void _alFallarLectura() {
    _estaHablando = false;
    _mensajeError = 'Error al leer el correo';
    notifyListeners();
  }

  Future<void> _registrarEscucha(Email correo) async {
    try {
      await onCorreoEscuchado?.call(correo);
    } catch (e) {
      debugPrint('No se pudo registrar el historial: $e');
    }
  }

  /* --------------------------------------------
                    LIMPIEZA
  -------------------------------------------- */
  @override
  void dispose() {
    _servicio.dispose();
    super.dispose();
  }
}
