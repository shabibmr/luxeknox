import 'package:flutter/material.dart';

class SessionComment {
  const SessionComment({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.author,
    required this.text,
    required this.isPrivate,
    required this.createdAt,
  });

  final String id;
  final String entityType; // 'plan', 'exercise', 'set'
  final String entityId;
  final String author;
  final String text;
  final bool isPrivate;
  final DateTime createdAt;
}

/// In-memory session comments store for active workout sessions.
class SessionCommentsStore {
  SessionCommentsStore._();
  static final instance = SessionCommentsStore._();

  final List<SessionComment> _comments = [];

  List<SessionComment> getComments({
    required String entityType,
    required String entityId,
  }) {
    return _comments
        .where((c) => c.entityType == entityType && c.entityId == entityId)
        .toList();
  }

  int countFor({
    required String entityType,
    required String entityId,
  }) {
    return _comments
        .where((c) => c.entityType == entityType && c.entityId == entityId)
        .length;
  }

  void addComment({
    required String entityType,
    required String entityId,
    required String author,
    required String text,
    required bool isPrivate,
  }) {
    _comments.add(
      SessionComment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        entityType: entityType,
        entityId: entityId,
        author: author,
        text: text,
        isPrivate: isPrivate,
        createdAt: DateTime.now(),
      ),
    );
  }

  void clear() {
    _comments.clear();
  }
}

class SessionCommentsSheet extends StatefulWidget {
  const SessionCommentsSheet({
    super.key,
    required this.entityType,
    required this.entityId,
    required this.title,
    this.author = 'Trainer Alex',
  });

  final String entityType;
  final String entityId;
  final String title;
  final String author;

  static Future<void> show(
    BuildContext context, {
    required String entityType,
    required String entityId,
    required String title,
    String author = 'Trainer Alex',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SessionCommentsSheet(
        entityType: entityType,
        entityId: entityId,
        title: title,
        author: author,
      ),
    );
  }

  @override
  State<SessionCommentsSheet> createState() => _SessionCommentsSheetState();
}

class _SessionCommentsSheetState extends State<SessionCommentsSheet> {
  final _commentController = TextEditingController();
  bool _isPrivate = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      SessionCommentsStore.instance.addComment(
        entityType: widget.entityType,
        entityId: widget.entityId,
        author: widget.author,
        text: text,
        isPrivate: _isPrivate,
      );
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final comments = SessionCommentsStore.instance.getComments(
      entityType: widget.entityType,
      entityId: widget.entityId,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMMENTS & NOTES',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: comments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No comments yet. Add notes or feedback below.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final c = comments[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: c.isPrivate
                              ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3)
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: c.isPrivate
                                ? theme.colorScheme.tertiary
                                : theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  c.author,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (c.isPrivate)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.tertiary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.lock,
                                          size: 11,
                                          color: theme.colorScheme.onTertiary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Trainer Only',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.onTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Text(
                                    'Shared',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(c.text, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Write a comment or note...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _isPrivate,
                onChanged: (val) => setState(() => _isPrivate = val ?? false),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPrivate = !_isPrivate),
                  child: Text(
                    'Private Note (Visible only to trainer)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: _submitComment,
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    ),
    ),
    );
  }
}
