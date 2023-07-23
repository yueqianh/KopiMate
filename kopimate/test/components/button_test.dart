import 'package:flutter_test/flutter_test.dart';
import 'package:kopimate/components/button.dart';

void main() {
  testWidgets('Button has text', (tester) async {
    await tester.pumpWidget(Button(onTap: () => {}, text: 'test'));

    final textFinder = find.text('test');

    expect(textFinder, findsOneWidget);
  });
}
