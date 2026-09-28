import 'package:luxeknox/features/people/domain/entities/person_scope.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const resolver = PersonScopeResolver();

  group('PersonScopeResolver (BR-PEOPLE-002/003)', () {
    test('resolves self when viewer id matches subject id', () {
      final scope = resolver.resolve(
        capabilities: const Capabilities(slugs: []),
        viewerProfileId: 'p1',
        subjectProfileId: 'p1',
      );

      expect(scope, PersonScope.self);
    });

    test('resolves any for a capability holder viewing someone else', () {
      final scope = resolver.resolve(
        capabilities: const Capabilities(slugs: ['people.read.any']),
        viewerProfileId: 'p1',
        subjectProfileId: 'p2',
      );

      expect(scope, PersonScope.any);
    });

    test(
      'resolves assignedClient for a trainer without the any capability',
      () {
        final scope = resolver.resolve(
          capabilities: const Capabilities(slugs: ['people.read.assigned']),
          viewerProfileId: 'p1',
          subjectProfileId: 'p2',
        );

        expect(scope, PersonScope.assignedClient);
      },
    );

    test(
      'falls back to self when no capability grants access to another profile',
      () {
        final scope = resolver.resolve(
          capabilities: const Capabilities(slugs: []),
          viewerProfileId: 'p1',
          subjectProfileId: 'p2',
        );

        expect(scope, PersonScope.self);
      },
    );
  });
}
