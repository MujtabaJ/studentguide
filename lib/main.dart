import 'package:flutter/material.dart';

import 'bootstrap.dart';

Future<void> main() async {
  const screenshots = bool.fromEnvironment('SCREENSHOTS');
  final app = await createStudentGuideApp(seedDemoData: screenshots);
  runApp(app);
}
