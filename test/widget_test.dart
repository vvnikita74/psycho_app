import 'package:flutter_test/flutter_test.dart';

import 'package:psycho_app/main.dart';

void main() {
  testWidgets('App test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
  });
}
