import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';
import 'note_editor.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final q = _query.text.trim().toLowerCase();
    final items = [...state.notes]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final filtered = q.isEmpty
        ? items
        : items
            .where(
              (n) =>
                  n.title.toLowerCase().contains(q) ||
                  n.content.toLowerCase().contains(q),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NoteEditor()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _query,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search notes',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: Icons.notes_outlined,
                    title: 'No notes yet',
                    message: 'Capture lectures, formulas, and revision summaries.',
                    actionLabel: 'New note',
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NoteEditor()),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final note = filtered[i];
                      final subject = state.subjectById(note.subjectId);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(
                            subject?.colorValue ?? 0xFF1E4D8C,
                          ),
                          child: const Icon(Icons.notes, color: Colors.white),
                        ),
                        title: Text(note.title),
                        subtitle: Text(
                          [
                            if (subject != null) subject.name,
                            dateFmt.format(note.updatedAt),
                          ].join(' · '),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NoteEditor(note: note),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
