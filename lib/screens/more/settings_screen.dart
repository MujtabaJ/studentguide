import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../state/student_state.dart';
import '../../widgets/common.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _name;
  late final TextEditingController _school;

  @override
  void initState() {
    super.initState();
    final p = context.read<StudentState>().profile;
    _name = TextEditingController(text: p.name);
    _school = TextEditingController(text: p.school);
  }

  @override
  void dispose() {
    _name.dispose();
    _school.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final state = context.read<StudentState>();
    await state.updateProfile(
      state.profile.copyWith(
        name: _name.text.trim(),
        school: _school.text.trim(),
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final profile = state.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Profile', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            onEditingComplete: _saveProfile,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _school,
            decoration: const InputDecoration(labelText: 'School'),
            onEditingComplete: _saveProfile,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: profile.gradeLevel.isEmpty ? 'High school' : profile.gradeLevel,
            decoration: const InputDecoration(labelText: 'Level'),
            items: const [
              DropdownMenuItem(value: 'Middle school', child: Text('Middle school')),
              DropdownMenuItem(value: 'High school', child: Text('High school')),
              DropdownMenuItem(value: 'College', child: Text('College')),
              DropdownMenuItem(value: 'University', child: Text('University')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => state.updateProfile(
              profile.copyWith(gradeLevel: v ?? profile.gradeLevel),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: _saveProfile, child: const Text('Save profile')),
          const SizedBox(height: 24),
          Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'system', label: Text('System')),
              ButtonSegment(value: 'light', label: Text('Light')),
              ButtonSegment(value: 'dark', label: Text('Dark')),
            ],
            selected: {profile.themeMode},
            onSelectionChanged: (s) =>
                state.updateProfile(profile.copyWith(themeMode: s.first)),
          ),
          const SizedBox(height: 24),
          Text('Study goal', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 15,
            max: 240,
            divisions: 15,
            label: '${profile.dailyGoalMinutes} min',
            value: profile.dailyGoalMinutes.toDouble().clamp(15, 240),
            onChanged: (v) => state.updateProfile(
              profile.copyWith(dailyGoalMinutes: v.round()),
            ),
          ),
          Text('${profile.dailyGoalMinutes} minutes per day'),
          const SizedBox(height: 24),
          Text('Data', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.ios_share),
            title: const Text('Export backup'),
            subtitle: const Text('Share a JSON copy of your local data'),
            onTap: () async {
              final json = state.exportBackup();
              await SharePlus.instance.share(ShareParams(text: json, title: 'Student Guide backup'));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Import backup'),
            onTap: () => _import(context),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
            title: const Text('Clear all data'),
            onTap: () async {
              final ok = await confirmDelete(
                context,
                title: 'Clear all data?',
                message:
                    'Subjects, tasks, notes, grades, and study history will be erased on this device.',
              );
              if (!ok || !context.mounted) return;
              await state.clearAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All local data cleared')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _import(BuildContext context) async {
    final controller = TextEditingController();
    final raw = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import backup'),
        content: TextField(
          controller: controller,
          minLines: 6,
          maxLines: 10,
          decoration: const InputDecoration(
            hintText: 'Paste the backup JSON here',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Import'),
          ),
        ],
      ),
    );
    if (raw == null || raw.trim().isEmpty || !context.mounted) return;
    try {
      await context.read<StudentState>().importBackup(raw);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup restored')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('That file is not a valid backup.')),
        );
      }
    }
  }
}
