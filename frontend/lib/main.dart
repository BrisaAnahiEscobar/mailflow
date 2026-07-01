import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tts_provider.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ttsProvider = TtsProvider();
  await ttsProvider.inicializar();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ttsProvider,
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
      home: HomePage(),
    );
  }
}
