import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/photo_pose.dart';
import '../../domain/entities/progress_photo.dart';
import '../cubit/progress_photos_cubit.dart';
import '../goal_view_actions.dart';
import '../goals_strings.dart';

class ProgressPhotosScreen extends StatelessWidget {
  const ProgressPhotosScreen({
    super.key,
    this.memberId,
    this.isAssignedTrainer = false,
  });

  final String? memberId;
  final bool isAssignedTrainer;

  String? _resolveMemberId() {
    if (memberId != null) return memberId;
    final session = getIt<SessionCubit>().state;
    if (session is SessionAuthenticated) {
      return session.principal.profileId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final id = _resolveMemberId();
    final session = getIt<SessionCubit>().state;
    final isOwner =
        memberId == null ||
        (session is SessionAuthenticated && session.principal.profileId == id);
    final canModerate =
        session is SessionAuthenticated &&
        session.capabilities.can('progress_photos.moderate');
    final canWriteGoals =
        session is SessionAuthenticated &&
        session.capabilities.can('goals.write');
    final shell = goalDetailShellForPath(GoRouterState.of(context).uri.path);
    final canUpload = canUploadProgressPhoto(
      shell: shell,
      isOwner: isOwner,
      canWriteGoals: canWriteGoals,
    );
    final canDelete = canDeleteProgressPhoto(
      isOwner: isOwner,
      canModerate: canModerate,
    );

    if (id == null || id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(GoalsStrings.photosTitle)),
        body: const AppEmptyView(message: GoalsStrings.photosEmpty),
      );
    }

    return BlocProvider(
      create: (_) => getIt<ProgressPhotosCubit>()
        ..load(
          id,
          isOwner: isOwner,
          isAssignedTrainer: isAssignedTrainer,
          canModerate: canModerate,
        ),
      child: _ProgressPhotosBody(
        memberId: id,
        isOwner: isOwner,
        isAssignedTrainer: isAssignedTrainer,
        canModerate: canModerate,
        canUpload: canUpload,
        canDelete: canDelete,
      ),
    );
  }
}

class _ProgressPhotosBody extends StatefulWidget {
  const _ProgressPhotosBody({
    required this.memberId,
    required this.isOwner,
    required this.isAssignedTrainer,
    required this.canModerate,
    required this.canUpload,
    required this.canDelete,
  });

  final String memberId;
  final bool isOwner;
  final bool isAssignedTrainer;
  final bool canModerate;
  final bool canUpload;
  final bool canDelete;

  @override
  State<_ProgressPhotosBody> createState() => _ProgressPhotosBodyState();
}

class _ProgressPhotosBodyState extends State<_ProgressPhotosBody> {
  var _compareMode = false;
  DateTime? _dateA;
  DateTime? _dateB;

