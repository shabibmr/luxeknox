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

import '../../features/alerts/data/datasources/alerts_remote_datasource.dart'
    as _i1019;
import '../../features/alerts/data/repositories/alerts_repository_impl.dart'
    as _i56;
import '../../features/alerts/domain/repositories/alerts_repository.dart'
    as _i7;
import '../../features/alerts/domain/usecases/list_system_alerts_usecase.dart'
    as _i1065;
import '../../features/alerts/presentation/cubit/system_alerts_cubit.dart'
    as _i449;
import '../../features/attendance/data/datasources/attendance_remote_datasource.dart'
    as _i425;
import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i719;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i477;
import '../../features/attendance/domain/usecases/attendance_usecases.dart'
    as _i841;
import '../../features/attendance/presentation/bloc/check_in_bloc.dart'
    as _i406;
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
    as _i804;
import '../../features/dashboard/presentation/cubit/dashboard_agenda_cubit.dart'
    as _i628;
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i24;
import '../../features/diet/data/datasources/diet_log_remote_datasource.dart'
    as _i785;
import '../../features/diet/data/datasources/diet_plan_remote_datasource.dart'
    as _i290;
import '../../features/diet/data/repositories/diet_log_repository_impl.dart'
    as _i532;
import '../../features/diet/data/repositories/diet_plan_repository_impl.dart'
    as _i198;
import '../../features/diet/domain/repositories/diet_log_repository.dart'
    as _i771;
import '../../features/diet/domain/repositories/diet_plan_repository.dart'
    as _i784;
import '../../features/diet/domain/usecases/archive_diet_plan_usecase.dart'
    as _i998;
import '../../features/diet/domain/usecases/assign_diet_plan_usecase.dart'
    as _i529;
import '../../features/diet/domain/usecases/create_diet_plan_usecase.dart'
    as _i86;
import '../../features/diet/domain/usecases/get_diet_meal_usecase.dart'
    as _i129;
import '../../features/diet/domain/usecases/get_diet_plan_usecase.dart'
    as _i911;
import '../../features/diet/domain/usecases/list_diet_logs_usecase.dart'
    as _i1025;
import '../../features/diet/domain/usecases/list_diet_plan_versions_usecase.dart'
    as _i556;
import '../../features/diet/domain/usecases/list_diet_plans_usecase.dart'
    as _i639;
import '../../features/diet/domain/usecases/publish_diet_plan_usecase.dart'
    as _i820;
import '../../features/diet/domain/usecases/record_diet_log_usecase.dart'
    as _i638;
import '../../features/diet/domain/usecases/replace_diet_plan_meals_usecase.dart'
    as _i805;
import '../../features/diet/domain/usecases/update_diet_plan_usecase.dart'
    as _i186;
import '../../features/diet/presentation/cubit/diet_daily_log_cubit.dart'
    as _i982;
import '../../features/diet/presentation/cubit/diet_history_cubit.dart'
    as _i778;
import '../../features/diet/presentation/cubit/diet_meal_detail_cubit.dart'
    as _i745;
import '../../features/diet/presentation/cubit/diet_plan_builder_cubit.dart'
    as _i261;
import '../../features/diet/presentation/cubit/diet_plan_detail_cubit.dart'
    as _i42;
import '../../features/diet/presentation/cubit/diet_plan_list_cubit.dart'
    as _i613;
import '../../features/diet/presentation/cubit/diet_plan_versions_cubit.dart'
    as _i857;
import '../../features/diet/presentation/cubit/food_picker_cubit.dart' as _i979;
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
    as _i1034;
import '../../features/exercises/domain/usecases/get_exercises_usecase.dart'
    as _i871;
import '../../features/exercises/domain/usecases/update_exercise_usecase.dart'
    as _i790;
import '../../features/exercises/presentation/bloc/exercise_list_bloc.dart'
    as _i757;
import '../../features/exercises/presentation/cubit/exercise_detail_cubit.dart'
    as _i756;
import '../../features/exercises/presentation/cubit/exercise_form_cubit.dart'
    as _i554;
import '../../features/foods/data/datasources/food_remote_datasource.dart'
    as _i822;
import '../../features/foods/data/repositories/food_repository_impl.dart'
    as _i64;
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
import '../../features/foods/presentation/cubit/food_form_cubit.dart' as _i826;
import '../../features/goals/data/datasources/goals_remote_datasource.dart'
    as _i812;
import '../../features/goals/data/repositories/goal_metrics_repository_impl.dart'
    as _i45;
import '../../features/goals/data/repositories/goals_repository_impl.dart'
    as _i159;
import '../../features/goals/data/repositories/measurements_repository_impl.dart'
    as _i981;
import '../../features/goals/data/repositories/progress_notes_repository_impl.dart'
    as _i523;
import '../../features/goals/data/repositories/progress_photos_repository_impl.dart'
    as _i591;
import '../../features/goals/domain/repositories/goal_metrics_repository.dart'
    as _i977;
import '../../features/goals/domain/repositories/goals_repository.dart'
    as _i608;
import '../../features/goals/domain/repositories/measurements_repository.dart'
    as _i247;
import '../../features/goals/domain/repositories/progress_notes_repository.dart'
    as _i210;
import '../../features/goals/domain/repositories/progress_photos_repository.dart'
    as _i721;
import '../../features/goals/domain/usecases/goal_metrics_usecases.dart' as _i2;
import '../../features/goals/domain/usecases/goals_usecases.dart' as _i62;
import '../../features/goals/domain/usecases/measurements_usecases.dart'
    as _i586;
import '../../features/goals/domain/usecases/progress_notes_usecases.dart'
    as _i44;
import '../../features/goals/domain/usecases/progress_photos_usecases.dart'
    as _i748;
import '../../features/goals/presentation/cubit/goal_detail_cubit.dart'
    as _i114;
import '../../features/goals/presentation/cubit/goal_form_cubit.dart' as _i814;
import '../../features/goals/presentation/cubit/goal_metrics_admin_cubit.dart'
    as _i1054;
import '../../features/goals/presentation/cubit/goals_list_cubit.dart' as _i555;
import '../../features/goals/presentation/cubit/measurements_cubit.dart'
    as _i927;
import '../../features/goals/presentation/cubit/progress_notes_cubit.dart'
    as _i188;
import '../../features/goals/presentation/cubit/progress_photos_cubit.dart'
    as _i634;
import '../../features/membership/data/datasources/membership_remote_datasource.dart'
    as _i133;
import '../../features/membership/data/repositories/membership_repository_impl.dart'
    as _i920;
import '../../features/membership/domain/repositories/membership_repository.dart'
    as _i325;
import '../../features/membership/domain/usecases/approve_freeze_usecase.dart'
    as _i47;
import '../../features/membership/domain/usecases/cancel_membership_usecase.dart'
    as _i238;
import '../../features/membership/domain/usecases/create_membership_product_usecase.dart'
    as _i499;
import '../../features/membership/domain/usecases/create_membership_usecase.dart'
    as _i65;
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
    as _i806;
import '../../features/membership/domain/usecases/request_membership_freeze_usecase.dart'
    as _i377;
import '../../features/membership/domain/usecases/update_membership_product_usecase.dart'
    as _i30;
import '../../features/membership/domain/usecases/upgrade_membership_usecase.dart'
    as _i617;
import '../../features/membership/presentation/bloc/create_membership_bloc.dart'
    as _i632;
import '../../features/membership/presentation/cubit/membership_card_cubit.dart'
    as _i309;
import '../../features/membership/presentation/cubit/membership_detail_cubit.dart'
    as _i854;
