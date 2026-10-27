import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/pt_product.dart';
import '../../domain/entities/pt_subscription.dart';
import '../cubit/sell_pt_cubit.dart';
import '../pt_strings.dart';
import '../widgets/sell_pt_replan_form.dart';
import '../widgets/sell_pt_sale_form.dart';

/// "Add Personal Training" for a member. With [replanning] set, the same
/// screen changes trainer and/or slot of an existing PT.
///
/// The loaded body is exactly one of [SellPtSaleForm] or [SellPtReplanForm].
class SellPtScreen extends StatelessWidget {
  const SellPtScreen({
    super.key,
    required this.memberId,
    this.memberName,
    this.replanning,
    this.products,
  });

  final int memberId;
  final String? memberName;
  final PtSubscription? replanning;
  final List<PtProduct>? products;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<SellPtCubit>();
        if (replanning != null && products != null) {
          cubit.initReplan(replanning!, products!, memberName: memberName);
        } else {
          cubit.init(memberId, memberName: memberName);
        }
        return cubit;
      },
      child: _SellPtView(memberId: memberId),
    );
  }
}

class _SellPtView extends StatelessWidget {
  const _SellPtView({required this.memberId});

  final int memberId;

  void _onBack(BuildContext context, int id) {
    if (context.canPop()) {
      context.pop();
    } else if (id > 0) {
      context.go(Routes.adminMembersDetailById(id));
    } else {
      context.go(Routes.adminMembers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellPtCubit, SellPtState>(
      listenWhen: (a, b) => a.result != b.result || a.failure != b.failure,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.result != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                state.isReplan ? PtStrings.replanned : PtStrings.sold,
              ),
            ),
          );
          if (context.canPop()) {
            context.pop(true);
          } else {
            Navigator.of(context).maybePop(true);
          }
        } else if (state.failure != null &&
            state.status == LoadStatus.success &&
            // A grid failure is already shown inline with a retry button.
            state.gridStatus != LoadStatus.failure) {
          messenger.showSnackBar(
            SnackBar(content: Text(failureMessage(state.failure!))),
          );
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final effectiveMemberId = state.memberId > 0
            ? state.memberId
            : memberId;
        final displayName = state.memberName ?? state.member?.fullName;
        void onBack() => _onBack(context, effectiveMemberId);

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: onBack),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.isReplan ? PtStrings.replanTitle : PtStrings.sellTitle,
                ),
                if (displayName != null && displayName.isNotEmpty)
                  Text(
                    'For $displayName',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          body: switch (state.status) {
            LoadStatus.initial || LoadStatus.loading => const AppLoading(),
            LoadStatus.failure => AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: context.read<SellPtCubit>().retry,
            ),
            LoadStatus.success =>
              state.isReplan
                  ? SellPtReplanForm(state: state, onBack: onBack)
                  : SellPtSaleForm(state: state, onBack: onBack),
          },
        );
      },
    );
  }
}
