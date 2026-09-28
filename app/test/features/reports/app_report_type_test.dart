import 'package:luxeknox/features/reports/domain/entities/app_report_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses wire names and revenue alias', () {
    expect(parseAppReportType('members'), AppReportType.members);
    expect(parseAppReportType('trainer_own'), AppReportType.trainerOwn);
    expect(parseAppReportType('revenue'), AppReportType.payments);
    expect(parseAppReportType('nope'), isNull);
  });

  test('filter visibility flags', () {
    expect(AppReportType.memberships.showsProductFilter, isTrue);
    expect(AppReportType.members.showsProductFilter, isFalse);
    expect(AppReportType.trainers.showsTrainerFilter, isTrue);
    expect(AppReportType.workouts.showsTrainerFilter, isTrue);
    expect(AppReportType.payments.showsTrainerFilter, isFalse);
  });
}
