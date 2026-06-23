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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MailFlow"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print("Leer correo");
          },
          child: const Text("Leer correo"),
        ),
      ),
    );
  }
}