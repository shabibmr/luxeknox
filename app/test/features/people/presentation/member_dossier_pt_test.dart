import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/entities/membership_status.dart';
import 'package:luxeknox/features/people/presentation/member_dossier_pt.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_subscription.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';

void main() {
  final now = DateTime(2026, 10, 1);

  Membership membership({
    MembershipStatus status = MembershipStatus.active,
    required DateTime endDate,
  }) {
    return Membership(
      id: 'm1',
      memberId: '42',
      productId: 'p1',
      startDate: DateTime(2026, 9, 1),
      endDate: endDate,
      status: status,
      rowVersion: 1,
    );
  }

  PtSubscription sub(PtSubscriptionStatus status) => PtSubscription(
    id: 1,
    memberId: 42,
    ptProductId: 3,
    trainerId: 7,
    startDate: DateTime(2026, 9, 1),
    endDate: DateTime(2026, 9, 29),
    weekdays: const [1, 3, 5],
    slotStart: '17:00:00',
    status: status,
    rowVersion: 1,
    productName: 'PT',
    sessionsPerWeek: 3,
    trainerName: 'Alex',
    slotLabel: '17:00-18:00',
  );

  group('ptDossierStatus', () {
    test('active / scheduled come from the current subscription', () {
      expect(
        ptDossierStatus(
          MemberPtSummary(current: sub(PtSubscriptionStatus.active)),
        ),
        PtDossierStatus.active,
      );
      expect(
        ptDossierStatus(
          MemberPtSummary(current: sub(PtSubscriptionStatus.scheduled)),
        ),
        PtDossierStatus.scheduled,
      );
    });

    test('expired when only a completed PT exists', () {
      expect(
        ptDossierStatus(
          MemberPtSummary(history: [sub(PtSubscriptionStatus.completed)]),
        ),
        PtDossierStatus.expired,
      );
    });

    test('expired when only a cancelled PT exists', () {
      expect(
        ptDossierStatus(
          MemberPtSummary(history: [sub(PtSubscriptionStatus.cancelled)]),
        ),
        PtDossierStatus.expired,
      );
    });

    test('not purchased when there is no PT history', () {
      expect(
        ptDossierStatus(const MemberPtSummary()),
        PtDossierStatus.notPurchased,
      );
      expect(ptDossierStatus(null), PtDossierStatus.notPurchased);
    });
  });

  group('MemberPtSummary.lastEnded', () {
    test('returns null when current subscription is present', () {
      final summary = MemberPtSummary(
        current: sub(PtSubscriptionStatus.active),
        history: [sub(PtSubscriptionStatus.completed)],
      );
      expect(summary.lastEnded, isNull);
    });

    test(
      'returns more recent cancelled subscription over older completed subscription',
      () {
        final olderCompleted = PtSubscription(
          id: 1,
          memberId: 42,
          ptProductId: 3,
          trainerId: 7,
          startDate: DateTime(2026, 8, 1),
          endDate: DateTime(2026, 8, 31),
          weekdays: const [1, 3, 5],
          slotStart: '17:00:00',
          status: PtSubscriptionStatus.completed,
          rowVersion: 1,
          productName: 'Old PT',
          sessionsPerWeek: 3,
          trainerName: 'Bob',
          slotLabel: '17:00-18:00',
        );
        final recentCancelled = PtSubscription(
          id: 2,
          memberId: 42,
          ptProductId: 3,
          trainerId: 8,
          startDate: DateTime(2026, 9, 1),
          endDate: DateTime(2026, 9, 30),
          weekdays: const [1, 3, 5],
          slotStart: '18:00:00',
          status: PtSubscriptionStatus.cancelled,
          rowVersion: 1,
          productName: 'Recent PT',
          sessionsPerWeek: 3,
          trainerName: 'Alice',
          slotLabel: '18:00-19:00',
        );

        final summary = MemberPtSummary(
          history: [recentCancelled, olderCompleted],
        );
        expect(summary.lastEnded, equals(recentCancelled));

        final summaryReversed = MemberPtSummary(
          history: [olderCompleted, recentCancelled],
        );
        expect(summaryReversed.lastEnded, equals(recentCancelled));
      },
    );
  });

  group('canSellMembership', () {
    test('admin with memberships.create can sell', () {
      expect(
        canSellMembership(userType: UserType.admin, canCreateMembership: true),
        isTrue,
      );
    });

    test('blocked for trainers and without the capability', () {
      expect(
        canSellMembership(
          userType: UserType.trainer,
          canCreateMembership: true,
        ),
        isFalse,
      );
      expect(
        canSellMembership(userType: UserType.admin, canCreateMembership: false),
        isFalse,
      );
    });
  });

  group('canSellPt', () {
    bool sell({
      UserType userType = UserType.admin,
      bool canCreatePt = true,
      Membership? m,
      MemberPtSummary? pt = const MemberPtSummary(),
    }) => canSellPt(
      userType: userType,
      canCreatePt: canCreatePt,
      membership: m,
      pt: pt,
      now: now,
    );

    test('admin with permission, active unexpired membership, no PT', () {
      expect(sell(m: membership(endDate: DateTime(2026, 12, 31))), isTrue);
    });

    test('membership ending today still counts as not expired', () {
      expect(sell(m: membership(endDate: now)), isTrue);
    });

    test('blocked when membership has expired or is missing', () {
      expect(sell(m: membership(endDate: DateTime(2026, 9, 30))), isFalse);
      expect(
        sell(
          m: membership(
            status: MembershipStatus.frozen,
            endDate: DateTime(2026, 12, 31),
          ),
        ),
        isFalse,
      );
      expect(sell(m: null), isFalse);
    });

    test('blocked while another PT is scheduled or active (one at a time)', () {
      expect(
        sell(
          m: membership(endDate: DateTime(2026, 12, 31)),
          pt: MemberPtSummary(current: sub(PtSubscriptionStatus.active)),
        ),
        isFalse,
      );
    });

    test('blocked for trainers and without the capability', () {
      final m = membership(endDate: DateTime(2026, 12, 31));
      expect(sell(userType: UserType.trainer, m: m), isFalse);
      expect(sell(canCreatePt: false, m: m), isFalse);
    });
  });

  test('trainerHubReadOnly follows trainer access', () {
    expect(
      trainerHubReadOnly(
        const MemberPtSummary(trainerAccess: TrainerAccess.readOnly),
      ),
      isTrue,
    );
    expect(
      trainerHubReadOnly(
        const MemberPtSummary(trainerAccess: TrainerAccess.full),
      ),
      isFalse,
    );
    expect(trainerHubReadOnly(null), isFalse);
  });

  group('formatDaysRelative', () {
    test('formats days left', () {
      expect(
        formatDaysRelative(DateTime(2026, 10, 11), now: now),
        '(10 days left)',
      );
    });

    test('formats expires today', () {
      expect(formatDaysRelative(now, now: now), '(expires today)');
    });

    test('formats expired days ago', () {
      expect(
        formatDaysRelative(DateTime(2026, 9, 28), now: now),
        '(expired 3 days ago)',
      );
    });
  });
}
