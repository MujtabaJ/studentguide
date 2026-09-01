import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';

class ExamEditor extends StatefulWidget {
  const ExamEditor({super.key, this.exam});

  final Exam? exam;

  @override
  State<ExamEditor> createState() => _ExamEditorState();
}

class _ExamEditorState extends State<ExamEditor> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _location;
  late final TextEditingController _notes;
  String? _subjectId;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final exam = widget.exam;
    _title = TextEditingController(text: exam?.title ?? '');
    _location = TextEditingController(text: exam?.location ?? '');
    _notes = TextEditingController(text: exam?.notes ?? '');
    _subjectId = exam?.subjectId;
    _date = exam?.dateTime ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date),
    );
    setState(() {
      _date = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? _date.hour,
        time?.minute ?? _date.minute,
      );
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final state = context.read<StudentState>();
    await state.upsertExam(
      Exam(
        id: widget.exam?.id ?? state.newId(),
        title: _title.text.trim(),
        dateTime: _date,
        subjectId: _subjectId,
        location: _location.text.trim(),
        notes: _notes.text.trim(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam == null ? 'New exam' : 'Edit exam'),
        actions: [
          if (widget.exam != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(
                  context,
                  title: 'Delete exam?',
                  message: 'This countdown will be removed.',
                );
                if (!ok || !context.mounted) return;
                await state.deleteExam(widget.exam!.id);
                if (context.mounted) Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Exam title'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              // ignore: deprecated_member_use
              value: _subjectId,
              decoration: const InputDecoration(labelText: 'Subject'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                for (final s in state.subjects)
                  DropdownMenuItem(value: s.id, child: Text(s.name)),
              ],
              onChanged: (v) => setState(() => _subjectId = v),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date and time'),
              subtitle: Text(_date.toString().substring(0, 16)),
              trailing: const Icon(Icons.event),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _location,
              decoration: const InputDecoration(labelText: 'Room or location'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'What to review'),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
