import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../membership/domain/entities/membership_product.dart';
import '../../../membership/domain/usecases/get_membership_products_usecase.dart';
import '../../../people/domain/entities/trainer_summary.dart';
import '../../../scheduling/presentation/widgets/trainer_picker_field.dart';
import '../../domain/entities/app_report_type.dart';
import '../report_strings.dart';

class ReportFiltersBar extends StatefulWidget {
  const ReportFiltersBar({
    super.key,
    required this.type,
    required this.productId,
    required this.trainerId,
    required this.onApply,
    this.lockTrainerId = false,
  });

  final AppReportType type;
  final String? productId;
  final String? trainerId;
  final bool lockTrainerId;
  final void Function({String? productId, String? trainerId}) onApply;

  @override
  State<ReportFiltersBar> createState() => _ReportFiltersBarState();
}

class _ReportFiltersBarState extends State<ReportFiltersBar> {
  late final TextEditingController _product;
  late final TextEditingController _trainer;
  List<MembershipProduct> _products = [];
  TrainerSummary? _selectedTrainer;

  @override
  void initState() {
    super.initState();
    _product = TextEditingController(text: widget.productId ?? '');
    _trainer = TextEditingController(text: widget.trainerId ?? '');
    _loadProducts();
  }

  void _loadProducts() {
    if (getIt.isRegistered<GetMembershipProductsUseCase>()) {
      getIt<GetMembershipProductsUseCase>()(
        const GetMembershipProductsParams(),
      ).then((res) {
        if (!mounted) return;
        res.fold((_) {}, (page) {
          setState(() => _products = page.items);
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant ReportFiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _product.text = widget.productId ?? '';
    }
    if (oldWidget.trainerId != widget.trainerId) {
      _trainer.text = widget.trainerId ?? '';
    }
  }

  @override
  void dispose() {
    _product.dispose();
    _trainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showProduct = widget.type.showsProductFilter;
    final showTrainer = widget.type.showsTrainerFilter && !widget.lockTrainerId;
    if (!showProduct && !showTrainer) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ReportStrings.filtersTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (showProduct) ...[
          if (_products.isNotEmpty)
            DropdownButtonFormField<String>(
              initialValue:
                  _product.text.isNotEmpty &&
                      _products.any((p) => p.id == _product.text)
                  ? _product.text
                  : null,
              decoration: const InputDecoration(
                labelText: ReportStrings.productIdLabel,
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: '', child: Text('All Packages')),
                ..._products.map(
                  (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                ),
              ],
              onChanged: (v) => setState(() => _product.text = v ?? ''),
            ),
          const SizedBox(height: 8),
        ],
        if (showTrainer) ...[
          TrainerPickerField(
            value: _selectedTrainer,
            onChanged: (t) {
              setState(() {
                _selectedTrainer = t;
                _trainer.text = t?.id.toString() ?? '';
              });
            },
          ),
          const SizedBox(height: 8),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: () => widget.onApply(
              productId: _product.text.trim().isEmpty
                  ? null
                  : _product.text.trim(),
              trainerId: _trainer.text.trim().isEmpty
                  ? null
                  : _trainer.text.trim(),
            ),
            child: const Text(ReportStrings.apply),
          ),
        ),
      ],
    );
  }
}
