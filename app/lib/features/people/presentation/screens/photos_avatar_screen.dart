import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/media/media_picker.dart';
import '../../../../core/media/signed_media_image.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/usecases/list_photos_usecase.dart';
import '../../domain/usecases/set_avatar_usecase.dart';
import '../../domain/usecases/upload_document_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';
import '../cubit/photos_cubit.dart';
import '../people_strings.dart';

class PhotosAvatarScreen extends StatelessWidget {
  const PhotosAvatarScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotosCubit(
        getIt<ListPhotosUseCase>(),
        getIt<UploadPhotoUseCase>(),
        getIt<CancelDocumentUploadUseCase>(),
        getIt<SetAvatarUseCase>(),
      )..load(memberId),
      child: _PhotosBody(memberId: memberId),
    );
  }
}

class _PhotosBody extends StatelessWidget {
  const _PhotosBody({required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PeopleStrings.photos),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined),
            tooltip: PeopleStrings.uploadPhoto,
            onPressed: () => _pickAndUpload(context),
          ),
        ],
      ),
      body: BlocConsumer<PhotosCubit, PhotosState>(
        listener: (context, state) {
          if (state.message == 'avatar') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(PeopleStrings.avatarSet)),
            );
          } else if (state.status == LoadStatus.failure &&
              state.photos.isNotEmpty &&
              state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          final photos = state.photos;
          final showFullScreen =
              photos.isEmpty && !state.uploading && state.uploadError == null;
          if (showFullScreen && state.status == LoadStatus.failure) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<PhotosCubit>().load(memberId),
            );
          }
          if (showFullScreen && state.status != LoadStatus.success) {
            return const AppLoading();
          }
          return Column(
            children: [
              if (state.uploading ||
                  state.uploadError != null ||
                  state.canRetry)
                _PhotoUploadBanner(
                  uploading: state.uploading,
                  progress: state.uploadProgress,
                  error: state.uploadError,
                  canRetry: state.canRetry,
                ),
              Expanded(
                child: photos.isEmpty
                    ? AppEmptyView(
                        message: PeopleStrings.emptyPhotos,
                        action: () => _pickAndUpload(context),
                        actionLabel: PeopleStrings.uploadPhoto,
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          final photo = photos[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                SignedMediaImage(objectKey: photo.objectKey),
                                if (photo.isCurrentAvatar)
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Chip(
                                        label: Text('Avatar'),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: TextButton(
                                    onPressed: photo.isCurrentAvatar
                                        ? null
                                        : () => context
                                              .read<PhotosCubit>()
                                              .setAsAvatar(photo.id),
                                    child: const Text(PeopleStrings.setAvatar),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickAndUpload(BuildContext context) async {
    final source = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(sheetContext, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(sheetContext, 'gallery'),
            ),
          ],
        ),
      ),
    );
    if (source == null || !context.mounted) return;

    final picker = getIt<MediaPicker>();
    final picked = source == 'camera'
        ? await picker.pickFromCamera()
        : await picker.pickFromGallery();
    if (picked == null || !context.mounted) return;

    await context.read<PhotosCubit>().upload(
      bytes: picked.bytes,
      contentType: picked.mimeType,
    );
  }
}

class _PhotoUploadBanner extends StatelessWidget {
  const _PhotoUploadBanner({
    required this.uploading,
    required this.progress,
    required this.error,
    required this.canRetry,
  });

  final bool uploading;
  final double? progress;
  final String? error;
  final bool canRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (uploading) ...[
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(child: Text('Uploading…')),
                  TextButton(
                    onPressed: () => context.read<PhotosCubit>().cancelUpload(),
                    child: const Text(PeopleStrings.uploadCancel),
                  ),
                ],
              ),
            ],
            if (error != null) Text(error!),
            if (canRetry && !uploading)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.read<PhotosCubit>().retryUpload(),
                  child: const Text(PeopleStrings.uploadRetry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
