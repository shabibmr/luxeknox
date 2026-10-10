import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/goals/domain/entities/photo_pose.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_photo.dart';
import 'package:luxeknox/features/goals/domain/usecases/progress_photos_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/admin_progress_photos_vault_cubit.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/screens/admin_progress_photos_vault_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListAllPhotos extends Mock implements ListAllProgressPhotosUseCase {}

void main() {
  late _MockListAllPhotos listAll;

  ProgressPhoto photo({
    required String id,
    required bool isPrivate,
    String memberId = '7',
  }) {
    return ProgressPhoto(
      id: id,
      memberId: memberId,
      photoUrl: 'https://example.com/$id.jpg',
      pose: PhotoPose.front,
      takenDate: DateTime(2026, 1, 15),
      isPrivate: isPrivate,
    );
  }

  setUp(() {
    listAll = _MockListAllPhotos();
    registerFallbackValue(const ListAllProgressPhotosParams());
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AdminProgressPhotosVaultCubit cubit,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const AdminProgressPhotosVaultScreen(),
        ),
      ),
    );
  }

  testWidgets('hides private photos when moderate is off', (tester) async {
    when(() => listAll(any())).thenAnswer(
      (_) async => Right(
        CursorPage(
          items: [
            photo(id: 'public', isPrivate: false),
            photo(id: 'secret', isPrivate: true, memberId: '9'),
          ],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    final cubit = AdminProgressPhotosVaultCubit(listAll);
    await pumpScreen(tester, cubit: cubit);
    await cubit.load(canModerate: false);
    await tester.pumpAndSettle();

    expect(find.textContaining('Member #7'), findsOneWidget);
    expect(find.textContaining('Member #9'), findsNothing);
    expect(find.text(GoalsStrings.privateLabel), findsNothing);
  });

  testWidgets('shows private photos when moderate is on', (tester) async {
    when(() => listAll(any())).thenAnswer(
      (_) async => Right(
        CursorPage(
          items: [
            photo(id: 'public', isPrivate: false),
            photo(id: 'secret', isPrivate: true, memberId: '9'),
          ],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    final cubit = AdminProgressPhotosVaultCubit(listAll);
    await pumpScreen(tester, cubit: cubit);
    await cubit.load(canModerate: true);
    await tester.pumpAndSettle();

    expect(find.textContaining('Member #7'), findsOneWidget);
    expect(find.textContaining('Member #9'), findsOneWidget);
    expect(find.textContaining(GoalsStrings.privateLabel), findsOneWidget);
  });
}
