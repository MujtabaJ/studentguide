import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';
import 'subject_detail.dart';
import 'subject_editor.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final gpa = state.gpa;

    return Scaffold(
      appBar: AppBar(title: const Text('Grades')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SubjectEditor()),
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Cumulative GPA', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    gpa == null ? '—' : gpa.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gpa == null
                        ? 'Add subjects and grades or a letter grade to calculate GPA.'
                        : '4.0 scale · weighted by course credits',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader('Subjects'),
          if (state.subjects.isEmpty)
            EmptyState(
              icon: Icons.menu_book_outlined,
              title: 'No subjects yet',
              message:
                  'Add courses with credits. Then log scores or a letter grade.',
              actionLabel: 'Add subject',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubjectEditor()),
              ),
            )
          else
            for (final subject in state.subjects)
              _SubjectTile(subject: subject),
        ],
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final percent = state.subjectPercent(subject.id);
    final letter = state.subjectLetter(subject);
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Color(subject.colorValue)),
        title: Text(subject.name),
        subtitle: Text(
          [
            if (subject.code.isNotEmpty) subject.code,
            '${subject.credits} cr',
            ?letter,
            if (percent != null) '${percent.toStringAsFixed(0)}%',
          ].join(' · '),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SubjectDetailScreen(subjectId: subject.id)),
        ),
      ),
    );
  }
}
