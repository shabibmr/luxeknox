import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../cubit/dashboard_cubit.dart';
import '../dashboard_strings.dart';
import '../widgets/dashboard_admin_section.dart';
import '../widgets/dashboard_member_section.dart';
import '../widgets/dashboard_skeleton.dart';
import '../widgets/dashboard_trainer_section.dart';

/// Home screen for all three role shells (member/trainer/admin). The
/// `GET /dashboard` response is role-scoped server-side, so a single screen
/// simply renders whichever of `member`/`trainer`/`admin` is present.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text(DashboardStrings.title)),
        body: const _DashboardBody(),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final status = context.select((DashboardCubit c) => c.state.status);

    if (status == DashboardStatus.loading ||
        status == DashboardStatus.initial) {
      return const DashboardSkeleton();
    }

    final hasData = context.select((DashboardCubit c) => c.state.hasData);
    if (status == DashboardStatus.failure && !hasData) {
      final failure = context.select((DashboardCubit c) => c.state.failure);
      return _ErrorView(
        message: failure == null
            ? DashboardStrings.empty
            : failureMessage(failure),
        onRetry: () => context.read<DashboardCubit>().load(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<DashboardCubit>().refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StaleDataBanner(),
          _MemberSection(),
          _TrainerSection(),
          _AdminSection(),
          _EmptyNotice(),
        ],
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: const Text(DashboardStrings.retry),
          ),
        ],
      ),
    );
  }
}
