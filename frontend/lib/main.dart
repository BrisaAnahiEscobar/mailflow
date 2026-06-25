import 'package:flutter/material.dart';
import 'screens/home_page.dart';

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
      home: HomePage(),
    );
  }
}