import 'package:equatable/equatable.dart';

class AttendancePass extends Equatable {
  const AttendancePass({
    required this.userId,
    required this.payload,
    required this.expiresAt,
  });

  final String userId;
  final String payload;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [userId, payload, expiresAt];
}
