import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  /* la instancia de flutter tts hace el trabajo
  es privada (_) solo la usan metodos de este service*/
  final FlutterTts _tts = FlutterTts();
  bool _estaHablando = false;

  bool get estaHablando => _estaHablando;

  /* --------------------------------------------
                  INICIALIZACION
  -------------------------------------------- */
  Future<void> inicializar() async {
    // config idioma velocidad tono de voz y volumen
    await _tts.setLanguage("es-ES");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    // callbacks
    _tts.setStartHandler(() {
      _estaHablando = true;
    });

    _tts.setCancelHandler(() {
      _estaHablando = false;
    });

    _tts.setErrorHandler((mensaje) {
      _estaHablando = false;
      debugPrint('TtsService error: $mensaje'); // fase 3
    });
  }

  /* --------------------------------------------
                    METODOS PUBLICOS
    -------------------------------------------- */
  Future<void> hablar(String texto) async {
    if (texto.trim().isEmpty) return;
    if (_estaHablando) {
      await parar();
    }
    await _tts.speak(texto);
  }

  Future<void> pausar() async {
    if (_estaHablando) {
      await _tts.pause();
    }
  }

  // TODO: revisar el soporte en flutter
  /*Future<void> reanudar() async {
    if (!_estaHablando) {
      await _tts.continueUtterance(); // revisar
    }
  }*/

  Future<void> parar() async {
    await _tts.stop();
    _estaHablando = false;
  }

  /* --------------------------------------------
                    LIMPIEZA
  -------------------------------------------- */
  Future<void> dispose() async {
    await parar();
  }
}
