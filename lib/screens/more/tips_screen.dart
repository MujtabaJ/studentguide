import 'package:flutter/material.dart';

import '../../data/study_tips.dart';
import '../study/tip_detail.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<StudyTip>>{};
    for (final tip in studyTips) {
      grouped.putIfAbsent(tip.category, () => []).add(tip);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Study tips')),
      body: ListView(
        children: [
          for (final category in grouped.keys) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(category, style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final tip in grouped[category]!)
              ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(tip.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TipDetailScreen(tip: tip)),
                ),
              ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
