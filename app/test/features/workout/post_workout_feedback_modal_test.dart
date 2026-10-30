import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/workout/presentation/widgets/post_workout_feedback_modal.dart';
import 'package:luxeknox/features/workout/presentation/workout_strings.dart';

void main() {
  Widget buildTestHost({
    void Function(PostWorkoutFeedbackResult?)? onResult,
    int initialPain = 0,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await PostWorkoutFeedbackModal.show(
                  context,
                  initialPain: initialPain,
                );
                onResult?.call(result);
              },
              child: const Text('Open Modal'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders initial sliders and notes field', (tester) async {
    await tester.pumpWidget(buildTestHost());
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    expect(find.text(WorkoutStrings.completeConfirmTitle), findsOneWidget);
    expect(find.text(WorkoutStrings.effortRatingLabel), findsOneWidget);
    expect(find.text(WorkoutStrings.satisfactionRatingLabel), findsOneWidget);
    expect(find.text(WorkoutStrings.painDiscomfortLabel), findsOneWidget);
    expect(find.text(WorkoutStrings.notesLabel), findsOneWidget);

    // With pain = 0, pain notes field is not visible
    expect(find.text(WorkoutStrings.painNotesLabel), findsNothing);
  });

  testWidgets(
    'shows pain notes and high discomfort alert when pain is high, requires pain notes',
    (tester) async {
      PostWorkoutFeedbackResult? capturedResult;
      await tester.pumpWidget(
        buildTestHost(initialPain: 4, onResult: (res) => capturedResult = res),
      );
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Pain notes field and safety warning should be visible
      expect(find.text(WorkoutStrings.painNotesLabel), findsOneWidget);
      expect(find.text(WorkoutStrings.highDiscomfortAlert), findsOneWidget);

      // Attempt submit without pain notes -> blocked by validation error
      await tester.tap(find.byKey(const ValueKey('feedback-modal-submit-btn')));
      await tester.pumpAndSettle();

      expect(capturedResult, isNull);
      expect(
        find.text('Please describe any pain or discomfort experienced'),
        findsOneWidget,
      );

      // Fill in pain notes and submit
      await tester.enterText(
        find.byKey(const ValueKey('feedback-pain-notes-field')),
        'Left knee tweak during heavy split squat',
      );
      await tester.enterText(
        find.byKey(const ValueKey('feedback-general-notes-field')),
        'Solid volume overall',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('feedback-modal-submit-btn')));
      await tester.pumpAndSettle();

      expect(capturedResult, isNotNull);
      expect(capturedResult!.effortRating, 7);
      expect(capturedResult!.satisfactionRating, 8);
      expect(capturedResult!.painDiscomfortScore, 4);
      expect(
        capturedResult!.painNotes,
        'Left knee tweak during heavy split squat',
      );
      expect(capturedResult!.notes, 'Solid volume overall');
    },
  );

  testWidgets('submits cleanly with zero pain without pain notes', (
    tester,
  ) async {
    PostWorkoutFeedbackResult? capturedResult;
    await tester.pumpWidget(
      buildTestHost(onResult: (res) => capturedResult = res),
    );
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('feedback-modal-submit-btn')));
    await tester.pumpAndSettle();

    expect(capturedResult, isNotNull);
    expect(capturedResult!.painDiscomfortScore, 0);
    expect(capturedResult!.painNotes, isNull);
  });
}
