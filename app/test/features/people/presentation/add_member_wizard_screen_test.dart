import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/domain/entities/new_member_input.dart';
import 'package:luxeknox/features/people/domain/usecases/create_member_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/add_member_wizard_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/add_member_wizard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateMemberUseCase extends Mock implements CreateMemberUseCase {}

void main() {
  late MockCreateMemberUseCase createMember;

  setUpAll(() {
    registerFallbackValue(const NewMemberInput());
  });

  setUp(() {
    createMember = MockCreateMemberUseCase();
    when(
      () => createMember(any()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    getIt.registerFactory<AddMemberWizardCubit>(
      () => AddMemberWizardCubit(createMember),
    );
  });

  tearDown(() => getIt.reset());

  testWidgets('renders wizard steps and next control', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: AddMemberWizardScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.addMemberTitle), findsOneWidget);
    expect(find.text(PeopleStrings.stepBasicInfo), findsWidgets);
    // Stepper keeps inactive-step controls mounted (AnimatedCrossFade).
    expect(
      find.widgetWithText(FilledButton, PeopleStrings.next),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'FilledButton controls survive tight infinite width parent',
    (tester) async {
      // Reproduces the web failure mode: Column stretch + maxWidth infinity
      // yields tight w=Infinity into controls; without Align.loosen/widthFactor
      // FilledButton asserts "BoxConstraints forces an infinite width".
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OverflowBox(
              minWidth: 0,
              maxWidth: double.infinity,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 400,
                child: Stepper(
                  currentStep: 0,
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FilledButton(
                              onPressed: details.onStepContinue,
                              child: const Text(PeopleStrings.next),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  steps: const [
                    Step(
                      title: Text(PeopleStrings.stepBasicInfo),
                      content: SizedBox(height: 48, child: Text('a')),
                    ),
                    Step(
                      title: Text(PeopleStrings.stepContactAccount),
                      content: SizedBox(height: 48, child: Text('b')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(FilledButton, PeopleStrings.next),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
