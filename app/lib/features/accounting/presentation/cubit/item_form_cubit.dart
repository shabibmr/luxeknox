import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/tax_code.dart';
import '../../domain/usecases/create_item_usecase.dart';
import '../../domain/usecases/get_account_usecase.dart';
import '../../domain/usecases/get_item_usecase.dart';
import '../../domain/usecases/get_tax_codes_usecase.dart';
import '../../domain/usecases/update_item_usecase.dart';
import '../accounting_strings.dart';

const Object _keep = Object();

/// Account ids the tracking toggle defaults to (inventory asset and COGS).
const String defaultInventoryAccountId = '1400';
const String defaultCogsAccountId = '5050';

class ItemFormState extends Equatable {
  const ItemFormState({
    this.item,
    this.loading = false,
    this.kind = 'goods',
    this.name = '',
    this.sku = '',
    this.hsnSac = '',
    this.categoryId,
    this.uom,
    this.saleRate = '',
    this.purchaseRate = '',
    this.taxCodeId,
    this.taxCodes = const [],
    this.incomeAccount,
    this.expenseAccount,
    this.inventoryTracked = false,
    this.inventoryAccount,
    this.cogsAccount,
    this.reorderLevel = '',
    this.isActive = true,
    this.isSubmitting = false,
    this.failure,
    this.savedItem,
    this.errors = const {},
  });

  /// The item being edited; null in create mode.
  final Item? item;
  final bool loading;
  final String kind;
  final String name;
  final String sku;
  final String hsnSac;
  final int? categoryId;
  final Uom? uom;
  final String saleRate;
  final String purchaseRate;
  final int? taxCodeId;
  final List<TaxCode> taxCodes;
  final Account? incomeAccount;
  final Account? expenseAccount;
  final bool inventoryTracked;
  final Account? inventoryAccount;
  final Account? cogsAccount;
  final String reorderLevel;
  final bool isActive;
  final bool isSubmitting;
  final Failure? failure;
  final Item? savedItem;

  /// Field key -> message. Keys: name, sku, hsnSac, saleRate, purchaseRate,
  /// reorderLevel, uom, incomeAccount, expenseAccount, inventoryAccount,
  /// cogsAccount.
  final Map<String, String> errors;

  bool get isEdit => item != null;

  /// INV-081: tracking and UOM cannot change once stock has moved.
  bool get trackingLocked => item?.hasMovements ?? false;
  bool get uomLocked => item?.hasMovements ?? false;

  /// `item_kind` is not part of the update DTO.
  bool get kindLocked => isEdit;

  bool get canSubmit => !isSubmitting && !loading && name.trim().isNotEmpty;

  ItemFormState copyWith({
    Object? item = _keep,
    bool? loading,
    String? kind,
    String? name,
    String? sku,
    String? hsnSac,
    Object? categoryId = _keep,
    Object? uom = _keep,
    String? saleRate,
    String? purchaseRate,
    Object? taxCodeId = _keep,
    List<TaxCode>? taxCodes,
    Object? incomeAccount = _keep,
    Object? expenseAccount = _keep,
    bool? inventoryTracked,
    Object? inventoryAccount = _keep,
    Object? cogsAccount = _keep,
    String? reorderLevel,
    bool? isActive,
    bool? isSubmitting,
    Object? failure = _keep,
    Object? savedItem = _keep,
    Map<String, String>? errors,
  }) {
    return ItemFormState(
      item: identical(item, _keep) ? this.item : item as Item?,
      loading: loading ?? this.loading,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      hsnSac: hsnSac ?? this.hsnSac,
      categoryId: identical(categoryId, _keep)
          ? this.categoryId
          : categoryId as int?,
      uom: identical(uom, _keep) ? this.uom : uom as Uom?,
      saleRate: saleRate ?? this.saleRate,
      purchaseRate: purchaseRate ?? this.purchaseRate,
      taxCodeId: identical(taxCodeId, _keep)
          ? this.taxCodeId
          : taxCodeId as int?,
      taxCodes: taxCodes ?? this.taxCodes,
      incomeAccount: identical(incomeAccount, _keep)
          ? this.incomeAccount
          : incomeAccount as Account?,
      expenseAccount: identical(expenseAccount, _keep)
          ? this.expenseAccount
          : expenseAccount as Account?,
      inventoryTracked: inventoryTracked ?? this.inventoryTracked,
      inventoryAccount: identical(inventoryAccount, _keep)
          ? this.inventoryAccount
          : inventoryAccount as Account?,
      cogsAccount: identical(cogsAccount, _keep)
          ? this.cogsAccount
          : cogsAccount as Account?,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      isActive: isActive ?? this.isActive,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: identical(failure, _keep) ? this.failure : failure as Failure?,
      savedItem: identical(savedItem, _keep)
          ? this.savedItem
          : savedItem as Item?,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
    item,
    loading,
    kind,
    name,
    sku,
    hsnSac,
    categoryId,
    uom,
    saleRate,
    purchaseRate,
    taxCodeId,
    taxCodes,
    incomeAccount,
    expenseAccount,
    inventoryTracked,
    inventoryAccount,
    cogsAccount,
    reorderLevel,
    isActive,
    isSubmitting,
    failure,
    savedItem,
    errors,
  ];
}

@injectable
class ItemFormCubit extends Cubit<ItemFormState> {
  ItemFormCubit(
    this._getItem,
    this._createItem,
    this._updateItem,
    this._getAccount,
    this._getTaxCodes,
  ) : super(const ItemFormState());

