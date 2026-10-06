import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/features/notifications/domain/entities/deep_link_target.dart';
import 'package:luxeknox/features/notifications/domain/helpers/deep_link_resolver.dart';

void main() {
  group('resolveDeepLinkPath', () {
    test('maps trainer to member profile trainer route', () {
      expect(
        resolveDeepLinkPath(
          const DeepLinkTarget(entityType: 'trainer', entityId: '1'),
        ),
        Routes.memberProfileTrainer,
      );
    });

    test('maps schedule id to member schedule by id', () {
      expect(
        resolveDeepLinkPath(
          const DeepLinkTarget(entityType: 'schedule', entityId: '15'),
        ),
        Routes.memberScheduleById('15'),
      );
    });
  });
}
