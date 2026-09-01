import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../data/models.dart';
import '../../screens/grades/subject_editor.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';

class PeriodEditor extends StatefulWidget {
  const PeriodEditor({super.key, this.period, this.weekday});

  final ClassPeriod? period;
  final int? weekday;

  @override
  State<PeriodEditor> createState() => _PeriodEditorState();
}

class _PeriodEditorState extends State<PeriodEditor> {
  String? _subjectId;
  late int _weekday;
  late int _start;
  late int _end;
  late final TextEditingController _room;

  @override
  void initState() {
    super.initState();
    final p = widget.period;
    _subjectId = p?.subjectId;
    _weekday = p?.weekday ?? widget.weekday ?? DateTime.now().weekday;
    _start = p?.startMinutes ?? 9 * 60;
    _end = p?.endMinutes ?? 10 * 60;
    _room = TextEditingController(text: p?.room ?? '');
  }

  @override
  void dispose() {
    _room.dispose();
    super.dispose();
  }

  Future<void> _pick(bool start) async {
    final initial = minutesToTime(start ? _start : _end);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      final minutes = timeToMinutes(picked);
      if (start) {
        _start = minutes;
        if (_end <= _start) _end = _start + 60;
      } else {
        _end = minutes;
      }
    });
  }

  Future<void> _save() async {
    final state = context.read<StudentState>();
    if (_subjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a subject first.')),
      );
      return;
    }
    if (_end <= _start) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }
    await state.upsertPeriod(
      ClassPeriod(
        id: widget.period?.id ?? state.newId(),
        subjectId: _subjectId!,
        weekday: _weekday,
        startMinutes: _start,
        endMinutes: _end,
        room: _room.text.trim(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.period == null ? 'Add class' : 'Edit class'),
        actions: [
          if (widget.period != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(
                  context,
                  title: 'Remove class?',
                  message: 'This period will leave the timetable.',
                );
                if (!ok || !context.mounted) return;
                await state.deletePeriod(widget.period!.id);
                if (context.mounted) Navigator.pop(context);
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (state.subjects.isEmpty)
            FilledButton.tonal(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubjectEditor()),
              ),
              child: const Text('Add a subject first'),
            )
          else
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _subjectId,
              decoration: const InputDecoration(labelText: 'Subject'),
              items: [
                for (final s in state.subjects)
                  DropdownMenuItem(value: s.id, child: Text(s.name)),
              ],
              onChanged: (v) => setState(() => _subjectId = v),
            ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            // ignore: deprecated_member_use
            value: _weekday,
            decoration: const InputDecoration(labelText: 'Day'),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Monday')),
              DropdownMenuItem(value: 2, child: Text('Tuesday')),
              DropdownMenuItem(value: 3, child: Text('Wednesday')),
              DropdownMenuItem(value: 4, child: Text('Thursday')),
              DropdownMenuItem(value: 5, child: Text('Friday')),
              DropdownMenuItem(value: 6, child: Text('Saturday')),
              DropdownMenuItem(value: 7, child: Text('Sunday')),
            ],
            onChanged: (v) => setState(() => _weekday = v ?? _weekday),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Starts'),
            subtitle: Text(formatTimeOfDay(context, _start)),
            onTap: () => _pick(true),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Ends'),
            subtitle: Text(formatTimeOfDay(context, _end)),
            onTap: () => _pick(false),
          ),
          TextField(
            controller: _room,
            decoration: const InputDecoration(labelText: 'Room (optional)'),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}
