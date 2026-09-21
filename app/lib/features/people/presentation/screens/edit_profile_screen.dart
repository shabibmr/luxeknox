import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/media/media_picker.dart';
import '../../../../core/media/signed_media_image.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/set_avatar_usecase.dart';
import '../../domain/usecases/update_member_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';
import '../cubit/edit_profile_cubit.dart';
import '../people_strings.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(
        getIt<GetMemberUseCase>(),
        getIt<UpdateMemberUseCase>(),
        getIt<SetAvatarUseCase>(),
        getIt<UploadPhotoUseCase>(),
      )..load(memberId),
      child: _EditProfileBody(memberId: memberId),
    );
  }
}

class _EditProfileBody extends StatelessWidget {
  const _EditProfileBody({required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.editProfile)),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileLoaded && state.message != null) {
            final text = state.message == 'avatar'
                ? PeopleStrings.avatarSet
                : PeopleStrings.profileSaved;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(text)));
          }
        },
        builder: (context, state) {
          return switch (state) {
            EditProfileLoading() => const AppLoading(),
            EditProfileFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<EditProfileCubit>().load(memberId),
            ),
            EditProfileLoaded(
              :final person,
              :final isSaving,
              :final isUploadingAvatar,
            ) =>
              _EditProfileForm(
                person: person,
                isSaving: isSaving,
                isUploadingAvatar: isUploadingAvatar,
              ),
          };
        },
      ),
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm({
    required this.person,
    required this.isSaving,
    required this.isUploadingAvatar,
  });

  final Person person;
  final bool isSaving;
  final bool isUploadingAvatar;

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _genderController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final p = widget.person;
    _firstNameController = TextEditingController(text: p.firstName);
    _lastNameController = TextEditingController(text: p.lastName);
    _emailController = TextEditingController(text: p.email ?? '');
    _phoneController = TextEditingController(text: p.phoneNumber ?? '');
    _genderController = TextEditingController(text: p.gender ?? '');
    _addressController = TextEditingController(text: p.address ?? '');
    _notesController = TextEditingController(text: p.notes ?? '');
  }

  @override
  void didUpdateWidget(covariant _EditProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.person != widget.person) {
      final p = widget.person;
      if (_firstNameController.text != p.firstName) {
        _firstNameController.text = p.firstName;
      }
      if (_lastNameController.text != p.lastName) {
        _lastNameController.text = p.lastName;
      }
      if (_emailController.text != (p.email ?? '')) {
        _emailController.text = p.email ?? '';
      }
      if (_phoneController.text != (p.phoneNumber ?? '')) {
        _phoneController.text = p.phoneNumber ?? '';
      }
      if (_genderController.text != (p.gender ?? '')) {
        _genderController.text = p.gender ?? '';
      }
      if (_addressController.text != (p.address ?? '')) {
        _addressController.text = p.address ?? '';
      }
      if (_notesController.text != (p.notes ?? '')) {
        _notesController.text = p.notes ?? '';
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadAvatar(BuildContext context) async {
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

    await context.read<EditProfileCubit>().uploadAndSetAvatar(
      bytes: picked.bytes,
      contentType: picked.mimeType,
    );
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final person = widget.person;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: person.avatarUrl != null && person.avatarUrl!.isNotEmpty
                    ? ClipOval(
                        child: SizedBox(
                          width: 96,
                          height: 96,
                          child: SignedMediaImage(
                            objectKey: person.avatarUrl!,
                            fit: BoxFit.cover,
                            height: 96,
                          ),
                        ),
                      )
                    : Text(
                        person.firstName.isNotEmpty
                            ? person.firstName[0].toUpperCase()
                            : '?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    tooltip: PeopleStrings.changeAvatar,
                    onPressed: widget.isUploadingAvatar
                        ? null
                        : () => _pickAndUploadAvatar(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.isUploadingAvatar) ...[
          const SizedBox(height: 8),
          const Center(child: LinearProgressIndicator()),
        ],
        const SizedBox(height: 24),
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: PeopleStrings.firstName),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(labelText: PeopleStrings.lastName),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: PeopleStrings.email),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: PeopleStrings.phone),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _genderController,
          decoration: const InputDecoration(labelText: PeopleStrings.gender),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: PeopleStrings.address),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(labelText: PeopleStrings.notes),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: widget.isSaving
              ? null
              : () {
                  context.read<EditProfileCubit>().save(
                    person.copyWith(
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                      email: _optional(_emailController.text),
                      phoneNumber: _optional(_phoneController.text),
                      gender: _optional(_genderController.text),
                      address: _optional(_addressController.text),
                      notes: _optional(_notesController.text),
                    ),
                  );
                },
          child: widget.isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(PeopleStrings.save),
        ),
      ],
    );
  }
}
