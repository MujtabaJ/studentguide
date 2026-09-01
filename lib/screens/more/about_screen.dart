import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            Icons.school_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Student Guide',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          const Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'by Audrey',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'Student Guide helps you plan classes, keep up with assignments and exams, take notes, study with a timer and flashcards, and track GPA. Everything is stored on this device.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.android_outlined),
            title: Text('Package'),
            subtitle: Text('com.audrey.student.guide'),
          ),
        ],
      ),
    );
  }
}
