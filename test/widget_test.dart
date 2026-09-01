import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:guide/core/gpa.dart';
import 'package:guide/data/models.dart';
import 'package:guide/data/store.dart';
import 'package:guide/state/student_state.dart';
import 'package:guide/widgets/common.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('percent maps to expected letter and GPA points', () {
    expect(percentToLetter(95), 'A');
    expect(percentToLetter(91), 'A-');
    expect(percentToLetter(59), 'F');
    expect(letterToPoints('B+'), 3.3);
  });

  test('AppStore round-trips subject data', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = AppStore(prefs);
    const subject = Subject(id: 's1', name: 'Biology', credits: 4);
    final data = const AppData().copyWith(subjects: [subject]);
    await store.save(data);
    expect(store.load().subjects.single.name, 'Biology');
  });

  test('GPA weights by credits', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final state = StudentState(AppStore(prefs));
    await state.load();
    await state.upsertSubject(
      const Subject(id: 'a', name: 'Math', credits: 4, letterGrade: 'A'),
    );
    await state.upsertSubject(
      const Subject(id: 'b', name: 'Art', credits: 2, letterGrade: 'C'),
    );
    expect(state.gpa, closeTo((4 * 4.0 + 2 * 2.0) / 6, 0.01));
  });

  testWidgets('EmptyState shows action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EmptyState(
          icon: Icons.checklist,
          title: 'No tasks',
          message: 'Add one',
          actionLabel: 'Add task',
          onAction: () {},
        ),
      ),
    );
    expect(find.text('No tasks'), findsOneWidget);
    expect(find.text('Add task'), findsOneWidget);
  });
}
