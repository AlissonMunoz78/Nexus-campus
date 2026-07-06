import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_campus/app.dart';

void main() {
  testWidgets('App builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const NexusCampusApp());
    expect(find.byType(NexusCampusApp), findsOneWidget);
  });
}
