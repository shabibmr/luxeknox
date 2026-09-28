import 'package:equatable/equatable.dart';

import 'progress_note_type.dart';

class ProgressNote extends Equatable {
  const ProgressNote({
    required this.id,
    required this.memberId,
    required this.authorUserId,
    required this.noteText,
    required this.noteType,
    required this.createdAt,
  });

  final String id;
  final String memberId;
  final String authorUserId;
  final String noteText;
  final ProgressNoteType noteType;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    memberId,
    authorUserId,
    noteText,
    noteType,
    createdAt,
  ];
}
