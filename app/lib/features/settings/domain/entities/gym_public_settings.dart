import 'package:equatable/equatable.dart';

/// Unauthenticated, gym-wide display settings (`GET /settings/public`).
class GymPublicSettings extends Equatable {
  const GymPublicSettings({
    required this.timezone,
    required this.currency,
    this.dateFormat,
    this.defaultPageSize,
    this.operatingHours,
    this.cancellationCutoffMinutes,
  });

  /// IANA timezone name (e.g. `Asia/Kolkata`) the gym operates in.
  final String timezone;
  final String currency;
  final String? dateFormat;
  final int? defaultPageSize;
  final String? operatingHours;
  final int? cancellationCutoffMinutes;

  @override
  List<Object?> get props => [
    timezone,
    currency,
    dateFormat,
    defaultPageSize,
    operatingHours,
    cancellationCutoffMinutes,
  ];
}
