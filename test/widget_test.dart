import 'package:flutter_test/flutter_test.dart';
import 'package:fluxo/main.dart';

void main() {
  testWidgets('Fluxo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FluxoApp());

    // Verify that our app finds the text.
    expect(find.text('Fluxo Initialized'), findsOneWidget);
  });
}
