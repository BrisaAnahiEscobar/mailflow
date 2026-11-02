import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/preferencias.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _estaHablando = false;
  Preferencias _preferencias = Preferencias.porDefecto;

  VoidCallback? onCompletado;
  VoidCallback? onError;

  bool get estaHablando => _estaHablando;

  Future<void> inicializar() async {
    await aplicarPreferencias(_preferencias);
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() => _estaHablando = true);
    _tts.setCancelHandler(() => _estaHablando = false);
    _tts.setCompletionHandler(() {
      _estaHablando = false;
      onCompletado?.call();
    });
    _tts.setErrorHandler((mensaje) {
      _estaHablando = false;
      debugPrint('TtsService error: $mensaje');
      onError?.call();
    });
  }

  Future<void> aplicarPreferencias(Preferencias p) async {
    _preferencias = p;
    await _tts.setSpeechRate(p.velocidadTts);
    await _tts.setPitch(p.pitchTts);
    await _tts.setLanguage(p.idiomaTts);
  }

  Future<void> hablar(String texto, {String idioma = ''}) async {
    if (texto.trim().isEmpty) return;
    if (_estaHablando) await parar();
    await _tts.setLanguage(idioma.isEmpty ? _preferencias.idiomaTts : idioma);
    await _tts.speak(texto);
  }

  Future<void> parar() async {
    await _tts.stop();
    _estaHablando = false;
  }

  Future<void> dispose() async => parar();
}
