import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../cubit/dashboard_agenda_cubit.dart';
import '../cubit/dashboard_cubit.dart';
import '../dashboard_strings.dart';
import '../widgets/dashboard_admin_section.dart';
import '../widgets/dashboard_agenda_section.dart';
import '../widgets/dashboard_member_section.dart';
import '../widgets/dashboard_skeleton.dart';
import '../widgets/dashboard_trainer_section.dart';

/// Home screen for all three role shells (member/trainer/admin). The
/// `GET /dashboard` response is role-scoped server-side, so a single screen
/// simply renders whichever of `member`/`trainer`/`admin` is present.
///
/// Agenda (today + next 7 days) loads independently via [DashboardAgendaCubit]
/// so its loading/error states never blank the membership/overview cards.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<DashboardCubit>()..load()),
        BlocProvider(
          create: (context) {
            final agenda = getIt<DashboardAgendaCubit>();
            final session = context.read<SessionCubit>().state;
            if (session is SessionAuthenticated) {
              final role = session.principal.userType;
              if (role == UserType.member || role == UserType.trainer) {
                agenda.load(role: role, profileId: session.principal.profileId);
              }
            }
            return agenda;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text(DashboardStrings.title)),
        body: const _DashboardBody(),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  Future<void> _onRefresh(BuildContext context) {
    return Future.wait([
      context.read<DashboardCubit>().refresh(),
      context.read<DashboardAgendaCubit>().refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((DashboardCubit c) => c.state.status);

    if (status == DashboardStatus.loading ||
        status == DashboardStatus.initial) {
      return const DashboardSkeleton();
    }

    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _DashboardLoadErrorBanner(),
          _StaleDataBanner(),
          _MemberSection(),
          _MemberQuickActions(),
          _TrainerSection(),
          DashboardAgendaSection(),
          _AdminSection(),
          _EmptyNotice(),
        ],
      ),
    );
  }
}

class _DashboardLoadErrorBanner extends StatelessWidget {
  const _DashboardLoadErrorBanner();

  @override
  Widget build(BuildContext context) {
    final showError = context.select(
      (DashboardCubit c) =>
          c.state.status == DashboardStatus.failure && !c.state.hasData,
    );
    if (!showError) return const SizedBox.shrink();

    final failure = context.select((DashboardCubit c) => c.state.failure);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.cloud_off_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  failure == null
                      ? DashboardStrings.dashboardError
                      : failureMessage(failure),
                ),
              ),
              TextButton(
                onPressed: () => context.read<DashboardCubit>().load(),
                child: const Text(DashboardStrings.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton();

  @override
  Widget build(BuildContext context) {
    final role = context.select<SessionCubit, UserType?>((cubit) {
      final state = cubit.state;
      return state is SessionAuthenticated ? state.principal.userType : null;
    });

    final path = switch (role) {
      UserType.member => Routes.memberNotifications,
      UserType.trainer => Routes.trainerNotifications,
      _ => null,
    };

    if (path == null) return const SizedBox.shrink();

    return IconButton(
      tooltip: DashboardStrings.notifications,
      onPressed: () => context.go(path),
      icon: const Icon(Icons.notifications_none),
    );
  }
}

class _MemberQuickActions extends StatelessWidget {
  const _MemberQuickActions();

  @override
  Widget build(BuildContext context) {
    final role = context.select<SessionCubit, UserType?>((cubit) {
      final state = cubit.state;
      return state is SessionAuthenticated ? state.principal.userType : null;
    });
    if (role != UserType.member) return const SizedBox.shrink();

    final actions = [
      (Icons.calendar_month_outlined, DashboardStrings.schedule, Routes.memberSchedule),
      (Icons.event_available_outlined, DashboardStrings.attendance, Routes.memberProfileAttendanceSummary),
      (Icons.fitness_center_outlined, DashboardStrings.workout, Routes.memberHomeWorkoutActive),
      (Icons.restaurant_outlined, DashboardStrings.diet, Routes.memberHomeDietLog),
      (Icons.trending_up_outlined, DashboardStrings.progress, Routes.memberProgress),
      (Icons.payments_outlined, DashboardStrings.payments, Routes.memberProfilePayments),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final action in actions)
                ActionChip(
                  avatar: Icon(action.$1, size: 18),
                  label: Text(action.$2),
                  onPressed: () => context.go(action.$3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaleDataBanner extends StatelessWidget {
  const _StaleDataBanner();

  @override
  Widget build(BuildContext context) {
    final showBanner = context.select(
      (DashboardCubit c) =>
          c.state.status == DashboardStatus.failure && c.state.hasData,
    );
    if (!showBanner) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        DashboardStrings.staleDataNotice,
        style: TextStyle(color: Colors.orange),
      ),
    );
  }
}

// Each section below uses BlocSelector so a change to one part of the
// snapshot never rebuilds the others (rebuild optimization).
class _MemberSection extends StatelessWidget {
  const _MemberSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DashboardCubit, DashboardState, DashboardMemberWidget?>(
      selector: (state) => state.snapshot?.member,
      builder: (context, member) {
        if (member == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DashboardMemberSection(data: member),
        );
      },
    );
  }
}

class _TrainerSection extends StatelessWidget {
  const _TrainerSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      DashboardCubit,
      DashboardState,
      DashboardTrainerWidget?
    >(
      selector: (state) => state.snapshot?.trainer,
      builder: (context, trainer) {
        if (trainer == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DashboardTrainerSection(data: trainer),
        );
      },
    );
  }
}

class _AdminSection extends StatelessWidget {
  const _AdminSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DashboardCubit, DashboardState, DashboardAdminWidget?>(
      selector: (state) => state.snapshot?.admin,
      builder: (context, admin) {
        if (admin == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DashboardAdminSection(data: admin),
        );
      },
    );
  }
}

class _EmptyNotice extends StatelessWidget {
  const _EmptyNotice();

  @override
  Widget build(BuildContext context) {
    final isEmpty = context.select(
      (DashboardCubit c) => c.state.snapshot?.isEmpty ?? false,
    );
    if (!isEmpty) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.only(top: 32),
      child: Center(child: Text(DashboardStrings.empty)),
    );
  }
}

