class StudyTip {
  const StudyTip({
    required this.id,
    required this.title,
    required this.category,
    required this.body,
  });

  final String id;
  final String title;
  final String category;
  final String body;
}

const studyTips = <StudyTip>[
  StudyTip(
    id: 'active-recall',
    title: 'Use active recall',
    category: 'Study techniques',
    body:
        'Close the notes and write or say everything you remember. Checking afterward shows what you actually know. Rereading feels productive but is a weaker way to learn.',
  ),
  StudyTip(
    id: 'spaced',
    title: 'Space your reviews',
    category: 'Study techniques',
    body:
        'Review material after 1 day, 3 days, and 1 week instead of cramming once. Short, repeated sessions beat one long night before the exam.',
  ),
  StudyTip(
    id: 'feynman',
    title: 'Teach it simply',
    category: 'Study techniques',
    body:
        'Explain the idea in plain language as if teaching a friend. Where you get stuck is exactly what to study next.',
  ),
  StudyTip(
    id: 'pomodoro',
    title: 'Work in focused sprints',
    category: 'Time management',
    body:
        'Study 25 minutes, then rest 5. After four rounds, take a longer break. The timer in this app follows that pattern so you stay consistent without burning out.',
  ),
  StudyTip(
    id: 'two-minute',
    title: 'Start with two minutes',
    category: 'Time management',
    body:
        'If a task feels heavy, commit to two minutes only. Opening the notes or reading one paragraph is often enough to keep going.',
  ),
  StudyTip(
    id: 'plan-week',
    title: 'Plan the week on Sunday',
    category: 'Time management',
    body:
        'List due dates, exams, and fixed classes first. Then place study blocks around them. Protect one evening for rest so the plan is realistic.',
  ),
  StudyTip(
    id: 'cornell',
    title: 'Cornell notes',
    category: 'Note taking',
    body:
        'Divide the page: cues on the left, notes on the right, summary at the bottom. Cover the notes and quiz yourself from the cue column later.',
  ),
  StudyTip(
    id: 'questions',
    title: 'Write questions, not transcripts',
    category: 'Note taking',
    body:
        'Turn headings into questions during class. Afterward, answer them from memory. This turns notes into a ready-made quiz.',
  ),
  StudyTip(
    id: 'exam-week',
    title: 'Exam week plan',
    category: 'Exam prep',
    body:
        'List every exam and the chapters it covers. Rank weak topics first. Sleep 7–9 hours; tired recall is worse than a shorter review.',
  ),
  StudyTip(
    id: 'past-papers',
    title: 'Practice under exam conditions',
    category: 'Exam prep',
    body:
        'If you can get past papers or sample questions, time yourself. Mark the answers, then restudy only the misses.',
  ),
  StudyTip(
    id: 'sleep',
    title: 'Sleep is study time',
    category: 'Wellbeing',
    body:
        'Memory consolidates during sleep. An all-nighter often costs more marks than it saves. Stop 30 minutes before bed and rest.',
  ),
  StudyTip(
    id: 'breaks',
    title: 'Move between sessions',
    category: 'Wellbeing',
    body:
        'Stand, stretch, or walk during breaks. A short reset improves focus for the next sprint more than scrolling social media.',
  ),
  StudyTip(
    id: 'phone',
    title: 'Park the phone',
    category: 'Wellbeing',
    body:
        'Put the phone in another room or use Do Not Disturb while the study timer runs. Attention residue from messages slows learning.',
  ),
  StudyTip(
    id: 'writing',
    title: 'Draft, then polish',
    category: 'Academic writing',
    body:
        'Write a messy first draft without editing. Then check structure, then sentences, then citations. Mixing all three at once stalls most students.',
  ),
  StudyTip(
    id: 'cite',
    title: 'Cite as you go',
    category: 'Academic writing',
    body:
        'Save the source the moment you use an idea. Last-minute citation hunts cause errors and extra stress.',
  ),
];

StudyTip tipOfTheDay(DateTime date) {
  final index = date.difference(DateTime(date.year)).inDays % studyTips.length;
  return studyTips[index];
}
