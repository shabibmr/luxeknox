import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/payment_methods_cubit.dart';
import '../payment_strings.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentMethodsCubit>()..load(),
      child: const _PaymentMethodsBody(),
    );
  }
}

class _PaymentMethodsBody extends StatelessWidget {
  const _PaymentMethodsBody();

  Future<void> _showCreateDialog(BuildContext context) async {
    if (!context.can('payments.create')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(PaymentStrings.noPermission)),
      );
      return;
    }

    final nameController = TextEditingController();
    var isDigital = false;
    var isActive = true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(PaymentStrings.createMethodTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: PaymentStrings.methodNameLabel,
                    ),
                    autofocus: true,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(PaymentStrings.isDigitalLabel),
                    value: isDigital,
                    onChanged: (v) => setState(() => isDigital = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(PaymentStrings.isActiveLabel),
                    value: isActive,
                    onChanged: (v) => setState(() => isActive = v),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text(PaymentStrings.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text(PaymentStrings.create),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      nameController.dispose();
      return;
    }

    final name = nameController.text.trim();
    nameController.dispose();
    if (name.isEmpty) return;

    await context.read<PaymentMethodsCubit>().createMethod(
      name,
      isDigital: isDigital,
      isActive: isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = context.can('payments.create');

    return Scaffold(
      appBar: AppBar(title: const Text(PaymentStrings.methodsTitle)),
      floatingActionButton: canCreate
          ? FloatingActionButton(
              tooltip: PaymentStrings.addMethodTooltip,
              onPressed: () => _showCreateDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
        listenWhen: (previous, next) =>
            next.failure != previous.failure &&
            next.failure != null &&
            next.items.isNotEmpty &&
            next.status != LoadStatus.failure,
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
        },
        builder: (context, state) {
          if (state.status == LoadStatus.loading && state.items.isEmpty) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && state.items.isEmpty) {
            return AppErrorView(
              message: state.failure == null
                  ? ''
                  : failureMessage(state.failure!),
              onRetry: () => context.read<PaymentMethodsCubit>().load(),
            );
          }
          final items = state.items;
          final creating = state.creating;
          if (items.isEmpty) {
            return Stack(
              children: [
                const AppEmptyView(message: PaymentStrings.noneFound),
                if (creating)
                  const Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(),
                  ),
              ],
            );
          }
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => context.read<PaymentMethodsCubit>().load(),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final method = items[index];
                    return ListTile(
                      title: Text(method.methodName),
                      subtitle: Text(
                        [
                          if (method.isDigital) PaymentStrings.digitalBadge,
                          if (!method.isActive) PaymentStrings.inactiveBadge,
                        ].join(' · '),
                      ),
                      trailing: Icon(
                        method.isActive
                            ? Icons.check_circle_outline
                            : Icons.block_outlined,
                      ),
                    );
                  },
                ),
              ),
              if (creating)
                const Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }
}