  final GetItemUseCase _getItem;
  final CreateItemUseCase _createItem;
  final UpdateItemUseCase _updateItem;
  final GetAccountUseCase _getAccount;
  final GetTaxCodesUseCase _getTaxCodes;

  /// Loads tax codes for the picker. Safe to call in both modes.
  Future<void> loadTaxCodes() async {
    final result = await _getTaxCodes(
      const GetTaxCodesParams(limit: 100, isActive: true),
    );
    result.fold((_) {}, (page) {
      if (!isClosed) emit(state.copyWith(taxCodes: page.items));
    });
  }

  /// Edit mode: fetch the item (unless [initial] is given) and prefill.
  Future<void> loadForEdit(int id, {Item? initial}) async {
    emit(state.copyWith(loading: true, failure: null));
    var item = initial;
    if (item == null) {
      final result = await _getItem(id);
      final failure = result.fold<Failure?>((f) => f, (_) => null);
      if (failure != null) {
        emit(state.copyWith(loading: false, failure: failure));
        return;
      }
      item = result.getOrElse((_) => throw StateError('unreachable'));
    }
    final income = await _account(item.incomeAccountId);
    final expense = await _account(item.expenseAccountId);
    final inventory = item.inventoryAccountId == null
        ? null
        : await _account(item.inventoryAccountId!);
    final cogs = item.cogsAccountId == null
        ? null
        : await _account(item.cogsAccountId!);
    emit(
      ItemFormState(
        item: item,
        kind: item.kind,
        name: item.name,
        sku: item.sku ?? '',
        hsnSac: item.hsnSac ?? '',
        categoryId: item.categoryId,
        uom: Uom(
          id: item.uomId,
          code: item.uomCode,
          name: item.uomCode,
          decimalPlaces: item.uomDecimalPlaces,
        ),
        saleRate: item.saleRate ?? '',
        purchaseRate: item.purchaseRate ?? '',
        taxCodeId: item.taxCodeId,
        taxCodes: state.taxCodes,
        incomeAccount: income,
        expenseAccount: expense,
        inventoryTracked: item.inventoryTracked,
        inventoryAccount: inventory,
        cogsAccount: cogs,
        reorderLevel: item.reorderLevel ?? '',
        isActive: item.isActive,
      ),
    );
  }

  Future<Account?> _account(Object id) async {
    final result = await _getAccount(GetAccountParams(id: id.toString()));
    return result.fold((_) => null, (a) => a);
  }

  Map<String, String> _without(String key) =>
      Map.of(state.errors)..remove(key);

  void kindChanged(String kind) {
    if (state.kindLocked) return;
    emit(state.copyWith(kind: kind));
  }

  void nameChanged(String v) =>
      emit(state.copyWith(name: v, errors: _without('name')));
  void skuChanged(String v) =>
      emit(state.copyWith(sku: v, errors: _without('sku')));
  void hsnSacChanged(String v) =>
      emit(state.copyWith(hsnSac: v, errors: _without('hsnSac')));
  void categoryChanged(int? id) => emit(state.copyWith(categoryId: id));
  void saleRateChanged(String v) =>
      emit(state.copyWith(saleRate: v, errors: _without('saleRate')));
  void purchaseRateChanged(String v) =>
      emit(state.copyWith(purchaseRate: v, errors: _without('purchaseRate')));
  void reorderLevelChanged(String v) =>
      emit(state.copyWith(reorderLevel: v, errors: _without('reorderLevel')));
  void taxCodeChanged(int? id) => emit(state.copyWith(taxCodeId: id));
  void isActiveChanged(bool v) => emit(state.copyWith(isActive: v));

  void uomChanged(Uom? uom) {
    if (state.uomLocked) return;
    emit(state.copyWith(uom: uom, errors: _without('uom')));
  }

  void incomeAccountChanged(Account? a) => emit(
    state.copyWith(incomeAccount: a, errors: _without('incomeAccount')),
  );
  void expenseAccountChanged(Account? a) => emit(
    state.copyWith(expenseAccount: a, errors: _without('expenseAccount')),
  );
  void inventoryAccountChanged(Account? a) => emit(
    state.copyWith(inventoryAccount: a, errors: _without('inventoryAccount')),
  );
  void cogsAccountChanged(Account? a) =>
      emit(state.copyWith(cogsAccount: a, errors: _without('cogsAccount')));

