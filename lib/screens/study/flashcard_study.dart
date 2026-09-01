import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/student_state.dart';

class FlashcardStudyScreen extends StatefulWidget {
  const FlashcardStudyScreen({super.key, required this.deck});

  final FlashcardDeck deck;

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  int _index = 0;
  bool _flipped = false;
  int _knownThisSession = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final cards = state.cardsForDeck(widget.deck.id);
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.deck.name)),
        body: const Center(child: Text('This deck has no cards.')),
      );
    }
    final card = cards[_index % cards.length];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('${(_index % cards.length) + 1}/${cards.length}'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _flipped = !_flipped),
                child: Card(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _flipped ? 'Answer' : 'Prompt',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _flipped ? card.back : card.front,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tap to flip',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _grade(state, card, false),
                    child: const Text('Again'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _grade(state, card, true),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Known this session: $_knownThisSession'),
          ],
        ),
      ),
    );
  }

  Future<void> _grade(StudentState state, Flashcard card, bool known) async {
    await state.upsertCard(
      card.copyWith(
        reviewCount: card.reviewCount + 1,
        knownCount: known ? card.knownCount + 1 : card.knownCount,
      ),
    );
    setState(() {
      if (known) _knownThisSession++;
      _index++;
      _flipped = false;
    });
  }
}
