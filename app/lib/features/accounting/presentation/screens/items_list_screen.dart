import 'package:flutter/material.dart';

import '../accounting_strings.dart';

/// Placeholder until IU-31 builds the list.
class ItemsListScreen extends StatelessWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AccountingStrings.itemsTitle)),
      body: const SizedBox.shrink(),
    );
  }
}
