/// Pain / discomfort rules for post-workout feedback.
///
/// [highPainThreshold] is kept in sync with the server safety hook
/// (`HIGH_PAIN_THRESHOLD` in `apps/api/src/work/workout-pain.ts`). Notes are
/// required for any score above 0, which is stricter than the server hook
/// (the server only raises a safety alert at the threshold).
abstract final class WorkoutPain {
  static const highPainThreshold = 4;

  static bool isHighPain(int score) => score >= highPainThreshold;

  static bool requiresNotes(int score) => score > 0;
}
