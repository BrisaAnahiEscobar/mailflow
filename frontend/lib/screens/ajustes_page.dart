import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/email.dart';
import '../models/preferencias.dart';
import '../providers/preferencias_provider.dart';
import '../providers/tts_provider.dart';

class AjustesPage extends StatefulWidget {
  const AjustesPage({super.key});

  @override
  State<AjustesPage> createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  static const _idiomas = {
    'es-ES': 'Español (España)',
    'en-US': 'Inglés (EE. UU.)',
  };

  late Preferencias _local;

  @override
  void initState() {
    super.initState();
    _local = context.read<PreferenciasProvider>().preferencias;
  }

  Future<void> _guardar() async {
    final provider = context.read<PreferenciasProvider>();
    final ok = await provider.guardar(_local);
    if (!mounted || ok) return;
    setState(() => _local = provider.preferencias);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(provider.mensajeError ?? 'No se pudo guardar')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final idiomaActual = _idiomas.containsKey(_local.idiomaTts)
        ? _local.idiomaTts
        : 'es-ES';

    return Scaffold(
      appBar: AppBar(title: const Text('Preferencias de voz')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          DropdownButtonFormField<String>(
            initialValue: idiomaActual,
            decoration: const InputDecoration(labelText: 'Idioma por defecto'),
            items: _idiomas.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _local = _local.copyWith(idiomaTts: v));
              _guardar();
            },
          ),
          const SizedBox(height: 24),
          Text('Velocidad: ${_local.velocidadTts.toStringAsFixed(2)}'),
          Slider(
            value: _local.velocidadTts.clamp(0.1, 1.0),
            min: 0.1,
            max: 1.0,
            divisions: 18,
            onChanged: (v) =>
                setState(() => _local = _local.copyWith(velocidadTts: v)),
            onChangeEnd: (_) => _guardar(),
          ),
          Text('Tono: ${_local.pitchTts.toStringAsFixed(2)}'),
          Slider(
            value: _local.pitchTts.clamp(0.5, 2.0),
            min: 0.5,
            max: 2.0,
            divisions: 15,
            onChanged: (v) =>
                setState(() => _local = _local.copyWith(pitchTts: v)),
            onChangeEnd: (_) => _guardar(),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.record_voice_over),
            label: const Text('Probar voz'),
            onPressed: () => context.read<TtsProvider>().leerCorreo(
              Email(
                remitente: 'MailFlow',
                asunto: 'Así suena la voz configurada',
                idioma: _local.idiomaTts,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
