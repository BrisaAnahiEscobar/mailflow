import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('MailFlow inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MailFlowApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
