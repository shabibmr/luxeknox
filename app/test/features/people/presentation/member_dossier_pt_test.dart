import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_product.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/people/presentation/member_dossier_pt.dart';

void main() {
  Membership membership({
    MembershipStatus status = MembershipStatus.active,
    int daysUntilExpiry = 30,
    int? remainingPtSessions,
    int? ptSessionsIncluded,
    bool includeProduct = true,
  }) {
    final end = DateTime.now().add(Duration(days: daysUntilExpiry));
    return Membership(
      id: 'm1',
      memberId: '42',
      productId: 'p1',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: end,
      remainingPtSessions: remainingPtSessions,
      status: status,
      rowVersion: 1,
      product: includeProduct
          ? MembershipProduct(
              id: 'p1',
              name: 'PT Pack',
              code: 'PT',
              durationDays: 30,
              basePrice: '100.00',
              ptSessionsIncluded: ptSessionsIncluded,
              isActive: true,
            )
          : null,
    );
  }

  group('isPtPurchased', () {
    test('true for active membership with product PT sessions', () {
      expect(
        isPtPurchased(membership(ptSessionsIncluded: 8)),
        isTrue,
      );
    });

    test('true when product omitted but remaining PT sessions > 0', () {
      expect(
        isPtPurchased(
          membership(
            includeProduct: false,
            remainingPtSessions: 3,
          ),
        ),
        isTrue,
      );
    });

    test('false when expired even with PT product', () {
      expect(
        isPtPurchased(
          membership(
            status: MembershipStatus.expired,
            daysUntilExpiry: -5,
            ptSessionsIncluded: 8,
          ),
        ),
        isFalse,
      );
    });

    test('false when no PT sessions', () {
      expect(
        isPtPurchased(membership(ptSessionsIncluded: 0, remainingPtSessions: 0)),
        isFalse,
      );
    });
  });

  group('isPtExpired', () {
    test('true for expired status with PT product', () {
      expect(
        isPtExpired(
          membership(
            status: MembershipStatus.expired,
            daysUntilExpiry: -2,
            ptSessionsIncluded: 8,
          ),
        ),
        isTrue,
      );
    });

    test('false when membership has no PT', () {
      expect(
        isPtExpired(
          membership(
            status: MembershipStatus.expired,
            daysUntilExpiry: -2,
            ptSessionsIncluded: 0,
          ),
        ),
        isFalse,
      );
    });
  });

  group('formatDaysRelative', () {
    test('formats days left', () {
      final end = DateTime(2026, 4, 10);
      final now = DateTime(2026, 4, 1);
      expect(formatDaysRelative(end, now: now), '(9 days left)');
    });

    test('formats expires today', () {
      final day = DateTime(2026, 4, 1);
      expect(formatDaysRelative(day, now: day), '(expires today)');
    });

    test('formats expired days ago', () {
      final end = DateTime(2026, 3, 25);
      final now = DateTime(2026, 4, 1);
      expect(formatDaysRelative(end, now: now), '(expired 7 days ago)');
    });
  });

  group('addPersonalTrainingLocation', () {
    test('sends active gym-only membership to membership detail', () {
      expect(
        addPersonalTrainingLocation(
          memberId: 42,
          membership: membership(ptSessionsIncluded: 0, remainingPtSessions: 0),
        ),
        Routes.adminMembershipById('m1'),
      );
    });

    test('sends no membership to assign-membership create', () {
      expect(
        addPersonalTrainingLocation(memberId: 42),
        '/admin/members/42/assign-membership',
      );
    });

    test('sends expired membership to assign-membership create', () {
      expect(
        addPersonalTrainingLocation(
          memberId: 42,
          membership: membership(
            status: MembershipStatus.expired,
            daysUntilExpiry: -2,
            ptSessionsIncluded: 0,
          ),
        ),
        '/admin/members/42/assign-membership',
      );
    });
  });
}
