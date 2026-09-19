import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/pagination/cursor_page.dart';

void main() {
  group('CursorPage value equality', () {
    test('CursorPage with same data are equal', () {
      const items = ['a', 'b', 'c'];
      const page1 = CursorPage(
        items: items,
        nextCursor: 'cursor123',
        hasMore: true,
      );
      const page2 = CursorPage(
        items: items,
        nextCursor: 'cursor123',
        hasMore: true,
      );

      expect(page1, equals(page2));
      expect(page1.hashCode, equals(page2.hashCode));
    });

    test('CursorPage with different items are not equal', () {
      const page1 = CursorPage(
        items: ['a', 'b'],
        nextCursor: 'cursor123',
        hasMore: true,
      );
      const page2 = CursorPage(
        items: ['a', 'b', 'c'],
        nextCursor: 'cursor123',
        hasMore: true,
      );

      expect(page1, isNot(equals(page2)));
    });

    test('CursorPage with different nextCursor are not equal', () {
      const items = ['a', 'b'];
      const page1 = CursorPage(
        items: items,
        nextCursor: 'cursor123',
        hasMore: true,
      );
      const page2 = CursorPage(
        items: items,
        nextCursor: 'cursor456',
        hasMore: true,
      );

      expect(page1, isNot(equals(page2)));
    });

    test('CursorPage with different hasMore are not equal', () {
      const items = ['a', 'b'];
      const page1 = CursorPage(
        items: items,
        nextCursor: 'cursor123',
        hasMore: true,
      );
      const page2 = CursorPage(
        items: items,
        nextCursor: 'cursor123',
        hasMore: false,
      );

      expect(page1, isNot(equals(page2)));
    });

    test('CursorPage with null nextCursor', () {
      const page1 = CursorPage(
        items: ['a', 'b'],
        nextCursor: null,
        hasMore: false,
      );
      const page2 = CursorPage(
        items: ['a', 'b'],
        nextCursor: null,
        hasMore: false,
      );

      expect(page1, equals(page2));
    });
  });

  group('CursorPage holds fields correctly', () {
    test('CursorPage holds items', () {
      final items = ['item1', 'item2', 'item3'];
      final page = CursorPage(
        items: items,
        nextCursor: 'cursor',
        hasMore: true,
      );

      expect(page.items, equals(items));
      expect(page.items.length, equals(3));
    });

    test('CursorPage holds nextCursor', () {
      const cursor = 'next_cursor_value';
      const page = CursorPage(items: [], nextCursor: cursor, hasMore: true);

      expect(page.nextCursor, equals(cursor));
    });

    test('CursorPage holds hasMore', () {
      const page = CursorPage(items: [], nextCursor: 'cursor', hasMore: false);

      expect(page.hasMore, isFalse);
    });

    test('CursorPage works with generic types', () {
      const intPage = CursorPage(
        items: [1, 2, 3],
        nextCursor: 'next',
        hasMore: true,
      );

      expect(intPage.items, equals([1, 2, 3]));
      expect(intPage.items[0], equals(1));
    });

    test('CursorPage with complex generic types', () {
      const complexPage = CursorPage(
        items: [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ],
        nextCursor: 'cursor123',
        hasMore: false,
      );

      expect(complexPage.items, hasLength(2));
      expect(complexPage.items[0]['name'], equals('Item 1'));
    });
  });

  group('CursorPage props for Equatable', () {
    test('CursorPage props contains all fields', () {
      const page = CursorPage(
        items: ['a', 'b'],
        nextCursor: 'cursor',
        hasMore: true,
      );

      expect(page.props, hasLength(3));
      expect(page.props[0], equals(['a', 'b']));
      expect(page.props[1], equals('cursor'));
      expect(page.props[2], equals(true));
    });
  });
}
