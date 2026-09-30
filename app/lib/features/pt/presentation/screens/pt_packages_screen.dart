import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/pt_product.dart';
import '../cubit/pt_packages_cubit.dart';
import '../pt_strings.dart';

/// Admin catalog of Personal Training packages.
class PtPackagesScreen extends StatelessWidget {
  const PtPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PtPackagesCubit>()..load(),
      child: const _PtPackagesView(),
    );
  }
}

class _PtPackagesView extends StatelessWidget {
  const _PtPackagesView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PtPackagesCubit, PtPackagesState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.message == 'saved') {
          messenger.showSnackBar(
            const SnackBar(content: Text(PtStrings.saved)),
          );
        } else if (state.failure != null &&
            state.status == LoadStatus.success) {
          messenger.showSnackBar(
            SnackBar(content: Text(failureMessage(state.failure!))),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text(PtStrings.packagesTitle)),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openForm(context, null),
            icon: const Icon(Icons.add),
            label: const Text(PtStrings.newPackage),
          ),
          body: switch (state.status) {
            LoadStatus.initial ||
            LoadStatus.loading when state.items.isEmpty => const AppLoading(),
            LoadStatus.failure when state.items.isEmpty => AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: context.read<PtPackagesCubit>().load,
            ),
            _ when state.items.isEmpty => const AppEmptyView(
              message: PtStrings.noPackages,
            ),
            _ => ListView.separated(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = state.items[i];
                return ListTile(
                  title: Text('${p.name} (${p.code})'),
                  subtitle: Text(
                    '${p.sessionsPerWeek}×/week · ${p.durationDays} days · ${p.basePrice}'
                    '${p.isActive ? '' : ' · ${PtStrings.archived}'}',
                  ),
                  trailing: Switch(
                    value: p.isActive,
                    onChanged: (v) =>
                        context.read<PtPackagesCubit>().setActive(p, v),
                  ),
                  onTap: () => _openForm(context, p),
                );
              },
            ),
          },
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, PtProduct? product) async {
    final cubit = context.read<PtPackagesCubit>();
    await showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _PtPackageForm(product: product),
      ),
    );
  }
}

class _PtPackageForm extends StatefulWidget {
  const _PtPackageForm({this.product});

  final PtProduct? product;

  @override
  State<_PtPackageForm> createState() => _PtPackageFormState();
}

class _PtPackageFormState extends State<_PtPackageForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.product?.name);
  late final _code = TextEditingController(text: widget.product?.code);
  late final _description = TextEditingController(
    text: widget.product?.description,
  );
  late final _duration = TextEditingController(
    text: widget.product?.durationDays.toString(),
  );
  late final _sessions = TextEditingController(
    text: widget.product?.sessionsPerWeek.toString(),
  );
  late final _price = TextEditingController(text: widget.product?.basePrice);
  late final _tax = TextEditingController(text: widget.product?.taxPercentage);

  static final _money = RegExp(r'^\d+\.\d{2}$');

  @override
  void dispose() {
    for (final c in [
      _name,
      _code,
      _description,
      _duration,
      _sessions,
      _price,
      _tax,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? PtStrings.required : null;

  String? _int(String? v, {int min = 1, int? max}) {
    final n = int.tryParse(v?.trim() ?? '');
    if (n == null) return PtStrings.invalidNumber;
    if (n < min || (max != null && n > max)) {
      return max != null ? PtStrings.sessionsRange : PtStrings.invalidNumber;
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final base = PtProduct(
      id: widget.product?.id ?? 0,
      name: _name.text.trim(),
      code: _code.text.trim(),
      description: _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      durationDays: int.parse(_duration.text.trim()),
      sessionsPerWeek: int.parse(_sessions.text.trim()),
      basePrice: _price.text.trim(),
      taxPercentage: _tax.text.trim().isEmpty ? null : _tax.text.trim(),
      isActive: widget.product?.isActive ?? true,
    );
    final ok = await context.read<PtPackagesCubit>().save(base);
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.select<PtPackagesCubit, bool>((c) => c.state.saving);
    return AlertDialog(
      title: Text(
        widget.product == null ? PtStrings.newPackage : PtStrings.editPackage,
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: PtStrings.name),
                  validator: _required,
                ),
                TextFormField(
                  controller: _code,
                  decoration: const InputDecoration(labelText: PtStrings.code),
                  validator: _required,
                ),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(
                    labelText: PtStrings.description,
                  ),
                  maxLines: 2,
                ),
                TextFormField(
                  controller: _duration,
                  decoration: const InputDecoration(
                    labelText: PtStrings.durationDays,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => _int(v),
                ),
                TextFormField(
                  controller: _sessions,
                  decoration: const InputDecoration(
                    labelText: PtStrings.sessionsPerWeek,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => _int(v, max: 7),
                ),
                TextFormField(
                  controller: _price,
                  decoration: const InputDecoration(labelText: PtStrings.price),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) => _money.hasMatch(v?.trim() ?? '')
                      ? null
                      : PtStrings.invalidMoney,
                ),
                TextFormField(
                  controller: _tax,
                  decoration: const InputDecoration(
                    labelText: PtStrings.taxPercentage,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) =>
                      (v == null ||
                          v.trim().isEmpty ||
                          _money.hasMatch(v.trim()))
                      ? null
                      : PtStrings.invalidMoney,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(PtStrings.cancel),
        ),
        FilledButton(
          onPressed: saving ? null : _submit,
          child: const Text(PtStrings.save),
        ),
      ],
    );
  }
}
