import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/loan_models.dart';
import 'loan_demo_data.dart';

class LoanLocalStore {
  LoanLocalStore(this._preferences);

  static const String _casesKey = 'loan_cases_v1';

  final SharedPreferences _preferences;

  static Future<LoanLocalStore> create() async {
    final preferences = await SharedPreferences.getInstance();
    return LoanLocalStore(preferences);
  }

  List<LoanCase> loadCases() {
    final raw = _preferences.getString(_casesKey);
    if (raw == null || raw.isEmpty) {
      return const <LoanCase>[];
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => LoanDemoData.restoreCase(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false);
    } catch (_) {
      return const <LoanCase>[];
    }
  }

  Future<void> saveCases(List<LoanCase> cases) {
    final encoded = jsonEncode(
      cases.map((loanCase) => loanCase.toJson()).toList(),
    );
    return _preferences.setString(_casesKey, encoded);
  }
}
