import 'package:flutter/material.dart';

import '../../data/study_tips.dart';

class TipDetailScreen extends StatelessWidget {
  const TipDetailScreen({super.key, required this.tip});

  final StudyTip tip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tip.category)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(tip.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(tip.body, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
