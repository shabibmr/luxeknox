import 'package:flutter/material.dart';

import '../accounting_strings.dart';

/// Placeholder until IU-52 builds the form. [itemId] null means create.
class ItemFormScreen extends StatelessWidget {
  const ItemFormScreen({super.key, this.itemId});

  final int? itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          itemId == null
              ? AccountingStrings.createItemTitle
              : AccountingStrings.editItemTitle,
        ),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
