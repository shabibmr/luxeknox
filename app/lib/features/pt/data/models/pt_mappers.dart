import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';

import '../../../membership/data/models/membership_date.dart';
import '../../domain/entities/pt_product.dart';
import '../../domain/entities/pt_schedule_grid.dart';
import '../../domain/entities/pt_subscription.dart';

extension PtProductApiX on api.PtProduct {
  PtProduct toDomain() => PtProduct(
    id: id,
    name: name,
    code: code,
    description: description,
    durationDays: durationDays,
    basePrice: basePrice,
    taxPercentage: taxPercentage,
    isActive: isActive,
  );
}

extension PtProductDomainX on PtProduct {
  api.PtProductWrite toWriteModel() => api.PtProductWrite(
    (b) => b
      ..name = name
      ..code = code
      ..description = description
      ..durationDays = durationDays
      ..basePrice = basePrice
      ..taxPercentage = taxPercentage
      ..isActive = isActive,
  );
}

extension PtSubscriptionApiX on api.PtSubscription {
  PtSubscription toDomain() => PtSubscription(
    id: id,
    memberId: memberId,
    ptProductId: ptProductId,
    trainerId: trainerId,
    startDate: apiDateToDateTime(startDate),
    endDate: apiDateToDateTime(endDate),
    weekdays: weekdays.toList(),
    slotStart: slotStart,
    status: PtSubscriptionStatus.values.byName(status.name),
    rowVersion: rowVersion,
    productName: productName,
    sessionsPerWeek: sessionsPerWeek,
    trainerName: trainerName,
    slotLabel: slotLabel,
  );
}

extension MemberPtSummaryApiX on api.MemberPtSummary {
  MemberPtSummary toDomain() => MemberPtSummary(
    current: current?.toDomain(),
    history: history.map((s) => s.toDomain()).toList(),
    trainerAccess: switch (trainerAccess) {
      api.MemberPtSummaryTrainerAccessEnum.full => TrainerAccess.full,
      api.MemberPtSummaryTrainerAccessEnum.readOnly => TrainerAccess.readOnly,
      _ => null,
    },
  );
}

extension PtScheduleGridApiX on api.PtScheduleGrid {
  PtScheduleGrid toDomain() => PtScheduleGrid(
    startDate: apiDateToDateTime(startDate),
    endDate: apiDateToDateTime(endDate),
    weekdays: weekdays.toList(),
    hours: hours.toList(),
    trainers: trainers
        .map((t) => PtGridTrainer(id: t.id, name: t.name))
        .toList(),
    cells: cells
        .map(
          (c) => PtGridCell(
            trainerId: c.trainerId,
            slotStart: c.slotStart,
            status: PtGridCellStatus.values.byName(c.status.name),
            occupiedBy: c.occupiedBy,
            conflictDates: c.conflictDates.map(apiDateToDateTime).toList(),
          ),
        )
        .toList(),
  );
}

ListBuilder<int> weekdaysBuilder(List<int> weekdays) =>
    ListBuilder<int>([...weekdays]..sort());
