enum TaskPriority { low, medium, high }

enum TaskType { assignment, homework, project, reading, other }

class UserProfile {
  const UserProfile({
    this.name = '',
    this.school = '',
    this.gradeLevel = '',
    this.onboardingComplete = false,
    this.themeMode = 'system',
    this.dailyGoalMinutes = 60,
  });

  final String name;
  final String school;
  final String gradeLevel;
  final bool onboardingComplete;
  final String themeMode;
  final int dailyGoalMinutes;

  UserProfile copyWith({
    String? name,
    String? school,
    String? gradeLevel,
    bool? onboardingComplete,
    String? themeMode,
    int? dailyGoalMinutes,
  }) {
    return UserProfile(
      name: name ?? this.name,
      school: school ?? this.school,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      themeMode: themeMode ?? this.themeMode,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'school': school,
        'gradeLevel': gradeLevel,
        'onboardingComplete': onboardingComplete,
        'themeMode': themeMode,
        'dailyGoalMinutes': dailyGoalMinutes,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? '',
        school: json['school'] as String? ?? '',
        gradeLevel: json['gradeLevel'] as String? ?? '',
        onboardingComplete: json['onboardingComplete'] as bool? ?? false,
        themeMode: json['themeMode'] as String? ?? 'system',
        dailyGoalMinutes: json['dailyGoalMinutes'] as int? ?? 60,
      );
}

class Subject {
  const Subject({
    required this.id,
    required this.name,
    this.code = '',
    this.instructor = '',
    this.room = '',
    this.credits = 3,
    this.colorValue = 0xFF1E4D8C,
    this.letterGrade,
  });

  final String id;
  final String name;
  final String code;
  final String instructor;
  final String room;
  final double credits;
  final int colorValue;
  final String? letterGrade;

  Subject copyWith({
    String? name,
    String? code,
    String? instructor,
    String? room,
    double? credits,
    int? colorValue,
    String? letterGrade,
    bool clearLetter = false,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      code: code ?? this.code,
      instructor: instructor ?? this.instructor,
      room: room ?? this.room,
      credits: credits ?? this.credits,
      colorValue: colorValue ?? this.colorValue,
      letterGrade: clearLetter ? letterGrade : (letterGrade ?? this.letterGrade),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'instructor': instructor,
        'room': room,
        'credits': credits,
        'colorValue': colorValue,
        'letterGrade': letterGrade,
      };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String? ?? '',
        instructor: json['instructor'] as String? ?? '',
        room: json['room'] as String? ?? '',
        credits: (json['credits'] as num?)?.toDouble() ?? 3,
        colorValue: json['colorValue'] as int? ?? 0xFF1E4D8C,
        letterGrade: json['letterGrade'] as String?,
      );
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    this.description = '',
    this.subjectId,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.type = TaskType.assignment,
    this.isCompleted = false,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String? subjectId;
  final DateTime? dueDate;
  final TaskPriority priority;
  final TaskType type;
  final bool isCompleted;
  final DateTime createdAt;

  TaskItem copyWith({
    String? title,
    String? description,
    String? subjectId,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskType? type,
    bool? isCompleted,
    bool clearSubject = false,
    bool clearDue = false,
  }) {
    return TaskItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      subjectId: clearSubject ? null : (subjectId ?? this.subjectId),
      dueDate: clearDue ? null : (dueDate ?? this.dueDate),
      priority: priority ?? this.priority,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'subjectId': subjectId,
        'dueDate': dueDate?.toIso8601String(),
        'priority': priority.name,
        'type': type.name,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        subjectId: json['subjectId'] as String?,
        dueDate: json['dueDate'] == null
            ? null
            : DateTime.tryParse(json['dueDate'] as String),
        priority: TaskPriority.values.byName(
          json['priority'] as String? ?? 'medium',
        ),
        type: TaskType.values.byName(json['type'] as String? ?? 'assignment'),
        isCompleted: json['isCompleted'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.dateTime,
    this.subjectId,
    this.location = '',
    this.notes = '',
  });

