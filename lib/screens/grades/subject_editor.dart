import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/gpa.dart';
import '../../core/theme.dart';
import '../../data/models.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';

class SubjectEditor extends StatefulWidget {
  const SubjectEditor({super.key, this.subject});

  final Subject? subject;

  @override
  State<SubjectEditor> createState() => _SubjectEditorState();
}

class _SubjectEditorState extends State<SubjectEditor> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _code;
  late final TextEditingController _instructor;
  late final TextEditingController _room;
  late final TextEditingController _credits;
  late int _color;
  String? _letter;

  @override
  void initState() {
    super.initState();
    final s = widget.subject;
    _name = TextEditingController(text: s?.name ?? '');
    _code = TextEditingController(text: s?.code ?? '');
    _instructor = TextEditingController(text: s?.instructor ?? '');
    _room = TextEditingController(text: s?.room ?? '');
    _credits = TextEditingController(text: (s?.credits ?? 3).toString());
    _color = s?.colorValue ?? AppColors.seed.toARGB32();
    _letter = s?.letterGrade;
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _instructor.dispose();
    _room.dispose();
    _credits.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final state = context.read<StudentState>();
    await state.upsertSubject(
      Subject(
        id: widget.subject?.id ?? state.newId(),
        name: _name.text.trim(),
        code: _code.text.trim(),
        instructor: _instructor.text.trim(),
        room: _room.text.trim(),
        credits: double.tryParse(_credits.text.trim()) ?? 3,
        colorValue: _color,
        letterGrade: _letter,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject == null ? 'New subject' : 'Edit subject'),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Course name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _code,
              decoration: const InputDecoration(labelText: 'Code (e.g. MATH 101)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instructor,
              decoration: const InputDecoration(labelText: 'Instructor'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _room,
              decoration: const InputDecoration(labelText: 'Usual room'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _credits,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Credits'),
              validator: (v) {
                final n = double.tryParse(v ?? '');
                if (n == null || n < 0) return 'Enter credits';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              // ignore: deprecated_member_use
              value: _letter,
              decoration: const InputDecoration(
                labelText: 'Overall letter grade (optional)',
                helperText: 'Used for GPA if you have not logged scores yet.',
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Not set')),
                for (final letter in letterPoints.keys)
                  DropdownMenuItem(value: letter, child: Text(letter)),
              ],
              onChanged: (v) => setState(() => _letter = v),
            ),
            const SizedBox(height: 16),
            Text('Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SubjectColorDots(
              value: _color,
              colors: AppColors.palette,
              onChanged: (v) => setState(() => _color = v),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
