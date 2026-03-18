import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jobi/core/l10n/app_localizations.dart';
import 'package:jobi/features/auth/presentation/pages/splash_page.dart';

void main() {
  testWidgets('Splash screen renders JOBI branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: SplashPage(),
      ),
    );

    expect(find.text('JOBI'), findsOneWidget);
    expect(find.byIcon(Icons.handshake_rounded), findsOneWidget);
  });
}
