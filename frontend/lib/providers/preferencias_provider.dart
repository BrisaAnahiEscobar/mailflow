import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/preferencias.dart';
import '../services/backend_service.dart';
import 'tts_provider.dart';

class PreferenciasProvider extends ChangeNotifier {
  final BackendService _backend;
  final TtsProvider _tts;

  PreferenciasProvider(this._backend, this._tts);

  Preferencias _preferencias = Preferencias.porDefecto;
  bool _cargando = false;
  bool _sesionActiva = false;
  String? _mensajeError;

  Preferencias get preferencias => _preferencias;

  bool get cargando => _cargando;

  String? get mensajeError => _mensajeError;

  void actualizarSesion(bool backendListo) {
    if (backendListo == _sesionActiva) return;
    _sesionActiva = backendListo;

    if (backendListo) {
      unawaited(cargar());
    } else {
      _preferencias = Preferencias.porDefecto;
      unawaited(_tts.aplicarPreferencias(_preferencias));
      notifyListeners();
    }
  }

  Future<void> cargar() async {
    _cargando = true;
    _mensajeError = null;
    notifyListeners();
    try {
      _preferencias = await _backend.obtenerPreferencias();
      await _tts.aplicarPreferencias(_preferencias);
    } catch (e) {
      debugPrint('PreferenciasProvider error al cargar: $e');
      _mensajeError = 'No se pudieron cargar las preferencias';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> guardar(Preferencias nuevas) async {
    final anterior = _preferencias;
    _preferencias = nuevas;
    _mensajeError = null;
    notifyListeners();
    try {
      _preferencias = await _backend.actualizarPreferencias(nuevas);
      await _tts.aplicarPreferencias(_preferencias);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('PreferenciasProvider error al guardar: $e');
      _preferencias = anterior;
      _mensajeError = 'No se pudieron guardar las preferencias';
      notifyListeners();
      return false;
    }
  }
}
