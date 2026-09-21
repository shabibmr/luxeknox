import 'package:equatable/equatable.dart';

class DeepLinkTarget extends Equatable {
  const DeepLinkTarget({
    required this.entityType,
    required this.entityId,
  });

  final String entityType;
  final String entityId;

  @override
  List<Object?> get props => [entityType, entityId];
}
