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

import '../../features/attendance/data/datasources/attendance_remote_datasource.dart'
    as _i425;
import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i719;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i477;
import '../../features/attendance/domain/usecases/attendance_usecases.dart'
    as _i841;
import '../../features/attendance/presentation/cubit/attendance_history_cubit.dart'
    as _i85;
import '../../features/attendance/presentation/cubit/attendance_pass_cubit.dart'
    as _i410;
import '../../features/auth/presentation/cubit/change_password_cubit.dart'
    as _i33;
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart'
    as _i104;
import '../../features/auth/presentation/cubit/login_cubit.dart' as _i69;
import '../../features/auth/presentation/cubit/reset_password_cubit.dart'
    as _i476;
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart'
    as _i817;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/domain/usecases/get_dashboard_usecase.dart'
    as _i805;
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i24;
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
    as _i1032;
import '../../features/exercises/domain/usecases/get_exercises_usecase.dart'
    as _i870;
import '../../features/exercises/domain/usecases/update_exercise_usecase.dart'
    as _i791;
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
    as _i71;
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
import '../../features/membership/presentation/cubit/create_membership_cubit.dart'
    as _i138;
import '../../features/membership/presentation/cubit/memberships_directory_cubit.dart'
    as _i407;
import '../../features/payments/data/datasources/payments_remote_datasource.dart'
    as _i935;
import '../../features/payments/data/repositories/payments_repository_impl.dart'
    as _i565;
import '../../features/payments/domain/repositories/payments_repository.dart'
    as _i663;
import '../../features/payments/domain/usecases/create_payment_method_usecase.dart'
    as _i66;
import '../../features/payments/domain/usecases/get_outstanding_payments_usecase.dart'
    as _i828;
import '../../features/payments/domain/usecases/get_payment_methods_usecase.dart'
    as _i789;
import '../../features/payments/domain/usecases/get_payment_usecase.dart'
    as _i835;
import '../../features/payments/domain/usecases/get_payments_usecase.dart'
    as _i645;
import '../../features/payments/presentation/cubit/outstanding_dues_cubit.dart'
    as _i1024;
import '../../features/payments/presentation/cubit/payment_detail_cubit.dart'
    as _i144;
import '../../features/payments/presentation/cubit/payment_methods_cubit.dart'
    as _i790;
import '../../features/payments/presentation/cubit/payments_ledger_cubit.dart'
    as _i853;
import '../../features/people/data/datasources/people_remote_datasource.dart'
    as _i1029;
import '../../features/people/data/datasources/profile_remote_datasource.dart'
    as _i327;
import '../../features/people/data/repositories/document_repository_impl.dart'
    as _i869;
import '../../features/people/data/repositories/people_repository_impl.dart'
    as _i1030;
import '../../features/people/data/repositories/profile_repository_impl.dart'
    as _i887;
import '../../features/people/domain/repositories/document_repository.dart'
    as _i210;
import '../../features/people/domain/repositories/people_repository.dart'
    as _i646;
import '../../features/people/domain/repositories/profile_repository.dart'
    as _i121;
import '../../features/people/domain/usecases/assign_trainer_usecase.dart'
    as _i829;
import '../../features/people/domain/usecases/create_emergency_contact_usecase.dart'
    as _i580;
import '../../features/people/domain/usecases/create_medical_record_usecase.dart'
    as _i525;
import '../../features/people/domain/usecases/delete_document_usecase.dart'
    as _i770;
import '../../features/people/domain/usecases/delete_emergency_contact_usecase.dart'
    as _i776;
import '../../features/people/domain/usecases/delete_medical_record_usecase.dart'
    as _i149;
import '../../features/people/domain/usecases/get_health_info_usecase.dart'
    as _i311;
import '../../features/people/domain/usecases/get_member_usecase.dart' as _i562;
import '../../features/people/domain/usecases/list_documents_usecase.dart'
    as _i1023;
import '../../features/people/domain/usecases/list_emergency_contacts_usecase.dart'
    as _i343;
import '../../features/people/domain/usecases/list_employees_usecase.dart'
    as _i1004;
import '../../features/people/domain/usecases/list_medical_records_usecase.dart'
    as _i578;
import '../../features/people/domain/usecases/list_members_usecase.dart'
    as _i436;