import '../../features/membership/presentation/cubit/membership_freeze_cubit.dart'
    as _i879;
import '../../features/membership/presentation/cubit/membership_freeze_form_cubit.dart'
    as _i203;
import '../../features/membership/presentation/cubit/membership_history_cubit.dart'
    as _i452;
import '../../features/membership/presentation/cubit/membership_packages_catalog_cubit.dart'
    as _i1069;
import '../../features/membership/presentation/cubit/membership_product_form_cubit.dart'
    as _i153;
import '../../features/membership/presentation/cubit/membership_renew_cubit.dart'
    as _i269;
import '../../features/membership/presentation/cubit/memberships_directory_cubit.dart'
    as _i407;
import '../../features/membership/presentation/cubit/trainer_membership_summary_cubit.dart'
    as _i751;
import '../../features/notifications/data/datasources/device_token_local_store.dart'
    as _i808;
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart'
    as _i937;
import '../../features/notifications/data/repositories/notifications_repository_impl.dart'
    as _i201;
import '../../features/notifications/data/services/device_token_service.dart'
    as _i576;
import '../../features/notifications/data/services/fcm_messaging_service.dart'
    as _i287;
import '../../features/notifications/data/services/fcm_push_token_provider.dart'
    as _i202;
import '../../features/notifications/domain/repositories/device_token_registrar.dart'
    as _i212;
import '../../features/notifications/domain/repositories/device_token_store.dart'
    as _i575;
import '../../features/notifications/domain/repositories/notifications_repository.dart'
    as _i563;
import '../../features/notifications/domain/repositories/push_token_provider.dart'
    as _i18;
import '../../features/notifications/domain/usecases/notification_usecases.dart'
    as _i864;
import '../../features/notifications/domain/usecases/unregister_device_on_logout.dart'
    as _i630;
import '../../features/notifications/presentation/cubit/broadcast_cubit.dart'
    as _i511;
import '../../features/notifications/presentation/cubit/notification_detail_cubit.dart'
    as _i552;
import '../../features/notifications/presentation/cubit/notifications_inbox_cubit.dart'
    as _i839;
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
    as _i791;
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
    as _i211;
import '../../features/people/domain/repositories/people_repository.dart'
    as _i646;
import '../../features/people/domain/repositories/profile_repository.dart'
    as _i121;
import '../../features/people/domain/usecases/assign_employee_role_usecase.dart'
    as _i725;
import '../../features/people/domain/usecases/assign_trainer_usecase.dart'
    as _i829;
import '../../features/people/domain/usecases/create_emergency_contact_usecase.dart'
    as _i580;
import '../../features/people/domain/usecases/create_employee_usecase.dart'
    as _i641;
import '../../features/people/domain/usecases/create_medical_record_usecase.dart'
    as _i527;
import '../../features/people/domain/usecases/create_member_usecase.dart'
    as _i226;
import '../../features/people/domain/usecases/create_trainer_usecase.dart'
    as _i500;
import '../../features/people/domain/usecases/delete_document_usecase.dart'
    as _i770;
import '../../features/people/domain/usecases/delete_emergency_contact_usecase.dart'
    as _i776;
import '../../features/people/domain/usecases/delete_medical_record_usecase.dart'
    as _i148;
import '../../features/people/domain/usecases/get_assigned_trainer_usecase.dart'
    as _i502;
import '../../features/people/domain/usecases/get_employee_usecase.dart'
    as _i780;
import '../../features/people/domain/usecases/get_health_info_usecase.dart'
    as _i311;
import '../../features/people/domain/usecases/get_member_usecase.dart' as _i562;
import '../../features/people/domain/usecases/get_trainer_usecase.dart'
    as _i1033;
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
import '../../features/people/domain/usecases/list_roles_usecase.dart' as _i884;
import '../../features/people/domain/usecases/list_trainers_usecase.dart'
    as _i382;
import '../../features/people/domain/usecases/set_avatar_usecase.dart'
    as _i1012;
import '../../features/people/domain/usecases/set_employee_status_usecase.dart'
    as _i392;
import '../../features/people/domain/usecases/update_emergency_contact_usecase.dart'
    as _i735;
import '../../features/people/domain/usecases/update_employee_usecase.dart'
    as _i165;
import '../../features/people/domain/usecases/update_health_info_usecase.dart'
    as _i63;
import '../../features/people/domain/usecases/update_medical_record_usecase.dart'
    as _i196;
import '../../features/people/domain/usecases/update_member_usecase.dart'
    as _i862;
import '../../features/people/domain/usecases/update_trainer_usecase.dart'
    as _i166;
import '../../features/people/domain/usecases/upload_document_usecase.dart'
    as _i438;
import '../../features/people/domain/usecases/upload_photo_usecase.dart'
    as _i78;
import '../../features/people/presentation/bloc/members_directory_bloc.dart'
    as _i415;
import '../../features/people/presentation/cubit/add_member_wizard_cubit.dart'
    as _i117;
import '../../features/people/presentation/cubit/edit_member_cubit.dart'
    as _i847;
import '../../features/people/presentation/cubit/edit_trainer_profile_cubit.dart'
    as _i551;
import '../../features/people/presentation/cubit/employee_form_cubit.dart'
    as _i888;
import '../../features/people/presentation/cubit/employee_roles_cubit.dart'
    as _i118;
import '../../features/people/presentation/cubit/employees_directory_cubit.dart'
    as _i369;
import '../../features/people/presentation/cubit/member_dossier_cubit.dart'
    as _i149;
import '../../features/people/presentation/cubit/my_trainer_profile_cubit.dart'
    as _i635;
import '../../features/people/presentation/cubit/trainer_form_cubit.dart'
    as _i20;
import '../../features/people/presentation/cubit/trainers_directory_cubit.dart'
    as _i971;
import '../../features/reports/data/datasources/report_remote_datasource.dart'
    as _i996;
import '../../features/reports/data/repositories/report_repository_impl.dart'
    as _i246;
import '../../features/reports/domain/repositories/report_repository.dart'
    as _i939;
import '../../features/reports/domain/usecases/export_report_csv_usecase.dart'
    as _i997;
import '../../features/reports/domain/usecases/get_report_usecase.dart' as _i46;
import '../../features/reports/presentation/cubit/report_cubit.dart' as _i402;
import '../../features/scheduling/data/datasources/scheduling_remote_datasource.dart'
    as _i969;
import '../../features/scheduling/data/repositories/scheduling_repository_impl.dart'
    as _i651;
import '../../features/scheduling/domain/repositories/scheduling_repository.dart'
    as _i250;
import '../../features/scheduling/domain/usecases/catalog_usecases.dart'
    as _i870;
import '../../features/scheduling/domain/usecases/schedule_usecases.dart'
    as _i777;
import '../../features/scheduling/presentation/bloc/book_schedule_bloc.dart'
    as _i300;
import '../../features/scheduling/presentation/cubit/facilities_cubit.dart'
    as _i115;
import '../../features/scheduling/presentation/cubit/open_slots_cubit.dart'
    as _i521;
import '../../features/scheduling/presentation/cubit/schedule_calendar_cubit.dart'
    as _i1056;
import '../../features/scheduling/presentation/cubit/schedule_detail_cubit.dart'
    as _i948;
import '../../features/scheduling/presentation/cubit/schedule_form_cubit.dart'
    as _i1013;
import '../../features/scheduling/presentation/cubit/schedule_history_cubit.dart'
    as _i706;
import '../../features/scheduling/presentation/cubit/todays_sessions_cubit.dart'
    as _i978;
import '../../features/scheduling/presentation/cubit/trainer_availability_cubit.dart'
    as _i1026;
