import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/student_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  final _name = TextEditingController();
  final _school = TextEditingController();
  String _level = 'High school';
  int _index = 0;

  static const _levels = [
    'Middle school',
    'High school',
    'College',
    'University',
    'Other',
  ];

  @override
  void dispose() {
    _page.dispose();
    _name.dispose();
    _school.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final state = context.read<StudentState>();
    await state.updateProfile(
      state.profile.copyWith(
        name: _name.text.trim(),
        school: _school.text.trim(),
        gradeLevel: _level,
        onboardingComplete: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _page,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  _IntroPage(
                    icon: Icons.school_rounded,
                    title: 'Welcome to Student Guide',
                    body:
                        'Plan your classes, track assignments and exams, take notes, study with flashcards, and watch your GPA — all on your device.',
                  ),
                  _IntroPage(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Built for real student days',
                    body:
                        'A weekly timetable, Pomodoro timer, grade tracker, and study tips live in one place. Your data stays on this phone.',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ListView(
                      children: [
                        Text(
                          'Tell us about you',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This is only stored locally and you can change it later.',
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Your name',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _school,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'School or campus (optional)',
                            prefixIcon: Icon(Icons.apartment_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          // ignore: deprecated_member_use
                          value: _level,
                          decoration: const InputDecoration(
                            labelText: 'Level',
                            prefixIcon: Icon(Icons.grade_outlined),
                          ),
                          items: [
                            for (final level in _levels)
                              DropdownMenuItem(value: level, child: Text(level)),
                          ],
                          onChanged: (v) => setState(() => _level = v ?? _level),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _index == i ? 22 : 8,
                        decoration: BoxDecoration(
                          color: _index == i
                              ? scheme.primary
                              : scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      if (_index < 2) {
                        _page.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                        );
                      } else {
                        _finish();
                      }
                    },
                    child: Text(_index < 2 ? 'Continue' : 'Get started'),
                  ),
                  if (_index == 2)
                    TextButton(
                      onPressed: _finish,
                      child: const Text('Skip for now'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 88, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
