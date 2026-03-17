import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobi/features/auth/presentation/pages/splash_page.dart';

void main() {
  testWidgets('Splash screen renders JOBI branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashPage(),
      ),
    );

    expect(find.text('JOBI'), findsOneWidget);
    expect(find.byIcon(Icons.handshake_rounded), findsOneWidget);
  });
}
