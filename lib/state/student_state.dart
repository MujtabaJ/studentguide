import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../core/formatters.dart';
import '../core/gpa.dart';
import '../data/models.dart';
import '../data/store.dart';

const _uuid = Uuid();

class StudentState extends ChangeNotifier {
  StudentState(this._store);

  final AppStore _store;
  AppData _data = const AppData();
  bool loaded = false;

  AppData get data => _data;
  UserProfile get profile => _data.profile;
  List<Subject> get subjects => _data.subjects;
  List<TaskItem> get tasks => _data.tasks;
  List<Exam> get exams => _data.exams;
  List<ClassPeriod> get periods => _data.periods;
  List<Note> get notes => _data.notes;
  List<GradeEntry> get grades => _data.grades;
  List<FlashcardDeck> get decks => _data.decks;
  List<Flashcard> get cards => _data.cards;
  List<StudySession> get sessions => _data.sessions;

  ThemeMode get themeMode {
    switch (profile.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> load() async {
    _data = _store.load();
    loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    await _store.save(_data);
    notifyListeners();
  }

  String newId() => _uuid.v4();

  Subject? subjectById(String? id) {
    if (id == null) return null;
    for (final s in subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  List<TaskItem> get openTasks =>
      tasks.where((t) => !t.isCompleted).toList()
        ..sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });

  List<TaskItem> tasksDueOn(DateTime day) => openTasks
      .where((t) => t.dueDate != null && isSameDay(t.dueDate!, day))
      .toList();

  List<TaskItem> get overdueTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return openTasks.where((t) {
      if (t.dueDate == null) return false;
      final due = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return due.isBefore(today);
    }).toList();
  }

  List<Exam> get upcomingExams {
    final now = DateTime.now().subtract(const Duration(hours: 2));
    return exams.where((e) => e.dateTime.isAfter(now)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<ClassPeriod> periodsFor(int weekday) {
    final list = periods.where((p) => p.weekday == weekday).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    return list;
  }

  int get todayStudyMinutes {
    final now = DateTime.now();
    return sessions
        .where((s) => isSameDay(s.startedAt, now))
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  int get studyStreak {
    if (sessions.isEmpty) return 0;
    final days = sessions
        .map((s) => DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    var streak = 0;
    var cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    if (days.first != cursor &&
        days.first != cursor.subtract(const Duration(days: 1))) {
      return 0;
    }
    if (days.first != cursor) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    for (final day in days) {
      if (day == cursor) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (day.isBefore(cursor)) {
        break;
      }
    }
    return streak;
  }

  double? subjectPercent(String subjectId) {
    final entries = grades.where((g) => g.subjectId == subjectId).toList();
    if (entries.isEmpty) return null;
    var weighted = 0.0;
    var totalWeight = 0.0;
    for (final e in entries) {
      if (e.maxScore <= 0) continue;
      weighted += (e.score / e.maxScore) * 100 * e.weight;
      totalWeight += e.weight;
    }
    if (totalWeight == 0) return null;
    return weighted / totalWeight;
  }

  String? subjectLetter(Subject subject) {
    final percent = subjectPercent(subject.id);
    if (percent != null) return percentToLetter(percent);
    return subject.letterGrade;
  }

  double? subjectPoints(Subject subject) {
    final letter = subjectLetter(subject);
    if (letter == null) return null;
    return letterToPoints(letter);
  }

  double? get gpa {
    var points = 0.0;
    var credits = 0.0;
    for (final subject in subjects) {
      final p = subjectPoints(subject);
      if (p == null || subject.credits <= 0) continue;
      points += p * subject.credits;
      credits += subject.credits;
    }
    if (credits == 0) return null;
    return points / credits;
  }

  Future<void> updateProfile(UserProfile profile) async {
    _data = _data.copyWith(profile: profile);
    await _persist();
  }

  Future<void> upsertSubject(Subject subject) async {
    final list = [...subjects];
    final i = list.indexWhere((s) => s.id == subject.id);
    if (i >= 0) {
      list[i] = subject;
    } else {
      list.add(subject);
    }
    _data = _data.copyWith(subjects: list);
    await _persist();
  }

  Future<void> deleteSubject(String id) async {
    _data = _data.copyWith(
      subjects: subjects.where((s) => s.id != id).toList(),
      tasks: tasks
          .map((t) => t.subjectId == id ? t.copyWith(clearSubject: true) : t)
          .toList(),
      exams: exams
          .map((e) => e.subjectId == id ? e.copyWith(clearSubject: true) : e)
          .toList(),
      periods: periods.where((p) => p.subjectId != id).toList(),
      notes: notes
          .map((n) => n.subjectId == id ? n.copyWith(clearSubject: true) : n)
          .toList(),
      grades: grades.where((g) => g.subjectId != id).toList(),
      decks: decks
          .map((d) => d.subjectId == id ? d.copyWith(clearSubject: true) : d)
          .toList(),
    );
    await _persist();
  }

  Future<void> upsertTask(TaskItem task) async {
    final list = [...tasks];
    final i = list.indexWhere((t) => t.id == task.id);
    if (i >= 0) {
      list[i] = task;
    } else {
      list.add(task);
    }
    _data = _data.copyWith(tasks: list);
    await _persist();
  }

  Future<void> deleteTask(String id) async {
    _data = _data.copyWith(tasks: tasks.where((t) => t.id != id).toList());
    await _persist();
  }

  Future<void> toggleTask(String id) async {
    _data = _data.copyWith(
      tasks: tasks
          .map((t) => t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t)
          .toList(),
    );
    await _persist();
  }

  Future<void> upsertExam(Exam exam) async {
    final list = [...exams];
    final i = list.indexWhere((e) => e.id == exam.id);
    if (i >= 0) {
      list[i] = exam;
    } else {
      list.add(exam);
    }
    _data = _data.copyWith(exams: list);
    await _persist();
  }

  Future<void> deleteExam(String id) async {
    _data = _data.copyWith(exams: exams.where((e) => e.id != id).toList());
    await _persist();
  }

  Future<void> upsertPeriod(ClassPeriod period) async {
    final list = [...periods];
    final i = list.indexWhere((p) => p.id == period.id);
    if (i >= 0) {
      list[i] = period;
    } else {
      list.add(period);
    }
    _data = _data.copyWith(periods: list);
    await _persist();
  }

  Future<void> deletePeriod(String id) async {
    _data = _data.copyWith(periods: periods.where((p) => p.id != id).toList());
    await _persist();
  }

  Future<void> upsertNote(Note note) async {
    final list = [...notes];
    final i = list.indexWhere((n) => n.id == note.id);
    if (i >= 0) {
      list[i] = note;
    } else {
      list.add(note);
    }
    _data = _data.copyWith(notes: list);
    await _persist();
  }

  Future<void> deleteNote(String id) async {
    _data = _data.copyWith(notes: notes.where((n) => n.id != id).toList());
    await _persist();
  }

  Future<void> upsertGrade(GradeEntry grade) async {
    final list = [...grades];
    final i = list.indexWhere((g) => g.id == grade.id);
    if (i >= 0) {
      list[i] = grade;
    } else {
      list.add(grade);
    }
    _data = _data.copyWith(grades: list);
    await _persist();
  }

  Future<void> deleteGrade(String id) async {
    _data = _data.copyWith(grades: grades.where((g) => g.id != id).toList());
    await _persist();
  }

  Future<void> upsertDeck(FlashcardDeck deck) async {
    final list = [...decks];
    final i = list.indexWhere((d) => d.id == deck.id);
    if (i >= 0) {
      list[i] = deck;
    } else {
      list.add(deck);
    }
    _data = _data.copyWith(decks: list);
    await _persist();
  }

  Future<void> deleteDeck(String id) async {
    _data = _data.copyWith(
      decks: decks.where((d) => d.id != id).toList(),
      cards: cards.where((c) => c.deckId != id).toList(),
    );
    await _persist();
  }

  Future<void> upsertCard(Flashcard card) async {
    final list = [...cards];
    final i = list.indexWhere((c) => c.id == card.id);
    if (i >= 0) {
      list[i] = card;
    } else {
      list.add(card);
    }
    _data = _data.copyWith(cards: list);
    await _persist();
  }

  Future<void> deleteCard(String id) async {
    _data = _data.copyWith(cards: cards.where((c) => c.id != id).toList());
    await _persist();
  }

  List<Flashcard> cardsForDeck(String deckId) =>
      cards.where((c) => c.deckId == deckId).toList();

  Future<void> logSession({
    required DateTime startedAt,
    required int durationMinutes,
    String? subjectId,
  }) async {
    if (durationMinutes < 1) return;
    _data = _data.copyWith(
      sessions: [
        ...sessions,
        StudySession(
          id: newId(),
          startedAt: startedAt,
          durationMinutes: durationMinutes,
          subjectId: subjectId,
        ),
      ],
    );
    await _persist();
  }

  String exportBackup() => _store.exportJson(_data);

  Future<void> importBackup(String raw) async {
    _data = _store.importJson(raw);
    await _persist();
  }

  Future<void> clearAll() async {
    _data = const AppData();
    await _store.clear();
    notifyListeners();
  }
}
