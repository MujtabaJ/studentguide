import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../state/student_state.dart';
import '../../state/timer_state.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late final TimerState _timer;

  @override
  void initState() {
    super.initState();
    _timer = context.read<TimerState>();
    _timer.addListener(_onTick);
  }

  void _onTick() {
    final timer = context.read<TimerState>();
    final minutes = timer.consumeCompletedFocus();
    if (minutes != null) {
      context.read<StudentState>().logSession(
            startedAt: DateTime.now().subtract(Duration(minutes: minutes)),
            durationMinutes: minutes,
            subjectId: timer.subjectId,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Focus session saved · ${formatMinutes(minutes)}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer.removeListener(_onTick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerState>();
    final state = context.watch<StudentState>();
    final scheme = Theme.of(context).colorScheme;
    final label = switch (timer.mode) {
      TimerMode.focus => 'Focus',
      TimerMode.shortBreak => 'Short break',
      TimerMode.longBreak => 'Long break',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Study timer')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CircularProgressIndicator(
                      value: timer.progress,
                      strokeWidth: 12,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        formatClock(timer.remainingSeconds),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text('Round ${timer.completedFocusRounds + 1}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final mode in TimerMode.values)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(switch (mode) {
                      TimerMode.focus => 'Focus',
                      TimerMode.shortBreak => 'Short',
                      TimerMode.longBreak => 'Long',
                    }),
                    selected: timer.mode == mode,
                    onSelected: timer.running
                        ? null
                        : (_) => timer.switchMode(mode),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            // ignore: deprecated_member_use
            value: timer.subjectId,
            decoration: const InputDecoration(labelText: 'Studying'),
            items: [
              const DropdownMenuItem(value: null, child: Text('General')),
              for (final s in state.subjects)
                DropdownMenuItem(value: s.id, child: Text(s.name)),
            ],
            onChanged: timer.running ? null : timer.setSubject,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: timer.running ? timer.pause : timer.start,
                  icon: Icon(timer.running ? Icons.pause : Icons.play_arrow),
                  label: Text(timer.running ? 'Pause' : 'Start'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: timer.reset,
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset',
              ),
              IconButton.filledTonal(
                onPressed: timer.skip,
                icon: const Icon(Icons.skip_next),
                tooltip: 'Skip',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Durations (minutes)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _DurationRow(
            label: 'Focus',
            value: timer.focusMinutes,
            onChanged: timer.running
                ? null
                : (v) => timer.setDurations(focus: v),
          ),
          _DurationRow(
            label: 'Short break',
            value: timer.shortBreakMinutes,
            onChanged: timer.running
                ? null
                : (v) => timer.setDurations(shortBreak: v),
          ),
          _DurationRow(
            label: 'Long break',
            value: timer.longBreakMinutes,
            onChanged: timer.running
                ? null
                : (v) => timer.setDurations(longBreak: v),
          ),
          const SizedBox(height: 16),
          Card(
            color: scheme.surfaceContainerHighest,
            child: ListTile(
              leading: const Icon(Icons.today_outlined),
              title: Text('Today: ${formatMinutes(state.todayStudyMinutes)}'),
              subtitle: Text('Goal: ${formatMinutes(state.profile.dailyGoalMinutes)}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationRow extends StatelessWidget {
  const _DurationRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          onPressed: onChanged == null ? null : () => onChanged!(value - 5),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(width: 40, child: Text('$value', textAlign: TextAlign.center)),
        IconButton(
          onPressed: onChanged == null ? null : () => onChanged!(value + 5),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
