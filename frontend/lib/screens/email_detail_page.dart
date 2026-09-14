import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/email.dart';
import '../providers/gmail_provider.dart';
import '../providers/tts_provider.dart';

class EmailDetailPage extends StatefulWidget {
  final Email correo;

  const EmailDetailPage({super.key, required this.correo});

  @override
  State<EmailDetailPage> createState() => _EmailDetailPageState();
}

class _EmailDetailPageState extends State<EmailDetailPage> {
  Email? _correoDetalle;

  @override
  void initState() {
    super.initState();

    _cargarDetalle();
  }

  Future<void> _cargarDetalle() async {
    final id = widget.correo.id;

    if (id == null) {
      return;
    }

    final detalle = await context.read<GmailProvider>().cargarDetalle(id);

    if (!mounted) {
      return;
    }

    if (detalle != null) {
      setState(() {
        _correoDetalle = detalle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final correo = _correoDetalle ?? widget.correo;

    return Scaffold(
      appBar: AppBar(title: const Text('Correo')),
      body: Consumer<GmailProvider>(
        builder: (context, gmailProvider, _) {
          final cargandoDetalle = gmailProvider.cargandoDetalle;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correo.asunto,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'De: ${correo.remitente}',
                  style: const TextStyle(fontSize: 16),
                ),

                if (correo.fecha != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    _formatearFecha(correo.fecha!),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],

                const SizedBox(height: 24),

                const Divider(),

                const SizedBox(height: 24),

                if (cargandoDetalle && _correoDetalle == null)
                  const Center(child: CircularProgressIndicator())
                else if (gmailProvider.mensajeErrorDetalle != null)
                  _ErrorDetalle(
                    mensaje: gmailProvider.mensajeErrorDetalle!,
                    onReintentar: _cargarDetalle,
                  )
                else if (correo.cuerpo == null || correo.cuerpo!.isEmpty)
                  const Text(
                    'No se pudo obtener el contenido '
                    'de este correo.',
                    style: TextStyle(fontSize: 16),
                  )
                else
                  Text(
                    correo.cuerpo!,
                    style: const TextStyle(fontSize: 17, height: 1.5),
                  ),

                const SizedBox(height: 32),

                if (correo.cuerpo != null && correo.cuerpo!.isNotEmpty)
                  _BotonLeerCorreo(correo: correo),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();

    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$anio $hora:$minuto';
  }
}

class _BotonLeerCorreo extends StatelessWidget {
  final Email correo;

  const _BotonLeerCorreo({required this.correo});

  @override
  Widget build(BuildContext context) {
    return Consumer<TtsProvider>(
      builder: (context, ttsProvider, _) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: ttsProvider.estaHablando
                ? null
                : () {
                    ttsProvider.leerCorreo(correo);
                  },
            icon: Icon(
              ttsProvider.estaHablando ? Icons.volume_up : Icons.play_arrow,
            ),
            label: Text(
              ttsProvider.estaHablando ? 'Leyendo...' : 'Leer correo',
            ),
          ),
        );
      },
    );
  }
}

class _ErrorDetalle extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _ErrorDetalle({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 42),
          const SizedBox(height: 12),
          Text(mensaje, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onReintentar,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
