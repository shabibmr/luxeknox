import 'package:flutter/material.dart';

import '../../domain/entities/item.dart';
import '../accounting_strings.dart';

/// Placeholder until IU-41 builds the detail view.
class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.itemId, this.initialItem});

  final int itemId;
  final Item? initialItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AccountingStrings.itemDetailTitle)),
      body: const SizedBox.shrink(),
    );
  }
}
