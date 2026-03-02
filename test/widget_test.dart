import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loan_project/app.dart';

void main() {
  testWidgets('renders the loan dashboard and navigation', (tester) async {
    await tester.pumpWidget(const LoanProjectApp());
    await tester.pumpAndSettle();

    expect(find.text('Northstar Loans'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Apply'), findsWidgets);
    expect(find.text('Manage'), findsOneWidget);
    expect(find.text('Simple Loan'), findsOneWidget);
    expect(find.text('Repayment Loan'), findsOneWidget);
    expect(find.text('Bridge Loan'), findsWidgets);
  });

  testWidgets(
    'remains responsive across all screens on a narrow mobile width',
    (tester) async {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      addTearDown(() => binding.setSurfaceSize(null));
      await binding.setSurfaceSize(const Size(320, 780));

      await tester.pumpWidget(const LoanProjectApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apply').last);
      await tester.pumpAndSettle();
      expect(
        find.text('Capture all borrower, loan, and compliance details'),
        findsOneWidget,
      );

      await tester.tap(find.text('Manage').last);
      await tester.pumpAndSettle();
      expect(
        find.text('Application status, required documents, and repayment plan'),
        findsOneWidget,
      );

      await tester.tap(find.text('Overview').last);
      await tester.pumpAndSettle();
      expect(find.text('Northstar Loans'), findsOneWidget);
    },
  );
}
