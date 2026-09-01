import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/demo_data.dart';
import 'data/store.dart';
import 'state/student_state.dart';
import 'state/timer_state.dart';

Future<Widget> createStudentGuideApp({bool seedDemoData = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final store = AppStore(prefs);
  if (seedDemoData) {
    await store.save(buildDemoData());
  }
  final student = StudentState(store);
  await student.load();
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: student),
      ChangeNotifierProvider(create: (_) => TimerState()),
    ],
    child: const StudentGuideApp(),
  );
}
