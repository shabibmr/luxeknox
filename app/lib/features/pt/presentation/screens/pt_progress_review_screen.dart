import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/pt_progress_review.dart';
import '../../domain/usecases/client_sign_pt_progress_review_usecase.dart';
import '../../domain/usecases/create_pt_progress_review_draft_usecase.dart';
import '../../domain/usecases/export_pt_progress_review_pdf_usecase.dart';
import '../../domain/usecases/get_pt_progress_review_usecase.dart';
import '../../domain/usecases/manager_approve_pt_progress_review_usecase.dart';
import '../../domain/usecases/update_pt_progress_review_card_usecase.dart';
import '../../domain/usecases/trainer_sign_pt_progress_review_usecase.dart';
import '../cubit/pt_progress_review_cubit.dart';
import '../pdf_card_saver.dart';
import '../pt_strings.dart';
import '../review_format.dart';
import '../widgets/celebration_highlight_chips.dart';
import '../widgets/measures_comparison_table.dart';
import '../widgets/next_phase_roadmap_card.dart';
import '../widgets/progress_review_draft_form.dart';
import '../widgets/review_card_editor.dart';
import '../widgets/review_checklist_card.dart';
import '../widgets/tri_party_signoff_tracker.dart';

export '../cubit/pt_progress_review_cubit.dart' show PtProgressReviewAudience;

/// Screen 45. Trainer drafts and signs first, the client signs next, then a
/// manager approves. Any of them can export the presentation card.
class PtProgressReviewScreen extends StatelessWidget {
  const PtProgressReviewScreen({
    super.key,
    required this.audience,
    this.reviewId,
    this.memberId,
    this.memberName,
    this.trainerName,
    this.initialPeriodStart,
    this.initialPeriodEnd,
    this.initialNextReviewDate,
    this.cubitBuilder,
    this.savePdf,
  });

  final PtProgressReviewAudience audience;
  final int? reviewId;
  final int? memberId;
  final String? memberName;
  final String? trainerName;
  final DateTime? initialPeriodStart;
  final DateTime? initialPeriodEnd;
  final DateTime? initialNextReviewDate;
  final PtProgressReviewCubit Function()? cubitBuilder;
  final Future<String?> Function(String filename, Uint8List bytes)? savePdf;

  PtProgressReviewCubit _createCubit() {
    final build = cubitBuilder;
    if (build != null) return build();
    return PtProgressReviewCubit(
      getIt<GetPtProgressReviewUseCase>(),
      getIt<CreatePtProgressReviewDraftUseCase>(),
      getIt<TrainerSignPtProgressReviewUseCase>(),
      getIt<ClientSignPtProgressReviewUseCase>(),
      getIt<ManagerApprovePtProgressReviewUseCase>(),
      getIt<ExportPtProgressReviewPdfUseCase>(),
      getIt<UpdatePtProgressReviewCardUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = _createCubit();
        final id = reviewId;
        if (id != null) cubit.load(id);
        return cubit;
      },
      child: _PtProgressReviewView(
        audience: audience,
        reviewId: reviewId,
        memberId: memberId,
        memberName: memberName,
        trainerName: trainerName,
        initialPeriodStart: initialPeriodStart,
        initialPeriodEnd: initialPeriodEnd,
        initialNextReviewDate: initialNextReviewDate,
        savePdf: savePdf,
      ),
    );
  }
}

class _PtProgressReviewView extends StatelessWidget {
  const _PtProgressReviewView({
    required this.audience,
    required this.reviewId,
    required this.memberId,
    required this.memberName,
    required this.trainerName,
    required this.initialPeriodStart,
    required this.initialPeriodEnd,
    required this.initialNextReviewDate,
    required this.savePdf,
  });

  final PtProgressReviewAudience audience;
  final int? reviewId;
  final int? memberId;
  final String? memberName;
  final String? trainerName;
  final DateTime? initialPeriodStart;
  final DateTime? initialPeriodEnd;
  final DateTime? initialNextReviewDate;
  final Future<String?> Function(String filename, Uint8List bytes)? savePdf;

  bool get _canDraft =>
      audience == PtProgressReviewAudience.trainer && memberId != null;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PtProgressReviewCubit, PtProgressReviewState>(
      listenWhen: (previous, next) =>
          previous.notice != next.notice ||
          previous.actionError != next.actionError ||
          previous.exportedPdf != next.exportedPdf,
      listener: (context, state) async {
        final notice = state.notice;
        final actionError = state.actionError;
        final pdf = state.exportedPdf;
        final text = notice ?? actionError;
        String? savedPath;
        if (pdf != null) {
          final save = savePdf ?? savePresentationCard;
          savedPath = await save(
            'pt-review-${state.review?.id ?? 'card'}.pdf',
            pdf,
          );
        }
        if (!context.mounted || text == null && savedPath == null) return;
        if (text != null) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.clearSnackBars();
          messenger.showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(text), if (savedPath != null) Text(savedPath)],
              ),
            ),
          );
        }
        context.read<PtProgressReviewCubit>().clearNotices();
        if (notice == PtStrings.drafted && state.review != null) {
          _openSavedReview(
            context,
            audience: audience,
            memberId: memberId,
            reviewId: state.review!.id,
          );
        }
      },
      builder: (context, state) {
        final review = state.review;
        final loadingExisting =
            review == null &&
            reviewId != null &&
            state.status == LoadStatus.loading;
        return Scaffold(
          appBar: AppBar(title: const Text(PtStrings.progressReviewTitle)),
          body: loadingExisting
              ? const AppLoading()
              : review == null &&
                    reviewId != null &&
                    state.status == LoadStatus.failure
              ? AppErrorView(
                  message: state.failure == null
                      ? PtStrings.reviewLoadFailed
                      : failureMessage(state.failure!),
                  onRetry: () =>
                      context.read<PtProgressReviewCubit>().load(reviewId!),
                )
              : review == null
              ? _canDraft
                    ? ProgressReviewDraftForm(
                        submitting: state.acting,
                        initialPeriodStart:
                            initialPeriodStart ??
                            DateTime.now().subtract(const Duration(days: 84)),
                        initialPeriodEnd: initialPeriodEnd ?? DateTime.now(),
                        initialNextReviewDate: initialNextReviewDate,
                        onCreate:
                            ({
                              required periodStart,
                              required periodEnd,
                              required trainerSummary,
                              required clientFeedback,
                              required nextPhaseGoal,
                              required nextPhaseTrainingFocus,
                              required nextReviewDate,
                            }) {
                              context.read<PtProgressReviewCubit>().createDraft(
                                PtProgressReviewDraftInput(
                                  memberId: memberId!,
                                  reviewPeriodStart: periodStart,
                                  reviewPeriodEnd: periodEnd,
                                  trainerSummary: trainerSummary,
                                  clientFeedback: clientFeedback,
                                  nextPhaseGoal: nextPhaseGoal,
                                  nextPhaseTrainingFocus:
                                      nextPhaseTrainingFocus,
                                  nextReviewDate: nextReviewDate,
                                ),
                              );
                            },
                      )
                    : const AppErrorView(message: PtStrings.reviewMissing)
              : _ReviewCard(
                  review: review,
                  audience: audience,
                  acting: state.acting,
                  memberName: memberName,
                  trainerName: trainerName,
                ),
        );
      },
    );
  }
}

