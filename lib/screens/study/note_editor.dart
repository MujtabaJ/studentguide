import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, this.note});

  final Note? note;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late final TextEditingController _title;
  late final TextEditingController _content;
  String? _subjectId;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note?.title ?? '');
    _content = TextEditingController(text: widget.note?.content ?? '');
    _subjectId = widget.note?.subjectId;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _title.text.trim().isEmpty ? 'Untitled note' : _title.text.trim();
    final state = context.read<StudentState>();
    await state.upsertNote(
      Note(
        id: widget.note?.id ?? state.newId(),
        title: title,
        content: _content.text,
        subjectId: _subjectId,
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New note' : 'Edit note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(
                  context,
                  title: 'Delete note?',
                  message: 'This note will be removed from the device.',
                );
                if (!ok || !context.mounted) return;
                await state.deleteNote(widget.note!.id);
                if (context.mounted) Navigator.pop(context);
              },
            ),
          IconButton(onPressed: _save, icon: const Icon(Icons.check)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            // ignore: deprecated_member_use
            value: _subjectId,
            decoration: const InputDecoration(labelText: 'Subject'),
            items: [
              const DropdownMenuItem(value: null, child: Text('General')),
              for (final s in state.subjects)
                DropdownMenuItem(value: s.id, child: Text(s.name)),
            ],
            onChanged: (v) => setState(() => _subjectId = v),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _content,
            minLines: 12,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              labelText: 'Content',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
