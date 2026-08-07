import 'package:flutter_test/flutter_test.dart';
import 'package:jotun_one/app.dart';

void main() {
  testWidgets('JotunOneApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const JotunOneApp());
    expect(find.byType(JotunOneApp), findsOneWidget);
  });
}
