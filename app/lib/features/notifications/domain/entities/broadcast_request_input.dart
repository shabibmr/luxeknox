import 'package:equatable/equatable.dart';

import 'broadcast_audience.dart';

class BroadcastRequestInput extends Equatable {
  const BroadcastRequestInput({
    required this.title,
    required this.message,
    this.notificationTypeId,
    this.dataPayload,
    this.audience,
    this.roleId,
  });

  final String title;
  final String message;
  final String? notificationTypeId;
  final Map<String, String?>? dataPayload;
  final BroadcastAudience? audience;
  final String? roleId;

  @override
  List<Object?> get props => [
    title,
    message,
    notificationTypeId,
    dataPayload,
    audience,
    roleId,
  ];
}
