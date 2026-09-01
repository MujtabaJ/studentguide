import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy policy')),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/legal/privacy_policy.md'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text(snapshot.data!),
          );
        },
      ),
    );
  }
}