  final String id;
  final String title;
  final DateTime dateTime;
  final String? subjectId;
  final String location;
  final String notes;

  Exam copyWith({
    String? title,
    DateTime? dateTime,
    String? subjectId,
    String? location,
    String? notes,
    bool clearSubject = false,
  }) {
    return Exam(
      id: id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      subjectId: clearSubject ? null : (subjectId ?? this.subjectId),
      location: location ?? this.location,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'subjectId': subjectId,
        'location': location,
        'notes': notes,
      };

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
        id: json['id'] as String,
        title: json['title'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        subjectId: json['subjectId'] as String?,
        location: json['location'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
      );
}

class ClassPeriod {
  const ClassPeriod({
    required this.id,
    required this.subjectId,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    this.room = '',
  });

  final String id;
  final String subjectId;
  final int weekday;
  final int startMinutes;
  final int endMinutes;
  final String room;

  ClassPeriod copyWith({
    String? subjectId,
    int? weekday,
    int? startMinutes,
    int? endMinutes,
    String? room,
  }) {
    return ClassPeriod(
      id: id,
      subjectId: subjectId ?? this.subjectId,
      weekday: weekday ?? this.weekday,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      room: room ?? this.room,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'weekday': weekday,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
        'room': room,
      };

  factory ClassPeriod.fromJson(Map<String, dynamic> json) => ClassPeriod(
        id: json['id'] as String,
        subjectId: json['subjectId'] as String,
        weekday: json['weekday'] as int,
        startMinutes: json['startMinutes'] as int,
        endMinutes: json['endMinutes'] as int,
        room: json['room'] as String? ?? '',
      );
}

class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.subjectId,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String content;
  final String? subjectId;
  final DateTime updatedAt;

  Note copyWith({
    String? title,
    String? content,
    String? subjectId,
    DateTime? updatedAt,
    bool clearSubject = false,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      subjectId: clearSubject ? null : (subjectId ?? this.subjectId),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'subjectId': subjectId,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String? ?? '',
        subjectId: json['subjectId'] as String?,
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

class GradeEntry {
  const GradeEntry({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.score,
    required this.maxScore,
    this.weight = 1,
  });

  final String id;
  final String subjectId;
  final String title;
  final double score;
  final double maxScore;
  final double weight;

  GradeEntry copyWith({
    String? title,
    double? score,
    double? maxScore,
    double? weight,
  }) {
    return GradeEntry(
      id: id,
      subjectId: subjectId,
      title: title ?? this.title,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'title': title,
        'score': score,
        'maxScore': maxScore,
        'weight': weight,
      };

  factory GradeEntry.fromJson(Map<String, dynamic> json) => GradeEntry(
        id: json['id'] as String,
        subjectId: json['subjectId'] as String,
        title: json['title'] as String,
        score: (json['score'] as num).toDouble(),
        maxScore: (json['maxScore'] as num).toDouble(),
        weight: (json['weight'] as num?)?.toDouble() ?? 1,
      );
}

class FlashcardDeck {
  const FlashcardDeck({
    required this.id,
    required this.name,
    this.subjectId,
  });

  final String id;
  final String name;
  final String? subjectId;

  FlashcardDeck copyWith({String? name, String? subjectId, bool clearSubject = false}) {
    return FlashcardDeck(
      id: id,
      name: name ?? this.name,
      subjectId: clearSubject ? null : (subjectId ?? this.subjectId),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subjectId': subjectId,
      };

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) => FlashcardDeck(
        id: json['id'] as String,
        name: json['name'] as String,
        subjectId: json['subjectId'] as String?,
      );
}

class Flashcard {
  const Flashcard({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.knownCount = 0,
    this.reviewCount = 0,
  });

  final String id;
  final String deckId;
  final String front;
  final String back;
  final int knownCount;
  final int reviewCount;

  Flashcard copyWith({
    String? front,
    String? back,
    int? knownCount,
    int? reviewCount,
  }) {
    return Flashcard(
      id: id,
      deckId: deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      knownCount: knownCount ?? this.knownCount,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'deckId': deckId,
        'front': front,
        'back': back,
        'knownCount': knownCount,
        'reviewCount': reviewCount,
      };

  factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
        id: json['id'] as String,
        deckId: json['deckId'] as String,
        front: json['front'] as String,
        back: json['back'] as String,
        knownCount: json['knownCount'] as int? ?? 0,
        reviewCount: json['reviewCount'] as int? ?? 0,
      );
}

class StudySession {
  const StudySession({
    required this.id,
    required this.startedAt,
    required this.durationMinutes,
    this.subjectId,
  });

  final String id;
  final DateTime startedAt;
  final int durationMinutes;
  final String? subjectId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'startedAt': startedAt.toIso8601String(),
        'durationMinutes': durationMinutes,
        'subjectId': subjectId,
      };

  factory StudySession.fromJson(Map<String, dynamic> json) => StudySession(
        id: json['id'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
        durationMinutes: json['durationMinutes'] as int,
        subjectId: json['subjectId'] as String?,
      );
}

class AppData {
  const AppData({
    this.profile = const UserProfile(),
    this.subjects = const [],
    this.tasks = const [],
    this.exams = const [],
    this.periods = const [],
    this.notes = const [],
    this.grades = const [],
    this.decks = const [],
    this.cards = const [],
    this.sessions = const [],
  });

  final UserProfile profile;
  final List<Subject> subjects;
  final List<TaskItem> tasks;
  final List<Exam> exams;
  final List<ClassPeriod> periods;
  final List<Note> notes;
  final List<GradeEntry> grades;
  final List<FlashcardDeck> decks;
  final List<Flashcard> cards;
  final List<StudySession> sessions;

  AppData copyWith({
    UserProfile? profile,
    List<Subject>? subjects,
    List<TaskItem>? tasks,
    List<Exam>? exams,
    List<ClassPeriod>? periods,
    List<Note>? notes,
    List<GradeEntry>? grades,
    List<FlashcardDeck>? decks,
    List<Flashcard>? cards,
    List<StudySession>? sessions,
  }) {
    return AppData(
      profile: profile ?? this.profile,
      subjects: subjects ?? this.subjects,
      tasks: tasks ?? this.tasks,
      exams: exams ?? this.exams,
      periods: periods ?? this.periods,
      notes: notes ?? this.notes,
      grades: grades ?? this.grades,
      decks: decks ?? this.decks,
      cards: cards ?? this.cards,
      sessions: sessions ?? this.sessions,
    );
  }

  Map<String, dynamic> toJson() => {
        'profile': profile.toJson(),
        'subjects': subjects.map((e) => e.toJson()).toList(),
        'tasks': tasks.map((e) => e.toJson()).toList(),
        'exams': exams.map((e) => e.toJson()).toList(),
        'periods': periods.map((e) => e.toJson()).toList(),
        'notes': notes.map((e) => e.toJson()).toList(),
        'grades': grades.map((e) => e.toJson()).toList(),
        'decks': decks.map((e) => e.toJson()).toList(),
        'cards': cards.map((e) => e.toJson()).toList(),
        'sessions': sessions.map((e) => e.toJson()).toList(),
      };

  factory AppData.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> list(String key) {
      final raw = json[key];
      if (raw is! List) return const [];
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }

    return AppData(
      profile: json['profile'] is Map
          ? UserProfile.fromJson(Map<String, dynamic>.from(json['profile'] as Map))
          : const UserProfile(),
      subjects: list('subjects').map(Subject.fromJson).toList(),
      tasks: list('tasks').map(TaskItem.fromJson).toList(),
      exams: list('exams').map(Exam.fromJson).toList(),
      periods: list('periods').map(ClassPeriod.fromJson).toList(),
      notes: list('notes').map(Note.fromJson).toList(),
      grades: list('grades').map(GradeEntry.fromJson).toList(),
      decks: list('decks').map(FlashcardDeck.fromJson).toList(),
      cards: list('cards').map(Flashcard.fromJson).toList(),
      sessions: list('sessions').map(StudySession.fromJson).toList(),
    );
  }
}
