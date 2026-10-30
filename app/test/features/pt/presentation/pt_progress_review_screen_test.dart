import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_progress_review.dart';
import 'package:luxeknox/features/pt/domain/repositories/pt_progress_review_repository.dart';
import 'package:luxeknox/features/pt/domain/usecases/client_sign_pt_progress_review_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/create_pt_progress_review_draft_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/export_pt_progress_review_pdf_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/get_pt_progress_review_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/manager_approve_pt_progress_review_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/trainer_sign_pt_progress_review_usecase.dart';
import 'package:luxeknox/features/pt/presentation/cubit/pt_progress_review_cubit.dart';
import 'package:luxeknox/features/pt/presentation/pdf_card_saver.dart';
import 'package:luxeknox/features/pt/presentation/pt_strings.dart';
import 'package:luxeknox/features/pt/presentation/screens/pt_progress_review_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const periodStart = '2026-07-01';
  const periodEnd = '2026-09-30';

  PtProgressReview review({
    PtProgressReviewStatus status = PtProgressReviewStatus.draft,
    DateTime? trainerSignedAt,
    DateTime? clientSignedAt,
    DateTime? managerSignedAt,
    String? trainerSummary = 'Strong quarter',
    String? nextPhaseGoal = 'Build strength',
    String? nextPhaseTrainingFocus = 'Upper body',
  }) {
    return PtProgressReview(
      id: 7,
      memberId: 42,
      trainerId: 12,
      reviewPeriodStart: DateTime.utc(2026, 7, 1),
      reviewPeriodEnd: DateTime.utc(2026, 9, 30),
      status: status,
      createdAt: DateTime.utc(2026, 10, 1),
      trainerSummary: trainerSummary,
      nextPhaseGoal: nextPhaseGoal,
      nextPhaseTrainingFocus: nextPhaseTrainingFocus,
      nextReviewDate: DateTime.utc(2026, 12, 1),
      progressHighlights: const ['Lost 4.4 kg', 'Consistency'],
      reviewChecklist: const PtReviewChecklist(
        goalsReviewed: true,
        measurementsReviewed: true,
      ),
      bodyMetricsSnapshot: const [
        BodyMetricSnapshot(
          metric: 'Body weight',
          startVal: 80,
          currentVal: 75.6,
          changeVal: -4.4,
          targetVal: 72,
        ),
      ],
      performanceMarkersSnapshot: const [
        PerformanceMarkerSnapshot(
          marker: 'Squat',
          startVal: '60 kg',
          currentVal: '80 kg',
          changeVal: '+20 kg',
          targetVal: '100 kg',
        ),
      ],
      trainerSignedAt: trainerSignedAt,
      clientSignedAt: clientSignedAt,
      managerSignedAt: managerSignedAt,
    );
  }

  late _FakeReviewRepository repository;
  late _RecordingSaver saver;

  PtProgressReviewCubit cubit() {
    return PtProgressReviewCubit(
      GetPtProgressReviewUseCase(repository),
      CreatePtProgressReviewDraftUseCase(repository),
      TrainerSignPtProgressReviewUseCase(repository),
      ClientSignPtProgressReviewUseCase(repository),
      ManagerApprovePtProgressReviewUseCase(repository),
      ExportPtProgressReviewPdfUseCase(repository),
    );
  }

  Widget wrap(PtProgressReviewScreen screen) {
    return MaterialApp(home: screen);
  }

  setUp(() {
    repository = _FakeReviewRepository(review());
    saver = _RecordingSaver();
  });

  Future<void> pumpLoaded(
    WidgetTester tester,
    PtProgressReviewScreen screen,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(wrap(screen));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('loaded review shows measures, highlights, checklist, roadmap', (
    tester,
  ) async {
    await pumpLoaded(
      tester,
      PtProgressReviewScreen(
        audience: PtProgressReviewAudience.trainer,
        reviewId: 7,
        memberId: 42,
        trainerName: 'Rina S',
        cubitBuilder: cubit,
      ),
    );

    expect(find.text('Rina S'), findsOneWidget);
    expect(find.text('$periodStart – $periodEnd'), findsOneWidget);
    expect(find.text(PtStrings.statusDraft), findsOneWidget);
    expect(find.text('Body weight'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
    expect(find.text('75.6'), findsOneWidget);
    expect(find.text('-4.4'), findsOneWidget);
    expect(find.text('72'), findsOneWidget);
    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('60 kg'), findsOneWidget);
    expect(find.text('+20 kg'), findsOneWidget);
    expect(find.text('Lost 4.4 kg'), findsOneWidget);
    expect(find.text('Consistency'), findsOneWidget);
    expect(find.text(PtStrings.goalsReviewed), findsOneWidget);
    expect(find.text(PtStrings.programUpdated), findsOneWidget);
    expect(find.text('Build strength'), findsOneWidget);
    expect(find.text('Upper body'), findsOneWidget);
    expect(find.text('2026-12-01'), findsOneWidget);
    expect(find.text(PtStrings.pending), findsNWidgets(3));
    expect(find.text(PtStrings.signAsTrainer), findsOneWidget);
    expect(find.text(PtStrings.signAsClient), findsNothing);
    expect(find.text(PtStrings.approveReview), findsNothing);
  });

  testWidgets('trainer drafts, signs, and exports the presentation card', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      wrap(
        PtProgressReviewScreen(
          audience: PtProgressReviewAudience.trainer,
          memberId: 42,
          trainerName: 'Rina S',
          initialPeriodStart: DateTime.utc(2026, 7, 1),
          initialPeriodEnd: DateTime.utc(2026, 9, 30),
          initialNextReviewDate: DateTime.utc(2026, 12, 1),
          cubitBuilder: cubit,
          savePdf: saver.call,
        ),
      ),
    );
    await tester.pump();

    expect(find.text(PtStrings.createDraft), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('review-summary')),
      'Strong quarter',
    );
    await tester.enterText(
      find.byKey(const Key('review-next-goal')),
      'Build strength',
    );
    await tester.ensureVisible(find.text(PtStrings.createDraft));
    await tester.tap(find.text(PtStrings.createDraft));
    await tester.pump();
    await tester.pump();

    expect(repository.lastDraft?.memberId, 42);
    expect(repository.lastDraft?.trainerSummary, 'Strong quarter');
    expect(repository.lastDraft?.nextPhaseGoal, 'Build strength');
    expect(repository.lastDraft?.nextReviewDate, DateTime.utc(2026, 12, 1));
    expect(find.text('Body weight'), findsOneWidget);
    expect(find.text(PtStrings.drafted), findsOneWidget);

    await tester.ensureVisible(find.text(PtStrings.signAsTrainer));
    await tester.tap(find.text(PtStrings.signAsTrainer));
    await tester.pump();
    await tester.pump();

    expect(repository.calls, contains('trainerSign:7'));
    expect(find.text(PtStrings.statusClient), findsOneWidget);
    expect(find.text(PtStrings.signAsTrainer), findsNothing);
    expect(find.text('2026-10-01'), findsOneWidget);

    await tester.ensureVisible(find.text(PtStrings.exportPdf));
    await tester.tap(find.text(PtStrings.exportPdf));
    await tester.pump();
    await tester.pump();

    expect(repository.calls, contains('exportPdf:7'));
    expect(find.text(PtStrings.exported), findsOneWidget);
    expect(saver.filename, 'pt-review-7.pdf');
    expect(saver.bytes, Uint8List.fromList(const [1, 2, 3, 4]));
    expect(find.text('/tmp/pt-review-7.pdf'), findsOneWidget);
  });

  testWidgets('client signs after the trainer', (tester) async {
    repository.current = review(
      status: PtProgressReviewStatus.pendingClientSign,
      trainerSignedAt: DateTime.utc(2026, 10, 1),
    );
    await pumpLoaded(
      tester,
      PtProgressReviewScreen(
        audience: PtProgressReviewAudience.member,
        reviewId: 7,
        cubitBuilder: cubit,
      ),
    );

    expect(find.text(PtStrings.signAsClient), findsOneWidget);
    expect(find.text(PtStrings.signAsTrainer), findsNothing);
    await tester.ensureVisible(find.text(PtStrings.signAsClient));
    await tester.tap(find.text(PtStrings.signAsClient));
    await tester.pump();
    await tester.pump();

    expect(repository.calls, contains('clientSign:7'));
    expect(find.text(PtStrings.statusManager), findsOneWidget);
    expect(find.text(PtStrings.clientSigned), findsOneWidget);
  });

  testWidgets('manager approves and can export', (tester) async {
    repository.current = review(
      status: PtProgressReviewStatus.pendingManagerApproval,
      trainerSignedAt: DateTime.utc(2026, 10, 1),
      clientSignedAt: DateTime.utc(2026, 10, 2),
    );
    await pumpLoaded(
      tester,
      PtProgressReviewScreen(
        audience: PtProgressReviewAudience.manager,
        reviewId: 7,
        memberId: 42,
        cubitBuilder: cubit,
        savePdf: saver.call,
      ),
    );

    expect(find.text(PtStrings.approveReview), findsOneWidget);
    await tester.ensureVisible(find.text(PtStrings.approveReview));
    await tester.tap(find.text(PtStrings.approveReview));
    await tester.pump();
    await tester.pump();

    expect(repository.calls, contains('managerApprove:7'));
    expect(find.text(PtStrings.statusApproved), findsOneWidget);
    expect(find.text(PtStrings.managerApproved), findsOneWidget);

    await tester.ensureVisible(find.text(PtStrings.exportPdf));
    await tester.tap(find.text(PtStrings.exportPdf));
    await tester.pump();
    await tester.pump();
    expect(repository.calls, contains('exportPdf:7'));
  });

  testWidgets('a refused sign stays on the review and shows the reason', (
    tester,
  ) async {
    repository.signFailure = const BusinessRuleFailure(
      'Cannot trainer-sign: review is pending_client_sign, expected draft',
    );
    await pumpLoaded(
      tester,
      PtProgressReviewScreen(
        audience: PtProgressReviewAudience.trainer,
        reviewId: 7,
        memberId: 42,
        cubitBuilder: cubit,
      ),
    );

    await tester.ensureVisible(find.text(PtStrings.signAsTrainer));
    await tester.tap(find.text(PtStrings.signAsTrainer));
    await tester.pump();
    await tester.pump();

    expect(find.text(PtStrings.statusDraft), findsOneWidget);
    expect(
      find.text(
        'Cannot trainer-sign: review is pending_client_sign, expected draft',
      ),
      findsOneWidget,
    );
  });

  test('savePresentationCard writes the PDF bytes', () async {
    const name = 'pt-review-spec.pdf';
    final path = await savePresentationCard(
      name,
      Uint8List.fromList(const [9, 8]),
    );
    expect(path, isNotNull);
    final file = File(path!);
    addTearDown(file.deleteSync);
    expect(file.readAsBytesSync(), Uint8List.fromList(const [9, 8]));
  });
}

