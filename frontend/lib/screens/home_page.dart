import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/email.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FlutterTts tts = FlutterTts();

  final Email correo = Email(
    remitente: "Mercado Libre",
    asunto: "Tu compra fue enviada",
  );

  Future<void> leerCorreo() async {
    await tts.setLanguage("es-ES");
    await tts.setSpeechRate(0.45);
    await tts.setPitch(1.0);

    await tts.speak(
      "Tienes un correo de ${correo.remitente}. "
      "Asunto: ${correo.asunto}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MailFlow"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Último correo",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "De: ${correo.remitente}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 12),

            Text(
              "Asunto: ${correo.asunto}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                onPressed: leerCorreo,
                child: const Text("Leer correo"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}