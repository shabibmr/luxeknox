import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/usecases/create_emergency_contact_usecase.dart';
import '../../domain/usecases/delete_emergency_contact_usecase.dart';
import '../../domain/usecases/list_emergency_contacts_usecase.dart';
import '../../domain/usecases/update_emergency_contact_usecase.dart';
import '../cubit/emergency_contacts_cubit.dart';
import '../people_strings.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({
    super.key,
    required this.userId,
  });

  final int userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmergencyContactsCubit(
        getIt<ListEmergencyContactsUseCase>(),
        getIt<CreateEmergencyContactUseCase>(),
        getIt<UpdateEmergencyContactUseCase>(),
        getIt<DeleteEmergencyContactUseCase>(),
      )..load(userId),
      child: _EmergencyContactsBody(userId: userId),
    );
  }
}

class _EmergencyContactsBody extends StatelessWidget {
  const _EmergencyContactsBody({required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PeopleStrings.emergencyContacts),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: PeopleStrings.add,
            onPressed: () => _showEditor(context),
          ),
        ],
      ),
      body: BlocBuilder<EmergencyContactsCubit, EmergencyContactsState>(
        builder: (context, state) {
          return switch (state) {
            EmergencyContactsLoading() => const AppLoading(),
            EmergencyContactsFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<EmergencyContactsCubit>().load(userId),
            ),
            EmergencyContactsLoaded(:final contacts) => contacts.isEmpty
                ? AppEmptyView(
                    message: PeopleStrings.emptyEmergency,
                    action: () => _showEditor(context),
                    actionLabel: PeopleStrings.add,
                  )
                : ListView.separated(
                    itemCount: contacts.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ListTile(
                        title: Text(contact.contactName),
                        subtitle: Text(
                          [
                            contact.phonePrimary,
                            if (contact.relationship != null)
                              contact.relationship,
                            if (contact.isPrimary) 'Primary',
                          ].join(' · '),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => context
                              .read<EmergencyContactsCubit>()
                              .remove(contact.id),
                        ),
                        onTap: () => _showEditor(context, existing: contact),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }

  Future<void> _showEditor(
    BuildContext context, {
    EmergencyContact? existing,
  }) async {
    final name = TextEditingController(text: existing?.contactName ?? '');
    final relationship = TextEditingController(text: existing?.relationship);
    final phone = TextEditingController(text: existing?.phonePrimary ?? '');
    final phone2 = TextEditingController(text: existing?.phoneSecondary);
    var isPrimary = existing?.isPrimary ?? false;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: Text(
                existing == null ? PeopleStrings.add : PeopleStrings.save,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.contactName,
                    ),
                  ),
                  TextField(
                    controller: relationship,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.relationship,
                    ),
                  ),
                  TextField(
                    controller: phone,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.phonePrimary,
                    ),
                  ),
                  TextField(
                    controller: phone2,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.phoneSecondary,
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(PeopleStrings.primaryContact),
                    value: isPrimary,
                    onChanged: (v) => setLocal(() => isPrimary = v),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text(PeopleStrings.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text(PeopleStrings.save),
                ),
              ],
            );
          },
        );
      },
    );
    if (saved != true || !context.mounted) return;
    final contact = EmergencyContact(
      id: existing?.id ?? 0,
      userId: userId,
      contactName: name.text.trim(),
      relationship: relationship.text.trim().isEmpty
          ? null
          : relationship.text.trim(),
      phonePrimary: phone.text.trim(),
      phoneSecondary: phone2.text.trim().isEmpty ? null : phone2.text.trim(),
      isPrimary: isPrimary,
    );
    final cubit = context.read<EmergencyContactsCubit>();
    if (existing == null) {
      await cubit.add(contact);
    } else {
      await cubit.save(contact);
    }
  }
}
