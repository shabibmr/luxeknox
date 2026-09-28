import 'package:luxeknox/core/media/upload_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UploadProgressWidget (FR-MEDIA-001/002)', () {
    testWidgets('renders nothing when idle and no error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UploadProgressWidget(isUploading: false),
          ),
        ),
      );

      expect(find.byType(Card), findsNothing);
      expect(find.text('Uploading…'), findsNothing);
    });

    testWidgets('renders progress indicator, formatted bytes, and triggers cancel', (tester) async {
      var canceled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UploadProgressWidget(
              isUploading: true,
              progress: 0.5,
              sentBytes: 2 * 1024 * 1024,
              totalBytes: 4 * 1024 * 1024,
              onCancel: () => canceled = true,
            ),
          ),
        ),
      );

      expect(find.text('Uploading…'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('2.0 MB / 4.0 MB'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      expect(canceled, isTrue);
    });

    testWidgets('renders error banner and triggers retry', (tester) async {
      var retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UploadProgressWidget(
              isUploading: false,
              errorMessage: 'Network timeout during upload',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Network timeout during upload'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });
  });
}
