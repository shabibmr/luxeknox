import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    this.notificationTypeId,
    required this.title,
    required this.message,
    this.dataPayload,
    this.senderUserId,
    required this.createdAt,
    this.isRead,
    this.readAt,
  });

  final String id;
  final String? notificationTypeId;
  final String title;
  final String message;
  final Map<String, String?>? dataPayload;
  final String? senderUserId;
  final DateTime createdAt;
  final bool? isRead;
  final DateTime? readAt;

  bool get unread => isRead != true;

  AppNotification copyWith({
    String? id,
    String? notificationTypeId,
    String? title,
    String? message,
    Map<String, String?>? dataPayload,
    String? senderUserId,
    DateTime? createdAt,
    bool? isRead,
    DateTime? readAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      notificationTypeId: notificationTypeId ?? this.notificationTypeId,
      title: title ?? this.title,
      message: message ?? this.message,
      dataPayload: dataPayload ?? this.dataPayload,
      senderUserId: senderUserId ?? this.senderUserId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    notificationTypeId,
    title,
    message,
    dataPayload,
    senderUserId,
    createdAt,
    isRead,
    readAt,
  ];
}
