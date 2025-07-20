class MoodEntry {
  final String id;
  final DateTime date;
  final Mood mood;
  final String? memo;

  MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    this.memo,
  });
}

enum Mood {
  veryHappy('😊', '매우 행복해요', 0),
  happy('🙂', '행복해요', 1),
  neutral('😐', '그저 그래요', 2),
  sad('😢', '슬퍼요', 3),
  angry('😠', '화나요', 4);

  final String emoji;
  final String label;
  final int moodIndex;

  const Mood(this.emoji, this.label, this.moodIndex);
}