class _RecordingSaver {
  String? filename;
  Uint8List? bytes;

  Future<String?> call(String filename, Uint8List bytes) async {
    this.filename = filename;
    this.bytes = bytes;
    return '/tmp/$filename';
  }
}

class _FakeReviewRepository implements PtProgressReviewRepository {
  _FakeReviewRepository(this.current);

  PtProgressReview current;
  final List<String> calls = [];
  PtProgressReviewDraftInput? lastDraft;
  Failure? signFailure;

  PtProgressReview _with({
    required PtProgressReviewStatus status,
    DateTime? trainerSignedAt,
    DateTime? clientSignedAt,
    DateTime? managerSignedAt,
    String? trainerSummary,
    String? nextPhaseGoal,
  }) {
    return PtProgressReview(
      id: current.id,
      memberId: current.memberId,
      trainerId: current.trainerId,
      reviewPeriodStart: current.reviewPeriodStart,
      reviewPeriodEnd: current.reviewPeriodEnd,
      status: status,
      createdAt: current.createdAt,
      bodyMetricsSnapshot: current.bodyMetricsSnapshot,
      performanceMarkersSnapshot: current.performanceMarkersSnapshot,
      progressHighlights: current.progressHighlights,
      trainerSummary: trainerSummary ?? current.trainerSummary,
      nextPhaseGoal: nextPhaseGoal ?? current.nextPhaseGoal,
      nextPhaseTrainingFocus: current.nextPhaseTrainingFocus,
      nextReviewDate: current.nextReviewDate,
      reviewChecklist: current.reviewChecklist,
      trainerSignedAt: trainerSignedAt ?? current.trainerSignedAt,
      clientSignedAt: clientSignedAt ?? current.clientSignedAt,
      managerSignedAt: managerSignedAt ?? current.managerSignedAt,
    );
  }

