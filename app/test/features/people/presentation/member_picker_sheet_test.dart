import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/people/domain/entities/profile_summary.dart';
import 'package:luxeknox/features/people/domain/usecases/list_members_usecase.dart';
import 'package:luxeknox/features/people/presentation/widgets/member_picker_sheet.dart';
import 'package:mocktail/mocktail.dart';

class MockListMembersUseCase extends Mock implements ListMembersUseCase {}

void main() {
  late MockListMembersUseCase listMembers;

  const testMembers = [
    ProfileSummary(
      id: 10,
      fullName: 'Alice Walker',
      membershipNumber: 'M-1001',
      membershipStatus: 'active',
    ),
    ProfileSummary(
      id: 20,
      fullName: 'Bob Builder',
      membershipNumber: 'M-1002',
      membershipStatus: 'pending',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const ListMembersParams());
  });

  setUp(() {
    listMembers = MockListMembersUseCase();
    when(() => listMembers(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: testMembers, nextCursor: null, hasMore: false),
      ),
    );
  });

  testWidgets('MemberPickerSheet renders members and selects on tap', (
    tester,
  ) async {
    ProfileSummary? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                selected = await showMemberPickerSheet(
                  context,
                  listMembers: listMembers,
                );
              },
              child: const Text('Open Picker'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    expect(find.text('Alice Walker'), findsOneWidget);
    expect(find.text('Membership: M-1001'), findsOneWidget);
    expect(find.text('Bob Builder'), findsOneWidget);

    await tester.tap(find.text('Alice Walker'));
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    expect(selected!.id, 10);
    expect(selected!.fullName, 'Alice Walker');
  });

  testWidgets('MemberPickerField displays selected member and triggers picker', (
    tester,
  ) async {
    ProfileSummary? selectedMember;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return MemberPickerField(
                selectedMember: selectedMember,
                listMembers: listMembers,
                onChanged: (m) => setState(() => selectedMember = m),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Select a member'), findsOneWidget);

    await tester.tap(find.byType(MemberPickerField));
    await tester.pumpAndSettle();

    expect(find.text('Bob Builder'), findsOneWidget);
    await tester.tap(find.text('Bob Builder'));
    await tester.pumpAndSettle();

    expect(find.text('Bob Builder (M-1002)'), findsOneWidget);
  });
}