import '../../features/people/domain/usecases/list_photos_usecase.dart'
    as _i917;
import '../../features/people/domain/usecases/list_trainers_usecase.dart'
    as _i382;
import '../../features/people/domain/usecases/set_avatar_usecase.dart'
    as _i1012;
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
import '../../features/people/domain/usecases/upload_photo_usecase.dart'
    as _i78;
import '../../features/people/presentation/cubit/employees_directory_cubit.dart'
    as _i369;
import '../../features/people/presentation/cubit/member_dossier_cubit.dart'
    as _i148;
import '../../features/people/presentation/cubit/members_directory_cubit.dart'
    as _i228;
import '../../features/people/presentation/cubit/trainers_directory_cubit.dart'
    as _i971;
import '../../features/scheduling/data/datasources/scheduling_remote_datasource.dart'
    as _i969;
import '../../features/scheduling/data/repositories/scheduling_repository_impl.dart'
    as _i651;
import '../../features/scheduling/domain/repositories/scheduling_repository.dart'
    as _i250;
import '../../features/scheduling/domain/usecases/catalog_usecases.dart'
    as _i871;
import '../../features/scheduling/domain/usecases/schedule_usecases.dart'
    as _i777;
import '../../features/scheduling/presentation/cubit/facilities_cubit.dart'
    as _i115;
import '../../features/scheduling/presentation/cubit/schedule_calendar_cubit.dart'
    as _i1056;
import '../../features/scheduling/presentation/cubit/schedule_detail_cubit.dart'
    as _i948;
import '../../features/scheduling/presentation/cubit/trainer_availability_cubit.dart'
    as _i1026;
import '../../features/workout/data/datasources/workout_plan_remote_datasource.dart'
    as _i773;
import '../../features/workout/data/datasources/workout_session_remote_datasource.dart'
    as _i70;
import '../../features/workout/data/repositories/workout_plan_repository_impl.dart'
    as _i1031;
import '../../features/workout/data/repositories/workout_session_repository_impl.dart'
    as _i55;
import '../../features/workout/domain/repositories/workout_plan_repository.dart'
    as _i68;
import '../../features/workout/domain/repositories/workout_session_repository.dart'
    as _i14;
import '../../features/workout/domain/usecases/archive_workout_plan_usecase.dart'
    as _i664;
import '../../features/workout/domain/usecases/assign_workout_plan_usecase.dart'
    as _i60;
import '../../features/workout/domain/usecases/complete_workout_session_usecase.dart'
    as _i57;
import '../../features/workout/domain/usecases/create_workout_plan_usecase.dart'
    as _i701;
import '../../features/workout/domain/usecases/get_workout_plan_usecase.dart'
    as _i391;
import '../../features/workout/domain/usecases/list_workout_plan_versions_usecase.dart'
    as _i516;
import '../../features/workout/domain/usecases/list_workout_plans_usecase.dart'
    as _i110;
import '../../features/workout/domain/usecases/list_workout_sessions_usecase.dart'
    as _i736;
import '../../features/workout/domain/usecases/log_workout_set_usecase.dart'
    as _i88;
import '../../features/workout/domain/usecases/publish_workout_plan_usecase.dart'
    as _i553;
import '../../features/workout/domain/usecases/replace_workout_plan_exercises_usecase.dart'
    as _i179;
import '../../features/workout/domain/usecases/start_workout_session_usecase.dart'
    as _i556;
import '../../features/workout/domain/usecases/update_workout_plan_usecase.dart'
    as _i134;
import '../../features/workout/presentation/cubit/workout_history_cubit.dart'
    as _i251;
import '../../features/workout/presentation/cubit/workout_plan_builder_cubit.dart'
    as _i598;
import '../../features/workout/presentation/cubit/workout_plan_detail_cubit.dart'
    as _i261;
import '../../features/workout/presentation/cubit/workout_plan_list_cubit.dart'
    as _i731;
import '../../features/workout/presentation/cubit/workout_plan_versions_cubit.dart'
    as _i1063;
