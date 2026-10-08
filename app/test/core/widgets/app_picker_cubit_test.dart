import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_picker_cubit.dart';

class TestItem {
  const TestItem(this.id, this.name);
  final int id;
  final String name;
}

void main() {
  group('AppPickerCubit', () {
    const item1 = TestItem(1, 'One');
    const item2 = TestItem(2, 'Two');
    const item3 = TestItem(3, 'Three');

    test('initial state has empty items and initial status', () {
      final cubit = AppPickerCubit<TestItem>(
        fetcher: ({cursor, query}) async => const Right(
          CursorPage(items: [], nextCursor: null, hasMore: false),
        ),
      );

      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.hasMore, false);
      cubit.close();
    });

    test('load() successfully emits items and pagination info', () async {
      final cubit = AppPickerCubit<TestItem>(
        fetcher: ({cursor, query}) async => const Right(
          CursorPage(
            items: [item1, item2],
            nextCursor: 'cursor_2',
            hasMore: true,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.items, [item1, item2]);
      expect(cubit.state.nextCursor, 'cursor_2');
      expect(cubit.state.hasMore, true);
      cubit.close();
    });

    test('load() emits failure when fetcher returns error', () async {
      const failure = NetworkFailure();
      final cubit = AppPickerCubit<TestItem>(
        fetcher: ({cursor, query}) async => const Left(failure),
      );

      await cubit.load();

      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.failure, failure);
      cubit.close();
    });

    test('loadMore() appends items and updates cursor', () async {
      final cubit = AppPickerCubit<TestItem>(
        fetcher: ({cursor, query}) async {
          if (cursor == null) {
            return const Right(
              CursorPage(items: [item1], nextCursor: 'c1', hasMore: true),
            );
          }
          return const Right(
            CursorPage(items: [item2, item3], nextCursor: null, hasMore: false),
          );
        },
      );

      await cubit.load();
      expect(cubit.state.items, [item1]);
      expect(cubit.state.hasMore, true);

      await cubit.loadMore();
      expect(cubit.state.items, [item1, item2, item3]);
      expect(cubit.state.hasMore, false);
      cubit.close();
    });

    test('onSearchChanged debounces calls', () async {
      int fetchCount = 0;
      final cubit = AppPickerCubit<TestItem>(
        debounceDuration: const Duration(milliseconds: 50),
        fetcher: ({cursor, query}) async {
          fetchCount++;
          return const Right(
            CursorPage(items: [item1], nextCursor: null, hasMore: false),
          );
        },
      );

      cubit.onSearchChanged('a');
      cubit.onSearchChanged('ab');
      cubit.onSearchChanged('abc');

      expect(fetchCount, 0);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(fetchCount, 1);
      expect(cubit.state.query, 'abc');
      cubit.close();
    });
  });
}
