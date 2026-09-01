import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/store.dart';
import 'state/student_state.dart';
import 'state/timer_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final student = StudentState(AppStore(prefs));
  await student.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: student),
        ChangeNotifierProvider(create: (_) => TimerState()),
      ],
      child: const StudentGuideApp(),
    ),
  );
}
