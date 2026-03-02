import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:loan_project/app.dart';
import 'package:loan_project/data/loan_local_store.dart';

void main() {
  testWidgets('renders the loan dashboard and navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LoanLocalStore.create();

    await tester.pumpWidget(LoanProjectApp(store: store));
    await tester.pumpAndSettle();

    expect(find.text('Loan workspace'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Apply'), findsWidgets);
    expect(find.text('Manage'), findsOneWidget);
    expect(find.text('Home Loan'), findsWidgets);
    expect(find.text('Education Loan'), findsWidgets);
  });

  testWidgets(
    'remains responsive across all screens on a narrow mobile width',
    (tester) async {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      final store = await LoanLocalStore.create();

      addTearDown(() => binding.setSurfaceSize(null));
      await binding.setSurfaceSize(const Size(320, 780));

      await tester.pumpWidget(LoanProjectApp(store: store));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apply').last);
      await tester.pumpAndSettle();
      expect(find.text('New loan request'), findsOneWidget);

      await tester.tap(find.text('Manage').last);
      await tester.pumpAndSettle();
      expect(find.text('Saved loans'), findsOneWidget);

      await tester.tap(find.text('Overview').last);
      await tester.pumpAndSettle();
      expect(find.text('Loan workspace'), findsOneWidget);
    },
  );
}
