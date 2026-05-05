import 'package:flutter_test/flutter_test.dart';
import 'package:paktax/main.dart';

void main() {
  testWidgets('PakTax home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PakTaxApp());
    expect(find.text('PakTax'), findsWidgets);
  });
}
