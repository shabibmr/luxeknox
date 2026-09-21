import 'package:equatable/equatable.dart';

import 'device_platform.dart';

class NotificationDevice extends Equatable {
  const NotificationDevice({
    required this.id,
    required this.userId,
    required this.deviceToken,
    required this.devicePlatform,
    this.lastActiveAt,
  });

  final String id;
  final String userId;
  final String deviceToken;
  final DevicePlatform devicePlatform;
  final DateTime? lastActiveAt;

  @override
  List<Object?> get props => [
    id,
    userId,
    deviceToken,
    devicePlatform,
    lastActiveAt,
  ];
}
