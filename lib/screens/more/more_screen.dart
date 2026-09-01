import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/student_state.dart';
import '../grades/subject_editor.dart';
import 'about_screen.dart';
import 'privacy_screen.dart';
import 'settings_screen.dart';
import 'tips_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<StudentState>().profile;
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text(profile.name.isEmpty ? 'Student' : profile.name),
            subtitle: Text(
              [
                if (profile.school.isNotEmpty) profile.school,
                if (profile.gradeLevel.isNotEmpty) profile.gradeLevel,
              ].join(' · ').ifEmpty('Tap settings to add your details'),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.tune),
            title: const Text('Settings'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_box_outlined),
            title: const Text('Add subject'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubjectEditor()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: const Text('Study tips'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TipsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy policy'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
