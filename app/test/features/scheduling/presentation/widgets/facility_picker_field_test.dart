import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_catalog.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/catalog_usecases.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:luxeknox/features/scheduling/presentation/widgets/facility_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockListFacilitiesUseCase extends Mock implements ListFacilitiesUseCase {}

void main() {
  late MockListFacilitiesUseCase listFacilities;

  const facilities = [
    FacilityInfo(id: 'f1', name: 'Main hall', isActive: true),
    FacilityInfo(id: 'f2', name: 'Studio B', isActive: true),
  ];

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    listFacilities = MockListFacilitiesUseCase();
  });

  Widget buildApp() {
    return MaterialApp(
      home: Scaffold(
        body: FacilityPickerField(
          listFacilities: listFacilities,
          onChanged: (_) {},
        ),
      ),
    );
  }

  testWidgets('shows a spinner while loading', (tester) async {
    when(() => listFacilities(any())).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 50),
        () => const Right(facilities),
      ),
    );

    await tester.pumpWidget(buildApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('renders facilities and reports selection', (tester) async {
    when(() => listFacilities(any())).thenAnswer((_) async => const Right(facilities));
    FacilityInfo? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FacilityPickerField(
            listFacilities: listFacilities,
            onChanged: (facility) => selected = facility,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('facility_picker_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Studio B').last);
    await tester.pumpAndSettle();

    expect(selected, facilities[1]);
  });

  testWidgets('shows retry on load failure and reloads on tap', (tester) async {
    var callCount = 0;
    when(() => listFacilities(any())).thenAnswer((_) async {
      callCount++;
      return callCount == 1
          ? const Left(NetworkFailure())
          : const Right(facilities);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text(SchedulingStrings.facilityFieldLabel), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(callCount, 2);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
  });
}
