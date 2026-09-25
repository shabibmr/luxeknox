import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/health_info.dart';
import '../../domain/usecases/get_health_info_usecase.dart';
import '../../domain/usecases/update_health_info_usecase.dart';
import '../cubit/health_info_cubit.dart';
import '../people_strings.dart';

class HealthInfoScreen extends StatelessWidget {
  const HealthInfoScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HealthInfoCubit(
        getIt<GetHealthInfoUseCase>(),
        getIt<UpdateHealthInfoUseCase>(),
      )..load(memberId),
      child: _HealthInfoBody(memberId: memberId),
    );
  }
}

class _HealthInfoBody extends StatelessWidget {
  const _HealthInfoBody({required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.health)),
      body: BlocConsumer<HealthInfoCubit, HealthInfoState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(PeopleStrings.healthSaved)),
            );
          } else if (state.status == LoadStatus.failure &&
              state.info != null &&
              state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          if (state.info == null && state.status == LoadStatus.failure) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<HealthInfoCubit>().load(memberId),
            );
          }
          final info = state.info;
          if (info == null) {
            return const AppLoading();
          }
          return _HealthForm(info: info);
        },
      ),
    );
  }
}

class _HealthForm extends StatefulWidget {
  const _HealthForm({required this.info});

  final HealthInfo info;

  @override
  State<_HealthForm> createState() => _HealthFormState();
}

class _HealthFormState extends State<_HealthForm> {
  late final _blood = TextEditingController(text: widget.info.bloodGroup);
  late final _height = TextEditingController(
    text: widget.info.heightCm?.toString() ?? '',
  );
  late final _weight = TextEditingController(
    text: widget.info.baselineWeightKg?.toString() ?? '',
  );
  late final _allergies = TextEditingController(text: widget.info.allergies);
  late final _diet = TextEditingController(
    text: widget.info.dietaryPreferences,
  );
  late final _physician = TextEditingController(
    text: widget.info.physicianName,
  );
  late final _physicianPhone = TextEditingController(
    text: widget.info.physicianPhone,
  );

  @override
  void dispose() {
    _blood.dispose();
    _height.dispose();
    _weight.dispose();
    _allergies.dispose();
    _diet.dispose();
    _physician.dispose();
    _physicianPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _blood,
          decoration: const InputDecoration(
            labelText: PeopleStrings.bloodGroup,
          ),
        ),
        TextField(
          controller: _height,
          decoration: const InputDecoration(labelText: PeopleStrings.heightCm),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _weight,
          decoration: const InputDecoration(labelText: PeopleStrings.weightKg),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _allergies,
          decoration: const InputDecoration(labelText: PeopleStrings.allergies),
          maxLines: 2,
        ),
        TextField(
          controller: _diet,
          decoration: const InputDecoration(
            labelText: PeopleStrings.dietaryPreferences,
          ),
          maxLines: 2,
        ),
        TextField(
          controller: _physician,
          decoration: const InputDecoration(
            labelText: PeopleStrings.physicianName,
          ),
        ),
        TextField(
          controller: _physicianPhone,
          decoration: const InputDecoration(
            labelText: PeopleStrings.physicianPhone,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            context.read<HealthInfoCubit>().save(
              widget.info.copyWith(
                bloodGroup: _optional(_blood.text),
                heightCm: double.tryParse(_height.text.trim()),
                baselineWeightKg: double.tryParse(_weight.text.trim()),
                allergies: _optional(_allergies.text),
                dietaryPreferences: _optional(_diet.text),
                physicianName: _optional(_physician.text),
                physicianPhone: _optional(_physicianPhone.text),
              ),
            );
          },
          child: const Text(PeopleStrings.save),
        ),
      ],
    );
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
