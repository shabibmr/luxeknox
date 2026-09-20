import '../../../../session/domain/entities/capabilities.dart';

/// The viewer's relationship to a [Person] being displayed, driving the
/// adaptive Profile screen (02) and field editability on Edit Profile (03)
/// per BR-PEOPLE-002/003.
///
/// This is a UI-shaping hint only — the server is the authority and
/// independently enforces BR-PEOPLE-002 (member reading another member ->
/// 403) and BR-PEOPLE-003 (trainer reading an unassigned member -> 404).
enum PersonScope { self, assignedClient, any }

/// Resolves a [PersonScope] from the viewer's [Capabilities] plus identity.
///
/// Capability slugs follow the `people.read.<any|assigned>` convention
/// used elsewhere for `context.can(<slug>)` checks (see global rules).
class PersonScopeResolver {
  const PersonScopeResolver();

  /// [viewerProfileId] is the authenticated principal's own profile id;
  /// [subjectProfileId] is the profile id of the [Person] being viewed.
  PersonScope resolve({
    required Capabilities capabilities,
    required String viewerProfileId,
    required String subjectProfileId,
  }) {
    if (viewerProfileId == subjectProfileId) return PersonScope.self;
    if (capabilities.can('people.read.any')) return PersonScope.any;
    if (capabilities.can('people.read.assigned')) {
      return PersonScope.assignedClient;
    }
    return PersonScope.self;
  }
}