  /// Turning tracking on fills the default inventory and COGS accounts when
  /// they are still empty.
  Future<void> trackingChanged(bool on) async {
    if (state.trackingLocked) return;
    emit(state.copyWith(inventoryTracked: on));
    if (!on) return;
    if (state.inventoryAccount == null) {
      final a = await _account(defaultInventoryAccountId);
      if (!isClosed && a != null && state.inventoryAccount == null) {
        emit(state.copyWith(inventoryAccount: a));
      }
    }
    if (state.cogsAccount == null) {
      final a = await _account(defaultCogsAccountId);
      if (!isClosed && a != null && state.cogsAccount == null) {
        emit(state.copyWith(cogsAccount: a));
      }
    }
  }

  static bool _badRate(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return false;
    final v = double.tryParse(t);
    return v == null || v < 0;
  }

  /// Client checks only; business rules come back from the API.
  Map<String, String> validate() {
    final e = <String, String>{};
    final name = state.name.trim();
    if (name.isEmpty) {
      e['name'] = AccountingStrings.itemNameRequired;
    } else if (name.length > 150) {
      e['name'] = AccountingStrings.itemNameTooLong;
    }
    if (state.sku.trim().length > 64) {
      e['sku'] = AccountingStrings.itemSkuTooLong;
    }
    if (state.hsnSac.trim().length > 16) {
      e['hsnSac'] = AccountingStrings.itemHsnSacTooLong;
    }
    if (_badRate(state.saleRate)) {
      e['saleRate'] = AccountingStrings.itemRateInvalid;
    }
    if (_badRate(state.purchaseRate)) {
      e['purchaseRate'] = AccountingStrings.itemRateInvalid;
    }
    if (_badRate(state.reorderLevel)) {
      e['reorderLevel'] = AccountingStrings.itemRateInvalid;
    }
    if (state.uom == null) e['uom'] = AccountingStrings.itemUomRequired;
    if (state.incomeAccount == null) {
      e['incomeAccount'] = AccountingStrings.itemAccountRequired;
    } else if (int.tryParse(state.incomeAccount!.id) == null) {
      e['incomeAccount'] = AccountingStrings.itemAccountRequired;
    }
    if (state.expenseAccount == null) {
      e['expenseAccount'] = AccountingStrings.itemAccountRequired;
    } else if (int.tryParse(state.expenseAccount!.id) == null) {
      e['expenseAccount'] = AccountingStrings.itemAccountRequired;
    }
    if (state.inventoryTracked) {
      if (state.inventoryAccount == null) {
        e['inventoryAccount'] = AccountingStrings.itemAccountRequired;
      } else if (int.tryParse(state.inventoryAccount!.id) == null) {
        e['inventoryAccount'] = AccountingStrings.itemAccountRequired;
      }
      if (state.cogsAccount == null) {
        e['cogsAccount'] = AccountingStrings.itemAccountRequired;
      } else if (int.tryParse(state.cogsAccount!.id) == null) {
        e['cogsAccount'] = AccountingStrings.itemAccountRequired;
      }
    }
    return e;
  }

  ItemDraft buildDraft() {
    final tracked = state.inventoryTracked;
    return ItemDraft(
      name: state.name.trim(),
      kind: state.kind,
      sku: state.sku,
      hsnSac: state.hsnSac,
      categoryId: state.categoryId,
      uomId: state.uom?.id ?? 0,
      saleRate: state.saleRate,
      purchaseRate: state.purchaseRate,
      taxCodeId: state.taxCodeId,
      incomeAccountId: int.tryParse(state.incomeAccount?.id ?? '') ?? 0,
      expenseAccountId: int.tryParse(state.expenseAccount?.id ?? '') ?? 0,
      inventoryTracked: tracked,
      inventoryAccountId: tracked
          ? int.tryParse(state.inventoryAccount?.id ?? '')
          : null,
      cogsAccountId: tracked ? int.tryParse(state.cogsAccount?.id ?? '') : null,
      reorderLevel: tracked ? state.reorderLevel : null,
      isActive: state.isActive,
    );
  }

  Future<bool> submit() async {
    if (state.isSubmitting) return false;
    final errors = validate();
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors, failure: null));
      return false;
    }
    emit(state.copyWith(isSubmitting: true, failure: null, errors: const {}));
    final draft = buildDraft();
    final result = state.isEdit
        ? await _updateItem(UpdateItemParams(id: state.item!.id, draft: draft))
        : await _createItem(draft);
    return result.fold(
      (f) {
        emit(state.copyWith(isSubmitting: false, failure: f));
        return false;
      },
      (saved) {
        emit(state.copyWith(isSubmitting: false, savedItem: saved));
        return true;
      },
    );
  }
}
