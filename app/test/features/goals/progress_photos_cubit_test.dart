import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/goals/domain/entities/photo_pose.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_photo.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_photo_comparison.dart';
import 'package:luxeknox/features/goals/domain/usecases/progress_photos_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/progress_photos_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockListPhotos extends Mock implements ListProgressPhotosUseCase {}

class _MockCreatePhoto extends Mock implements CreateProgressPhotoUseCase {}

class _MockDeletePhoto extends Mock implements DeleteProgressPhotoUseCase {}

class _MockComparePhotos extends Mock implements CompareProgressPhotosUseCase {}

void main() {
  late _MockListPhotos listPhotos;
  late _MockCreatePhoto createPhoto;
  late _MockDeletePhoto deletePhoto;
  late _MockComparePhotos comparePhotos;

  const memberId = '10';
  final date1 = DateTime.utc(2026, 1, 15);
  final date2 = DateTime.utc(2026, 2, 20);

  const frontDate1 = ProgressPhoto(
    id: '1',
    memberId: memberId,
    photoUrl: 'https://example.com/front1.jpg',
    pose: PhotoPose.front,
  );

  setUpAll(() {
    registerFallbackValue(const ListProgressPhotosParams(memberId: '0'));
    registerFallbackValue(
      CompareProgressPhotosParams(
        memberId: '0',
        date1: DateTime.utc(2026, 1, 1),
        date2: DateTime.utc(2026, 1, 2),
      ),
    );
  });

  setUp(() {
    listPhotos = _MockListPhotos();
    createPhoto = _MockCreatePhoto();
    deletePhoto = _MockDeletePhoto();
    comparePhotos = _MockComparePhotos();
    when(() => listPhotos(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(
          items: [frontDate1],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
  });

  ProgressPhotosCubit buildCubit() => ProgressPhotosCubit(
    listPhotos,
    createPhoto,
    deletePhoto,
    comparePhotos,
  );

  Future<ProgressPhotosCubit> loadedCubit() async {
    final cubit = buildCubit();
    await cubit.load(
      memberId,
      isOwner: true,
      isAssignedTrainer: false,
      canModerate: false,
    );
    return cubit;
  }

  blocTest<ProgressPhotosCubit, ProgressPhotosState>(
    'compare calls use case with memberId and date1/date2',
    build: () {
      when(() => comparePhotos(any())).thenAnswer(
        (_) async => Right(
          ProgressPhotoComparison(
            date1: date1,
            date2: date2,
            front: const ProgressPhotoPosePair(date1: frontDate1),
          ),
        ),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load(
        memberId,
        isOwner: true,
        isAssignedTrainer: false,
        canModerate: false,
      );
      await cubit.compare(date1: date1, date2: date2);
    },
    verify: (_) {
      final captured = verify(
        () => comparePhotos(captureAny()),
      ).captured.single as CompareProgressPhotosParams;
      expect(captured.memberId, memberId);
      expect(captured.date1, date1);
      expect(captured.date2, date2);
    },
  );

  test('compare stores empty pose slots as null pairs', () async {
    when(() => comparePhotos(any())).thenAnswer(
      (_) async => Right(
        ProgressPhotoComparison(
          date1: date1,
          date2: date2,
          front: const ProgressPhotoPosePair(date1: frontDate1),
        ),
      ),
    );

    final cubit = await loadedCubit();
    await cubit.compare(date1: date1, date2: date2);

    final comparison = cubit.state.comparison!;
    expect(comparison.front.date1, frontDate1);
    expect(comparison.front.date2, isNull);
    expect(comparison.side.date1, isNull);
    expect(comparison.side.date2, isNull);
    expect(comparison.back.date1, isNull);
    expect(comparison.back.date2, isNull);
    expect(cubit.state.comparing, isFalse);
    expect(cubit.state.compareDate1, date1);
    expect(cubit.state.compareDate2, date2);

    await cubit.close();
  });

  test('compare failure clears comparison and sets failure', () async {
    when(() => comparePhotos(any())).thenAnswer(
      (_) async => const Left(NetworkFailure()),
    );

    final cubit = await loadedCubit();
    await cubit.compare(date1: date1, date2: date2);

    expect(cubit.state.comparison, isNull);
    expect(cubit.state.failure, isA<NetworkFailure>());
    expect(cubit.state.comparing, isFalse);

    await cubit.close();
  });
}
