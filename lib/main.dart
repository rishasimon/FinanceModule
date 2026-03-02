import 'package:flutter/material.dart';

import 'app.dart';
import 'data/loan_local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await LoanLocalStore.create();
  runApp(LoanProjectApp(store: store));
}