import '../../features/settings/data/datasources/settings_remote_datasource.dart'
    as _i140;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/domain/usecases/get_public_settings_usecase.dart'
    as _i744;
import '../../features/settings/domain/usecases/get_settings_usecase.dart'
    as _i1032;
import '../../features/settings/domain/usecases/update_settings_usecase.dart'
    as _i474;
import '../../features/settings/presentation/cubit/settings_category_cubit.dart'
    as _i872;
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
    as _i557;
import '../../features/workout/domain/usecases/update_workout_plan_usecase.dart'
    as _i134;
import '../../features/workout/presentation/bloc/active_workout_bloc.dart'
    as _i354;
import '../../features/workout/presentation/cubit/exercise_picker_cubit.dart'
    as _i467;
import '../../features/workout/presentation/cubit/rest_timer_cubit.dart'
    as _i255;
import '../../features/workout/presentation/cubit/workout_history_cubit.dart'
    as _i251;
import '../../features/workout/presentation/cubit/workout_plan_builder_cubit.dart'
    as _i598;
import '../../features/workout/presentation/cubit/workout_plan_detail_cubit.dart'
    as _i262;
import '../../features/workout/presentation/cubit/workout_plan_list_cubit.dart'
    as _i731;
import '../../features/workout/presentation/cubit/workout_plan_versions_cubit.dart'
    as _i1063;