void _openSavedReview(
  BuildContext context, {
  required PtProgressReviewAudience audience,
  required int? memberId,
  required int reviewId,
}) {
  if (audience != PtProgressReviewAudience.member && memberId == null) return;
  final target = switch (audience) {
    PtProgressReviewAudience.member => Routes.memberProgressReviewById(
      '$reviewId',
    ),
    PtProgressReviewAudience.trainer => Routes.trainerMembersProgressReviewById(
      '$memberId',
      '$reviewId',
    ),
    PtProgressReviewAudience.manager => Routes.adminMembersProgressReviewById(
      '$memberId',
      '$reviewId',
    ),
  };
  try {
    if (GoRouterState.of(context).uri.path == target) return;
    context.replace(target);
  } on Object {
    // Widget tests mount this screen without a GoRouter.
  }
}

class _ReviewCard extends StatefulWidget {
  const _ReviewCard({
    required this.review,
    required this.audience,
    required this.acting,
    required this.memberName,
    required this.trainerName,
  });

  final PtProgressReview review;
  final PtProgressReviewAudience audience;
  final bool acting;
  final String? memberName;
  final String? trainerName;

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _cardDirty = false;

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final audience = widget.audience;
    final trainerName = widget.trainerName;
    final memberName = widget.memberName;
    final theme = Theme.of(context);
    final cubit = context.read<PtProgressReviewCubit>();
    final editing =
        audience == PtProgressReviewAudience.trainer && review.isCardEditable;
    final trainer = (trainerName == null || trainerName.trim().isEmpty)
        ? '${PtStrings.trainerParty} #${review.trainerId}'
        : trainerName.trim();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Chip(
              label: Text(
                '${formatReviewDate(review.reviewPeriodStart)} – ${formatReviewDate(review.reviewPeriodEnd)}',
              ),
            ),
            Chip(label: Text(_statusLabel(review.status))),
            if (memberName != null && memberName.trim().isNotEmpty)
              Text(memberName.trim(), style: theme.textTheme.titleMedium),
            Text(trainer, style: theme.textTheme.titleMedium),
          ],
        ),
        if (review.trainerSummary != null &&
            review.trainerSummary!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(PtStrings.trainerSummary, style: theme.textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(review.trainerSummary!.trim()),
        ],
        const SizedBox(height: 12),
        MeasuresComparisonTable(
          bodyMetrics: review.bodyMetricsSnapshot,
          performanceMarkers: review.performanceMarkersSnapshot,
        ),
        const SizedBox(height: 12),
        if (editing)
          ReviewCardEditor(
            review: review,
            saving: widget.acting,
            onSave: cubit.saveCard,
            onDirtyChanged: (dirty) {
              if (mounted) setState(() => _cardDirty = dirty);
            },
          )
        else ...[
          CelebrationHighlightChips(
            highlights: review.progressHighlights,
            otherText: review.highlightsOtherText,
          ),
          const SizedBox(height: 12),
          ReviewChecklistCard(checklist: review.reviewChecklist),
        ],
        const SizedBox(height: 12),
        NextPhaseRoadmapCard(
          goal: review.nextPhaseGoal,
          trainingFocus: review.nextPhaseTrainingFocus,
          nextReviewDate: review.nextReviewDate,
        ),
        const SizedBox(height: 12),
        TriPartySignoffTracker(
          review: review,
          audience: audience,
          acting: widget.acting,
          trainerSignEnabled: !_cardDirty,
          onTrainerSign: cubit.signAsTrainer,
          onClientSign: cubit.signAsClient,
          onManagerApprove: cubit.approveAsManager,
          onExport: cubit.exportPdf,
        ),
      ],
    );
  }
}

String _statusLabel(PtProgressReviewStatus status) {
  return switch (status) {
    PtProgressReviewStatus.draft => PtStrings.statusDraft,
    PtProgressReviewStatus.pendingClientSign => PtStrings.statusClient,
    PtProgressReviewStatus.pendingManagerApproval => PtStrings.statusManager,
    PtProgressReviewStatus.approved => PtStrings.statusApproved,
    PtProgressReviewStatus.archived => PtStrings.statusArchived,
  };
}
