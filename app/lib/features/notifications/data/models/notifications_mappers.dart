import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/entities/broadcast_audience.dart';
import '../../domain/entities/broadcast_request_input.dart';
import '../../domain/entities/device_platform.dart';
import '../../domain/entities/notification_device.dart';

extension NotificationModelMapper on api.Notification {
  AppNotification toDomain() {
    return AppNotification(
      id: id.toString(),
      notificationTypeId: notificationTypeId?.toString(),
      title: title,
      message: message,
      dataPayload: dataPayload == null
          ? null
          : {
              for (final e in dataPayload!.entries)
                e.key: _jsonObjectToString(e.value),
            },
      senderUserId: senderUserId?.toString(),
      createdAt: createdAt,
      isRead: isRead,
      readAt: readAt,
    );
  }
}

extension DeviceModelMapper on api.Device {
  NotificationDevice toDomain() {
    return NotificationDevice(
      id: id.toString(),
      userId: userId.toString(),
      deviceToken: deviceToken,
      devicePlatform: DevicePlatform.fromWire(devicePlatform.name),
      lastActiveAt: lastActiveAt,
    );
  }
}

api.DeviceWrite toDeviceWrite({
  required String deviceToken,
  required DevicePlatform platform,
}) {
  return api.DeviceWrite(
    (b) => b
      ..deviceToken = deviceToken
      ..devicePlatform = switch (platform) {
        DevicePlatform.ios => api.DeviceWriteDevicePlatformEnum.ios,
        DevicePlatform.android => api.DeviceWriteDevicePlatformEnum.android,
        DevicePlatform.web => api.DeviceWriteDevicePlatformEnum.web,
      },
  );
}

api.BroadcastRequest toBroadcastRequest(BroadcastRequestInput input) {
  return api.BroadcastRequest((b) {
    b
      ..title = input.title
      ..message = input.message;
    final typeId = int.tryParse(input.notificationTypeId ?? '');
    if (typeId != null) b.notificationTypeId = typeId;
    if (input.audience != null) {
      b.audience = switch (input.audience!) {
        BroadcastAudience.allMembers =>
          api.BroadcastRequestAudienceEnum.allMembers,
        BroadcastAudience.assignedClients =>
          api.BroadcastRequestAudienceEnum.assignedClients,
        BroadcastAudience.role => api.BroadcastRequestAudienceEnum.role,
      };
    }
    final roleId = int.tryParse(input.roleId ?? '');
    if (roleId != null) b.roleId = roleId;
    if (input.dataPayload != null && input.dataPayload!.isNotEmpty) {
      b.dataPayload.replace(
        BuiltMap<String, JsonObject?>({
          for (final e in input.dataPayload!.entries)
            e.key: e.value == null ? null : JsonObject(e.value),
        }),
      );
    }
  });
}

String? _jsonObjectToString(JsonObject? value) {
  if (value == null) return null;
  if (value.isString) return value.asString;
  if (value.isNum) return value.asNum.toString();
  if (value.isBool) return value.asBool.toString();
  return value.toString();
}
