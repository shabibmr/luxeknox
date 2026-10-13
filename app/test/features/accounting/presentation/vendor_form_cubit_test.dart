import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/vendor.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_vendor_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_vendor_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/update_vendor_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/vendor_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVendorUseCase extends Mock implements GetVendorUseCase {}

class MockCreateVendorUseCase extends Mock implements CreateVendorUseCase {}

class MockUpdateVendorUseCase extends Mock implements UpdateVendorUseCase {}

void main() {
  late MockGetVendorUseCase mockGetVendor;
  late MockCreateVendorUseCase mockCreateVendor;
  late MockUpdateVendorUseCase mockUpdateVendor;
  late VendorFormCubit cubit;

  const tVendor = Vendor(
    id: 'v-100',
    name: 'Iron Grip Equipments',
    phone: '+1 555-9999',
    contactEmail: 'sales@irongrip.com',
    taxNumber: 'GSTIN-9999',
    isActive: true,
  );

  setUpAll(() {
    registerFallbackValue(
      const CreateVendorParams(name: 'dummy'),
    );
    registerFallbackValue(
      const UpdateVendorParams(id: 'dummy'),
    );
  });

  setUp(() {
    mockGetVendor = MockGetVendorUseCase();
    mockCreateVendor = MockCreateVendorUseCase();
    mockUpdateVendor = MockUpdateVendorUseCase();
    cubit = VendorFormCubit(
      mockGetVendor,
      mockCreateVendor,
      mockUpdateVendor,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has default empty values', () {
    expect(cubit.state, const VendorFormState());
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.isEdit, isFalse);
    expect(cubit.state.isActive, isTrue);
    expect(cubit.state.name, '');
    expect(cubit.state.phone, '');
    expect(cubit.state.email, '');
    expect(cubit.state.gstin, '');
  });

  group('load', () {
    blocTest<VendorFormCubit, VendorFormState>(
      'emits [loading, success] with populated fields on successful fetch',
      build: () {
        when(() => mockGetVendor('v-100'))
            .thenAnswer((_) async => const Right(tVendor));
        return cubit;
      },
      act: (cubit) => cubit.load('v-100'),
      expect: () => [
        const VendorFormState(
          status: LoadStatus.loading,
          failure: null,
        ),
        const VendorFormState(
          status: LoadStatus.success,
          vendor: tVendor,
          name: 'Iron Grip Equipments',
          phone: '+1 555-9999',
          email: 'sales@irongrip.com',
          gstin: 'GSTIN-9999',
          isActive: true,
        ),
      ],
    );

    blocTest<VendorFormCubit, VendorFormState>(
      'emits [loading, failure] when use case returns failure',
      build: () {
        when(() => mockGetVendor('v-100')).thenAnswer(
            (_) async => const Left(BusinessRuleFailure('Vendor not found')));
        return cubit;
      },
      act: (cubit) => cubit.load('v-100'),
      expect: () => [
        const VendorFormState(
          status: LoadStatus.loading,
          failure: null,
        ),
        const VendorFormState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Vendor not found'),
        ),
      ],
    );
  });

  group('field change handlers', () {
    test('nameChanged updates name and sets error if empty', () {
      cubit.nameChanged('Flex Equipment');
      expect(cubit.state.name, 'Flex Equipment');
      expect(cubit.state.nameError, isNull);

      cubit.nameChanged('   ');
      expect(cubit.state.nameError, AccountingStrings.vendorNameRequired);
    });

    test('phoneChanged updates phone', () {
      cubit.phoneChanged('123456');
      expect(cubit.state.phone, '123456');
    });

    test('emailChanged updates email and validates format', () {
      cubit.emailChanged('invalid-email');
      expect(cubit.state.emailError, isNotNull);

      cubit.emailChanged('test@example.com');
      expect(cubit.state.emailError, isNull);
    });

    test('gstinChanged and isActiveChanged update state', () {
      cubit.gstinChanged('GSTIN-444');
      cubit.isActiveChanged(false);

      expect(cubit.state.gstin, 'GSTIN-444');
      expect(cubit.state.isActive, isFalse);
    });
  });

  group('submit', () {
    test('submit returns false and sets nameError when name is empty', () async {
      cubit.nameChanged('');
      final result = await cubit.submit();

      expect(result, isFalse);
      expect(cubit.state.nameError, AccountingStrings.vendorNameRequired);
      verifyNever(() => mockCreateVendor(any()));
    });

    blocTest<VendorFormCubit, VendorFormState>(
      'calls CreateVendorUseCase in create mode and emits [submitting, success]',
      build: () {
        when(() => mockCreateVendor(any()))
            .thenAnswer((_) async => const Right(tVendor));
        return cubit;
      },
      seed: () => const VendorFormState(
        name: 'Iron Grip Equipments',
        phone: '+1 555-9999',
        email: 'sales@irongrip.com',
        gstin: 'GSTIN-9999',
        isActive: true,
      ),
      act: (cubit) async => cubit.submit(),
      expect: () => [
        const VendorFormState(
          name: 'Iron Grip Equipments',
          phone: '+1 555-9999',
          email: 'sales@irongrip.com',
          gstin: 'GSTIN-9999',
          isActive: true,
          isSubmitting: true,
        ),
        const VendorFormState(
          status: LoadStatus.success,
          savedVendor: tVendor,
          name: 'Iron Grip Equipments',
          phone: '+1 555-9999',
          email: 'sales@irongrip.com',
          gstin: 'GSTIN-9999',
          isActive: true,
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(() => mockCreateVendor(
              const CreateVendorParams(
                name: 'Iron Grip Equipments',
                phone: '+1 555-9999',
                email: 'sales@irongrip.com',
                gstin: 'GSTIN-9999',
                isActive: true,
              ),
            )).called(1);
      },
    );

    blocTest<VendorFormCubit, VendorFormState>(
      'calls UpdateVendorUseCase in edit mode and emits [submitting, success]',
      build: () {
        when(() => mockUpdateVendor(any()))
            .thenAnswer((_) async => const Right(tVendor));
        return cubit;
      },
      seed: () => const VendorFormState(
        vendor: tVendor,
        name: 'Iron Grip Equipments',
        phone: '+1 555-9999',
        email: 'sales@irongrip.com',
        gstin: 'GSTIN-9999',
        isActive: true,
      ),
      act: (cubit) async => cubit.submit(),
      expect: () => [
        const VendorFormState(
          vendor: tVendor,
          name: 'Iron Grip Equipments',
          phone: '+1 555-9999',
          email: 'sales@irongrip.com',
          gstin: 'GSTIN-9999',
          isActive: true,
          isSubmitting: true,
        ),
        const VendorFormState(
          status: LoadStatus.success,
          vendor: tVendor,
          savedVendor: tVendor,
          name: 'Iron Grip Equipments',
          phone: '+1 555-9999',
          email: 'sales@irongrip.com',
          gstin: 'GSTIN-9999',
          isActive: true,
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(() => mockUpdateVendor(
              const UpdateVendorParams(
                id: 'v-100',
                name: 'Iron Grip Equipments',
                phone: '+1 555-9999',
                email: 'sales@irongrip.com',
                gstin: 'GSTIN-9999',
                isActive: true,
              ),
            )).called(1);
      },
    );

    blocTest<VendorFormCubit, VendorFormState>(
      'emits failure when create vendor fails',
      build: () {
        when(() => mockCreateVendor(any())).thenAnswer(
            (_) async => const Left(BusinessRuleFailure('Creation failed')));
        return cubit;
      },
      seed: () => const VendorFormState(
        name: 'Iron Grip',
      ),
      act: (cubit) async => cubit.submit(),
      expect: () => [
        const VendorFormState(
          name: 'Iron Grip',
          isSubmitting: true,
        ),
        const VendorFormState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Creation failed'),
          name: 'Iron Grip',
          isSubmitting: false,
        ),
      ],
    );
  });
}
