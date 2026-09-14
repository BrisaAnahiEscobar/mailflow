import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/email.dart';
import '../providers/gmail_provider.dart';
import 'email_detail_page.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  void _abrirCorreo(BuildContext context, Email correo) {
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
      appBar: AppBar(title: const Text('Bandeja de entrada')),
      body: Consumer<GmailProvider>(
        builder: (context, gmailProvider, _) {
          if (gmailProvider.cargando && gmailProvider.correos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (gmailProvider.correos.isEmpty) {
            return const Center(child: Text('No hay correos para mostrar.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await gmailProvider.cargarBandeja();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: gmailProvider.correos.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final correo = gmailProvider.correos[index];

                return ListTile(
                  onTap: () {
                    _abrirCorreo(context, correo);
                  },
                  leading: CircleAvatar(
                    child: Text(
                      correo.remitente.isNotEmpty
                          ? correo.remitente[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(
                    correo.remitente,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: correo.leido
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        correo.asunto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: correo.leido
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      if (correo.snippet != null && correo.snippet!.isNotEmpty)
                        Text(
                          correo.snippet!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: correo.fecha != null
                      ? Text(
                          _formatearFecha(correo.fecha!),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        )
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes';
  }
}
