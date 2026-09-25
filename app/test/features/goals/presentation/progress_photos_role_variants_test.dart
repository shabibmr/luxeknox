import 'dart:async';
import 'dart:io';

import 'package:app/core/di/injector.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/goals/domain/entities/photo_pose.dart';
import 'package:app/features/goals/domain/entities/progress_photo.dart';
import 'package:app/features/goals/domain/usecases/progress_photos_usecases.dart';
import 'package:app/features/goals/presentation/cubit/progress_photos_cubit.dart';
import 'package:app/features/goals/presentation/goals_strings.dart';
import 'package:app/features/goals/presentation/screens/progress_photos_screen.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListPhotos extends Mock implements ListProgressPhotosUseCase {}

class _MockCreatePhoto extends Mock implements CreateProgressPhotoUseCase {}

class _MockDeletePhoto extends Mock implements DeleteProgressPhotoUseCase {}

class _MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

class _ImageHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

class _FakeHttpClient extends Fake implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpRequest();
}

class _FakeHttpRequest extends Fake implements HttpClientRequest {
  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _FakeHttpResponse();
}

class _FakeHttpHeaders extends Fake implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _FakeHttpResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _png.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_png).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

/// 1x1 transparent PNG so [Image.network] settles in tests.
const List<int> _png = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

/// Private photos stay visible to the owner and to `progress_photos.moderate`.
/// A trainer who is not the assigned trainer and cannot moderate does not see them.
void main() {
  const memberId = 'p-member';

  const publicPhoto = ProgressPhoto(
    id: 'pub',
    memberId: memberId,
    photoUrl: 'https://example.test/public.jpg',
    pose: PhotoPose.front,
  );
  const privatePhoto = ProgressPhoto(
    id: 'priv',
    memberId: memberId,
    photoUrl: 'https://example.test/private.jpg',
    pose: PhotoPose.side,
    isPrivate: true,
  );

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: memberId,
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p-trainer',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p-admin',
  );

  late _MockListPhotos listPhotos;
  late _MockCreatePhoto createPhoto;
  late _MockDeletePhoto deletePhoto;

  setUpAll(() {
    HttpOverrides.global = _ImageHttpOverrides();
    registerFallbackValue(const ListProgressPhotosParams(memberId: '0'));
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    listPhotos = _MockListPhotos();
    createPhoto = _MockCreatePhoto();
    deletePhoto = _MockDeletePhoto();
    when(() => listPhotos(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(
          items: [publicPhoto, privatePhoto],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    getIt.registerFactory<ProgressPhotosCubit>(
      () => ProgressPhotosCubit(listPhotos, createPhoto, deletePhoto),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pumpRole(
    WidgetTester tester, {
    required Principal principal,
    required Capabilities capabilities,
  }) async {
    final session = _MockSessionCubit();
    whenListen(
      session,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );
    getIt.registerSingleton<SessionCubit>(session);

    await tester.pumpWidget(
      const MaterialApp(
        home: ProgressPhotosScreen(memberId: memberId),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('member owner sees their private photo', (tester) async {
    await pumpRole(
      tester,
      principal: memberPrincipal,
      capabilities: const Capabilities(slugs: []),
    );

    expect(find.text(GoalsStrings.photosTitle), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
  });

  testWidgets('trainer without moderate does not see a private photo', (
    tester,
  ) async {
    await pumpRole(
      tester,
      principal: trainerPrincipal,
      capabilities: const Capabilities(slugs: []),
    );

    expect(find.text(GoalsStrings.photosTitle), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsNothing);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('admin with progress_photos.moderate sees private photos', (
    tester,
  ) async {
    await pumpRole(
      tester,
      principal: adminPrincipal,
      capabilities: const Capabilities(slugs: ['progress_photos.moderate']),
    );

    expect(find.text(GoalsStrings.photosTitle), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
  });
}
