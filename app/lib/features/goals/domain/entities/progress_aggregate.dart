import 'package:equatable/equatable.dart';

class ProgressAggregateCounts extends Equatable {
  const ProgressAggregateCounts({
    required this.activeGoals,
    required this.achievedGoals,
    required this.membersMeasured30d,
    required this.photos30d,
  });

  final int activeGoals;
  final int achievedGoals;
  final int membersMeasured30d;
  final int photos30d;

  @override
  List<Object?> get props => [
    activeGoals,
    achievedGoals,
    membersMeasured30d,
    photos30d,
  ];
}