  @override
  Future<Either<Failure, PtProgressReview>> createDraft(
    PtProgressReviewDraftInput input,
  ) async {
    calls.add('createDraft:${input.memberId}');
    lastDraft = input;
    current = _with(
      status: PtProgressReviewStatus.draft,
      trainerSummary: input.trainerSummary,
      nextPhaseGoal: input.nextPhaseGoal,
    );
    return Right(current);
  }

  @override
  Future<Either<Failure, PtProgressReview>> get(int reviewId) async {
    calls.add('get:$reviewId');
    return Right(current);
  }

  @override
  Future<Either<Failure, PtProgressReview>> trainerSign(int reviewId) async {
    calls.add('trainerSign:$reviewId');
    if (signFailure != null) return Left(signFailure!);
    current = _with(
      status: PtProgressReviewStatus.pendingClientSign,
      trainerSignedAt: DateTime.utc(2026, 10, 1),
    );
    return Right(current);
  }

  @override
  Future<Either<Failure, PtProgressReview>> clientSign(int reviewId) async {
    calls.add('clientSign:$reviewId');
    current = _with(
      status: PtProgressReviewStatus.pendingManagerApproval,
      clientSignedAt: DateTime.utc(2026, 10, 2),
    );
    return Right(current);
  }

  @override
  Future<Either<Failure, PtProgressReview>> managerApprove(int reviewId) async {
    calls.add('managerApprove:$reviewId');
    current = _with(
      status: PtProgressReviewStatus.approved,
      managerSignedAt: DateTime.utc(2026, 10, 3),
    );
    return Right(current);
  }

  @override
  Future<Either<Failure, Uint8List>> exportPdf(int reviewId) async {
    calls.add('exportPdf:$reviewId');
    return Right(Uint8List.fromList(const [1, 2, 3, 4]));
  }
}
