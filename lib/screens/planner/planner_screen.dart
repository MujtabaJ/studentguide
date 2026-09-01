import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';
import 'exam_editor.dart';
import 'period_editor.dart';
import 'task_editor.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Planner'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tasks'),
              Tab(text: 'Schedule'),
              Tab(text: 'Exams'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TasksTab(),
            _ScheduleTab(),
            _ExamsTab(),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final index = DefaultTabController.of(context).index;
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TaskEditor()),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PeriodEditor()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExamEditor()),
                  );
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}

enum _TaskFilter { open, today, done }

class _TasksTab extends StatefulWidget {
  const _TasksTab();

  @override
  State<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<_TasksTab> {
  _TaskFilter _filter = _TaskFilter.open;
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final now = DateTime.now();
    var items = switch (_filter) {
      _TaskFilter.open => state.openTasks,
      _TaskFilter.today => state.tasksDueOn(now),
      _TaskFilter.done =>
        state.tasks.where((t) => t.isCompleted).toList().reversed.toList(),
    };
    final q = _query.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      items = items.where((t) => t.title.toLowerCase().contains(q)).toList();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _query,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search tasks',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Open'),
                selected: _filter == _TaskFilter.open,
                onSelected: (_) => setState(() => _filter = _TaskFilter.open),
              ),
              ChoiceChip(
                label: const Text('Today'),
                selected: _filter == _TaskFilter.today,
                onSelected: (_) => setState(() => _filter = _TaskFilter.today),
              ),
              ChoiceChip(
                label: const Text('Done'),
                selected: _filter == _TaskFilter.done,
                onSelected: (_) => setState(() => _filter = _TaskFilter.done),
              ),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? EmptyState(
                  icon: Icons.checklist_outlined,
                  title: 'No tasks',
                  message:
                      'Add homework, projects, and readings so due dates stay in one list.',
                  actionLabel: 'Add task',
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TaskEditor()),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final task = items[i];
                    final subject = state.subjectById(task.subjectId);
                    return Slidable(
                      key: ValueKey(task.id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => state.toggleTask(task.id),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            icon: task.isCompleted
                                ? Icons.undo
                                : Icons.check,
                            label: task.isCompleted ? 'Undo' : 'Done',
                          ),
                          SlidableAction(
                            onPressed: (_) async {
                              final ok = await confirmDelete(
                                context,
                                title: 'Delete task?',
                                message: 'This cannot be undone.',
                              );
                              if (ok) await state.deleteTask(task.id);
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            foregroundColor: Colors.white,
                            icon: Icons.delete_outline,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(subject?.colorValue ?? 0xFF64748B),
                          child: Icon(
                            task.isCompleted
                                ? Icons.check
                                : Icons.assignment_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          [
                            if (subject != null) subject.name,
                            if (task.dueDate != null)
                              dateFmt.format(task.dueDate!),
                            task.priority.name,
                          ].join(' · '),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskEditor(task: task),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ScheduleTab extends StatefulWidget {
  const _ScheduleTab();

  @override
  State<_ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<_ScheduleTab> {
  late int _weekday = DateTime.now().weekday;

  static const _days = [
    (1, 'Mon'),
    (2, 'Tue'),
    (3, 'Wed'),
    (4, 'Thu'),
    (5, 'Fri'),
    (6, 'Sat'),
    (7, 'Sun'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final periods = state.periodsFor(_weekday);
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              for (final day in _days)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(day.$2),
                    selected: _weekday == day.$1,
                    onSelected: (_) => setState(() => _weekday = day.$1),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: periods.isEmpty
              ? EmptyState(
                  icon: Icons.calendar_view_week_outlined,
                  title: 'No classes this day',
                  message: 'Build your weekly timetable so Home can show today.',
                  actionLabel: 'Add class',
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PeriodEditor(weekday: _weekday),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 88),
                  itemCount: periods.length,
                  itemBuilder: (context, i) {
                    final period = periods[i];
                    final subject = state.subjectById(period.subjectId);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(
                          subject?.colorValue ?? 0xFF1E4D8C,
                        ),
                      ),
                      title: Text(subject?.name ?? 'Class'),
                      subtitle: Text(
                        '${formatTimeOfDay(context, period.startMinutes)} – ${formatTimeOfDay(context, period.endMinutes)}'
                        '${period.room.isEmpty ? '' : ' · ${period.room}'}',
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PeriodEditor(period: period),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final ok = await confirmDelete(
                            context,
                            title: 'Remove class?',
                            message: 'This period will leave the timetable.',
                          );
                          if (ok) await state.deletePeriod(period.id);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ExamsTab extends StatelessWidget {
  const _ExamsTab();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final items = [...state.exams]
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.event_outlined,
        title: 'No exams yet',
        message: 'Add exam dates for a countdown on Home.',
        actionLabel: 'Add exam',
        onAction: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ExamEditor()),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final exam = items[i];
        final subject = state.subjectById(exam.subjectId);
        final days = exam.dateTime.difference(DateTime.now()).inDays;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(subject?.colorValue ?? 0xFF1E4D8C),
            child: Text(
              days < 0 ? '—' : '$days',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          title: Text(exam.title),
          subtitle: Text(
            [
              dateTimeFmt.format(exam.dateTime),
              if (subject != null) subject.name,
              if (exam.location.isNotEmpty) exam.location,
            ].join(' · '),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExamEditor(exam: exam)),
          ),
        );
      },
    );
  }
}
