import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounts_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/go_live_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/vendors_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/items_cubit.dart';

/// Feedback loop for blank Chart of Accounts / Go-Live screens:
/// generated DI incorrectly injects unregistered Duration/DateTime.
void main() {
  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('AccountsCubit resolves from getIt (Chart of Accounts)', () {
    configureDependencies();
    expect(() => getIt<AccountsCubit>(), returnsNormally);
  });

  test('GoLiveCubit resolves from getIt (Go-Live)', () {
    configureDependencies();
    expect(() => getIt<GoLiveCubit>(), returnsNormally);
  });

  test('VendorsCubit resolves from getIt', () {
    configureDependencies();
    expect(() => getIt<VendorsCubit>(), returnsNormally);
  });

  test('ItemsCubit resolves from getIt', () {
    configureDependencies();
    expect(() => getIt<ItemsCubit>(), returnsNormally);
  });
}
