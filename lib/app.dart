import 'package:flutter/material.dart';

import 'data/loan_demo_data.dart';
import 'models/loan_models.dart';
import 'screens/apply_loan_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/portfolio_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/ui_components.dart';

class LoanProjectApp extends StatelessWidget {
  const LoanProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Northstar Loans',
      theme: buildAppTheme(),
      home: const LoanWorkspace(),
    );
  }
}

class LoanWorkspace extends StatefulWidget {
  const LoanWorkspace({super.key});

  @override
  State<LoanWorkspace> createState() => _LoanWorkspaceState();
}

class _LoanWorkspaceState extends State<LoanWorkspace> {
  int _currentIndex = 0;
  LoanType _applyFocus = LoanDemoData.products.first.type;
  LoanCase? _activeCase = LoanDemoData.seededCase;

  void _openApplicationFlow(LoanType type) {
    setState(() {
      _applyFocus = type;
      _currentIndex = 1;
    });
  }

  void _submitApplication(LoanCase loanCase) {
    setState(() {
      _activeCase = loanCase;
      _currentIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      OverviewScreen(
        products: LoanDemoData.products,
        activeCase: _activeCase,
        onApply: _openApplicationFlow,
      ),
      ApplyLoanScreen(
        products: LoanDemoData.products,
        initialType: _applyFocus,
        onSubmitted: _submitApplication,
      ),
      PortfolioScreen(activeCase: _activeCase),
    ];

    return AppShell(
      currentIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      child: IndexedStack(index: _currentIndex, children: screens),
    );
  }
}
