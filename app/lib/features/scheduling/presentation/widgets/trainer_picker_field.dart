import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../people/domain/entities/trainer_summary.dart';
import '../../../people/domain/usecases/list_trainers_usecase.dart';
import '../scheduling_strings.dart';

/// Form field that opens a searchable, paged picker over `GET /trainers`
/// (F2.1). Unlike [FacilityPickerField]/[ScheduleTypePickerField], trainers
/// are paged server-side, so selection happens in a modal search sheet
/// instead of an inline dropdown.
class TrainerPickerField extends StatelessWidget {
  const TrainerPickerField({
    super.key,
    required this.onChanged,
    this.value,
    this.listTrainers,
    this.errorText,
    this.enabled = true,
  });

  /// The currently selected trainer, or `null` for none selected.
  final TrainerSummary? value;

  final ValueChanged<TrainerSummary?> onChanged;

  /// External validation error (e.g. "Required"), shown under the field.
  final String? errorText;

  final bool enabled;

  /// Test seam; defaults to the DI-registered [ListTrainersUseCase].
  final ListTrainersUseCase? listTrainers;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('trainer_picker_field'),
      onTap: enabled ? () => _openPicker(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: SchedulingStrings.trainerFieldLabel,
          errorText: errorText,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          value?.fullName ?? SchedulingStrings.trainerFieldPlaceholder,
          style: value == null
              ? Theme.of(context).inputDecorationTheme.hintStyle
              : null,
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<TrainerSummary?>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TrainerSearchSheet(
        listTrainers: listTrainers ?? getIt<ListTrainersUseCase>(),
      ),
    );
    if (selected != null) {
      onChanged(selected);
    }
  }
}

class _TrainerSearchSheet extends StatefulWidget {
  const _TrainerSearchSheet({required this.listTrainers});

  final ListTrainersUseCase listTrainers;

  @override
  State<_TrainerSearchSheet> createState() => _TrainerSearchSheetState();
}

class _TrainerSearchSheetState extends State<_TrainerSearchSheet> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  String? _query;
  String? _nextCursor;
  bool _hasMore = false;
  List<TrainerSummary> _trainers = const [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _load(query: value.trim().isEmpty ? null : value.trim());
    });
  }

  Future<void> _load({String? query}) async {
    setState(() {
      _loading = true;
      _error = null;
      _query = query;
    });
    final result = await widget.listTrainers(
      ListTrainersParams(query: query),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
      }),
      (page) => setState(() {
        _loading = false;
        _trainers = page.items;
        _nextCursor = page.nextCursor;
        _hasMore = page.hasMore;
      }),
    );
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    final result = await widget.listTrainers(
      ListTrainersParams(query: _query, cursor: _nextCursor),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() => _loadingMore = false),
      (page) => setState(() {
        _loadingMore = false;
        _trainers = [..._trainers, ...page.items];
        _nextCursor = page.nextCursor;
        _hasMore = page.hasMore;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  key: const Key('trainer_search_field'),
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: SchedulingStrings.trainerSearchHint,
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: TextButton(
          onPressed: () => _load(query: _query),
          child: Text(_error!),
        ),
      );
    }
    if (_trainers.isEmpty) {
      return const Center(
        child: Text(SchedulingStrings.trainerFieldEmpty),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: _trainers.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _trainers.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final trainer = _trainers[index];
        return ListTile(
          key: Key('trainer_option_${trainer.id}'),
          title: Text(trainer.fullName),
          subtitle: trainer.specializations.isEmpty
              ? null
              : Text(trainer.specializations.join(', ')),
          onTap: () => Navigator.of(context).pop(trainer),
        );
      },
    );
  }
}