import '../../session/data/datasources/session_remote_datasource.dart' as _i963;
import '../../session/data/repositories/session_repository_impl.dart' as _i803;
import '../../session/domain/repositories/session_repository.dart' as _i158;
import '../../session/domain/usecases/change_password_usecase.dart' as _i455;
import '../../session/domain/usecases/forgot_password_usecase.dart' as _i586;
import '../../session/domain/usecases/get_me_usecase.dart' as _i852;
import '../../session/domain/usecases/login_usecase.dart' as _i1059;
import '../../session/domain/usecases/logout_usecase.dart' as _i2;
import '../../session/domain/usecases/refresh_session_usecase.dart' as _i898;
import '../../session/domain/usecases/reset_password_usecase.dart' as _i695;
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
    gh.singleton<_i633.DASHApi>(() => registerModule.dashApi(gh<_i361.Dio>()));
    gh.singleton<_i633.SCHEDApi>(
      () => registerModule.schedApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i633.ATTNApi>(() => registerModule.attnApi(gh<_i361.Dio>()));
    gh.singleton<_i633.PAYApi>(() => registerModule.payApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i70.WorkoutSessionRemoteDataSource>(
      () => _i70.WorkoutSessionRemoteDataSourceImpl(
        gh<_i633.WORKApi>(),
        gh<_i361.Dio>(),
      ),
    );
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
    gh.lazySingleton<_i1029.PeopleRemoteDataSource>(
      () => _i1029.PeopleRemoteDataSourceImpl(gh<_i633.PEOPLEApi>()),
    );
    gh.lazySingleton<_i325.MembershipRepository>(
      () => _i920.MembershipRepositoryImpl(
        gh<_i133.MembershipRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i646.PeopleRepository>(
      () => _i1030.PeopleRepositoryImpl(gh<_i1029.PeopleRemoteDataSource>()),
    );
    gh.lazySingleton<_i14.WorkoutSessionRepository>(
      () => _i55.WorkoutSessionRepositoryImpl(
        gh<_i70.WorkoutSessionRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i969.SchedulingRemoteDataSource>(
      () => _i969.SchedulingRemoteDataSourceImpl(gh<_i633.SCHEDApi>()),
    );
    gh.lazySingleton<_i817.DashboardRemoteDataSource>(
      () => _i817.DashboardRemoteDataSourceImpl(gh<_i633.DASHApi>()),
    );
    gh.lazySingleton<_i57.CompleteWorkoutSessionUseCase>(
      () => _i57.CompleteWorkoutSessionUseCase(
        gh<_i14.WorkoutSessionRepository>(),
      ),
    );
    gh.lazySingleton<_i736.ListWorkoutSessionsUseCase>(
      () =>
          _i736.ListWorkoutSessionsUseCase(gh<_i14.WorkoutSessionRepository>()),
    );
    gh.lazySingleton<_i88.LogWorkoutSetUseCase>(
      () => _i88.LogWorkoutSetUseCase(gh<_i14.WorkoutSessionRepository>()),
    );
    gh.lazySingleton<_i556.StartWorkoutSessionUseCase>(
      () =>
          _i556.StartWorkoutSessionUseCase(gh<_i14.WorkoutSessionRepository>()),
    );
    gh.lazySingleton<_i327.ProfileRemoteDataSource>(
      () => _i327.ProfileRemoteDataSourceImpl(gh<_i633.HEALTHApi>()),
    );
    gh.lazySingleton<_i935.PaymentsRemoteDataSource>(
      () => _i935.PaymentsRemoteDataSourceImpl(gh<_i633.PAYApi>()),
    );
    gh.lazySingleton<_i822.FoodRemoteDataSource>(
      () => _i822.FoodRemoteDataSourceImpl(gh<_i633.DIETApi>()),
    );
    gh.lazySingleton<_i100.ExerciseRemoteDataSource>(
      () => _i100.ExerciseRemoteDataSourceImpl(gh<_i633.WORKApi>()),
    );
    gh.lazySingleton<_i773.WorkoutPlanRemoteDataSource>(
      () => _i773.WorkoutPlanRemoteDataSourceImpl(
        gh<_i633.WORKApi>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i829.AssignTrainerUseCase>(
      () => _i829.AssignTrainerUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i562.GetMemberUseCase>(
      () => _i562.GetMemberUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i1004.ListEmployeesUseCase>(
      () => _i1004.ListEmployeesUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i436.ListMembersUseCase>(
      () => _i436.ListMembersUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i382.ListTrainersUseCase>(
      () => _i382.ListTrainersUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i862.UpdateMemberUseCase>(
      () => _i862.UpdateMemberUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i665.DashboardRepository>(
      () =>
          _i509.DashboardRepositoryImpl(gh<_i817.DashboardRemoteDataSource>()),
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
    gh.lazySingleton<_i71.GetMembershipUseCase>(
      () => _i71.GetMembershipUseCase(gh<_i325.MembershipRepository>()),
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
    gh.lazySingleton<_i425.AttendanceRemoteDataSource>(
      () => _i425.AttendanceRemoteDataSourceImpl(gh<_i633.ATTNApi>()),
    );
    gh.lazySingleton<_i158.SessionRepository>(
      () => _i803.SessionRepositoryImpl(
        gh<_i963.SessionRemoteDataSource>(),
        gh<_i973.TokenStorage>(),
      ),
    );
    gh.lazySingleton<_i68.WorkoutPlanRepository>(
      () => _i1031.WorkoutPlanRepositoryImpl(
        gh<_i773.WorkoutPlanRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i663.PaymentsRepository>(
      () => _i565.PaymentsRepositoryImpl(gh<_i935.PaymentsRemoteDataSource>()),
    );
    gh.factory<_i138.CreateMembershipCubit>(
      () => _i138.CreateMembershipCubit(
        gh<_i64.CreateMembershipUseCase>(),
        gh<_i359.GetMembershipProductsUseCase>(),
        gh<_i436.ListMembersUseCase>(),
      ),
    );
    gh.factory<_i228.MembersDirectoryCubit>(
      () => _i228.MembersDirectoryCubit(gh<_i436.ListMembersUseCase>()),
    );
    gh.factory<_i971.TrainersDirectoryCubit>(
      () => _i971.TrainersDirectoryCubit(gh<_i382.ListTrainersUseCase>()),
    );
    gh.factory<_i251.WorkoutHistoryCubit>(
      () => _i251.WorkoutHistoryCubit(gh<_i736.ListWorkoutSessionsUseCase>()),
    );
    gh.lazySingleton<_i455.ChangePasswordUseCase>(
      () => _i455.ChangePasswordUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i586.ForgotPasswordUseCase>(
      () => _i586.ForgotPasswordUseCase(gh<_i158.SessionRepository>()),
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
    gh.lazySingleton<_i695.ResetPasswordUseCase>(
      () => _i695.ResetPasswordUseCase(gh<_i158.SessionRepository>()),
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
    gh.lazySingleton<_i121.ProfileRepository>(
      () => _i887.ProfileRepositoryImpl(gh<_i327.ProfileRemoteDataSource>()),
    );
    gh.factory<_i407.MembershipsDirectoryCubit>(
      () => _i407.MembershipsDirectoryCubit(gh<_i370.GetMembershipsUseCase>()),
    );
    gh.factory<_i148.MemberDossierCubit>(
      () => _i148.MemberDossierCubit(
        gh<_i562.GetMemberUseCase>(),
        gh<_i862.UpdateMemberUseCase>(),
        gh<_i829.AssignTrainerUseCase>(),
      ),
    );
    gh.lazySingleton<_i275.ExerciseRepository>(
      () => _i340.ExerciseRepositoryImpl(gh<_i100.ExerciseRemoteDataSource>()),
    );
    gh.lazySingleton<_i210.DocumentRepository>(
      () => _i869.DocumentRepositoryImpl(
        gh<_i327.ProfileRemoteDataSource>(),
        gh<_i510.MediaUploader>(),
      ),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i893.SessionCubit>()),
    );
    gh.lazySingleton<_i66.CreatePaymentMethodUseCase>(
      () => _i66.CreatePaymentMethodUseCase(gh<_i663.PaymentsRepository>()),
    );
    gh.lazySingleton<_i828.GetOutstandingPaymentsUseCase>(
      () => _i828.GetOutstandingPaymentsUseCase(gh<_i663.PaymentsRepository>()),
    );
    gh.lazySingleton<_i789.GetPaymentMethodsUseCase>(
      () => _i789.GetPaymentMethodsUseCase(gh<_i663.PaymentsRepository>()),
    );
    gh.lazySingleton<_i835.GetPaymentUseCase>(
      () => _i835.GetPaymentUseCase(gh<_i663.PaymentsRepository>()),
    );
    gh.lazySingleton<_i645.GetPaymentsUseCase>(
      () => _i645.GetPaymentsUseCase(gh<_i663.PaymentsRepository>()),
    );
    gh.factory<_i33.ChangePasswordCubit>(
      () => _i33.ChangePasswordCubit(gh<_i455.ChangePasswordUseCase>()),
    );
    gh.lazySingleton<_i664.ArchiveWorkoutPlanUseCase>(
      () => _i664.ArchiveWorkoutPlanUseCase(gh<_i68.WorkoutPlanRepository>()),
    );
    gh.lazySingleton<_i60.AssignWorkoutPlanUseCase>(
      () => _i60.AssignWorkoutPlanUseCase(gh<_i68.WorkoutPlanRepository>()),
    );
    gh.lazySingleton<_i701.CreateWorkoutPlanUseCase>(
      () => _i701.CreateWorkoutPlanUseCase(gh<_i68.WorkoutPlanRepository>()),
    );
    gh.lazySingleton<_i391.GetWorkoutPlanUseCase>(
      () => _i391.GetWorkoutPlanUseCase(gh<_i68.WorkoutPlanRepository>()),
    );
    gh.lazySingleton<_i516.ListWorkoutPlanVersionsUseCase>(
      () => _i516.ListWorkoutPlanVersionsUseCase(
        gh<_i68.WorkoutPlanRepository>(),
      ),
    );
    gh.lazySingleton<_i110.ListWorkoutPlansUseCase>(
      () => _i110.ListWorkoutPlansUseCase(gh<_i68.WorkoutPlanRepository>()),
    );
    gh.lazySingleton<_i553.PublishWorkoutPlanUseCase>(
      () => _i553.PublishWorkoutPlanUseCase(gh<_i68.WorkoutPlanRepository>()),
    );
    gh.lazySingleton<_i179.ReplaceWorkoutPlanExercisesUseCase>(
      () => _i179.ReplaceWorkoutPlanExercisesUseCase(
        gh<_i68.WorkoutPlanRepository>(),
      ),
    );
    gh.lazySingleton<_i134.UpdateWorkoutPlanUseCase>(
      () => _i134.UpdateWorkoutPlanUseCase(gh<_i68.WorkoutPlanRepository>()),
    );
    gh.factory<_i144.PaymentDetailCubit>(
      () => _i144.PaymentDetailCubit(gh<_i835.GetPaymentUseCase>()),
    );
    gh.factory<_i1024.OutstandingDuesCubit>(
      () => _i1024.OutstandingDuesCubit(
        gh<_i828.GetOutstandingPaymentsUseCase>(),
      ),
    );
    gh.factory<_i598.WorkoutPlanBuilderCubit>(
      () => _i598.WorkoutPlanBuilderCubit(
        gh<_i391.GetWorkoutPlanUseCase>(),
        gh<_i701.CreateWorkoutPlanUseCase>(),
        gh<_i134.UpdateWorkoutPlanUseCase>(),
        gh<_i179.ReplaceWorkoutPlanExercisesUseCase>(),
        gh<_i553.PublishWorkoutPlanUseCase>(),
      ),
    );
    gh.lazySingleton<_i250.SchedulingRepository>(
      () => _i651.SchedulingRepositoryImpl(
        gh<_i969.SchedulingRemoteDataSource>(),
      ),
    );
    gh.factory<_i790.PaymentMethodsCubit>(
      () => _i790.PaymentMethodsCubit(
        gh<_i789.GetPaymentMethodsUseCase>(),
        gh<_i66.CreatePaymentMethodUseCase>(),
      ),
    );
    gh.factory<_i104.ForgotPasswordCubit>(
      () => _i104.ForgotPasswordCubit(gh<_i586.ForgotPasswordUseCase>()),
    );
    gh.lazySingleton<_i1062.CreateExerciseUseCase>(
      () => _i1062.CreateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i708.DeactivateExerciseUseCase>(
      () => _i708.DeactivateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i1032.GetExerciseUseCase>(
      () => _i1032.GetExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i870.GetExercisesUseCase>(
      () => _i870.GetExercisesUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i791.UpdateExerciseUseCase>(
      () => _i791.UpdateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.factory<_i261.WorkoutPlanDetailCubit>(
      () => _i261.WorkoutPlanDetailCubit(
        gh<_i391.GetWorkoutPlanUseCase>(),
        gh<_i553.PublishWorkoutPlanUseCase>(),
        gh<_i664.ArchiveWorkoutPlanUseCase>(),
        gh<_i60.AssignWorkoutPlanUseCase>(),
      ),
    );
    gh.lazySingleton<_i871.ListFacilitiesUseCase>(
      () => _i871.ListFacilitiesUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i871.CreateFacilityUseCase>(
      () => _i871.CreateFacilityUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i871.ListScheduleTypesUseCase>(
      () => _i871.ListScheduleTypesUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i871.GetTrainerAvailabilityUseCase>(
      () =>
          _i871.GetTrainerAvailabilityUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i871.PutTrainerAvailabilityUseCase>(
      () =>
          _i871.PutTrainerAvailabilityUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i777.ListSchedulesUseCase>(
      () => _i777.ListSchedulesUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i777.GetScheduleUseCase>(
      () => _i777.GetScheduleUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i777.CreateScheduleUseCase>(
      () => _i777.CreateScheduleUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i777.CancelScheduleUseCase>(
      () => _i777.CancelScheduleUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i777.BookScheduleUseCase>(
      () => _i777.BookScheduleUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i777.UnbookScheduleUseCase>(
      () => _i777.UnbookScheduleUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i777.StartScheduleUseCase>(
      () => _i777.StartScheduleUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i777.CompleteScheduleUseCase>(
      () => _i777.CompleteScheduleUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i477.AttendanceRepository>(
      () => _i719.AttendanceRepositoryImpl(
        gh<_i425.AttendanceRemoteDataSource>(),
      ),
    );
    gh.factory<_i369.EmployeesDirectoryCubit>(
      () => _i369.EmployeesDirectoryCubit(gh<_i1004.ListEmployeesUseCase>()),
    );
    gh.factory<_i69.LoginCubit>(
      () => _i69.LoginCubit(gh<_i893.SessionCubit>()),
    );
    gh.factory<_i1063.WorkoutPlanVersionsCubit>(
      () => _i1063.WorkoutPlanVersionsCubit(
        gh<_i516.ListWorkoutPlanVersionsUseCase>(),
      ),
    );
    gh.factory<_i756.ExerciseDetailCubit>(
      () => _i756.ExerciseDetailCubit(gh<_i1032.GetExerciseUseCase>()),
    );
    gh.lazySingleton<_i805.GetDashboardUseCase>(
      () => _i805.GetDashboardUseCase(gh<_i665.DashboardRepository>()),
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
    gh.lazySingleton<_i149.DeleteMedicalRecordUseCase>(
      () => _i149.DeleteMedicalRecordUseCase(gh<_i121.ProfileRepository>()),
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
    gh.factory<_i757.ExerciseListBloc>(
      () => _i757.ExerciseListBloc(
        getExercisesUseCase: gh<_i870.GetExercisesUseCase>(),
      ),
    );
    gh.lazySingleton<_i770.DeleteDocumentUseCase>(
      () => _i770.DeleteDocumentUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.lazySingleton<_i1023.ListDocumentsUseCase>(
      () => _i1023.ListDocumentsUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.lazySingleton<_i917.ListPhotosUseCase>(
      () => _i917.ListPhotosUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.lazySingleton<_i1012.SetAvatarUseCase>(
      () => _i1012.SetAvatarUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.lazySingleton<_i438.UploadDocumentUseCase>(
      () => _i438.UploadDocumentUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.lazySingleton<_i438.CancelDocumentUploadUseCase>(
      () => _i438.CancelDocumentUploadUseCase(gh<_i210.DocumentRepository>()),
    );
    gh.lazySingleton<_i78.UploadPhotoUseCase>(
      () => _i78.UploadPhotoUseCase(gh<_i210.DocumentRepository>()),
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
    gh.factory<_i731.WorkoutPlanListCubit>(
      () => _i731.WorkoutPlanListCubit(gh<_i110.ListWorkoutPlansUseCase>()),
    );
    gh.lazySingleton<_i841.GetAttendancePassUseCase>(
      () => _i841.GetAttendancePassUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.lazySingleton<_i841.CheckInUseCase>(
      () => _i841.CheckInUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.lazySingleton<_i841.CheckOutUseCase>(
      () => _i841.CheckOutUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.lazySingleton<_i841.ListAttendancesUseCase>(
      () => _i841.ListAttendancesUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.lazySingleton<_i841.GetAttendanceSummaryUseCase>(
      () => _i841.GetAttendanceSummaryUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.lazySingleton<_i841.ListAttendanceHistoriesUseCase>(
      () => _i841.ListAttendanceHistoriesUseCase(
        gh<_i477.AttendanceRepository>(),
      ),
    );
    gh.lazySingleton<_i841.MarkSessionAttendanceUseCase>(
      () =>
          _i841.MarkSessionAttendanceUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.factory<_i476.ResetPasswordCubit>(
      () => _i476.ResetPasswordCubit(gh<_i695.ResetPasswordUseCase>()),
    );
    gh.factory<_i168.FoodDetailCubit>(
      () => _i168.FoodDetailCubit(gh<_i463.GetFoodUseCase>()),
    );
    gh.factory<_i853.PaymentsLedgerCubit>(
      () => _i853.PaymentsLedgerCubit(gh<_i645.GetPaymentsUseCase>()),
    );
    gh.factory<_i1056.ScheduleCalendarCubit>(
      () => _i1056.ScheduleCalendarCubit(gh<_i777.ListSchedulesUseCase>()),
    );
    gh.factory<_i710.FoodListBloc>(
      () => _i710.FoodListBloc(getFoodsUseCase: gh<_i687.GetFoodsUseCase>()),
    );
    gh.factory<_i410.CheckInCubit>(
      () => _i410.CheckInCubit(gh<_i841.CheckInUseCase>()),
    );
    gh.factory<_i85.AttendanceSummaryCubit>(
      () => _i85.AttendanceSummaryCubit(
        gh<_i841.GetAttendanceSummaryUseCase>(),
        gh<_i841.ListAttendancesUseCase>(),
      ),
    );
    gh.factory<_i1026.TrainerAvailabilityCubit>(
      () => _i1026.TrainerAvailabilityCubit(
        gh<_i871.GetTrainerAvailabilityUseCase>(),
        gh<_i871.PutTrainerAvailabilityUseCase>(),
      ),
    );
    gh.factory<_i115.FacilitiesCubit>(
      () => _i115.FacilitiesCubit(
        gh<_i871.ListFacilitiesUseCase>(),
        gh<_i871.CreateFacilityUseCase>(),
      ),
    );
    gh.factory<_i410.AttendancePassCubit>(
      () => _i410.AttendancePassCubit(
        gh<_i841.GetAttendancePassUseCase>(),
        gh<_i841.ListAttendancesUseCase>(),
        gh<_i841.CheckOutUseCase>(),
      ),
    );
    gh.factory<_i85.AttendanceHistoryCubit>(
      () => _i85.AttendanceHistoryCubit(gh<_i841.ListAttendancesUseCase>()),
    );
    gh.factory<_i948.ScheduleDetailCubit>(
      () => _i948.ScheduleDetailCubit(
        gh<_i777.GetScheduleUseCase>(),
        gh<_i777.BookScheduleUseCase>(),
        gh<_i777.UnbookScheduleUseCase>(),
        gh<_i777.CancelScheduleUseCase>(),
        gh<_i777.StartScheduleUseCase>(),
        gh<_i777.CompleteScheduleUseCase>(),
        gh<_i841.MarkSessionAttendanceUseCase>(),
      ),
    );
    gh.factory<_i24.DashboardCubit>(
      () => _i24.DashboardCubit(gh<_i805.GetDashboardUseCase>()),
    );
    gh.factory<_i85.AttendanceLiveFeedCubit>(
      () => _i85.AttendanceLiveFeedCubit(
        gh<_i841.ListAttendancesUseCase>(),
        gh<_i841.ListAttendanceHistoriesUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
