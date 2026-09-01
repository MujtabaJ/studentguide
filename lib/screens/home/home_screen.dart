import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../data/study_tips.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';
import '../planner/exam_editor.dart';
import '../planner/task_editor.dart';
import '../study/tip_detail.dart';
import '../study/timer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final now = DateTime.now();
    final name = state.profile.name.trim();
    final greeting = greetingFor(now);
    final title = name.isEmpty ? greeting : '$greeting, $name';
    final weekday = now.weekday;
    final todayClasses = state.periodsFor(weekday);
    final dueToday = state.tasksDueOn(now);
    final overdue = state.overdueTasks;
    final exams = state.upcomingExams.take(3).toList();
    final tip = tipOfTheDay(now);
    final goal = state.profile.dailyGoalMinutes;
    final studied = state.todayStudyMinutes;
    final progress = goal == 0 ? 0.0 : (studied / goal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Guide'),
        actions: [
          IconButton(
            tooltip: 'Study timer',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimerScreen()),
            ),
            icon: const Icon(Icons.timer_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          if (state.profile.school.isNotEmpty)
            Text(
              state.profile.school,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'GPA',
                  value: state.gpa == null ? '—' : state.gpa!.toStringAsFixed(2),
                  icon: Icons.insights_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Streak',
                  value: '${state.studyStreak}d',
                  icon: Icons.local_fire_department_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Open tasks',
                  value: '${state.openTasks.length}',
                  icon: Icons.checklist_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today’s study goal',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatMinutes(studied)} of ${formatMinutes(goal)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (overdue.isNotEmpty) ...[
            const SectionHeader('Overdue'),
            for (final task in overdue.take(5))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.warning_amber_rounded),
                title: Text(task.title),
                subtitle: Text(
                  task.dueDate == null ? 'No date' : dateFmt.format(task.dueDate!),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TaskEditor(task: task)),
                ),
              ),
          ],
          const SectionHeader('Today’s classes'),
          if (todayClasses.isEmpty)
            const Text('No classes on the timetable for today.')
          else
            for (final period in todayClasses)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Color(
                    state.subjectById(period.subjectId)?.colorValue ?? 0xFF1E4D8C,
                  ),
                  child: const Icon(Icons.class_outlined, color: Colors.white),
                ),
                title: Text(
                  state.subjectById(period.subjectId)?.name ?? 'Class',
                ),
                subtitle: Text(
                  '${formatTimeOfDay(context, period.startMinutes)} – ${formatTimeOfDay(context, period.endMinutes)}'
                  '${period.room.isEmpty ? '' : ' · ${period.room}'}',
                ),
              ),
          const SectionHeader('Due today'),
          if (dueToday.isEmpty)
            const Text('Nothing due today. Add a task when work is assigned.')
          else
            for (final task in dueToday)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: task.isCompleted,
                onChanged: (_) => state.toggleTask(task.id),
                title: Text(task.title),
                subtitle: Text(
                  state.subjectById(task.subjectId)?.name ?? task.type.name,
                ),
              ),
          const SectionHeader('Upcoming exams'),
          if (exams.isEmpty)
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExamEditor()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add an exam'),
            )
          else
            for (final exam in exams)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: Text(exam.title),
                subtitle: Text(
                  '${dateTimeFmt.format(exam.dateTime)} · ${_countdown(exam.dateTime)}',
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExamEditor(exam: exam)),
                ),
              ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: Text(tip.title),
              subtitle: Text(tip.category),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TipDetailScreen(tip: tip)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _countdown(DateTime date) {
    final days = date.difference(DateTime.now()).inDays;
    if (days < 0) return 'passed';
    if (days == 0) return 'today';
    if (days == 1) return 'tomorrow';
    return 'in $days days';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(label, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
