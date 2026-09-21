import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../auth_strings.dart';
import '../widgets/sign_out_tile.dart';

class ProfileTabLink {
  const ProfileTabLink({
    required this.title,
    required this.path,
    this.icon = Icons.chevron_right,
  });

  final String title;
  final String path;
  final IconData icon;
}

/// Profile tab root: optional nested links, password change, and sign-out.
class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({
    super.key,
    required this.title,
    this.links = const [],
  });

  final String title;
  final List<ProfileTabLink> links;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        children: [
          for (final link in links)
            ListTile(
              leading: Icon(link.icon),
              title: Text(link.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(link.path),
            ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text(AuthStrings.changePassword),
            onTap: () => context.push(Routes.changePassword),
          ),
          const SignOutTile(),
        ],
      ),
    );
  }
}
