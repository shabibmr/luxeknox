import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_inputs.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_screening.dart';
import 'package:luxeknox/features/people/domain/repositories/par_q_repository.dart';
import 'package:luxeknox/features/people/domain/usecases/submit_par_q_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/par_q_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/widgets/par_q_screening_form.dart';
import 'package:luxeknox/features/people/presentation/widgets/par_q_signature_canvas.dart';
import 'package:mocktail/mocktail.dart';

class MockSubmitParQUseCase extends Mock implements SubmitParQUseCase {}

class FakeParQRepository implements ParQRepository {
  ParQSubmission? submitted;
  int submitCalls = 0;

  @override
  Future<Either<Failure, ParQScreening>> submit(
    ParQSubmission submission,
  ) async {
    submitCalls++;
    submitted = submission;
    return Right(
      ParQScreening(
        id: 1,
        memberId: submission.memberId,
        version: '2024.1',
        answers: submission.answers,
        hasPositiveAnswer: false,
        referralRequired: false,
        declarationAccepted: true,
        clientSignature: submission.clientSignature,
        clearanceStatus: ParQClearanceStatus.passed,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
  }

  @override
  Future<Either<Failure, ParQScreening>> getLatest(int memberId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ParQScreening>> trainerReview(
    ParQTrainerReviewInput review,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ParQScreening>> clear(ParQClearanceInput clearance) {
    throw UnimplementedError();
  }
}

void main() {
  late MockSubmitParQUseCase mockSubmit;
  late ParQCubit cubit;

  final tSubmission = ParQSubmission(
    memberId: 10,
    answers: List.filled(7, ParQAnswer.no),
    declarationAccepted: true,
    clientSignature: 'ink',
  );

  final tPassedScreening = ParQScreening(
    id: 1,
    memberId: 10,
    version: '2024.1',
    answers: List.filled(7, ParQAnswer.no),
    hasPositiveAnswer: false,
    referralRequired: false,
    declarationAccepted: true,
    clearanceStatus: ParQClearanceStatus.passed,
    createdAt: DateTime(2026, 1, 1),
  );

  final tPendingScreening = ParQScreening(
    id: 2,
    memberId: 10,
    version: '2024.1',
    answers: [
      const ParQAnswer(yes: true, details: 'Heart surgery'),
      ...List.filled(6, ParQAnswer.no),
    ],
    hasPositiveAnswer: true,
    referralRequired: true,
    referralReason: 'Heart condition reported',
    declarationAccepted: true,
    clearanceStatus: ParQClearanceStatus.pendingClearance,
    createdAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(tSubmission);
  });

  setUp(() {
    mockSubmit = MockSubmitParQUseCase();
    cubit = ParQCubit(mockSubmit);
  });

  tearDown(() {
    cubit.close();
  });

  Widget wrap(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets(
    'renders all 7 questions, declaration checkbox, signature canvas, and submit button',
    (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        wrap(ParQScreeningForm(memberId: 10, cubit: cubit)),
      );
      await tester.pumpAndSettle();

      expect(find.text(PeopleStrings.parQTitle), findsOneWidget);
      expect(find.text(PeopleStrings.parQQ1), findsOneWidget);
      expect(find.text(PeopleStrings.parQQ2), findsOneWidget);
      expect(find.text(PeopleStrings.parQQ3), findsOneWidget);
      expect(find.text(PeopleStrings.parQQ4), findsOneWidget);
      expect(find.text(PeopleStrings.parQQ5), findsOneWidget);
      expect(find.text(PeopleStrings.parQQ6), findsOneWidget);
      expect(find.text(PeopleStrings.parQQ7), findsOneWidget);

      expect(
        find.byKey(const Key('par_q_declaration_checkbox')),
        findsOneWidget,
      );
      expect(find.byType(ParQSignatureCanvas), findsOneWidget);
      expect(find.byKey(const Key('par_q_submit_button')), findsOneWidget);
    },
  );

  testWidgets('selecting YES expands detail text field', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(ParQScreeningForm(memberId: 10, cubit: cubit)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('par_q_details_input_0')), findsNothing);

    // Tap YES on question 0
    final segmentedBtn0 = find.byKey(const Key('par_q_segmented_0'));
    final yesBtn = find.descendant(
      of: segmentedBtn0,
      matching: find.text(PeopleStrings.yes),
    );
    await tester.tap(yesBtn);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('par_q_details_input_0')), findsOneWidget);

    // Tapping NO hides it again
    final noBtn = find.descendant(
      of: segmentedBtn0,
      matching: find.text(PeopleStrings.no),
    );
    await tester.tap(noBtn);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('par_q_details_input_0')), findsNothing);
  });

  testWidgets('validates required detail when question is YES', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(ParQScreeningForm(memberId: 10, cubit: cubit)),
    );
    await tester.pumpAndSettle();

    // Tap YES on question 1
    final segmentedBtn1 = find.byKey(const Key('par_q_segmented_1'));
    final yesBtn = find.descendant(
      of: segmentedBtn1,
      matching: find.text(PeopleStrings.yes),
    );
    await tester.tap(yesBtn);
    await tester.pumpAndSettle();

    // Check declaration
    await tester.tap(find.byKey(const Key('par_q_declaration_checkbox')));
    await tester.pumpAndSettle();

    // Draw signature
    await tester.drag(
      find.byKey(const Key('par_q_signature_gesture_detector')),
      const Offset(50, 20),
    );
    await tester.pumpAndSettle();

    // Submit with empty details on question 1
    final submitBtn = find.byKey(const Key('par_q_submit_button'));
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.parQDetailsRequired), findsOneWidget);
    verifyNever(() => mockSubmit(any()));
  });

  testWidgets('validates declaration checkbox and signature requirement', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(ParQScreeningForm(memberId: 10, cubit: cubit)),
    );
    await tester.pumpAndSettle();

    // Tap submit without checking declaration and without signature
    final submitBtn = find.byKey(const Key('par_q_submit_button'));
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.parQDeclarationRequired), findsOneWidget);
    expect(find.text(PeopleStrings.parQSignatureRequired), findsOneWidget);
    verifyNever(() => mockSubmit(any()));
  });

  testWidgets(
    'submits form with all NO answers and displays PASSED clearance card',
    (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      when(
        () => mockSubmit(any()),
      ).thenAnswer((_) async => Right(tPassedScreening));

      ParQScreening? submittedScreening;

      await tester.pumpWidget(
        wrap(
          ParQScreeningForm(
            memberId: 10,
            cubit: cubit,
            onSubmitted: (s) => submittedScreening = s,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Accept declaration
      await tester.ensureVisible(
        find.byKey(const Key('par_q_declaration_checkbox')),
      );
      await tester.tap(find.byKey(const Key('par_q_declaration_checkbox')));
      await tester.pumpAndSettle();

      // Sign on canvas
      final canvasFinder = find.byKey(
        const Key('par_q_signature_gesture_detector'),
      );
      await tester.ensureVisible(canvasFinder);
      await tester.drag(canvasFinder, const Offset(60, 20));
      await tester.pumpAndSettle();

      // Submit
      final submitBtn = find.byKey(const Key('par_q_submit_button'));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      verify(() => mockSubmit(any())).called(1);
      expect(submittedScreening, equals(tPassedScreening));
      expect(find.text(PeopleStrings.parQPassedTitle), findsOneWidget);
      expect(find.text(PeopleStrings.parQPassedBody), findsOneWidget);
    },
  );

  testWidgets(
    'submits form with a YES answer and details, displays PENDING CLEARANCE card',
    (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      when(
        () => mockSubmit(any()),
      ).thenAnswer((_) async => Right(tPendingScreening));

      await tester.pumpWidget(
        wrap(ParQScreeningForm(memberId: 10, cubit: cubit)),
      );
      await tester.pumpAndSettle();

      // Select YES on question 0
      final segmentedBtn0 = find.byKey(const Key('par_q_segmented_0'));
      final yesBtn = find.descendant(
        of: segmentedBtn0,
        matching: find.text(PeopleStrings.yes),
      );
      await tester.tap(yesBtn);
      await tester.pumpAndSettle();

      // Enter details
      await tester.enterText(
        find.byKey(const Key('par_q_details_input_0')),
        'Heart surgery',
      );
      await tester.pumpAndSettle();

      // Accept declaration
      await tester.ensureVisible(
        find.byKey(const Key('par_q_declaration_checkbox')),
      );
      await tester.tap(find.byKey(const Key('par_q_declaration_checkbox')));
      await tester.pumpAndSettle();

      // Sign on canvas
      final canvasFinder = find.byKey(
        const Key('par_q_signature_gesture_detector'),
      );
      await tester.ensureVisible(canvasFinder);
      await tester.drag(canvasFinder, const Offset(60, 20));
      await tester.pumpAndSettle();

      // Submit
      final submitBtn = find.byKey(const Key('par_q_submit_button'));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      verify(() => mockSubmit(any())).called(1);
      expect(find.text(PeopleStrings.parQPendingTitle), findsOneWidget);
      expect(find.text(PeopleStrings.parQPendingBody), findsOneWidget);
      expect(
        find.text('Referral reason: Heart condition reported'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'clearing signature disables clear button and marks as unsigned',
    (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        wrap(ParQScreeningForm(memberId: 10, cubit: cubit)),
      );
      await tester.pumpAndSettle();

      final clearBtn = find.byKey(const Key('par_q_signature_clear_button'));
      expect(tester.widget<TextButton>(clearBtn).onPressed, isNull);

      // Sign
      final canvasFinder = find.byKey(
        const Key('par_q_signature_gesture_detector'),
      );
      await tester.ensureVisible(canvasFinder);
      await tester.drag(canvasFinder, const Offset(40, 30));
      await tester.pumpAndSettle();

      expect(tester.widget<TextButton>(clearBtn).onPressed, isNotNull);

      // Clear
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      expect(tester.widget<TextButton>(clearBtn).onPressed, isNull);
    },
  );

  testWidgets('displays initialScreening card and allows retake', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        ParQScreeningForm(
          memberId: 10,
          cubit: cubit,
          initialScreening: tPassedScreening,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.parQPassedTitle), findsOneWidget);

    // Retake resets the card
    await tester.tap(find.byKey(const Key('par_q_retake_button')));
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.parQPassedTitle), findsNothing);
  });

  testWidgets(
    'showParQSignatureDialog opens dialog, allows signing, and confirms',
    (tester) async {
      List<List<Offset>>? strokes;

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  strokes = await showParQSignatureDialog(context: context);
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(PeopleStrings.parQSignatureDialogTitle), findsOneWidget);

      // Confirm button is disabled initially
      final confirmBtnFinder = find.widgetWithText(
        FilledButton,
        PeopleStrings.parQSignatureDone,
      );
      expect(tester.widget<FilledButton>(confirmBtnFinder).onPressed, isNull);

      // Draw signature in dialog
      final canvasFinder = find.byKey(
        const Key('par_q_signature_gesture_detector'),
      );
      await tester.drag(canvasFinder, const Offset(50, 20));
      await tester.pumpAndSettle();

      expect(
        tester.widget<FilledButton>(confirmBtnFinder).onPressed,
        isNotNull,
      );

      // Tap confirm
      await tester.tap(confirmBtnFinder);
      await tester.pumpAndSettle();

      expect(strokes, isNotNull);
      expect(strokes!.isNotEmpty, true);
      expect(find.text(PeopleStrings.parQSignatureDialogTitle), findsNothing);
    },
  );

  testWidgets('fake repository receives the drawn signature on submit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeParQRepository();
    final signedCubit = ParQCubit(SubmitParQUseCase(repository));
    addTearDown(signedCubit.close);

    await tester.pumpWidget(
      wrap(ParQScreeningForm(memberId: 10, cubit: signedCubit)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('par_q_declaration_checkbox')),
    );
    await tester.tap(find.byKey(const Key('par_q_declaration_checkbox')));
    await tester.pumpAndSettle();

    final canvasFinder = find.byKey(
      const Key('par_q_signature_gesture_detector'),
    );
    await tester.ensureVisible(canvasFinder);
    await tester.drag(canvasFinder, const Offset(60, 20));
    await tester.pumpAndSettle();

    final submitBtn = find.byKey(const Key('par_q_submit_button'));
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(repository.submitCalls, 1);
    final posted = repository.submitted!;
    expect(posted.memberId, 10);
    expect(posted.declarationAccepted, isTrue);
    expect(posted.answers, List.filled(7, ParQAnswer.no));
    expect(posted.clientSignature, contains('strokes'));
    expect(posted.clientSignature, isNot(contains('"strokes":[]')));
  });

  testWidgets('fake repository is not called when the signature is missing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeParQRepository();
    final signedCubit = ParQCubit(SubmitParQUseCase(repository));
    addTearDown(signedCubit.close);

    await tester.pumpWidget(
      wrap(ParQScreeningForm(memberId: 10, cubit: signedCubit)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('par_q_declaration_checkbox')),
    );
    await tester.tap(find.byKey(const Key('par_q_declaration_checkbox')));
    await tester.pumpAndSettle();

    final submitBtn = find.byKey(const Key('par_q_submit_button'));
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.parQSignatureRequired), findsOneWidget);
    expect(repository.submitCalls, 0);
  });
}
