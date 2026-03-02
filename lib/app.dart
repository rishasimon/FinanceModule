import 'package:flutter/material.dart';

import 'data/loan_demo_data.dart';
import 'data/loan_local_store.dart';
import 'models/loan_models.dart';
import 'screens/apply_loan_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/portfolio_screen.dart';
import 'state/loan_portfolio_controller.dart';
import 'theme/app_theme.dart';
import 'widgets/ui_components.dart';

class LoanProjectApp extends StatelessWidget {
  const LoanProjectApp({super.key, required this.store});

  final LoanLocalStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Northstar Loans',
      theme: buildAppTheme(),
      home: LoanWorkspace(store: store),
    );
  }
}

class LoanWorkspace extends StatefulWidget {
  const LoanWorkspace({super.key, required this.store});

  final LoanLocalStore store;

  @override
  State<LoanWorkspace> createState() => _LoanWorkspaceState();
}

class _LoanWorkspaceState extends State<LoanWorkspace> {
  late final LoanPortfolioController _controller;
  int _currentIndex = 0;
  LoanType _applyFocus = LoanDemoData.products.first.type;
  String? _selectedCaseId;

  @override
  void initState() {
    super.initState();
    _controller = LoanPortfolioController(
      store: widget.store,
      initialCases: widget.store.loadCases(),
    );
    _selectedCaseId = _controller.featuredCase?.applicationId;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openApplicationFlow(LoanType type) {
    setState(() {
      _applyFocus = type;
      _currentIndex = 1;
    });
  }

  void _openManageTab({String? caseId}) {
    setState(() {
      _selectedCaseId = caseId ?? _selectedCaseId;
      _currentIndex = 2;
    });
  }

  Future<void> _submitApplication(LoanCase loanCase) async {
    await _controller.submitCase(loanCase);
    if (!mounted) {
      return;
    }
    _openManageTab(caseId: loanCase.applicationId);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final screens = <Widget>[
          OverviewScreen(
            products: LoanDemoData.products,
            cases: _controller.cases,
            onApply: _openApplicationFlow,
            onOpenManage: _openManageTab,
          ),
          ApplyLoanScreen(
            products: LoanDemoData.products,
            initialType: _applyFocus,
            onSubmitted: _submitApplication,
          ),
          PortfolioScreen(
            cases: _controller.cases,
            selectedCaseId: _selectedCaseId,
            onSelectCase: (applicationId) {
              setState(() {
                _selectedCaseId = applicationId;
              });
            },
            onCreateRequest: () => _openApplicationFlow(LoanType.personal),
          ),
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
      },
    );
  }
}
