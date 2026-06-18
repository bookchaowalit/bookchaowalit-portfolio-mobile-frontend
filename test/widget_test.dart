import 'package:flutter_test/flutter_test.dart';

import 'package:bookchaowalit_portfolio_mobile/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BookChaowalitPortfolioApp());

    // Verify app title is displayed
    expect(find.text('Chaowalit Greepoke'), findsOneWidget);
  });
}
