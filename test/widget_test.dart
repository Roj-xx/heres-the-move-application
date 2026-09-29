import 'package:flutter_test/flutter_test.dart';

import 'package:heres_the_move/main.dart';

void main() {
  testWidgets('renders the initialization placeholder', (tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Here’s the Move'), findsOneWidget);
    expect(find.text('Project initialized successfully.'), findsOneWidget);
  });
}
