import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../data/loan_demo_data.dart';
import '../data/loan_local_store.dart';
import '../models/loan_models.dart';

class LoanPortfolioController extends ChangeNotifier {
  LoanPortfolioController({
    required LoanLocalStore store,
    List<LoanCase>? initialCases,
  }) : _store = store,
       _cases = List<LoanCase>.from(initialCases ?? LoanDemoData.seededCases);

  final LoanLocalStore _store;
  final List<LoanCase> _cases;

  UnmodifiableListView<LoanCase> get cases =>
      UnmodifiableListView(_sortedCases(_cases));

  List<LoanCase> get requestCases => cases
      .where(
        (loanCase) =>
            loanCase.status == LoanCaseStatus.documentsPending ||
            loanCase.status == LoanCaseStatus.underReview,
      )
      .toList(growable: false);

  List<LoanCase> get approvedAndActiveCases => cases
      .where(
        (loanCase) =>
            loanCase.status == LoanCaseStatus.approved ||
            loanCase.status == LoanCaseStatus.active,
      )
      .toList(growable: false);

  List<LoanCase> get activeCases => cases
      .where((loanCase) => loanCase.status == LoanCaseStatus.active)
      .toList(growable: false);

  LoanCase? get featuredCase {
    final active = activeCases;
    if (active.isNotEmpty) {
      return active.first;
    }
    final approvedAndActive = approvedAndActiveCases;
    if (approvedAndActive.isNotEmpty) {
      return approvedAndActive.first;
    }
    final requests = requestCases;
    if (requests.isNotEmpty) {
      return requests.first;
    }
    return null;
  }

  LoanCase? caseById(String applicationId) {
    for (final loanCase in _cases) {
      if (loanCase.applicationId == applicationId) {
        return loanCase;
      }
    }
    return null;
  }

  Future<void> submitCase(LoanCase loanCase) async {
    _cases.add(loanCase);
    await _store.saveCases(_sortedCases(_cases));
    notifyListeners();
  }

  static List<LoanCase> _sortedCases(List<LoanCase> cases) {
    final sorted = List<LoanCase>.from(cases);
    sorted.sort((a, b) => b.submittedOn.compareTo(a.submittedOn));
    return sorted;
  }
}
