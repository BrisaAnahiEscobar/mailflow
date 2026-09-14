import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/email.dart';
import '../providers/gmail_provider.dart';
import 'email_detail_page.dart';
import 'inbox_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gmailProvider = context.read<GmailProvider>();

      if (gmailProvider.correos.isEmpty && !gmailProvider.cargando) {
        gmailProvider.cargarBandeja();
      }
    });
  }

  void _abrirCorreo(Email correo) {
    if (correo.id == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmailDetailPage(correo: correo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MailFlow'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: () {
              context.read<GmailProvider>().cargarBandeja();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<GmailProvider>(
        builder: (context, gmailProvider, _) {
          if (gmailProvider.cargando && gmailProvider.correos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (gmailProvider.mensajeError != null &&
              gmailProvider.correos.isEmpty) {
            return _ErrorBandeja(
              mensaje: gmailProvider.mensajeError!,
              onReintentar: () {
                gmailProvider.cargarBandeja();
              },
            );
          }

          if (gmailProvider.correos.isEmpty) {
            return const Center(
              child: Text(
                'No hay correos para mostrar.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await gmailProvider.cargarBandeja();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Buzón de entrada',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  '${gmailProvider.correos.length} correos',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 20),

                ...gmailProvider.correos.map(
                  (correo) => _CorreoCard(
                    correo: correo,
                    onTap: () => _abrirCorreo(correo),
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InboxPage()),
                    );
                  },
                  child: const Text('Ver todos los correos'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CorreoCard extends StatelessWidget {
  final Email correo;
  final VoidCallback onTap;

  const _CorreoCard({required this.correo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      correo.remitente,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: correo.leido
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                  ),

                  if (!correo.leido)
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                correo.asunto,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: correo.leido
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),

              if (correo.snippet != null && correo.snippet!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  correo.snippet!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],

              if (correo.fecha != null) ...[
                const SizedBox(height: 8),
                Text(
                  _formatearFecha(correo.fecha!),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes ${hora}:$minuto';
  }
}

class _ErrorBandeja extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _ErrorBandeja({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onReintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
