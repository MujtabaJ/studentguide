import 'package:flutter/material.dart';

import '../more/tips_screen.dart';
import 'flashcards_screen.dart';
import 'notes_screen.dart';
import 'timer_screen.dart';

class StudyHubScreen extends StatelessWidget {
  const StudyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (
        Icons.timer_outlined,
        'Study timer',
        'Pomodoro focus sessions',
        const TimerScreen(),
      ),
      (
        Icons.notes_outlined,
        'Notes',
        'Lecture and revision notes',
        const NotesScreen(),
      ),
      (
        Icons.style_outlined,
        'Flashcards',
        'Active recall decks',
        const FlashcardsScreen(),
      ),
      (
        Icons.lightbulb_outline,
        'Study tips',
        'Techniques that actually work',
        const TipsScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Study')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemCount: tiles.length,
        itemBuilder: (context, i) {
          final tile = tiles[i];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => tile.$4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(tile.$1, size: 32, color: Theme.of(context).colorScheme.primary),
                    const Spacer(),
                    Text(tile.$2, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      tile.$3,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
