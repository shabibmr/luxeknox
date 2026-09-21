import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/media/document_access.dart';
import '../../../../core/media/media_picker.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/usecases/delete_document_usecase.dart';
import '../../domain/usecases/list_documents_usecase.dart';
import '../../domain/usecases/upload_document_usecase.dart';
import '../cubit/documents_cubit.dart';
import '../people_strings.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    final role = session is SessionAuthenticated
        ? session.principal.userType
        : UserType.member;

    return BlocProvider(
      create: (_) => DocumentsCubit(
        getIt<ListDocumentsUseCase>(),
        getIt<UploadDocumentUseCase>(),
        getIt<CancelDocumentUploadUseCase>(),
        getIt<DeleteDocumentUseCase>(),
        role,
      )..load(memberId),
      child: _DocumentsBody(memberId: memberId, role: role),
    );
  }
}

class _DocumentsBody extends StatelessWidget {
  const _DocumentsBody({required this.memberId, required this.role});

  final int memberId;
  final UserType role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PeopleStrings.documents),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_outlined),
            tooltip: PeopleStrings.uploadDocument,
            onPressed: () => _pickAndUpload(context),
          ),
        ],
      ),
      body: BlocBuilder<DocumentsCubit, DocumentsState>(
        builder: (context, state) {
          return switch (state) {
            DocumentsLoading() => const AppLoading(),
            DocumentsFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<DocumentsCubit>().load(memberId),
            ),
            DocumentsLoaded(
              :final documents,
              :final uploading,
              :final uploadProgress,
              :final uploadError,
            ) =>
              Column(
                children: [
                  if (uploading || uploadError != null || state.canRetry)
                    _UploadBanner(
                      uploading: uploading,
                      progress: uploadProgress,
                      error: uploadError,
                      canRetry: state.canRetry,
                    ),
                  Expanded(
                    child: documents.isEmpty
                        ? AppEmptyView(
                            message: PeopleStrings.emptyDocuments,
                            action: () => _pickAndUpload(context),
                            actionLabel: PeopleStrings.uploadDocument,
                          )
                        : ListView.separated(
                            itemCount: documents.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final doc = documents[index];
                              return ListTile(
                                title: Text(
                                  doc.title ?? doc.documentType.name,
                                ),
                                subtitle: Text(doc.documentType.name),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => context
                                      .read<DocumentsCubit>()
                                      .remove(doc.id),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
          };
        },
      ),
    );
  }

  Future<void> _pickAndUpload(BuildContext context) async {
    final purpose = await showModalBottomSheet<DocumentPurpose>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: DocumentPurpose.values
              .where(
                (p) => canAccessDocument(role: role, purpose: p),
              )
              .map(
                (p) => ListTile(
                  title: Text(p.name),
                  onTap: () => Navigator.pop(sheetContext, p),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (purpose == null || !context.mounted) return;

    final titleController = TextEditingController();
    final titled = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(PeopleStrings.documentTitle),
        content: TextField(controller: titleController),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(PeopleStrings.cancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, titleController.text.trim()),
            child: const Text(PeopleStrings.uploadDocument),
          ),
        ],
      ),
    );
    if (titled == null || titled.isEmpty || !context.mounted) return;

    final picked = await getIt<MediaPicker>().pickDocument();
    if (picked == null || !context.mounted) return;

    await context.read<DocumentsCubit>().upload(
      purpose: purpose,
      title: titled,
      bytes: picked.bytes,
      contentType: picked.mimeType,
    );
  }
}

class _UploadBanner extends StatelessWidget {
  const _UploadBanner({
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
                    onPressed: () =>
                        context.read<DocumentsCubit>().cancelUpload(),
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
                  onPressed: () => context.read<DocumentsCubit>().retryUpload(),
                  child: const Text(PeopleStrings.uploadRetry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
