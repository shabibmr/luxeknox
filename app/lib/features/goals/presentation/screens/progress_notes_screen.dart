import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/progress_note_type.dart';
import '../cubit/progress_notes_cubit.dart';
import '../goals_strings.dart';

class ProgressNotesScreen extends StatelessWidget {
  const ProgressNotesScreen({super.key, this.memberId});

  final String? memberId;

  String? _resolveMemberId() {
    if (memberId != null) return memberId;
    final session = getIt<SessionCubit>().state;
    if (session is SessionAuthenticated) {
      return session.principal.profileId;
    }
    return null;
  }

  ProgressNoteType _defaultNoteType() {
    final session = getIt<SessionCubit>().state;
    if (session is! SessionAuthenticated) {
      return ProgressNoteType.memberNote;
    }
    return switch (session.principal.userType) {
      UserType.trainer || UserType.employee || UserType.admin =>
        ProgressNoteType.trainerAssessment,
      UserType.member => ProgressNoteType.memberNote,
    };
  }

  @override
  Widget build(BuildContext context) {
    final id = _resolveMemberId();
    if (id == null || id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(GoalsStrings.notesTitle)),
        body: const AppEmptyView(message: GoalsStrings.notesEmpty),
      );
    }

    return BlocProvider(
      create: (_) => getIt<ProgressNotesCubit>()..load(id),
      child: _ProgressNotesBody(
        memberId: id,
        defaultType: _defaultNoteType(),
      ),
    );
  }
}

class _ProgressNotesBody extends StatelessWidget {
  const _ProgressNotesBody({
    required this.memberId,
    required this.defaultType,
  });

  final String memberId;
  final ProgressNoteType defaultType;

  Future<void> _compose(BuildContext context) async {
    final controller = TextEditingController();
    var type = defaultType;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.viewInsetsOf(ctx).bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    GoalsStrings.composeNote,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  DropdownButtonFormField<ProgressNoteType>(
                    // ignore: deprecated_member_use
                    value: type,
                    decoration: const InputDecoration(
                      labelText: GoalsStrings.statusLabel,
                    ),
                    items: [
                      for (final t in ProgressNoteType.values)
                        DropdownMenuItem(
                          value: t,
                          child: Text(GoalsStrings.noteTypeLabelFor(t)),
                        ),
                    ],
                    onChanged: (v) {
                      if (v != null) setLocal(() => type = v);
                    },
                  ),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: GoalsStrings.noteTextLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;
                      final ok = await context
                          .read<ProgressNotesCubit>()
                          .addNote(noteText: text, noteType: type);
                      if (ctx.mounted) Navigator.of(ctx).pop(ok);
                    },
                    child: const Text(GoalsStrings.save),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    controller.dispose();
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(GoalsStrings.noteSaved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.notesTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: GoalsStrings.composeNote,
        onPressed: () => _compose(context),
        child: const Icon(Icons.note_add_outlined),
      ),
      body: BlocConsumer<ProgressNotesCubit, ProgressNotesState>(
        listener: (context, state) {
          if (state is ProgressNotesLoaded && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return switch (state) {
            ProgressNotesLoading() => const AppLoading(),
            ProgressNotesFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<ProgressNotesCubit>().load(memberId),
            ),
            ProgressNotesLoaded(:final notes) => notes.isEmpty
                ? const AppEmptyView(message: GoalsStrings.notesEmpty)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final n = notes[index];
                      return Card(
                        child: ListTile(
                          title: Text(n.noteText),
                          subtitle: Text(
                            '${GoalsStrings.noteTypeLabelFor(n.noteType)} · '
                            '${n.createdAt.toIso8601String()}',
                          ),
                        ),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }
}
