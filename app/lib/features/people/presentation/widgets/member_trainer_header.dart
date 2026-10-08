import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/get_trainer_usecase.dart';

/// Shows "Member: X · Trainer: Y" at the top of Goal/Workout/Diet editor
/// pages, so it's always clear which member and trainer an edit applies to.
class MemberTrainerHeader extends StatefulWidget {
  const MemberTrainerHeader({super.key, required this.memberId});

  /// Numeric member id as a string; a blank/unparsable id renders nothing.
  final String memberId;

  @override
  State<MemberTrainerHeader> createState() => _MemberTrainerHeaderState();
}

class _MemberTrainerHeaderState extends State<MemberTrainerHeader> {
  bool _loading = true;
  String? _memberName;
  String? _trainerName;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(MemberTrainerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memberId != widget.memberId) _load();
  }

  Future<void> _load() async {
    final id = int.tryParse(widget.memberId.trim());
    if (id == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    final memberResult = await getIt<GetMemberUseCase>()(id);
    final person = memberResult.fold((_) => null, (p) => p);
    String? trainerName;
    final trainerId = person?.assignedTrainerId;
    if (trainerId != null) {
      final trainerResult = await getIt<GetTrainerUseCase>()(trainerId);
      trainerName = trainerResult.fold((_) => null, (t) => t.fullName);
    }
    if (!mounted) return;
    setState(() {
      _memberName = person?.fullName;
      _trainerName = trainerName;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (int.tryParse(widget.memberId.trim()) == null) {
      return const SizedBox.shrink();
    }
    // No outer padding/margin — callers place this inline with their own
    // list/column spacing.
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: _loading
            ? const SizedBox(
                height: 16,
                child: LinearProgressIndicator(minHeight: 2),
              )
            : Row(
                children: [
                  const Icon(Icons.person_outline, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Member: ${_memberName ?? '—'}   ·   '
                      'Trainer: ${_trainerName ?? 'Unassigned'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
