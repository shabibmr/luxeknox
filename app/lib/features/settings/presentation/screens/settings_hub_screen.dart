import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../domain/entities/setting_category.dart';
import '../settings_strings.dart';

/// Admin settings navigation hub — one tile per settings category.
class SettingsHubScreen extends StatelessWidget {
  const SettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = SettingCategory.values;
    return Scaffold(
      appBar: AppBar(title: const Text(SettingsStrings.hubTitle)),
      body: ListView.separated(
        itemCount: categories.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.label),
            subtitle: Text(category.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                context.go(Routes.adminSettingsCategory(category.wireName)),
          );
        },
      ),
    );
  }
}
