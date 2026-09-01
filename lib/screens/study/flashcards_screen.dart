import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/student_state.dart';
import '../../widgets/common.dart';
import 'flashcard_study.dart';

class FlashcardsScreen extends StatelessWidget {
  const FlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editDeck(context),
        child: const Icon(Icons.add),
      ),
      body: state.decks.isEmpty
          ? EmptyState(
              icon: Icons.style_outlined,
              title: 'No decks yet',
              message: 'Create a deck, add cards, then quiz yourself.',
              actionLabel: 'New deck',
              onAction: () => _editDeck(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
              itemCount: state.decks.length,
              itemBuilder: (context, i) {
                final deck = state.decks[i];
                final count = state.cardsForDeck(deck.id).length;
                final subject = state.subjectById(deck.subjectId);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(subject?.colorValue ?? 0xFF1E4D8C),
                    child: const Icon(Icons.style, color: Colors.white),
                  ),
                  title: Text(deck.name),
                  subtitle: Text(
                    '$count cards${subject == null ? '' : ' · ${subject.name}'}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: count == 0
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FlashcardStudyScreen(deck: deck),
                              ),
                            ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeckDetailScreen(deck: deck),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

Future<void> _editDeck(BuildContext context, [FlashcardDeck? deck]) async {
  final state = context.read<StudentState>();
  final name = TextEditingController(text: deck?.name ?? '');
  String? subjectId = deck?.subjectId;
  final saved = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModal) {
          return AlertDialog(
            title: Text(deck == null ? 'New deck' : 'Edit deck'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Deck name'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  // ignore: deprecated_member_use
                  value: subjectId,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('General')),
                    for (final s in state.subjects)
                      DropdownMenuItem(value: s.id, child: Text(s.name)),
                  ],
                  onChanged: (v) => setModal(() => subjectId = v),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
  if (saved != true || name.text.trim().isEmpty) return;
  await state.upsertDeck(
    FlashcardDeck(
      id: deck?.id ?? state.newId(),
      name: name.text.trim(),
      subjectId: subjectId,
    ),
  );
}

class DeckDetailScreen extends StatelessWidget {
  const DeckDetailScreen({super.key, required this.deck});

  final FlashcardDeck deck;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StudentState>();
    final current = state.decks.where((d) => d.id == deck.id).firstOrNull ?? deck;
    final cards = state.cardsForDeck(current.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(current.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _editDeck(context, current),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await confirmDelete(
                context,
                title: 'Delete deck?',
                message: 'All cards in this deck will be removed.',
              );
              if (!ok || !context.mounted) return;
              await state.deleteDeck(current.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editCard(context, current.id),
        child: const Icon(Icons.add),
      ),
      body: cards.isEmpty
          ? EmptyState(
              icon: Icons.style_outlined,
              title: 'Empty deck',
              message: 'Add a term on the front and the answer on the back.',
              actionLabel: 'Add card',
              onAction: () => _editCard(context, current.id),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
              itemCount: cards.length,
              itemBuilder: (context, i) {
                final card = cards[i];
                return ListTile(
                  title: Text(card.front),
                  subtitle: Text(
                    'Reviewed ${card.reviewCount} · known ${card.knownCount}',
                  ),
                  onTap: () => _editCard(context, current.id, card),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => state.deleteCard(card.id),
                  ),
                );
              },
            ),
    );
  }
}

Future<void> _editCard(
  BuildContext context,
  String deckId, [
  Flashcard? card,
]) async {
  final state = context.read<StudentState>();
  final front = TextEditingController(text: card?.front ?? '');
  final back = TextEditingController(text: card?.back ?? '');
  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(card == null ? 'New card' : 'Edit card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: front,
            decoration: const InputDecoration(labelText: 'Front'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: back,
            decoration: const InputDecoration(labelText: 'Back'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  if (saved != true || front.text.trim().isEmpty || back.text.trim().isEmpty) {
    return;
  }
  await state.upsertCard(
    Flashcard(
      id: card?.id ?? state.newId(),
      deckId: deckId,
      front: front.text.trim(),
      back: back.text.trim(),
      knownCount: card?.knownCount ?? 0,
      reviewCount: card?.reviewCount ?? 0,
    ),
  );
}
