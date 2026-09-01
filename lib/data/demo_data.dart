import 'models.dart';

AppData buildDemoData([DateTime? now]) {
  final n = now ?? DateTime.now();
  final today = DateTime(n.year, n.month, n.day);
  const bio = 'sub-bio';
  const math = 'sub-math';
  const hist = 'sub-hist';
  const eng = 'sub-eng';

  return AppData(
    profile: const UserProfile(
      name: 'Alex Rivera',
      school: 'Riverside High',
      gradeLevel: 'High school',
      onboardingComplete: true,
      themeMode: 'light',
      dailyGoalMinutes: 60,
    ),
    subjects: const [
      Subject(
        id: bio,
        name: 'Biology',
        code: 'BIO 201',
        instructor: 'Dr. Chen',
        room: 'Lab 2',
        credits: 4,
        colorValue: 0xFF0F766E,
      ),
      Subject(
        id: math,
        name: 'Algebra II',
        code: 'MATH 220',
        instructor: 'Ms. Patel',
        room: 'B14',
        credits: 4,
        colorValue: 0xFF1E4D8C,
        letterGrade: 'A',
      ),
      Subject(
        id: hist,
        name: 'World History',
        code: 'HIST 110',
        instructor: 'Mr. Alvarez',
        room: 'C3',
        credits: 3,
        colorValue: 0xFFB45309,
      ),
      Subject(
        id: eng,
        name: 'English Lit',
        code: 'ENG 150',
        instructor: 'Mrs. Brooks',
        room: 'A1',
        credits: 3,
        colorValue: 0xFF7C3AED,
      ),
    ],
    tasks: [
      TaskItem(
        id: 't1',
        title: 'Lab report: cell mitosis',
        description: 'Include diagrams and sources.',
        subjectId: bio,
        dueDate: today,
        priority: TaskPriority.high,
        type: TaskType.assignment,
        createdAt: today.subtract(const Duration(days: 3)),
      ),
      TaskItem(
        id: 't2',
        title: 'Algebra homework set 12',
        subjectId: math,
        dueDate: today.add(const Duration(days: 1)),
        priority: TaskPriority.medium,
        type: TaskType.homework,
        createdAt: today.subtract(const Duration(days: 1)),
      ),
      TaskItem(
        id: 't3',
        title: 'Read chapter 8 — revolutions',
        subjectId: hist,
        dueDate: today.add(const Duration(days: 2)),
        priority: TaskPriority.low,
        type: TaskType.reading,
        createdAt: today.subtract(const Duration(days: 2)),
      ),
      TaskItem(
        id: 't4',
        title: 'Essay outline: Macbeth',
        subjectId: eng,
        dueDate: today.add(const Duration(days: 4)),
        priority: TaskPriority.medium,
        type: TaskType.project,
        createdAt: today.subtract(const Duration(days: 4)),
      ),
    ],
    exams: [
      Exam(
        id: 'e1',
        title: 'Biology midterm',
        dateTime: today.add(const Duration(days: 6, hours: 9)),
        subjectId: bio,
        location: 'Hall A',
        notes: 'Chapters 1–6, diagrams of mitosis.',
      ),
      Exam(
        id: 'e2',
        title: 'Algebra quiz',
        dateTime: today.add(const Duration(days: 2, hours: 11)),
        subjectId: math,
        location: 'B14',
      ),
    ],
    periods: [
      ClassPeriod(
        id: 'p1',
        subjectId: math,
        weekday: n.weekday,
        startMinutes: 8 * 60 + 30,
        endMinutes: 9 * 60 + 20,
        room: 'B14',
      ),
      ClassPeriod(
        id: 'p2',
        subjectId: bio,
        weekday: n.weekday,
        startMinutes: 10 * 60,
        endMinutes: 11 * 60 + 15,
        room: 'Lab 2',
      ),
      ClassPeriod(
        id: 'p3',
        subjectId: eng,
        weekday: n.weekday,
        startMinutes: 13 * 60,
        endMinutes: 13 * 60 + 50,
        room: 'A1',
      ),
      ClassPeriod(
        id: 'p4',
        subjectId: hist,
        weekday: n.weekday == 7 ? 1 : n.weekday + 1,
        startMinutes: 9 * 60,
        endMinutes: 9 * 60 + 50,
        room: 'C3',
      ),
    ],
    notes: [
      Note(
        id: 'n1',
        title: 'Mitosis stages',
        content:
            'Prophase, metaphase, anaphase, telophase. Remember spindle fibers attach at the centromere.',
        subjectId: bio,
        updatedAt: n.subtract(const Duration(hours: 5)),
      ),
      Note(
        id: 'n2',
        title: 'Quadratic formula',
        content: 'x = (-b ± √(b² - 4ac)) / 2a',
        subjectId: math,
        updatedAt: n.subtract(const Duration(days: 1)),
      ),
    ],
    grades: const [
      GradeEntry(
        id: 'g1',
        subjectId: bio,
        title: 'Quiz 1',
        score: 92,
        maxScore: 100,
        weight: 10,
      ),
      GradeEntry(
        id: 'g2',
        subjectId: bio,
        title: 'Lab 3',
        score: 88,
        maxScore: 100,
        weight: 15,
      ),
      GradeEntry(
        id: 'g3',
        subjectId: math,
        title: 'Unit test',
        score: 95,
        maxScore: 100,
        weight: 25,
      ),
      GradeEntry(
        id: 'g4',
        subjectId: hist,
        title: 'Essay 1',
        score: 86,
        maxScore: 100,
        weight: 20,
      ),
    ],
    decks: const [
      FlashcardDeck(id: 'd1', name: 'Biology terms', subjectId: bio),
    ],
    cards: const [
      Flashcard(
        id: 'c1',
        deckId: 'd1',
        front: 'Mitochondria',
        back: 'Organelle that produces ATP',
        knownCount: 4,
        reviewCount: 6,
      ),
      Flashcard(
        id: 'c2',
        deckId: 'd1',
        front: 'Photosynthesis',
        back: 'Process that converts light into chemical energy',
        knownCount: 2,
        reviewCount: 5,
      ),
    ],
    sessions: [
      for (var i = 0; i < 5; i++)
        StudySession(
          id: 's$i',
          startedAt: today.subtract(Duration(days: i)).add(const Duration(hours: 19)),
          durationMinutes: i == 0 ? 45 : 30,
          subjectId: i.isEven ? bio : math,
        ),
    ],
  );
}
