import 'package:flutter_test/flutter_test.dart';

import 'package:zyromate_hr_task/main.dart';

void main() {
  testWidgets('App builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('zyromate'), findsOneWidget);
  });
}
