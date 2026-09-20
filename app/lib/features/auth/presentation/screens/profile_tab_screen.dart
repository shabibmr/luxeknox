import 'package:flutter/material.dart';

import '../widgets/sign_out_tile.dart';

/// Profile tab root: shows sign-out until a real profile screen lands.
class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(children: const [SignOutTile()]),
    );
  }
}
