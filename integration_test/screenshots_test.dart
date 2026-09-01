import 'package:flutter_test/flutter_test.dart';
import 'package:guide/bootstrap.dart';
import 'package:integration_test/integration_test.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 400));
}

Future<void> _tapNav(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
  await _settle(tester);
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Play Store screenshots', (tester) async {
    final app = await createStudentGuideApp(seedDemoData: true);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    await binding.takeScreenshot('01_home');

    await _tapNav(tester, 'Planner');
    await binding.takeScreenshot('02_planner_tasks');

    await tester.tap(find.text('Schedule'));
    await _settle(tester);
    await binding.takeScreenshot('03_timetable');

    await tester.tap(find.text('Exams'));
    await _settle(tester);
    await binding.takeScreenshot('04_exams');

    await _tapNav(tester, 'Study');
    await binding.takeScreenshot('05_study');

    await tester.tap(find.text('Study timer'));
    await _settle(tester);
    await binding.takeScreenshot('06_timer');

    await tester.pageBack();
    await _settle(tester);
    await tester.tap(find.text('Flashcards'));
    await _settle(tester);
    await binding.takeScreenshot('07_flashcards');

    await tester.pageBack();
    await _settle(tester);
    await _tapNav(tester, 'Grades');
    await binding.takeScreenshot('08_grades');
  });
}
