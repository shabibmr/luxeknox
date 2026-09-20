import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../session/presentation/session_cubit.dart';
import '../auth_strings.dart';

/// Sign-out action for the Profile tab. Confirms before clearing the
/// session; the router reacts to the resulting `SessionUnauthenticated`
/// state and lands on `/login` with no imperative navigation here.
class SignOutTile extends StatelessWidget {
  const SignOutTile({super.key});

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final sessionCubit = context.read<SessionCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AuthStrings.signOut),
        content: const Text(AuthStrings.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AuthStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AuthStrings.signOut),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await sessionCubit.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text(AuthStrings.signOut),
      onTap: () => _confirmAndSignOut(context),
    );
  }
}
