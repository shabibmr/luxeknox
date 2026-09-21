// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:api_client/api_client.dart' as _i633;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/presentation/cubit/login_cubit.dart' as _i69;
import '../../features/exercises/data/datasources/exercise_remote_datasource.dart'
    as _i100;
import '../../features/exercises/data/repositories/exercise_repository_impl.dart'
    as _i340;
import '../../features/exercises/domain/repositories/exercise_repository.dart'
    as _i275;
import '../../features/exercises/domain/usecases/create_exercise_usecase.dart'
    as _i1062;
import '../../features/exercises/domain/usecases/deactivate_exercise_usecase.dart'
    as _i708;
import '../../features/exercises/domain/usecases/get_exercise_usecase.dart'
    as _i1031;
import '../../features/exercises/domain/usecases/get_exercises_usecase.dart'
    as _i870;
import '../../features/exercises/domain/usecases/update_exercise_usecase.dart'
    as _i790;
import '../../features/exercises/presentation/bloc/exercise_list_bloc.dart'
    as _i757;
import '../../features/exercises/presentation/cubit/exercise_detail_cubit.dart'
    as _i756;
import '../../features/foods/data/datasources/food_remote_datasource.dart'
    as _i822;
import '../../features/foods/data/repositories/food_repository_impl.dart'
    as _i65;
import '../../features/foods/domain/repositories/food_repository.dart' as _i728;
import '../../features/foods/domain/usecases/create_food_usecase.dart' as _i420;
import '../../features/foods/domain/usecases/deactivate_food_usecase.dart'
    as _i517;
import '../../features/foods/domain/usecases/get_food_usecase.dart' as _i463;
import '../../features/foods/domain/usecases/get_foods_usecase.dart' as _i687;
import '../../features/foods/domain/usecases/update_food_usecase.dart' as _i897;
import '../../features/foods/presentation/bloc/food_list_bloc.dart' as _i710;
import '../../features/foods/presentation/cubit/food_detail_cubit.dart'
    as _i168;
import '../../features/membership/data/datasources/membership_remote_datasource.dart'
    as _i133;
import '../../features/membership/data/repositories/membership_repository_impl.dart'
    as _i920;
import '../../features/membership/domain/repositories/membership_repository.dart'
    as _i325;
import '../../features/membership/domain/usecases/approve_freeze_usecase.dart'
    as _i46;
import '../../features/membership/domain/usecases/cancel_membership_usecase.dart'
    as _i238;
import '../../features/membership/domain/usecases/create_membership_product_usecase.dart'
    as _i499;
import '../../features/membership/domain/usecases/create_membership_usecase.dart'
    as _i64;
import '../../features/membership/domain/usecases/extend_membership_usecase.dart'
    as _i227;
import '../../features/membership/domain/usecases/get_membership_freezes_usecase.dart'
    as _i590;
import '../../features/membership/domain/usecases/get_membership_history_usecase.dart'
    as _i106;
import '../../features/membership/domain/usecases/get_membership_product_usecase.dart'
    as _i363;
import '../../features/membership/domain/usecases/get_membership_products_usecase.dart'
    as _i359;
import '../../features/membership/domain/usecases/get_membership_usecase.dart'
    as _i70;
import '../../features/membership/domain/usecases/get_memberships_usecase.dart'
    as _i370;
import '../../features/membership/domain/usecases/reject_freeze_usecase.dart'
    as _i223;
import '../../features/membership/domain/usecases/renew_membership_usecase.dart'
    as _i804;
import '../../features/membership/domain/usecases/request_membership_freeze_usecase.dart'
    as _i377;
import '../../features/membership/domain/usecases/update_membership_product_usecase.dart'
    as _i30;
import '../../features/membership/domain/usecases/upgrade_membership_usecase.dart'
    as _i617;
import '../../features/people/domain/repositories/document_repository.dart'
    as _i210;
import '../../features/people/domain/repositories/people_repository.dart'
    as _i646;
import '../../features/people/domain/repositories/profile_repository.dart'
    as _i121;
import '../../features/people/domain/usecases/create_emergency_contact_usecase.dart'
    as _i580;
import '../../features/people/domain/usecases/create_medical_record_usecase.dart'
    as _i525;
import '../../features/people/domain/usecases/delete_document_usecase.dart'
    as _i770;
import '../../features/people/domain/usecases/delete_emergency_contact_usecase.dart'
    as _i776;
import '../../features/people/domain/usecases/delete_medical_record_usecase.dart'
    as _i148;
import '../../features/people/domain/usecases/get_health_info_usecase.dart'
    as _i311;
import '../../features/people/domain/usecases/get_member_usecase.dart' as _i562;
import '../../features/people/domain/usecases/list_documents_usecase.dart'
    as _i1023;
import '../../features/people/domain/usecases/list_emergency_contacts_usecase.dart'
    as _i343;
import '../../features/people/domain/usecases/list_medical_records_usecase.dart'
    as _i578;
import '../../features/people/domain/usecases/list_members_usecase.dart'
    as _i436;
import '../../features/people/domain/usecases/update_emergency_contact_usecase.dart'
    as _i735;
