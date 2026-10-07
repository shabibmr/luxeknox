import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/media/upload_progress_widget.dart';
import 'package:luxeknox/core/widgets/app_filter_sheet_shell.dart';
import 'package:luxeknox/features/exercises/domain/entities/exercise.dart';
import 'package:luxeknox/features/exercises/presentation/widgets/exercise_list_item.dart';
import 'package:luxeknox/features/foods/domain/entities/food.dart';
import 'package:luxeknox/features/foods/presentation/widgets/food_list_item.dart';
import 'package:luxeknox/features/notifications/domain/entities/app_notification.dart';
import 'package:luxeknox/features/notifications/presentation/widgets/notification_list_tile.dart';

/// Narrow-viewport layout audit for widgets that previously used unconstrained
/// spaceBetween Rows or ListTile + Chip combinations.
void main() {
  const narrow = Size(320, 640);

  Future<void> pumpNarrow(WidgetTester tester, Widget child) async {
    final view = tester.view;
    view.physicalSize = narrow;
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('ExerciseListItem survives long name + chip at 320px', (
    tester,
  ) async {
    const exercise = Exercise(
      id: '1',
      name: 'Single-Arm Dumbbell Romanian Deadlift With Contralateral Reach',
      primaryMuscleGroup: 'Hamstrings and Posterior Chain',
      secondaryMuscles: ['Glutes', 'Erectors'],
      equipmentNeeded: ['Dumbbell', 'Bench', 'Resistance band'],
      instructions: 'Hinge.',
      difficultyLevel: 'Advanced Intermediate',
      isActive: true,
    );

    await pumpNarrow(tester, const ExerciseListItem(exercise: exercise));
    expect(tester.takeException(), isNull);
    expect(find.byType(ExerciseListItem), findsOneWidget);
  });

  testWidgets('FoodListItem survives long name + chip at 320px', (
    tester,
  ) async {
    const food = Food(
      id: '1',
      name: 'Organic Grass-Fed Greek Yogurt With Honey And Granola Topping',
      servingSize: 250,
      servingUnit: 'grams per serving container',
      calories: 220,
      proteinGrams: 20,
      carbsGrams: 25,
      fatGrams: 5,
      isVerified: true,
      isActive: true,
    );

    await pumpNarrow(tester, const FoodListItem(food: food));
    expect(tester.takeException(), isNull);
    expect(find.byType(FoodListItem), findsOneWidget);
  });

  testWidgets('AppFilterSheetShell title row does not overflow at 320px', (
    tester,
  ) async {
    await pumpNarrow(
      tester,
      AppFilterSheetShell(
        title: 'Extremely Long Filter Sheet Title That Would Overflow',
        clearAllLabel: 'Clear all filters now',
        applyLabel: 'Apply filters',
        onClearAll: () {},
        onApply: () {},
        children: const [Text('Field')],
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('UploadProgressWidget rows do not overflow at 320px', (
    tester,
  ) async {
    await pumpNarrow(
      tester,
      UploadProgressWidget(
        isUploading: true,
        progress: 0.42,
        sentBytes: 12 * 1024 * 1024,
        totalBytes: 48 * 1024 * 1024,
        onCancel: () {},
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('NotificationListTile unread chip survives long title at 320px', (
    tester,
  ) async {
    final notification = AppNotification(
      id: '1',
      title:
          'Your personal training package renewal reminder for next month is ready',
      message:
          'Please review the attached schedule and confirm whether you want to continue with the same trainer assignment.',
      createdAt: DateTime.utc(2026, 3, 15, 12),
      isRead: false,
    );

    await pumpNarrow(
      tester,
      NotificationListTile(notification: notification, onTap: () {}),
    );
    expect(tester.takeException(), isNull);
  });
}
