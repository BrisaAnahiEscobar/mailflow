import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/gmail_provider.dart';
import 'providers/preferencias_provider.dart';
import 'providers/tts_provider.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'services/auth_service.dart';
import 'services/backend_service.dart';
import 'services/gmail_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final backendService = BackendService(baseUrl: dotenv.env['API_BASE_URL']!);

  final ttsProvider = TtsProvider()
    ..onCorreoEscuchado = backendService.registrarEscucha;
  await ttsProvider.inicializar();

  final preferenciasProvider = PreferenciasProvider(
    backendService,
    ttsProvider,
  );

  final authProvider = AuthProvider(AuthService(), backendService)
    ..onBackendListoCambio = preferenciasProvider.actualizarSesion;
  await authProvider.inicializar(
    clientId: dotenv.env['GOOGLE_CLIENT_ID']!,
    serverClientId: kIsWeb ? null : dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
  );

  final gmailProvider = GmailProvider(GmailService());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ttsProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: gmailProvider),
        ChangeNotifierProvider.value(value: preferenciasProvider),
      ],
      child: const MailFlowApp(),
    ),
  );
}

class MailFlowApp extends StatelessWidget {
  const MailFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MailFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final sesionCompleta =
              auth.estaAutenticado &&
              auth.backendListo &&
              auth.tieneAccesoGmail;
          return sesionCompleta ? HomePage() : const LoginPage();
        },
      ),
    );
  }
}
