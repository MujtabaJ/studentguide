import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';
import 'subject_editor.dart';

class SubjectDetailScreen extends StatelessWidget {
  const SubjectDetailScreen({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final subject = state.subjectById(subjectId);
    if (subject == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Subject not found')),
      );
    }
    final entries = state.grades.where((g) => g.subjectId == subjectId).toList();
    final percent = state.subjectPercent(subjectId);
    final letter = state.subjectLetter(subject);

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SubjectEditor(subject: subject)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await confirmDelete(
                context,
                title: 'Delete subject?',
                message:
                    'Grades and class periods for this course will be removed.',
              );
              if (!ok || !context.mounted) return;
              await state.deleteSubject(subject.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editGrade(context, subject.id),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(subject.colorValue)),
              title: Text(letter ?? 'No grade yet'),
              subtitle: Text(
                [
                  if (subject.code.isNotEmpty) subject.code,
                  if (subject.instructor.isNotEmpty) subject.instructor,
                  '${subject.credits} credits',
                  if (percent != null) '${percent.toStringAsFixed(1)}%',
                ].join(' · '),
              ),
            ),
          ),
          const SectionHeader('Score entries'),
          if (entries.isEmpty)
            const Text(
              'Log quizzes, papers, and exams. Weighted average becomes the course grade.',
            )
          else
            for (final entry in entries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(entry.title),
                subtitle: Text(
                  '${entry.score}/${entry.maxScore} · weight ${entry.weight}',
                ),
                onTap: () => _editGrade(context, subject.id, entry),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => state.deleteGrade(entry.id),
                ),
              ),
        ],
      ),
    );
  }
}

Future<void> _editGrade(
  BuildContext context,
  String subjectId, [
  GradeEntry? entry,
]) async {
  final state = context.read<StudentState>();
  final title = TextEditingController(text: entry?.title ?? '');
  final score = TextEditingController(text: entry?.score.toString() ?? '');
  final max = TextEditingController(text: entry?.maxScore.toString() ?? '100');
  final weight = TextEditingController(text: entry?.weight.toString() ?? '1');
  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(entry == null ? 'Add score' : 'Edit score'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: score,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Score'),
            ),
            TextField(
              controller: max,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Out of'),
            ),
            TextField(
              controller: weight,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight',
                helperText: 'Use 1 for equal items, or percents that add to 100.',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  if (saved != true) return;
  final s = double.tryParse(score.text);
  final m = double.tryParse(max.text);
  final w = double.tryParse(weight.text);
  if (title.text.trim().isEmpty || s == null || m == null || w == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a title, score, max, and weight.')),
      );
    }
    return;
  }
  await state.upsertGrade(
    GradeEntry(
      id: entry?.id ?? state.newId(),
      subjectId: subjectId,
      title: title.text.trim(),
      score: s,
      maxScore: m,
      weight: w,
    ),
  );
}