import '../../features/people/domain/usecases/update_health_info_usecase.dart'
    as _i62;
import '../../features/people/domain/usecases/update_medical_record_usecase.dart'
    as _i196;
import '../../features/people/domain/usecases/update_member_usecase.dart'
    as _i862;
import '../../features/people/domain/usecases/upload_document_usecase.dart'
    as _i438;
import '../../session/data/datasources/session_remote_datasource.dart' as _i963;
import '../../session/data/repositories/session_repository_impl.dart' as _i803;
import '../../session/domain/repositories/session_repository.dart' as _i158;
import '../../session/domain/usecases/get_me_usecase.dart' as _i852;
import '../../session/domain/usecases/login_usecase.dart' as _i1059;
import '../../session/domain/usecases/logout_usecase.dart' as _i2;
import '../../session/domain/usecases/refresh_session_usecase.dart' as _i898;
import '../../session/domain/usecases/restore_session_usecase.dart' as _i123;
import '../../session/presentation/session_cubit.dart' as _i893;
import '../config/app_config.dart' as _i650;
import '../media/media_picker.dart' as _i763;
import '../media/media_uploader.dart' as _i510;
import '../media/signed_media_resolver.dart' as _i700;
import '../monitoring/crash_reporter.dart' as _i668;
import '../storage/token_storage.dart' as _i973;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i650.AppConfig>(() => registerModule.appConfig);
    gh.singleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i763.MediaPicker>(() => _i763.MediaPicker());
    gh.lazySingleton<_i668.CrashReporter>(
      () => const _i668.NoOpCrashReporter(),
    );
    gh.singleton<_i973.TokenStorage>(
      () => registerModule.tokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i562.GetMemberUseCase>(
      () => _i562.GetMemberUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i436.ListMembersUseCase>(
      () => _i436.ListMembersUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i862.UpdateMemberUseCase>(
      () => _i862.UpdateMemberUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i580.CreateEmergencyContactUseCase>(
      () => _i580.CreateEmergencyContactUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i525.CreateMedicalRecordUseCase>(
      () => _i525.CreateMedicalRecordUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i776.DeleteEmergencyContactUseCase>(
      () => _i776.DeleteEmergencyContactUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i148.DeleteMedicalRecordUseCase>(
      () => _i148.DeleteMedicalRecordUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i311.GetHealthInfoUseCase>(
      () => _i311.GetHealthInfoUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i343.ListEmergencyContactsUseCase>(
      () => _i343.ListEmergencyContactsUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i578.ListMedicalRecordsUseCase>(
      () => _i578.ListMedicalRecordsUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i735.UpdateEmergencyContactUseCase>(
      () => _i735.UpdateEmergencyContactUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i62.UpdateHealthInfoUseCase>(
      () => _i62.UpdateHealthInfoUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i196.UpdateMedicalRecordUseCase>(
      () => _i196.UpdateMedicalRecordUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i770.DeleteDocumentUseCase>(
      () => _i770.DeleteDocumentUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.lazySingleton<_i1023.ListDocumentsUseCase>(
      () => _i1023.ListDocumentsUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.lazySingleton<_i438.UploadDocumentUseCase>(
      () => _i438.UploadDocumentUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.singleton<_i361.Dio>(
      () => registerModule.dio(gh<_i650.AppConfig>(), gh<_i973.TokenStorage>()),
    );
    gh.singleton<_i633.AUTHApi>(() => registerModule.authApi(gh<_i361.Dio>()));
    gh.singleton<_i633.WORKApi>(() => registerModule.workApi(gh<_i361.Dio>()));
    gh.singleton<_i633.DIETApi>(() => registerModule.dietApi(gh<_i361.Dio>()));
    gh.singleton<_i633.PEOPLEApi>(
      () => registerModule.peopleApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i633.HEALTHApi>(
      () => registerModule.healthApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i633.MEDIAApi>(
      () => registerModule.mediaApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i633.MEMBApi>(() => registerModule.membApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i963.SessionRemoteDataSource>(
      () => _i963.SessionRemoteDataSourceImpl(gh<_i633.AUTHApi>()),
    );
    gh.lazySingleton<_i510.MediaUploader>(
      () => _i510.MediaUploader(gh<_i633.MEDIAApi>()),
    );
    gh.lazySingleton<_i700.SignedMediaResolver>(
      () => _i700.SignedMediaResolver(gh<_i633.MEDIAApi>()),
    );
    gh.lazySingleton<_i133.MembershipRemoteDataSource>(
      () => _i133.MembershipRemoteDataSourceImpl(gh<_i633.MEMBApi>()),
    );
    gh.lazySingleton<_i325.MembershipRepository>(
      () => _i920.MembershipRepositoryImpl(
        gh<_i133.MembershipRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i822.FoodRemoteDataSource>(
      () => _i822.FoodRemoteDataSourceImpl(gh<_i633.DIETApi>()),
    );
    gh.lazySingleton<_i100.ExerciseRemoteDataSource>(
      () => _i100.ExerciseRemoteDataSourceImpl(gh<_i633.WORKApi>()),
    );
    gh.lazySingleton<_i46.ApproveFreezeUseCase>(
      () => _i46.ApproveFreezeUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i238.CancelMembershipUseCase>(
      () => _i238.CancelMembershipUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i499.CreateMembershipProductUseCase>(
      () => _i499.CreateMembershipProductUseCase(
        gh<_i325.MembershipRepository>(),
      ),
    );
    gh.lazySingleton<_i64.CreateMembershipUseCase>(
      () => _i64.CreateMembershipUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i227.ExtendMembershipUseCase>(
      () => _i227.ExtendMembershipUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i590.GetMembershipFreezesUseCase>(
      () => _i590.GetMembershipFreezesUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i106.GetMembershipHistoryUseCase>(
      () => _i106.GetMembershipHistoryUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i363.GetMembershipProductUseCase>(
      () => _i363.GetMembershipProductUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i359.GetMembershipProductsUseCase>(
      () =>
          _i359.GetMembershipProductsUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i70.GetMembershipUseCase>(
      () => _i70.GetMembershipUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i370.GetMembershipsUseCase>(
      () => _i370.GetMembershipsUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i223.RejectFreezeUseCase>(
      () => _i223.RejectFreezeUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i804.RenewMembershipUseCase>(
      () => _i804.RenewMembershipUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i377.RequestMembershipFreezeUseCase>(
      () => _i377.RequestMembershipFreezeUseCase(
        gh<_i325.MembershipRepository>(),
      ),
    );
    gh.lazySingleton<_i30.UpdateMembershipProductUseCase>(
      () =>
          _i30.UpdateMembershipProductUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i617.UpgradeMembershipUseCase>(
      () => _i617.UpgradeMembershipUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i158.SessionRepository>(
      () => _i803.SessionRepositoryImpl(
        gh<_i963.SessionRemoteDataSource>(),
        gh<_i973.TokenStorage>(),
      ),
    );
    gh.lazySingleton<_i852.GetMeUseCase>(
      () => _i852.GetMeUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i1059.LoginUseCase>(
      () => _i1059.LoginUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i2.LogoutUseCase>(
      () => _i2.LogoutUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i898.RefreshSessionUseCase>(
      () => _i898.RefreshSessionUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i123.RestoreSessionUseCase>(
      () => _i123.RestoreSessionUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i728.FoodRepository>(
      () => _i65.FoodRepositoryImpl(gh<_i822.FoodRemoteDataSource>()),
    );
    gh.singleton<_i893.SessionCubit>(
      () => _i893.SessionCubit(
        restoreSessionUseCase: gh<_i123.RestoreSessionUseCase>(),
        loginUseCase: gh<_i1059.LoginUseCase>(),
        logoutUseCase: gh<_i2.LogoutUseCase>(),
      ),
    );
    gh.lazySingleton<_i275.ExerciseRepository>(
      () => _i340.ExerciseRepositoryImpl(gh<_i100.ExerciseRemoteDataSource>()),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i893.SessionCubit>()),
    );
    gh.lazySingleton<_i1062.CreateExerciseUseCase>(
      () => _i1062.CreateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i708.DeactivateExerciseUseCase>(
      () => _i708.DeactivateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i1031.GetExerciseUseCase>(
      () => _i1031.GetExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i870.GetExercisesUseCase>(
      () => _i870.GetExercisesUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i790.UpdateExerciseUseCase>(
      () => _i790.UpdateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.factory<_i69.LoginCubit>(
      () => _i69.LoginCubit(gh<_i893.SessionCubit>()),
    );
    gh.factory<_i756.ExerciseDetailCubit>(
      () => _i756.ExerciseDetailCubit(gh<_i1031.GetExerciseUseCase>()),
    );
    gh.factory<_i757.ExerciseListBloc>(
      () => _i757.ExerciseListBloc(
        getExercisesUseCase: gh<_i870.GetExercisesUseCase>(),
      ),
    );
    gh.lazySingleton<_i420.CreateFoodUseCase>(
      () => _i420.CreateFoodUseCase(gh<_i728.FoodRepository>()),
    );
    gh.lazySingleton<_i517.DeactivateFoodUseCase>(
      () => _i517.DeactivateFoodUseCase(gh<_i728.FoodRepository>()),
    );
    gh.lazySingleton<_i463.GetFoodUseCase>(
      () => _i463.GetFoodUseCase(gh<_i728.FoodRepository>()),
    );
    gh.lazySingleton<_i687.GetFoodsUseCase>(
      () => _i687.GetFoodsUseCase(gh<_i728.FoodRepository>()),
    );
    gh.lazySingleton<_i897.UpdateFoodUseCase>(
      () => _i897.UpdateFoodUseCase(gh<_i728.FoodRepository>()),
    );
    gh.factory<_i168.FoodDetailCubit>(
      () => _i168.FoodDetailCubit(gh<_i463.GetFoodUseCase>()),
    );
    gh.factory<_i710.FoodListBloc>(
      () => _i710.FoodListBloc(getFoodsUseCase: gh<_i687.GetFoodsUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
