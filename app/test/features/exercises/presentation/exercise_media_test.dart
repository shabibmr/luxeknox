import 'package:app/features/exercises/presentation/widgets/exercise_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseMedia (K9)', () {
    testWidgets('shows a placeholder when there is no media', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ExerciseMedia())),
      );

      expect(find.text('No media available.'), findsOneWidget);
    });

    testWidgets('a broken gif URL falls back without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseMedia(gifUrl: 'https://example.invalid/broken.gif'),
          ),
        ),
      );

      // Let the failed network image resolve to its errorBuilder.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
      expect(find.text('Preview unavailable.'), findsOneWidget);
    });

    testWidgets('shows a watch-video button when a video URL is present', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseMedia(videoUrl: 'https://example.com/video'),
          ),
        ),
      );

      expect(
        find.widgetWithText(OutlinedButton, 'Watch video'),
        findsOneWidget,
      );
    });

    testWidgets(
      'a video link that fails to launch shows an error snackbar, never a crash',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExerciseMedia(
                videoUrl: 'https://example.com/video',
                launcher: (_) async => false,
              ),
            ),
          ),
        );

        await tester.tap(find.widgetWithText(OutlinedButton, 'Watch video'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Could not open the video link.'), findsOneWidget);
      },
    );

    testWidgets('a launcher that throws never crashes the app', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseMedia(
              videoUrl: 'https://example.com/video',
              launcher: (_) async => throw Exception('boom'),
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(OutlinedButton, 'Watch video'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Could not open the video link.'), findsOneWidget);
    });
  });
}
