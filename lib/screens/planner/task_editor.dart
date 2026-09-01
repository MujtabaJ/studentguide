import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';

class TaskEditor extends StatefulWidget {
  const TaskEditor({super.key, this.task});

  final TaskItem? task;

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  String? _subjectId;
  DateTime? _due;
  TaskPriority _priority = TaskPriority.medium;
  TaskType _type = TaskType.assignment;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = TextEditingController(text: task?.title ?? '');
    _description = TextEditingController(text: task?.description ?? '');
    _subjectId = task?.subjectId;
    _due = task?.dueDate;
    _priority = task?.priority ?? TaskPriority.medium;
    _type = task?.type ?? TaskType.assignment;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final state = context.read<StudentState>();
    final task = TaskItem(
      id: widget.task?.id ?? state.newId(),
      title: _title.text.trim(),
      description: _description.text.trim(),
      subjectId: _subjectId,
      dueDate: _due,
      priority: _priority,
      type: _type,
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
    );
    await state.upsertTask(task);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New task' : 'Edit task'),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(
                  context,
                  title: 'Delete task?',
                  message: 'This cannot be undone.',
                );
                if (!ok || !context.mounted) return;
                await state.deleteTask(widget.task!.id);
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
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Title'),
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
            DropdownButtonFormField<TaskType>(
              // ignore: deprecated_member_use
              value: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: [
                for (final t in TaskType.values)
                  DropdownMenuItem(value: t, child: Text(t.name)),
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              // ignore: deprecated_member_use
              value: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: [
                for (final p in TaskPriority.values)
                  DropdownMenuItem(value: p, child: Text(p.name)),
              ],
              onChanged: (v) => setState(() => _priority = v ?? _priority),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Due date'),
              subtitle: Text(_due == null ? 'None' : _due.toString().split(' ').first),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_due != null)
                    IconButton(
                      onPressed: () => setState(() => _due = null),
                      icon: const Icon(Icons.clear),
                    ),
                  IconButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _due ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _due = picked);
                    },
                    icon: const Icon(Icons.event),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _description,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
