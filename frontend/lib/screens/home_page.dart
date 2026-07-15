import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/email.dart';
import '../providers/tts_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Email correo = Email(
    remitente: "Mercado Libre",
    asunto: "Tu compra fue enviada",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MailFlow")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<TtsProvider>(
          builder: (context, ttsProvider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Último correo",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

                if (ttsProvider.mensajeError != null)
                  Text(
                    ttsProvider.mensajeError!,
                    style: const TextStyle(color: Colors.red),
                  ),

                Center(
                  child: ElevatedButton(
                    // deshabilitado mientras habla, para evitar doble-tap
                    onPressed: ttsProvider.estaHablando
                        ? null
                        : () => ttsProvider.leerCorreo(correo),
                    child: Text(
                      ttsProvider.estaHablando ? "Leyendo..." : "Leer correo",
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
