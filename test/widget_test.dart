import 'package:flutter_test/flutter_test.dart';
import 'package:hitung_koin_app/core/values/app_strings.dart';
import 'package:hitung_koin_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is rendered.
    expect(find.text(AppStrings.appName), findsWidgets);
  });
}