  Future<void> _addPhoto(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final urlController = TextEditingController();
    var pose = PhotoPose.front;
    var isPrivate = false;
    DateTime? takenDate = DateTime.now();

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
                    GoalsStrings.addPhoto,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      labelText: GoalsStrings.photoUrlLabel,
                    ),
                  ),
                  DropdownButtonFormField<PhotoPose>(
                    // ignore: deprecated_member_use
                    value: pose,
                    decoration: const InputDecoration(
                      labelText: GoalsStrings.poseLabel,
                    ),
                    items: [
                      for (final p in PhotoPose.values)
                        DropdownMenuItem(
                          value: p,
                          child: Text(GoalsStrings.poseLabelFor(p)),
                        ),
                    ],
                    onChanged: (v) {
                      if (v != null) setLocal(() => pose = v);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(GoalsStrings.privateLabel),
                    value: isPrivate,
                    onChanged: (v) => setLocal(() => isPrivate = v),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final url = urlController.text.trim();
                      if (url.isEmpty) return;
                      final ok = await context
                          .read<ProgressPhotosCubit>()
                          .addPhoto(
                            photoUrl: url,
                            pose: pose,
                            takenDate: takenDate,
                            isPrivate: isPrivate,
                          );
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
    urlController.dispose();
    if (saved == true) {
      messenger.showSnackBar(
        const SnackBar(content: Text(GoalsStrings.photoSaved)),
      );
    }
  }

  Future<void> _pickDate(bool isA) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isA ? _dateA : _dateB) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isA) {
        _dateA = picked;
      } else {
        _dateB = picked;
      }
    });
    final a = _dateA;
    final b = _dateB;
    if (a != null && b != null) {
      await context.read<ProgressPhotosCubit>().compare(date1: a, date2: b);
    }
  }

  void _toggleCompareMode() {
    setState(() => _compareMode = !_compareMode);
    if (!_compareMode) {
      context.read<ProgressPhotosCubit>().clearComparison();
      setState(() {
        _dateA = null;
        _dateB = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(GoalsStrings.photosTitle),
        actions: [
          IconButton(
            tooltip: GoalsStrings.compareMode,
            icon: Icon(_compareMode ? Icons.grid_view : Icons.compare),
            onPressed: _toggleCompareMode,
          ),
        ],
      ),
      floatingActionButton: widget.canUpload
          ? FloatingActionButton(
              key: const Key('progress-photos-upload'),
              tooltip: GoalsStrings.addPhoto,
              onPressed: () => _addPhoto(context),
              child: const Icon(Icons.add_a_photo_outlined),
            )
          : null,
      body: BlocConsumer<ProgressPhotosCubit, ProgressPhotosState>(
        listener: (context, state) {
          final showData =
              state.status == LoadStatus.success || state.photos.isNotEmpty;
          if (state.failure != null && showData) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          final showData =
              state.status == LoadStatus.success || state.photos.isNotEmpty;
          if (state.status == LoadStatus.loading && !showData) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !showData) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<ProgressPhotosCubit>().load(
                widget.memberId,
                isOwner: widget.isOwner,
                isAssignedTrainer: widget.isAssignedTrainer,
                canModerate: widget.canModerate,
              ),
            );
          }
          final photos = state.photos;
          if (photos.isEmpty && !_compareMode) {
            return const AppEmptyView(message: GoalsStrings.photosEmpty);
          }
          return _compareMode
              ? _buildCompare(context, state)
              : _buildGallery(context, photos);
        },
      ),
    );
  }

  Widget _buildGallery(BuildContext context, List<ProgressPhoto> photos) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final pose in PhotoPose.values) ...[
          Text(
            GoalsStrings.poseLabelFor(pose),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in photos.where((e) => e.pose == pose))
                SizedBox(
                  width: 140,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Image.network(
                            p.photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const ColoredBox(
                              color: Colors.black12,
                              child: Icon(Icons.broken_image_outlined),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.takenDate
                                          ?.toIso8601String()
                                          .split('T')
                                          .first ??
                                      '—',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              if (p.isPrivate)
                                const Icon(Icons.lock_outline, size: 16),
                              if (widget.canDelete)
                                IconButton(
                                  key: Key('progress-photos-delete-${p.id}'),
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    final ok = await context
                                        .read<ProgressPhotosCubit>()
                                        .removePhoto(p.id);
                                    if (ok && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            GoalsStrings.photoDeleted,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildCompare(BuildContext context, ProgressPhotosState state) {
    final comparison = state.comparison;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          GoalsStrings.compareTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(GoalsStrings.compareDateA),
          subtitle: Text(_dateA?.toIso8601String().split('T').first ?? '—'),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _pickDate(true),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(GoalsStrings.compareDateB),
          subtitle: Text(_dateB?.toIso8601String().split('T').first ?? '—'),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _pickDate(false),
          ),
        ),
        const SizedBox(height: 12),
        if (_dateA == null || _dateB == null)
          const Text(GoalsStrings.compareEmpty)
        else if (state.comparing)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (comparison == null)
          const Text(GoalsStrings.compareEmpty)
        else
          for (final pose in PhotoPose.values) ...[
            Text(
              GoalsStrings.poseLabelFor(pose),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _compareTile(
                    comparison.pairFor(pose).date1,
                    label: _formatDate(comparison.date1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _compareTile(
                    comparison.pairFor(pose).date2,
                    label: _formatDate(comparison.date2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
      ],
    );
  }

  String _formatDate(DateTime d) =>
      d.toIso8601String().split('T').first;

  Widget _compareTile(ProgressPhoto? photo, {required String label}) {
    if (photo == null) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ColoredBox(
              color: Colors.black12,
              child: Center(
                child: Text(
                  GoalsStrings.compareNoPhoto,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Text(label),
        ],
      );
    }
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Image.network(
            photo.photoUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: Colors.black12,
              child: Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
        Text(label),
      ],
    );
  }
}
