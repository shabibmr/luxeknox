import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/par_q_inputs.dart';
import '../../domain/entities/par_q_screening.dart';
import '../../domain/usecases/submit_par_q_usecase.dart';
import '../clearance_status_presentation.dart';
import '../cubit/par_q_cubit.dart';
import '../people_strings.dart';
import 'par_q_signature_canvas.dart';
import 'par_q_signature_codec.dart';

/// Form component for the 7 PAR-Q+ health screening questions, expandable
/// detail fields on YES, legal declaration checkbox, and touch signature.
class ParQScreeningForm extends StatefulWidget {
  const ParQScreeningForm({
    super.key,
    required this.memberId,
    this.initialScreening,
    this.onSubmitted,
    this.cubit,
  });

  final int memberId;
  final ParQScreening? initialScreening;
  final ValueChanged<ParQScreening>? onSubmitted;
  final ParQCubit? cubit;

  @override
  State<ParQScreeningForm> createState() => _ParQScreeningFormState();
}

class _ParQScreeningFormState extends State<ParQScreeningForm> {
  late final ParQCubit _cubit;
  late final bool _ownsCubit;

  @override
  void initState() {
    super.initState();
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
      _ownsCubit = false;
    } else {
      _cubit = ParQCubit(getIt<SubmitParQUseCase>());
      _ownsCubit = true;
    }
  }

  @override
  void dispose() {
    if (_ownsCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: _ParQScreeningFormBody(
        memberId: widget.memberId,
        initialScreening: widget.initialScreening,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}

class _ParQScreeningFormBody extends StatefulWidget {
  const _ParQScreeningFormBody({
    required this.memberId,
    this.initialScreening,
    this.onSubmitted,
  });

  final int memberId;
  final ParQScreening? initialScreening;
  final ValueChanged<ParQScreening>? onSubmitted;

  @override
  State<_ParQScreeningFormBody> createState() => _ParQScreeningFormBodyState();
}

class _ParQScreeningFormBodyState extends State<_ParQScreeningFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _signatureCanvasKey = GlobalKey<ParQSignatureCanvasState>();

  late final List<bool> _answers;
  late final List<TextEditingController> _detailControllers;

  bool _declarationAccepted = false;
  bool _hasSignature = false;
  bool _showDeclarationError = false;
  bool _showSignatureError = false;
  bool _retaking = false;

  static const List<String> _questions = [
    PeopleStrings.parQQ1,
    PeopleStrings.parQQ2,
    PeopleStrings.parQQ3,
    PeopleStrings.parQQ4,
    PeopleStrings.parQQ5,
    PeopleStrings.parQQ6,
    PeopleStrings.parQQ7,
  ];

  @override
  void initState() {
    super.initState();
    _answers = List.filled(7, false);
    _detailControllers = List.generate(7, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (final controller in _detailControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _retaking = true;
      for (int i = 0; i < 7; i++) {
        _answers[i] = false;
        _detailControllers[i].clear();
      }
      _declarationAccepted = false;
      _hasSignature = false;
      _showDeclarationError = false;
      _showSignatureError = false;
    });
    _signatureCanvasKey.currentState?.clear();
    context.read<ParQCubit>().reset();
  }

  void _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    final decValid = _declarationAccepted;
    final sigValid = _hasSignature;

    setState(() {
      _showDeclarationError = !decValid;
      _showSignatureError = !sigValid;
    });

    if (!formValid || !decValid || !sigValid) {
      return;
    }

    final answers = List.generate(7, (i) {
      final isYes = _answers[i];
      return ParQAnswer(
        yes: isYes,
        details: isYes ? _detailControllers[i].text.trim() : null,
      );
    });

    final submission = ParQSubmission(
      memberId: widget.memberId,
      answers: answers,
      declarationAccepted: true,
      clientSignature: encodeParQSignature(
        _signatureCanvasKey.currentState?.strokes ?? const [],
      ),
    );

    await context.read<ParQCubit>().submit(submission);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ParQCubit, ParQState>(
      listener: (context, state) {
        if (state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failureMessage(state.failure!)),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        } else if (state.status == LoadStatus.success &&
            state.screening != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(PeopleStrings.parQSubmitted)),
          );
          widget.onSubmitted?.call(state.screening!);
        }
      },
      builder: (context, state) {
        final activeScreening =
            state.screening ?? (_retaking ? null : widget.initialScreening);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (activeScreening != null) ...[
                _ClearanceStatusCard(
                  screening: activeScreening,
                  onRetake: _resetForm,
                ),
                const SizedBox(height: 16),
              ],
              Text(
                PeopleStrings.parQTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                PeopleStrings.parQSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < 7; i++) ...[
                      _QuestionCard(
                        index: i,
                        questionText: _questions[i],
                        isYes: _answers[i],
                        detailController: _detailControllers[i],
                        onChanged: (val) {
                          setState(() {
                            _answers[i] = val;
                            if (!val) {
                              _detailControllers[i].clear();
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                    ],
                    const Divider(height: 32),
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceContainerLow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _showDeclarationError
                              ? theme.colorScheme.error
                              : theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              key: const Key('par_q_declaration_checkbox'),
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                PeopleStrings.parQDeclaration,
                                style: theme.textTheme.bodyMedium,
                              ),
                              value: _declarationAccepted,
                              onChanged: (val) {
                                setState(() {
                                  _declarationAccepted = val ?? false;
                                  if (_declarationAccepted) {
                                    _showDeclarationError = false;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            if (_showDeclarationError)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  bottom: 8,
                                ),
                                child: Text(
                                  PeopleStrings.parQDeclarationRequired,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          PeopleStrings.parQSignatureTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          key: const Key('par_q_signature_dialog_button'),
                          onPressed: () async {
                            final strokes = await showParQSignatureDialog(
                              context: context,
                              initialHasSignature: _hasSignature,
                            );
                            if (strokes != null) {
                              _signatureCanvasKey.currentState?.setStrokes(
                                strokes,
                              );
                              setState(() {
                                _hasSignature = strokes.any(
                                  (s) => s.isNotEmpty,
                                );
                                if (_hasSignature) {
                                  _showSignatureError = false;
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.fullscreen, size: 18),
                          label: const Text('Fullscreen'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ParQSignatureCanvas(
                      key: _signatureCanvasKey,
                      height: 150,
                      initialHasSignature: _hasSignature,
                      onChanged: (hasSig) {
                        setState(() {
                          _hasSignature = hasSig;
                          if (_hasSignature) {
                            _showSignatureError = false;
                          }
                        });
                      },
                    ),
                    if (_showSignatureError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: Text(
                          PeopleStrings.parQSignatureRequired,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('par_q_submit_button'),
                      onPressed: state.isSubmitting ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              PeopleStrings.parQSubmit,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.questionText,
    required this.isYes,
    required this.detailController,
    required this.onChanged,
  });

  final int index;
  final String questionText;
  final bool isYes;
  final TextEditingController detailController;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isYes
              ? theme.colorScheme.primary.withValues(alpha: 0.6)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questionText,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SegmentedButton<bool>(
                  key: Key('par_q_segmented_$index'),
                  segments: const [
                    ButtonSegment<bool>(
                      value: false,
                      label: Text(PeopleStrings.no),
                    ),
                    ButtonSegment<bool>(
                      value: true,
                      label: Text(PeopleStrings.yes),
                    ),
                  ],
                  selected: {isYes},
                  onSelectionChanged: (selectedSet) {
                    onChanged(selectedSet.first);
                  },
                ),
              ],
            ),
            if (isYes) ...[
              const SizedBox(height: 12),
              TextFormField(
                key: Key('par_q_details_input_$index'),
                controller: detailController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: PeopleStrings.parQDetailsLabel,
                  hintText: PeopleStrings.parQDetailsHint,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (value) {
                  if (isYes && (value == null || value.trim().isEmpty)) {
                    return PeopleStrings.parQDetailsRequired;
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClearanceStatusCard extends StatelessWidget {
  const _ClearanceStatusCard({required this.screening, required this.onRetake});

  final ParQScreening screening;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final look = ClearanceStatusPresentation.resolve(
      scheme: theme.colorScheme,
      status: screening.clearanceStatus,
    );
    final color = look.color;
    final icon = look.icon;
    final title = look.formTitle!;
    final body = look.formBody!;

    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyMedium),
            if (screening.referralReason != null &&
                screening.referralReason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Referral reason: ${screening.referralReason}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                key: const Key('par_q_retake_button'),
                onPressed: onRetake,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text(PeopleStrings.parQRetake),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
