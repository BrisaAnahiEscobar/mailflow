import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MailFlowApp());
}

class MailFlowApp extends StatelessWidget {
  const MailFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MailFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FlutterTts tts = FlutterTts();

Future<void> leerCorreo() async {
 /*await tts.setLanguage("es-ES");
  await tts.setSpeechRate(0.45);
  await tts.setPitch(1.0);
  await tts.setVolume(1.0);
*/
  await tts.speak(
    "Hola Brisa. Tienes un correo nuevo."
  );
}
  print("Botón presionado");

  var resultadoIdioma = await tts.setLanguage("es-ES");
  print("Idioma: $resultadoIdioma");

  var resultado = await tts.speak(
    "Hola Brisa. Tienes un correo nuevo.",
  );

  print("Speak: $resultado");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MailFlow"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: leerCorreo,
          child: const Text("Leer correo"),
        ),
      ),
    );
  }
}