import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as google_sign_in_web;
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MailFlow')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Bienvenida a MailFlow',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Para escuchar tus correos, primero iniciá sesión '
                  'y después autorizá el acceso a Gmail.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                if (auth.mensajeError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      auth.mensajeError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // =========================================================
                // PASO 1: INICIAR SESIÓN CON GOOGLE
                // =========================================================
                if (kIsWeb)
                  Center(child: google_sign_in_web.renderButton())
                else
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: Text(
                      auth.estaAutenticado
                          ? 'Sesión iniciada: '
                                '${auth.usuario?.email ?? ""}'
                          : 'Iniciar sesión con Google',
                    ),
                    onPressed: (auth.cargando || auth.estaAutenticado)
                        ? null
                        : () => auth.iniciarSesion(),
                  ),

                const SizedBox(height: 16),

                // =========================================================
                // PASO 2: AUTORIZAR GMAIL
                // =========================================================
                ElevatedButton.icon(
                  icon: const Icon(Icons.mark_email_read_outlined),
                  label: Text(
                    auth.tieneAccesoGmail
                        ? 'Acceso a Gmail autorizado'
                        : 'Autorizar acceso a Gmail',
                  ),
                  onPressed:
                      (!auth.estaAutenticado ||
                          auth.cargando ||
                          auth.tieneAccesoGmail)
                      ? null
                      : () => auth.autorizarGmail(),
                ),

                if (auth.cargando)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: CircularProgressIndicator(),
                  ),

                if (auth.estaAutenticado && auth.tieneAccesoGmail)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextButton(
                      onPressed: () => auth.cerrarSesion(),
                      child: const Text('Cerrar sesión'),
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
