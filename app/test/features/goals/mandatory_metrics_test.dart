import 'package:luxeknox/features/goals/domain/helpers/mandatory_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns missing mandatory metric ids', () {
    final missing = missingMandatoryMetrics(
      mandatoryIds: const ['1', '2', '3'],
      submittedMetricIds: const ['1', '3'],
    );
    expect(missing, ['2']);
  });

  test('empty when all present', () {
    final missing = missingMandatoryMetrics(
      mandatoryIds: const ['1', '2'],
      submittedMetricIds: const ['2', '1', '9'],
    );
    expect(missing, isEmpty);
  });

  test('empty mandatory list yields empty', () {
    expect(
      missingMandatoryMetrics(
        mandatoryIds: const [],
        submittedMetricIds: const [],
      ),
      isEmpty,
    );
  });
}
