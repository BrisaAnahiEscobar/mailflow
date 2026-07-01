import 'package:flutter/foundation.dart';

import '../models/email.dart';
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
      await _servicio.inicializar();
      _inicializado = true;
      _mensajeError = null;
    } catch (e) {
      _mensajeError = 'No se pudo inicializar el lector de voz';
      debugPrint('TtsProvider error al inicializar: $e');
    }
  }

  notifyListeners();

  /* --------------------------------------------
                    METODOS PUBLICOS
  -------------------------------------------- */
  Future<void> leerCorreo(Email correo) async {
    if (!_inicializado) return;
    try {
      _correoActual = correo;
      _estaHablando = true;
      _mensajeError = null;
      notifyListeners();
      await _servicio.hablar(correo.textoParaLeer());
      _estaHablando = false;
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
                    LIMPIEZA
  -------------------------------------------- */
  @override
  void dispose() {
    _servicio.dispose();
    super.dispose();
  }
}
