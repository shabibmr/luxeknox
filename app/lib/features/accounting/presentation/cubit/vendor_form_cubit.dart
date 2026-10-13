import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/usecases/create_vendor_usecase.dart';
import '../../domain/usecases/get_vendor_usecase.dart';
import '../../domain/usecases/update_vendor_usecase.dart';
import '../accounting_strings.dart';

const Object _sentinel = Object();

class VendorFormState extends Equatable {
  const VendorFormState({
    this.status = LoadStatus.initial,
    this.vendor,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.gstin = '',
    this.isActive = true,
    this.isSubmitting = false,
    this.failure,
    this.savedVendor,
    this.nameError,
    this.phoneError,
    this.emailError,
    this.gstinError,
  });

  final LoadStatus status;
  final Vendor? vendor;
  final String name;
  final String phone;
  final String email;
  final String gstin;
  final bool isActive;
  final bool isSubmitting;
  final Failure? failure;
  final Vendor? savedVendor;
  final String? nameError;
  final String? phoneError;
  final String? emailError;
  final String? gstinError;

  bool get isEdit => vendor != null;

  bool get isValid =>
      nameError == null &&
      phoneError == null &&
      emailError == null &&
      gstinError == null &&
      name.trim().isNotEmpty;

  VendorFormState copyWith({
    LoadStatus? status,
    Object? vendor = _sentinel,
    String? name,
    String? phone,
    String? email,
    String? gstin,
    bool? isActive,
    bool? isSubmitting,
    Object? failure = _sentinel,
    Object? savedVendor = _sentinel,
    Object? nameError = _sentinel,
    Object? phoneError = _sentinel,
    Object? emailError = _sentinel,
    Object? gstinError = _sentinel,
  }) {
    return VendorFormState(
      status: status ?? this.status,
      vendor: identical(vendor, _sentinel) ? this.vendor : (vendor as Vendor?),
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      isActive: isActive ?? this.isActive,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      savedVendor: identical(savedVendor, _sentinel)
          ? this.savedVendor
          : (savedVendor as Vendor?),
      nameError: identical(nameError, _sentinel)
          ? this.nameError
          : (nameError as String?),
      phoneError: identical(phoneError, _sentinel)
          ? this.phoneError
          : (phoneError as String?),
      emailError: identical(emailError, _sentinel)
          ? this.emailError
          : (emailError as String?),
      gstinError: identical(gstinError, _sentinel)
          ? this.gstinError
          : (gstinError as String?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        vendor,
        name,
        phone,
        email,
        gstin,
        isActive,
        isSubmitting,
        failure,
        savedVendor,
        nameError,
        phoneError,
        emailError,
        gstinError,
      ];
}

@injectable
class VendorFormCubit extends Cubit<VendorFormState> {
  VendorFormCubit(
    this._getVendor,
    this._createVendor,
    this._updateVendor,
  ) : super(const VendorFormState());

  final GetVendorUseCase _getVendor;
  final CreateVendorUseCase _createVendor;
  final UpdateVendorUseCase _updateVendor;

  Future<void> load(String id) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getVendor(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (vendor) => setVendor(vendor),
    );
  }

  void setVendor(Vendor vendor) {
    emit(
      state.copyWith(
        status: LoadStatus.success,
        vendor: vendor,
        name: vendor.name,
        phone: vendor.phone ?? '',
        email: vendor.contactEmail ?? '',
        gstin: vendor.taxNumber ?? '',
        isActive: vendor.isActive,
        failure: null,
        nameError: null,
        phoneError: null,
        emailError: null,
        gstinError: null,
      ),
    );
  }

  void nameChanged(String value) {
    String? error;
    if (value.trim().isEmpty) {
      error = AccountingStrings.vendorNameRequired;
    }
    emit(state.copyWith(name: value, nameError: error));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, phoneError: null));
  }

  void emailChanged(String value) {
    String? error;
    final trimmed = value.trim();
    if (trimmed.isNotEmpty &&
        (!trimmed.contains('@') || !trimmed.contains('.'))) {
      error = 'Please enter a valid email address';
    }
    emit(state.copyWith(email: value, emailError: error));
  }

  void gstinChanged(String value) {
    emit(state.copyWith(gstin: value, gstinError: null));
  }

  void isActiveChanged(bool value) {
    emit(state.copyWith(isActive: value));
  }

  bool validate() {
    String? nameError;
    if (state.name.trim().isEmpty) {
      nameError = AccountingStrings.vendorNameRequired;
    }

    String? emailError;
    final trimmedEmail = state.email.trim();
    if (trimmedEmail.isNotEmpty &&
        (!trimmedEmail.contains('@') || !trimmedEmail.contains('.'))) {
      emailError = 'Please enter a valid email address';
    }

    emit(
      state.copyWith(
        nameError: nameError,
        emailError: emailError,
      ),
    );

    return nameError == null && emailError == null;
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    emit(state.copyWith(isSubmitting: true, failure: null));

    final trimmedName = state.name.trim();
    final trimmedPhone =
        state.phone.trim().isEmpty ? null : state.phone.trim();
    final trimmedEmail =
        state.email.trim().isEmpty ? null : state.email.trim();
    final trimmedGstin =
        state.gstin.trim().isEmpty ? null : state.gstin.trim();

    if (state.isEdit) {
      final result = await _updateVendor(
        UpdateVendorParams(
          id: state.vendor!.id,
          name: trimmedName,
          phone: trimmedPhone,
          email: trimmedEmail,
          gstin: trimmedGstin,
          isActive: state.isActive,
        ),
      );

      return result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: LoadStatus.failure,
              failure: failure,
              isSubmitting: false,
            ),
          );
          return false;
        },
        (vendor) {
          emit(
            state.copyWith(
              status: LoadStatus.success,
              vendor: vendor,
              savedVendor: vendor,
              isSubmitting: false,
              failure: null,
            ),
          );
          return true;
        },
      );
    } else {
      final result = await _createVendor(
        CreateVendorParams(
          name: trimmedName,
          phone: trimmedPhone,
          email: trimmedEmail,
          gstin: trimmedGstin,
          isActive: state.isActive,
        ),
      );

      return result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: LoadStatus.failure,
              failure: failure,
              isSubmitting: false,
            ),
          );
          return false;
        },
        (vendor) {
          emit(
            state.copyWith(
              status: LoadStatus.success,
              savedVendor: vendor,
              isSubmitting: false,
              failure: null,
            ),
          );
          return true;
        },
      );
    }
  }
}
