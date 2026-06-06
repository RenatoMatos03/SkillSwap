import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skill_swap/main.dart';

void main() {
  testWidgets('opens home and shows the quiz landing view', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Registar'), findsOneWidget);

    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Olá, Maria Rodrigues 👋'), findsOneWidget);

    await tester.tap(find.text('Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar Quiz'), findsOneWidget);
    expect(find.text('Bases de Dados'), findsOneWidget);
  });
}
