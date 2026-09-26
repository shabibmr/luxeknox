import 'package:luxeknox/features/membership/presentation/membership_strings.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../../fixtures/principal_fixtures.dart';

String catalogSubtitle({
  required UserType role,
  required String code,
  required int durationDays,
  required String basePrice,
}) {
  if (role == UserType.trainer) {
    return '$code · ${durationDays}d';
  }
  return '$code · ${durationDays}d · $basePrice';
}

void main() {
  testWidgets('trainer pricing visibility omits base price', (tester) async {
    final subtitle = catalogSubtitle(
      role: PrincipalFixtures.trainer.userType,
      code: 'GOLD',
      durationDays: 30,
      basePrice: '99.00',
    );

    await pumpApp(
      tester,
      Scaffold(
        body: ListTile(
          title: const Text(MembershipStrings.catalogTitle),
          subtitle: Text(subtitle),
        ),
      ),
    );

    expect(find.textContaining('99.00'), findsNothing);
    expect(find.text('GOLD · 30d'), findsOneWidget);
  });

  testWidgets('member pricing visibility includes base price', (tester) async {
    final subtitle = catalogSubtitle(
      role: PrincipalFixtures.member.userType,
      code: 'GOLD',
      durationDays: 30,
      basePrice: '99.00',
    );

    await pumpApp(
      tester,
      Scaffold(
        body: ListTile(subtitle: Text(subtitle)),
      ),
    );

    expect(find.text('GOLD · 30d · 99.00'), findsOneWidget);
  });
}