import '../../session/data/datasources/session_remote_datasource.dart' as _i963;
import '../../session/data/repositories/session_repository_impl.dart' as _i803;
import '../../session/domain/repositories/session_repository.dart' as _i158;
import '../../session/domain/usecases/change_password_usecase.dart' as _i455;
import '../../session/domain/usecases/forgot_password_usecase.dart' as _i587;
import '../../session/domain/usecases/get_me_usecase.dart' as _i852;
import '../../session/domain/usecases/login_usecase.dart' as _i1059;
import '../../session/domain/usecases/logout_usecase.dart' as _i3;
import '../../session/domain/usecases/refresh_session_usecase.dart' as _i898;
import '../../session/domain/usecases/reset_password_usecase.dart' as _i695;
import '../../session/domain/usecases/restore_session_usecase.dart' as _i123;
import '../../session/presentation/session_cubit.dart' as _i893;
import '../config/app_config.dart' as _i650;
import '../media/image_compressor.dart' as _i525;
import '../media/media_downloader.dart' as _i995;
import '../media/media_picker.dart' as _i763;
import '../media/media_uploader.dart' as _i510;
import '../media/signed_media_resolver.dart' as _i700;
import '../monitoring/crash_reporter.dart' as _i668;
import '../storage/token_storage.dart' as _i973;
import '../time/gym_timezone_provider.dart' as _i570;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i255.RestTimerCubit>(() => _i255.RestTimerCubit());
    gh.singleton<_i650.AppConfig>(() => registerModule.appConfig);
    gh.singleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i525.ImageCompressor>(() => _i525.ImageCompressor());
    gh.lazySingleton<_i763.MediaPicker>(() => _i763.MediaPicker());
    gh.lazySingleton<_i18.PushTokenProvider>(
      () => _i202.FcmPushTokenProvider(),
    );
    gh.singleton<_i973.TokenStorage>(
      () => registerModule.tokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i668.CrashReporter>(
      () => const _i668.NoOpCrashReporter(),
    );
    gh.lazySingleton<_i575.DeviceTokenStore>(
      () => _i808.DeviceTokenLocalStore(gh<_i558.FlutterSecureStorage>()),
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
    gh.singleton<_i633.RPTApi>(() => registerModule.rptApi(gh<_i361.Dio>()));
    gh.singleton<_i633.GOALApi>(() => registerModule.goalApi(gh<_i361.Dio>()));
    gh.singleton<_i633.NOTIFApi>(
      () => registerModule.notifApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i633.SYSApi>(() => registerModule.sysApi(gh<_i361.Dio>()));
    gh.singleton<_i633.RBACApi>(() => registerModule.rbacApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i817.DashboardRemoteDataSource>(
      () => _i817.DashboardRemoteDataSourceImpl(gh<_i633.DASHApi>()),
    );
    gh.lazySingleton<_i290.DietPlanRemoteDataSource>(
      () => _i290.DietPlanRemoteDataSourceImpl(
        gh<_i633.DIETApi>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i70.WorkoutSessionRemoteDataSource>(
      () => _i70.WorkoutSessionRemoteDataSourceImpl(
        gh<_i633.WORKApi>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i665.DashboardRepository>(
      () =>
          _i509.DashboardRepositoryImpl(gh<_i817.DashboardRemoteDataSource>()),
    );
    gh.lazySingleton<_i784.DietPlanRepository>(
      () => _i198.DietPlanRepositoryImpl(gh<_i290.DietPlanRemoteDataSource>()),
    );
    gh.lazySingleton<_i812.GoalsRemoteDataSource>(
      () => _i812.GoalsRemoteDataSourceImpl(gh<_i633.GOALApi>()),
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
    gh.lazySingleton<_i937.NotificationsRemoteDataSource>(
      () => _i937.NotificationsRemoteDataSourceImpl(gh<_i633.NOTIFApi>()),
    );
    gh.lazySingleton<_i210.ProgressNotesRepository>(
      () =>
          _i523.ProgressNotesRepositoryImpl(gh<_i812.GoalsRemoteDataSource>()),
    );
    gh.lazySingleton<_i247.MeasurementsRepository>(
      () => _i981.MeasurementsRepositoryImpl(gh<_i812.GoalsRemoteDataSource>()),
    );
    gh.lazySingleton<_i977.GoalMetricsRepository>(
      () => _i45.GoalMetricsRepositoryImpl(gh<_i812.GoalsRemoteDataSource>()),
    );
    gh.lazySingleton<_i608.GoalsRepository>(
      () => _i159.GoalsRepositoryImpl(gh<_i812.GoalsRemoteDataSource>()),
    );
    gh.lazySingleton<_i62.ListMemberGoalsUseCase>(
      () => _i62.ListMemberGoalsUseCase(gh<_i608.GoalsRepository>()),
    );
    gh.lazySingleton<_i62.GetGoalUseCase>(
      () => _i62.GetGoalUseCase(gh<_i608.GoalsRepository>()),
    );
    gh.lazySingleton<_i62.CreateMemberGoalUseCase>(
      () => _i62.CreateMemberGoalUseCase(gh<_i608.GoalsRepository>()),
    );
    gh.lazySingleton<_i62.UpdateGoalUseCase>(
      () => _i62.UpdateGoalUseCase(gh<_i608.GoalsRepository>()),
    );
    gh.lazySingleton<_i62.CheckInGoalUseCase>(
      () => _i62.CheckInGoalUseCase(gh<_i608.GoalsRepository>()),
    );
    gh.lazySingleton<_i563.NotificationsRepository>(
      () => _i201.NotificationsRepositoryImpl(
        gh<_i937.NotificationsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i133.MembershipRemoteDataSource>(
      () => _i133.MembershipRemoteDataSourceImpl(gh<_i633.MEMBApi>()),
    );
    gh.factory<_i555.GoalsListCubit>(
      () => _i555.GoalsListCubit(gh<_i62.ListMemberGoalsUseCase>()),
    );
    gh.lazySingleton<_i158.SessionRepository>(
      () => _i803.SessionRepositoryImpl(
        gh<_i963.SessionRemoteDataSource>(),
        gh<_i973.TokenStorage>(),
      ),
    );
    gh.lazySingleton<_i804.GetDashboardUseCase>(
      () => _i804.GetDashboardUseCase(gh<_i665.DashboardRepository>()),
    );
    gh.lazySingleton<_i630.UnregisterDeviceOnLogoutUseCase>(
      () => _i630.UnregisterDeviceOnLogoutUseCase(
        gh<_i563.NotificationsRepository>(),
        gh<_i575.DeviceTokenStore>(),
      ),
    );
    gh.lazySingleton<_i100.ExerciseRemoteDataSource>(
      () => _i100.ExerciseRemoteDataSourceImpl(gh<_i633.WORKApi>()),
    );
    gh.lazySingleton<_i425.AttendanceRemoteDataSource>(
      () => _i425.AttendanceRemoteDataSourceImpl(gh<_i633.ATTNApi>()),
    );
    gh.lazySingleton<_i140.SettingsRemoteDataSource>(
      () => _i140.SettingsRemoteDataSourceImpl(gh<_i633.SYSApi>()),
    );
    gh.lazySingleton<_i969.SchedulingRemoteDataSource>(
      () => _i969.SchedulingRemoteDataSourceImpl(gh<_i633.SCHEDApi>()),
    );
    gh.lazySingleton<_i995.MediaDownloader>(
      () => _i995.MediaDownloader(gh<_i700.SignedMediaResolver>()),
    );
    gh.lazySingleton<_i674.SettingsRepository>(
      () => _i955.SettingsRepositoryImpl(gh<_i140.SettingsRemoteDataSource>()),
    );
    gh.lazySingleton<_i477.AttendanceRepository>(
      () => _i719.AttendanceRepositoryImpl(
        gh<_i425.AttendanceRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i822.FoodRemoteDataSource>(
      () => _i822.FoodRemoteDataSourceImpl(gh<_i633.DIETApi>()),
    );
    gh.lazySingleton<_i1029.PeopleRemoteDataSource>(
      () => _i1029.PeopleRemoteDataSourceImpl(
        gh<_i633.PEOPLEApi>(),
        gh<_i633.RBACApi>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i773.WorkoutPlanRemoteDataSource>(
      () => _i773.WorkoutPlanRemoteDataSourceImpl(
        gh<_i633.WORKApi>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i327.ProfileRemoteDataSource>(
      () => _i327.ProfileRemoteDataSourceImpl(gh<_i633.HEALTHApi>()),
    );
    gh.lazySingleton<_i2.ListGoalMetricsUseCase>(
      () => _i2.ListGoalMetricsUseCase(gh<_i977.GoalMetricsRepository>()),
    );
    gh.lazySingleton<_i2.CreateGoalMetricUseCase>(
      () => _i2.CreateGoalMetricUseCase(gh<_i977.GoalMetricsRepository>()),
    );
    gh.lazySingleton<_i2.UpdateGoalMetricUseCase>(
      () => _i2.UpdateGoalMetricUseCase(gh<_i977.GoalMetricsRepository>()),
    );
    gh.lazySingleton<_i1019.AlertsRemoteDataSource>(
      () => _i1019.AlertsRemoteDataSourceImpl(gh<_i633.SYSApi>()),
    );
    gh.lazySingleton<_i14.WorkoutSessionRepository>(
      () => _i55.WorkoutSessionRepositoryImpl(
        gh<_i70.WorkoutSessionRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i212.DeviceTokenRegistrar>(
      () => _i576.DeviceTokenService(
        gh<_i563.NotificationsRepository>(),
        gh<_i575.DeviceTokenStore>(),
        gh<_i18.PushTokenProvider>(),
      ),
    );
    gh.lazySingleton<_i998.ArchiveDietPlanUseCase>(
      () => _i998.ArchiveDietPlanUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i529.AssignDietPlanUseCase>(
      () => _i529.AssignDietPlanUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i86.CreateDietPlanUseCase>(
      () => _i86.CreateDietPlanUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i129.GetDietMealUseCase>(
      () => _i129.GetDietMealUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i911.GetDietPlanUseCase>(
      () => _i911.GetDietPlanUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i556.ListDietPlanVersionsUseCase>(
      () => _i556.ListDietPlanVersionsUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i639.ListDietPlansUseCase>(
      () => _i639.ListDietPlansUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i820.PublishDietPlanUseCase>(
      () => _i820.PublishDietPlanUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i805.ReplaceDietPlanMealsUseCase>(
      () => _i805.ReplaceDietPlanMealsUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i186.UpdateDietPlanUseCase>(
      () => _i186.UpdateDietPlanUseCase(gh<_i784.DietPlanRepository>()),
    );
    gh.lazySingleton<_i785.DietLogRemoteDataSource>(
      () => _i785.DietLogRemoteDataSourceImpl(gh<_i633.DIETApi>()),
    );
    gh.lazySingleton<_i996.ReportRemoteDataSource>(
      () =>
          _i996.ReportRemoteDataSourceImpl(gh<_i633.RPTApi>(), gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i44.ListProgressNotesUseCase>(
      () => _i44.ListProgressNotesUseCase(gh<_i210.ProgressNotesRepository>()),
    );
    gh.lazySingleton<_i44.CreateProgressNoteUseCase>(
      () => _i44.CreateProgressNoteUseCase(gh<_i210.ProgressNotesRepository>()),
    );
    gh.factory<_i24.DashboardCubit>(
      () => _i24.DashboardCubit(gh<_i804.GetDashboardUseCase>()),
    );
    gh.lazySingleton<_i935.PaymentsRemoteDataSource>(
      () => _i935.PaymentsRemoteDataSourceImpl(gh<_i633.PAYApi>()),
    );
    gh.factory<_i1054.GoalMetricsAdminCubit>(
      () => _i1054.GoalMetricsAdminCubit(
        gh<_i2.ListGoalMetricsUseCase>(),
        gh<_i2.CreateGoalMetricUseCase>(),
        gh<_i2.UpdateGoalMetricUseCase>(),
      ),
    );
    gh.lazySingleton<_i728.FoodRepository>(
      () => _i64.FoodRepositoryImpl(gh<_i822.FoodRemoteDataSource>()),
    );
    gh.factory<_i114.GoalDetailCubit>(
      () => _i114.GoalDetailCubit(
        gh<_i62.GetGoalUseCase>(),
        gh<_i62.CheckInGoalUseCase>(),
      ),
    );
    gh.lazySingleton<_i121.ProfileRepository>(
      () => _i887.ProfileRepositoryImpl(gh<_i327.ProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i3.LogoutUseCase>(
      () => _i3.LogoutUseCase(
        gh<_i158.SessionRepository>(),
        gh<_i630.UnregisterDeviceOnLogoutUseCase>(),
      ),
    );
    gh.lazySingleton<_i586.ListMeasurementsUseCase>(
      () => _i586.ListMeasurementsUseCase(gh<_i247.MeasurementsRepository>()),
    );
    gh.lazySingleton<_i586.GetMeasurementUseCase>(
      () => _i586.GetMeasurementUseCase(gh<_i247.MeasurementsRepository>()),
    );
    gh.lazySingleton<_i586.CreateMeasurementUseCase>(
      () => _i586.CreateMeasurementUseCase(gh<_i247.MeasurementsRepository>()),
    );
    gh.lazySingleton<_i325.MembershipRepository>(
      () => _i920.MembershipRepositoryImpl(
        gh<_i133.MembershipRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i580.CreateEmergencyContactUseCase>(
      () => _i580.CreateEmergencyContactUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i527.CreateMedicalRecordUseCase>(
      () => _i527.CreateMedicalRecordUseCase(gh<_i121.ProfileRepository>()),
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
    gh.lazySingleton<_i63.UpdateHealthInfoUseCase>(
      () => _i63.UpdateHealthInfoUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i196.UpdateMedicalRecordUseCase>(
      () => _i196.UpdateMedicalRecordUseCase(gh<_i121.ProfileRepository>()),
    );
    gh.lazySingleton<_i646.PeopleRepository>(
      () => _i1030.PeopleRepositoryImpl(gh<_i1029.PeopleRemoteDataSource>()),
    );
    gh.lazySingleton<_i721.ProgressPhotosRepository>(
      () =>
          _i591.ProgressPhotosRepositoryImpl(gh<_i812.GoalsRemoteDataSource>()),
    );
    gh.lazySingleton<_i502.GetAssignedTrainerUseCase>(
      () => _i502.GetAssignedTrainerUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.factory<_i857.DietPlanVersionsCubit>(
      () =>
          _i857.DietPlanVersionsCubit(gh<_i556.ListDietPlanVersionsUseCase>()),
    );
    gh.lazySingleton<_i864.ListNotificationsUseCase>(
      () => _i864.ListNotificationsUseCase(gh<_i563.NotificationsRepository>()),
    );
    gh.lazySingleton<_i864.GetNotificationUseCase>(
      () => _i864.GetNotificationUseCase(gh<_i563.NotificationsRepository>()),
    );
    gh.lazySingleton<_i864.MarkNotificationReadUseCase>(
      () => _i864.MarkNotificationReadUseCase(
        gh<_i563.NotificationsRepository>(),
      ),
    );
    gh.lazySingleton<_i864.MarkAllNotificationsReadUseCase>(
      () => _i864.MarkAllNotificationsReadUseCase(
        gh<_i563.NotificationsRepository>(),
      ),
    );
    gh.lazySingleton<_i864.BroadcastNotificationUseCase>(
      () => _i864.BroadcastNotificationUseCase(
        gh<_i563.NotificationsRepository>(),
      ),
    );
    gh.lazySingleton<_i864.ListBroadcastsUseCase>(
      () => _i864.ListBroadcastsUseCase(gh<_i563.NotificationsRepository>()),
    );
    gh.lazySingleton<_i864.ListDevicesUseCase>(
      () => _i864.ListDevicesUseCase(gh<_i563.NotificationsRepository>()),
    );
    gh.lazySingleton<_i864.RegisterDeviceUseCase>(
      () => _i864.RegisterDeviceUseCase(gh<_i563.NotificationsRepository>()),
    );
    gh.lazySingleton<_i864.DeleteDeviceUseCase>(
      () => _i864.DeleteDeviceUseCase(gh<_i563.NotificationsRepository>()),
    );
    gh.lazySingleton<_i7.AlertsRepository>(
      () => _i56.AlertsRepositoryImpl(gh<_i1019.AlertsRemoteDataSource>()),
    );
    gh.lazySingleton<_i1065.ListSystemAlertsUseCase>(
      () => _i1065.ListSystemAlertsUseCase(gh<_i7.AlertsRepository>()),
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
    gh.lazySingleton<_i841.GetAttendanceOccupancyUseCase>(
      () =>
          _i841.GetAttendanceOccupancyUseCase(gh<_i477.AttendanceRepository>()),
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
    gh.lazySingleton<_i663.PaymentsRepository>(
      () => _i565.PaymentsRepositoryImpl(gh<_i935.PaymentsRemoteDataSource>()),
    );
    gh.factory<_i85.AttendanceSummaryCubit>(
      () => _i85.AttendanceSummaryCubit(
        gh<_i841.GetAttendanceSummaryUseCase>(),
        gh<_i841.ListAttendancesUseCase>(),
      ),
    );
    gh.lazySingleton<_i68.WorkoutPlanRepository>(
      () => _i1031.WorkoutPlanRepositoryImpl(
        gh<_i773.WorkoutPlanRemoteDataSource>(),
      ),
    );
    gh.factory<_i927.MeasurementsCubit>(
      () => _i927.MeasurementsCubit(
        gh<_i586.ListMeasurementsUseCase>(),
        gh<_i586.CreateMeasurementUseCase>(),
        gh<_i2.ListGoalMetricsUseCase>(),
      ),
    );
    gh.lazySingleton<_i455.ChangePasswordUseCase>(
      () => _i455.ChangePasswordUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i587.ForgotPasswordUseCase>(
      () => _i587.ForgotPasswordUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i852.GetMeUseCase>(
      () => _i852.GetMeUseCase(gh<_i158.SessionRepository>()),
    );
    gh.lazySingleton<_i1059.LoginUseCase>(
      () => _i1059.LoginUseCase(gh<_i158.SessionRepository>()),
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
    gh.lazySingleton<_i744.GetPublicSettingsUseCase>(
      () => _i744.GetPublicSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i1032.GetSettingsUseCase>(
      () => _i1032.GetSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i474.UpdateSettingsUseCase>(
      () => _i474.UpdateSettingsUseCase(gh<_i674.SettingsRepository>()),
    );
    gh.lazySingleton<_i570.GymTimezoneProvider>(
      () => _i570.GymTimezoneProvider(gh<_i744.GetPublicSettingsUseCase>()),
    );
    gh.factory<_i745.DietMealDetailCubit>(
      () => _i745.DietMealDetailCubit(gh<_i129.GetDietMealUseCase>()),
    );
    gh.lazySingleton<_i275.ExerciseRepository>(
      () => _i340.ExerciseRepositoryImpl(gh<_i100.ExerciseRemoteDataSource>()),
    );
    gh.lazySingleton<_i748.ListProgressPhotosUseCase>(
      () =>
          _i748.ListProgressPhotosUseCase(gh<_i721.ProgressPhotosRepository>()),
    );
    gh.lazySingleton<_i748.CreateProgressPhotoUseCase>(
      () => _i748.CreateProgressPhotoUseCase(
        gh<_i721.ProgressPhotosRepository>(),
      ),
    );
    gh.lazySingleton<_i748.DeleteProgressPhotoUseCase>(
      () => _i748.DeleteProgressPhotoUseCase(
        gh<_i721.ProgressPhotosRepository>(),
      ),
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
    gh.lazySingleton<_i557.StartWorkoutSessionUseCase>(
      () =>
          _i557.StartWorkoutSessionUseCase(gh<_i14.WorkoutSessionRepository>()),
    );
    gh.lazySingleton<_i211.DocumentRepository>(
      () => _i869.DocumentRepositoryImpl(
        gh<_i327.ProfileRemoteDataSource>(),
        gh<_i510.MediaUploader>(),
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
    gh.lazySingleton<_i939.ReportRepository>(
      () => _i246.ReportRepositoryImpl(gh<_i996.ReportRemoteDataSource>()),
    );
    gh.lazySingleton<_i250.SchedulingRepository>(
      () => _i651.SchedulingRepositoryImpl(
        gh<_i969.SchedulingRemoteDataSource>(),
      ),
    );
    gh.factory<_i839.NotificationsInboxCubit>(
      () => _i839.NotificationsInboxCubit(
        gh<_i864.ListNotificationsUseCase>(),
        gh<_i864.MarkNotificationReadUseCase>(),
        gh<_i864.MarkAllNotificationsReadUseCase>(),
        gh<_i212.DeviceTokenRegistrar>(),
      ),
    );
    gh.factory<_i104.ForgotPasswordCubit>(
      () => _i104.ForgotPasswordCubit(gh<_i587.ForgotPasswordUseCase>()),
    );
    gh.factory<_i552.NotificationDetailCubit>(
      () => _i552.NotificationDetailCubit(
        gh<_i864.GetNotificationUseCase>(),
        gh<_i864.MarkNotificationReadUseCase>(),
      ),
    );
    gh.factory<_i634.ProgressPhotosCubit>(
      () => _i634.ProgressPhotosCubit(
        gh<_i748.ListProgressPhotosUseCase>(),
        gh<_i748.CreateProgressPhotoUseCase>(),
        gh<_i748.DeleteProgressPhotoUseCase>(),
      ),
    );
    gh.factory<_i613.DietPlanListCubit>(
      () => _i613.DietPlanListCubit(gh<_i639.ListDietPlansUseCase>()),
    );
    gh.factory<_i826.FoodFormCubit>(
      () => _i826.FoodFormCubit(
        gh<_i420.CreateFoodUseCase>(),
        gh<_i897.UpdateFoodUseCase>(),
        gh<_i517.DeactivateFoodUseCase>(),
      ),
    );
    gh.factory<_i410.AttendancePassCubit>(
      () => _i410.AttendancePassCubit(
        gh<_i841.GetAttendancePassUseCase>(),
        gh<_i841.ListAttendancesUseCase>(),
        gh<_i841.CheckOutUseCase>(),
      ),
    );
    gh.factory<_i42.DietPlanDetailCubit>(
      () => _i42.DietPlanDetailCubit(
        gh<_i911.GetDietPlanUseCase>(),
        gh<_i820.PublishDietPlanUseCase>(),
        gh<_i998.ArchiveDietPlanUseCase>(),
        gh<_i529.AssignDietPlanUseCase>(),
      ),
    );
    gh.factory<_i814.GoalFormCubit>(
      () => _i814.GoalFormCubit(
        gh<_i2.ListGoalMetricsUseCase>(),
        gh<_i62.CreateMemberGoalUseCase>(),
        gh<_i62.UpdateGoalUseCase>(),
        gh<_i62.GetGoalUseCase>(),
      ),
    );
    gh.factory<_i168.FoodDetailCubit>(
      () => _i168.FoodDetailCubit(gh<_i463.GetFoodUseCase>()),
    );
    gh.lazySingleton<_i997.ExportReportCsvUseCase>(
      () => _i997.ExportReportCsvUseCase(gh<_i939.ReportRepository>()),
    );
    gh.lazySingleton<_i46.GetReportUseCase>(
      () => _i46.GetReportUseCase(gh<_i939.ReportRepository>()),
    );
    gh.factory<_i511.BroadcastCubit>(
      () => _i511.BroadcastCubit(
        gh<_i864.BroadcastNotificationUseCase>(),
        gh<_i864.ListBroadcastsUseCase>(),
      ),
    );
    gh.factory<_i33.ChangePasswordCubit>(
      () => _i33.ChangePasswordCubit(gh<_i455.ChangePasswordUseCase>()),
    );
    gh.lazySingleton<_i770.DeleteDocumentUseCase>(
      () => _i770.DeleteDocumentUseCase(gh<_i211.DocumentRepository>()),
    );
    gh.lazySingleton<_i1023.ListDocumentsUseCase>(
      () => _i1023.ListDocumentsUseCase(gh<_i211.DocumentRepository>()),
    );
    gh.lazySingleton<_i917.ListPhotosUseCase>(
      () => _i917.ListPhotosUseCase(gh<_i211.DocumentRepository>()),
    );
    gh.lazySingleton<_i1012.SetAvatarUseCase>(
      () => _i1012.SetAvatarUseCase(gh<_i211.DocumentRepository>()),
    );
    gh.lazySingleton<_i438.UploadDocumentUseCase>(
      () => _i438.UploadDocumentUseCase(gh<_i211.DocumentRepository>()),
    );
    gh.lazySingleton<_i438.CancelDocumentUploadUseCase>(
      () => _i438.CancelDocumentUploadUseCase(gh<_i211.DocumentRepository>()),
    );
    gh.lazySingleton<_i78.UploadPhotoUseCase>(
      () => _i78.UploadPhotoUseCase(gh<_i211.DocumentRepository>()),
    );
    gh.factory<_i188.ProgressNotesCubit>(
      () => _i188.ProgressNotesCubit(
        gh<_i44.ListProgressNotesUseCase>(),
        gh<_i44.CreateProgressNoteUseCase>(),
      ),
    );
    gh.lazySingleton<_i771.DietLogRepository>(
      () => _i532.DietLogRepositoryImpl(gh<_i785.DietLogRemoteDataSource>()),
    );
    gh.factory<_i261.DietPlanBuilderCubit>(
      () => _i261.DietPlanBuilderCubit(
        gh<_i911.GetDietPlanUseCase>(),
        gh<_i86.CreateDietPlanUseCase>(),
        gh<_i186.UpdateDietPlanUseCase>(),
        gh<_i805.ReplaceDietPlanMealsUseCase>(),
      ),
    );
    gh.lazySingleton<_i47.ApproveFreezeUseCase>(
      () => _i47.ApproveFreezeUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i238.CancelMembershipUseCase>(
      () => _i238.CancelMembershipUseCase(gh<_i325.MembershipRepository>()),
    );
    gh.lazySingleton<_i499.CreateMembershipProductUseCase>(
      () => _i499.CreateMembershipProductUseCase(
        gh<_i325.MembershipRepository>(),
      ),
    );
    gh.lazySingleton<_i65.CreateMembershipUseCase>(
      () => _i65.CreateMembershipUseCase(gh<_i325.MembershipRepository>()),
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
    gh.lazySingleton<_i806.RenewMembershipUseCase>(
      () => _i806.RenewMembershipUseCase(gh<_i325.MembershipRepository>()),
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
    gh.factory<_i269.MembershipRenewCubit>(
      () => _i269.MembershipRenewCubit(
        gh<_i71.GetMembershipUseCase>(),
        gh<_i359.GetMembershipProductsUseCase>(),
        gh<_i806.RenewMembershipUseCase>(),
      ),
    );
    gh.factory<_i476.ResetPasswordCubit>(
      () => _i476.ResetPasswordCubit(gh<_i695.ResetPasswordUseCase>()),
    );
    gh.factory<_i85.AttendanceHistoryCubit>(
      () => _i85.AttendanceHistoryCubit(gh<_i841.ListAttendancesUseCase>()),
    );
    gh.factory<_i407.MembershipsDirectoryCubit>(
      () => _i407.MembershipsDirectoryCubit(gh<_i370.GetMembershipsUseCase>()),
    );
    gh.factory<_i751.TrainerMembershipSummaryCubit>(
      () => _i751.TrainerMembershipSummaryCubit(
        gh<_i370.GetMembershipsUseCase>(),
      ),
    );
    gh.factory<_i710.FoodListBloc>(
      () => _i710.FoodListBloc(getFoodsUseCase: gh<_i687.GetFoodsUseCase>()),
    );
    gh.lazySingleton<_i725.AssignEmployeeRoleUseCase>(
      () => _i725.AssignEmployeeRoleUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i829.AssignTrainerUseCase>(
      () => _i829.AssignTrainerUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i641.CreateEmployeeUseCase>(
      () => _i641.CreateEmployeeUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i226.CreateMemberUseCase>(
      () => _i226.CreateMemberUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i500.CreateTrainerUseCase>(
      () => _i500.CreateTrainerUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i780.GetEmployeeUseCase>(
      () => _i780.GetEmployeeUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i562.GetMemberUseCase>(
      () => _i562.GetMemberUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i1033.GetTrainerUseCase>(
      () => _i1033.GetTrainerUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i1004.ListEmployeesUseCase>(
      () => _i1004.ListEmployeesUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i436.ListMembersUseCase>(
      () => _i436.ListMembersUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i884.ListRolesUseCase>(
      () => _i884.ListRolesUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i382.ListTrainersUseCase>(
      () => _i382.ListTrainersUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i392.SetEmployeeStatusUseCase>(
      () => _i392.SetEmployeeStatusUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i165.UpdateEmployeeUseCase>(
      () => _i165.UpdateEmployeeUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i862.UpdateMemberUseCase>(
      () => _i862.UpdateMemberUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.lazySingleton<_i166.UpdateTrainerUseCase>(
      () => _i166.UpdateTrainerUseCase(gh<_i646.PeopleRepository>()),
    );
    gh.factory<_i1024.OutstandingDuesCubit>(
      () => _i1024.OutstandingDuesCubit(
        gh<_i828.GetOutstandingPaymentsUseCase>(),
      ),
    );
    gh.factory<_i406.CheckInBloc>(
      () => _i406.CheckInBloc(gh<_i841.CheckInUseCase>()),
    );
    gh.factory<_i118.EmployeeRolesCubit>(
      () => _i118.EmployeeRolesCubit(
        gh<_i780.GetEmployeeUseCase>(),
        gh<_i884.ListRolesUseCase>(),
        gh<_i725.AssignEmployeeRoleUseCase>(),
      ),
    );
    gh.factory<_i635.MyTrainerProfileCubit>(
      () => _i635.MyTrainerProfileCubit(gh<_i502.GetAssignedTrainerUseCase>()),
    );
    gh.lazySingleton<_i1025.ListDietLogsUseCase>(
      () => _i1025.ListDietLogsUseCase(gh<_i771.DietLogRepository>()),
    );
    gh.lazySingleton<_i638.RecordDietLogUseCase>(
      () => _i638.RecordDietLogUseCase(gh<_i771.DietLogRepository>()),
    );
    gh.factory<_i452.MembershipHistoryCubit>(
      () => _i452.MembershipHistoryCubit(
        gh<_i370.GetMembershipsUseCase>(),
        gh<_i106.GetMembershipHistoryUseCase>(),
      ),
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
    gh.lazySingleton<_i870.ListFacilitiesUseCase>(
      () => _i870.ListFacilitiesUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i870.CreateFacilityUseCase>(
      () => _i870.CreateFacilityUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i870.ListScheduleTypesUseCase>(
      () => _i870.ListScheduleTypesUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i870.GetTrainerAvailabilityUseCase>(
      () =>
          _i870.GetTrainerAvailabilityUseCase(gh<_i250.SchedulingRepository>()),
    );
    gh.lazySingleton<_i870.PutTrainerAvailabilityUseCase>(
      () =>
          _i870.PutTrainerAvailabilityUseCase(gh<_i250.SchedulingRepository>()),
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
    gh.lazySingleton<_i777.UpdateScheduleUseCase>(
      () => _i777.UpdateScheduleUseCase(gh<_i250.SchedulingRepository>()),
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
    gh.factory<_i778.DietHistoryCubit>(
      () => _i778.DietHistoryCubit(gh<_i1025.ListDietLogsUseCase>()),
    );
    gh.factory<_i251.WorkoutHistoryCubit>(
      () => _i251.WorkoutHistoryCubit(gh<_i736.ListWorkoutSessionsUseCase>()),
    );
    gh.factory<_i85.AttendanceLiveFeedCubit>(
      () => _i85.AttendanceLiveFeedCubit(
        gh<_i841.ListAttendancesUseCase>(),
        gh<_i841.ListAttendanceHistoriesUseCase>(),
      ),
    );
    gh.lazySingleton<_i1062.CreateExerciseUseCase>(
      () => _i1062.CreateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i708.DeactivateExerciseUseCase>(
      () => _i708.DeactivateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i1034.GetExerciseUseCase>(
      () => _i1034.GetExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i871.GetExercisesUseCase>(
      () => _i871.GetExercisesUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.lazySingleton<_i790.UpdateExerciseUseCase>(
      () => _i790.UpdateExerciseUseCase(gh<_i275.ExerciseRepository>()),
    );
    gh.factory<_i309.MembershipCardCubit>(
      () => _i309.MembershipCardCubit(
        gh<_i370.GetMembershipsUseCase>(),
        gh<_i377.RequestMembershipFreezeUseCase>(),
      ),
    );
    gh.factory<_i731.WorkoutPlanListCubit>(
      () => _i731.WorkoutPlanListCubit(gh<_i110.ListWorkoutPlansUseCase>()),
    );
    gh.factory<_i262.WorkoutPlanDetailCubit>(
      () => _i262.WorkoutPlanDetailCubit(
        gh<_i391.GetWorkoutPlanUseCase>(),
        gh<_i553.PublishWorkoutPlanUseCase>(),
        gh<_i664.ArchiveWorkoutPlanUseCase>(),
        gh<_i60.AssignWorkoutPlanUseCase>(),
      ),
    );
    gh.factory<_i521.OpenSlotsCubit>(
      () => _i521.OpenSlotsCubit(
        gh<_i502.GetAssignedTrainerUseCase>(),
        gh<_i870.GetTrainerAvailabilityUseCase>(),
        gh<_i777.ListSchedulesUseCase>(),
      ),
    );
    gh.factory<_i853.PaymentsLedgerCubit>(
      () => _i853.PaymentsLedgerCubit(gh<_i645.GetPaymentsUseCase>()),
    );
    gh.factory<_i979.FoodPickerCubit>(
      () => _i979.FoodPickerCubit(gh<_i687.GetFoodsUseCase>()),
    );
    gh.factory<_i971.TrainersDirectoryCubit>(
      () => _i971.TrainersDirectoryCubit(gh<_i382.ListTrainersUseCase>()),
    );
    gh.singleton<_i893.SessionCubit>(
      () => _i893.SessionCubit(
        restoreSessionUseCase: gh<_i123.RestoreSessionUseCase>(),
        loginUseCase: gh<_i1059.LoginUseCase>(),
        logoutUseCase: gh<_i3.LogoutUseCase>(),
      ),
    );
    gh.factory<_i551.EditTrainerProfileCubit>(
      () => _i551.EditTrainerProfileCubit(
        gh<_i1033.GetTrainerUseCase>(),
        gh<_i166.UpdateTrainerUseCase>(),
      ),
    );
    gh.factory<_i415.MembersDirectoryBloc>(
      () => _i415.MembersDirectoryBloc(gh<_i436.ListMembersUseCase>()),
    );
    gh.factory<_i449.SystemAlertsCubit>(
      () => _i449.SystemAlertsCubit(gh<_i1065.ListSystemAlertsUseCase>()),
    );
    gh.factory<_i144.PaymentDetailCubit>(
      () => _i144.PaymentDetailCubit(gh<_i835.GetPaymentUseCase>()),
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
        gh<_i777.UpdateScheduleUseCase>(),
      ),
    );
    gh.factory<_i1026.TrainerAvailabilityCubit>(
      () => _i1026.TrainerAvailabilityCubit(
        gh<_i870.GetTrainerAvailabilityUseCase>(),
        gh<_i870.PutTrainerAvailabilityUseCase>(),
      ),
    );
    gh.factory<_i879.MembershipFreezeCubit>(
      () => _i879.MembershipFreezeCubit(
        gh<_i370.GetMembershipsUseCase>(),
        gh<_i590.GetMembershipFreezesUseCase>(),
        gh<_i47.ApproveFreezeUseCase>(),
        gh<_i223.RejectFreezeUseCase>(),
      ),
    );
    gh.factory<_i20.TrainerFormCubit>(
      () => _i20.TrainerFormCubit(gh<_i500.CreateTrainerUseCase>()),
    );
    gh.factory<_i791.PaymentMethodsCubit>(
      () => _i791.PaymentMethodsCubit(
        gh<_i789.GetPaymentMethodsUseCase>(),
        gh<_i66.CreatePaymentMethodUseCase>(),
      ),
    );
    gh.factory<_i300.BookScheduleBloc>(
      () => _i300.BookScheduleBloc(gh<_i777.BookScheduleUseCase>()),
    );
    gh.factory<_i847.EditMemberCubit>(
      () => _i847.EditMemberCubit(
        gh<_i562.GetMemberUseCase>(),
        gh<_i862.UpdateMemberUseCase>(),
      ),
    );
    gh.factory<_i117.AddMemberWizardCubit>(
      () => _i117.AddMemberWizardCubit(gh<_i226.CreateMemberUseCase>()),
    );
    gh.factory<_i872.SettingsCategoryCubit>(
      () => _i872.SettingsCategoryCubit(
        gh<_i1032.GetSettingsUseCase>(),
        gh<_i474.UpdateSettingsUseCase>(),
      ),
    );
    gh.factory<_i1013.ScheduleFormCubit>(
      () => _i1013.ScheduleFormCubit(
        gh<_i777.CreateScheduleUseCase>(),
        gh<_i777.UpdateScheduleUseCase>(),
        gh<_i777.GetScheduleUseCase>(),
        gh<_i870.ListScheduleTypesUseCase>(),
        gh<_i870.ListFacilitiesUseCase>(),
        gh<_i1033.GetTrainerUseCase>(),
      ),
    );
    gh.factory<_i854.MembershipDetailCubit>(
      () => _i854.MembershipDetailCubit(
        gh<_i71.GetMembershipUseCase>(),
        gh<_i806.RenewMembershipUseCase>(),
        gh<_i238.CancelMembershipUseCase>(),
        gh<_i227.ExtendMembershipUseCase>(),
        gh<_i617.UpgradeMembershipUseCase>(),
      ),
    );
    gh.factory<_i354.ActiveWorkoutBloc>(
      () => _i354.ActiveWorkoutBloc(
        gh<_i557.StartWorkoutSessionUseCase>(),
        gh<_i88.LogWorkoutSetUseCase>(),
        gh<_i57.CompleteWorkoutSessionUseCase>(),
        gh<_i391.GetWorkoutPlanUseCase>(),
        gh<_i255.RestTimerCubit>(),
      ),
    );
    gh.factory<_i402.ReportCubit>(
      () => _i402.ReportCubit(
        gh<_i46.GetReportUseCase>(),
        gh<_i997.ExportReportCsvUseCase>(),
      ),
    );
    gh.factory<_i153.MembershipProductFormCubit>(
      () => _i153.MembershipProductFormCubit(
        gh<_i499.CreateMembershipProductUseCase>(),
        gh<_i30.UpdateMembershipProductUseCase>(),
      ),
    );
    gh.factory<_i69.LoginCubit>(
      () => _i69.LoginCubit(gh<_i893.SessionCubit>()),
    );
    gh.factory<_i149.MemberDossierCubit>(
      () => _i149.MemberDossierCubit(
        gh<_i562.GetMemberUseCase>(),
        gh<_i862.UpdateMemberUseCase>(),
        gh<_i829.AssignTrainerUseCase>(),
      ),
    );
    gh.factory<_i369.EmployeesDirectoryCubit>(
      () => _i369.EmployeesDirectoryCubit(gh<_i1004.ListEmployeesUseCase>()),
    );
    gh.factory<_i888.EmployeeFormCubit>(
      () => _i888.EmployeeFormCubit(
        gh<_i641.CreateEmployeeUseCase>(),
        gh<_i165.UpdateEmployeeUseCase>(),
        gh<_i780.GetEmployeeUseCase>(),
        gh<_i884.ListRolesUseCase>(),
        gh<_i392.SetEmployeeStatusUseCase>(),
      ),
    );
    gh.factory<_i467.ExercisePickerCubit>(
      () => _i467.ExercisePickerCubit(gh<_i871.GetExercisesUseCase>()),
    );
    gh.factory<_i115.FacilitiesCubit>(
      () => _i115.FacilitiesCubit(
        gh<_i870.ListFacilitiesUseCase>(),
        gh<_i870.CreateFacilityUseCase>(),
      ),
    );
    gh.factory<_i1069.MembershipPackagesCatalogCubit>(
      () => _i1069.MembershipPackagesCatalogCubit(
        gh<_i359.GetMembershipProductsUseCase>(),
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
    gh.factory<_i1056.ScheduleCalendarCubit>(
      () => _i1056.ScheduleCalendarCubit(gh<_i777.ListSchedulesUseCase>()),
    );
    gh.factory<_i706.ScheduleHistoryCubit>(
      () => _i706.ScheduleHistoryCubit(gh<_i777.ListSchedulesUseCase>()),
    );
    gh.factory<_i978.TodaysSessionsCubit>(
      () => _i978.TodaysSessionsCubit(gh<_i777.ListSchedulesUseCase>()),
    );
    gh.factory<_i628.DashboardAgendaCubit>(
      () => _i628.DashboardAgendaCubit(
        gh<_i777.ListSchedulesUseCase>(),
        gh<_i570.GymTimezoneProvider>(),
      ),
    );
    gh.factory<_i756.ExerciseDetailCubit>(
      () => _i756.ExerciseDetailCubit(gh<_i1034.GetExerciseUseCase>()),
    );
    gh.factory<_i203.MembershipFreezeFormCubit>(
      () => _i203.MembershipFreezeFormCubit(
        gh<_i71.GetMembershipUseCase>(),
        gh<_i377.RequestMembershipFreezeUseCase>(),
      ),
    );
    gh.factory<_i982.DietDailyLogCubit>(
      () => _i982.DietDailyLogCubit(
        gh<_i638.RecordDietLogUseCase>(),
        gh<_i1025.ListDietLogsUseCase>(),
        gh<_i639.ListDietPlansUseCase>(),
      ),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i893.SessionCubit>()),
    );
    gh.factory<_i632.CreateMembershipBloc>(
      () => _i632.CreateMembershipBloc(
        gh<_i65.CreateMembershipUseCase>(),
        gh<_i359.GetMembershipProductsUseCase>(),
        gh<_i436.ListMembersUseCase>(),
      ),
    );
    gh.factory<_i1063.WorkoutPlanVersionsCubit>(
      () => _i1063.WorkoutPlanVersionsCubit(
        gh<_i516.ListWorkoutPlanVersionsUseCase>(),
      ),
    );
    gh.factory<_i554.ExerciseFormCubit>(
      () => _i554.ExerciseFormCubit(
        gh<_i1062.CreateExerciseUseCase>(),
        gh<_i790.UpdateExerciseUseCase>(),
        gh<_i708.DeactivateExerciseUseCase>(),
      ),
    );
    gh.factory<_i757.ExerciseListBloc>(
      () => _i757.ExerciseListBloc(
        getExercisesUseCase: gh<_i871.GetExercisesUseCase>(),
      ),
    );
    gh.lazySingleton<_i287.FcmMessagingService>(
      () => _i287.FcmMessagingService(
        gh<_i18.PushTokenProvider>(),
        gh<_i212.DeviceTokenRegistrar>(),
        gh<_i583.GoRouter>(),
        gh<_i893.SessionCubit>(),
      ),
      dispose: (i) => i.dispose(),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
