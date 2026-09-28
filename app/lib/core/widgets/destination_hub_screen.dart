import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Simple list hub for a shell tab that fans out to nested destinations.
class DestinationHubScreen extends StatelessWidget {
  const DestinationHubScreen({
    super.key,
    required this.title,
    required this.items,
    this.footer,
  });

  final String title;
  final List<DestinationHubItem> items;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final footer = this.footer;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        itemCount: items.length + (footer != null ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (footer != null && index == items.length) {
            return footer;
          }
          final item = items[index];
          return ListTile(
            leading: item.icon == null ? null : Icon(item.icon),
            title: Text(item.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(item.path),
          );
        },
      ),
    );
  }
}

class DestinationHubItem {
  const DestinationHubItem({
    required this.title,
    required this.path,
    this.icon,
  });

  final String title;
  final String path;
  final IconData? icon;
}
