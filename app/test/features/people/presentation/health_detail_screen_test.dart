import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/features/people/domain/entities/health_info.dart';
import 'package:luxeknox/features/people/domain/usecases/create_health_record_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_health_history_usecase.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/health_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockListHealthHistoryUseCase extends Mock
    implements ListHealthHistoryUseCase {}

class MockCreateHealthRecordUseCase extends Mock
    implements CreateHealthRecordUseCase {}

void main() {
  late MockListHealthHistoryUseCase listHistory;
  late MockCreateHealthRecordUseCase createRecord;

  final tOlder = HealthInfo(
    id: 1,
    memberId: 5,
    bloodGroup: 'B+',
    recordedAt: DateTime(2026, 1, 1),
  );
  final tNewer = HealthInfo(
    id: 2,
    memberId: 5,
    bloodGroup: 'O+',
    recordedAt: DateTime(2026, 2, 1),
  );

  setUpAll(() {
    registerFallbackValue(tOlder);
  });

  setUp(() {
    listHistory = MockListHealthHistoryUseCase();
    createRecord = MockCreateHealthRecordUseCase();

    getIt.registerFactory<ListHealthHistoryUseCase>(() => listHistory);
    getIt.registerFactory<CreateHealthRecordUseCase>(() => createRecord);
  });

  tearDown(() => getIt.reset());

  Widget wrap(Widget child) => MaterialApp(home: child);

  testWidgets('Previous is disabled with a single record', (tester) async {
    when(() => listHistory(5)).thenAnswer((_) async => Right([tOlder]));

    await tester.pumpWidget(wrap(const HealthDetailScreen(memberId: 5)));
    await tester.pumpAndSettle();

    final previousButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, PeopleStrings.previous),
    );
    expect(previousButton.onPressed, isNull);
  });

  testWidgets('Previous is enabled with two records', (tester) async {
    when(() => listHistory(5))
        .thenAnswer((_) async => Right([tNewer, tOlder]));

    await tester.pumpWidget(wrap(const HealthDetailScreen(memberId: 5)));
    await tester.pumpAndSettle();

    final previousButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, PeopleStrings.previous),
    );
    expect(previousButton.onPressed, isNotNull);
  });

  testWidgets('tapping Save calls cubit.save, not an update path', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    when(() => listHistory(5)).thenAnswer((_) async => Right([tOlder]));
    when(
      () => createRecord(any()),
    ).thenAnswer((_) async => Right(tNewer));

    await tester.pumpWidget(wrap(const HealthDetailScreen(memberId: 5)));
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(FilledButton, PeopleStrings.save);
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    verify(() => createRecord(any())).called(1);
  });
}
