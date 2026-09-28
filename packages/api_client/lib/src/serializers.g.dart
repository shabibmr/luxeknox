// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add($Member.serializer)
      ..add(AssignPlanRequest.serializer)
      ..add(AssignRoleRequest.serializer)
      ..add(AssignTrainerRequest.serializer)
      ..add(Attendance.serializer)
      ..add(AttendanceHistory.serializer)
      ..add(AttendanceHistoryPage.serializer)
      ..add(AttendanceMethod.serializer)
      ..add(AttendancePage.serializer)
      ..add(AttendancePass.serializer)
      ..add(AttendanceSummary.serializer)
      ..add(AuditLog.serializer)
      ..add(AuditLogPage.serializer)
      ..add(BookRequest.serializer)
      ..add(BroadcastRequest.serializer)
      ..add(BroadcastRequestAudienceEnum.serializer)
      ..add(CancelBookingRequest.serializer)
      ..add(CancelRequest.serializer)
      ..add(ChangePasswordRequest.serializer)
      ..add(CheckInRequest.serializer)
      ..add(Dashboard.serializer)
      ..add(Device.serializer)
      ..add(DeviceDevicePlatformEnum.serializer)
      ..add(DevicePage.serializer)
      ..add(DeviceWrite.serializer)
      ..add(DeviceWriteDevicePlatformEnum.serializer)
      ..add(DietLog.serializer)
      ..add(DietLogPage.serializer)
      ..add(DietLogWrite.serializer)
      ..add(DietPlan.serializer)
      ..add(DietPlanFood.serializer)
      ..add(DietPlanMeal.serializer)
      ..add(DietPlanMealsWrite.serializer)
      ..add(DietPlanMealsWriteMealsInner.serializer)
      ..add(DietPlanMealsWriteMealsInnerFoodsInner.serializer)
      ..add(DietPlanPage.serializer)
      ..add(DietPlanStatusEnum.serializer)
      ..add(DietPlanVersion.serializer)
      ..add(DietPlanVersionPage.serializer)
      ..add(DietPlanWrite.serializer)
      ..add(EmergencyContact.serializer)
      ..add(EmergencyContactPage.serializer)
      ..add(EmergencyContactWrite.serializer)
      ..add(Employee.serializer)
      ..add(EmployeeCreate.serializer)
      ..add(EmployeePage.serializer)
      ..add(EmployeeStatus.serializer)
      ..add(EmployeeStatusRequest.serializer)
      ..add(EmployeeUpdate.serializer)
      ..add(ErrorBody.serializer)
      ..add(ErrorCode.serializer)
      ..add(ErrorDetail.serializer)
      ..add(Exercise.serializer)
      ..add(ExercisePage.serializer)
      ..add(ExerciseWrite.serializer)
      ..add(Facility.serializer)
      ..add(FacilityPage.serializer)
      ..add(FacilityWrite.serializer)
      ..add(Food.serializer)
      ..add(FoodPage.serializer)
      ..add(FoodWrite.serializer)
      ..add(ForgotPasswordRequest.serializer)
      ..add(Goal.serializer)
      ..add(GoalCheckInWrite.serializer)
      ..add(GoalHistory.serializer)
      ..add(GoalMetric.serializer)
      ..add(GoalMetricCategoryEnum.serializer)
      ..add(GoalMetricPage.serializer)
      ..add(GoalMetricWrite.serializer)
      ..add(GoalMetricWriteCategoryEnum.serializer)
      ..add(GoalPage.serializer)
      ..add(GoalStatusEnum.serializer)
      ..add(GoalWrite.serializer)
      ..add(GoalWriteStatusEnum.serializer)
      ..add(Health.serializer)
      ..add(HealthCondition.serializer)
      ..add(HealthConditionPage.serializer)
      ..add(HealthConditionWrite.serializer)
      ..add(HealthStatusEnum.serializer)
      ..add(LoginRequest.serializer)
      ..add(LogoutRequest.serializer)
      ..add(LongitudinalDataPoint.serializer)
      ..add(ManualOverrideRequest.serializer)
      ..add(MarkAttendanceRequest.serializer)
      ..add(MeResponse.serializer)
      ..add(MeResponseProfile.serializer)
      ..add(Measurement.serializer)
      ..add(MeasurementPage.serializer)
      ..add(MeasurementValue.serializer)
      ..add(MeasurementWrite.serializer)
      ..add(MediaDownload.serializer)
      ..add(MediaUpload.serializer)
      ..add(MediaUploadRequest.serializer)
      ..add(MediaUploadRequestPurposeEnum.serializer)
      ..add(MedicalHistory.serializer)
      ..add(MedicalHistoryPage.serializer)
      ..add(MedicalHistoryWrite.serializer)
      ..add(MemberCreate.serializer)
      ..add(MemberDocument.serializer)
      ..add(MemberDocumentDocumentTypeEnum.serializer)
      ..add(MemberDocumentPage.serializer)
      ..add(MemberDocumentWrite.serializer)
      ..add(MemberDocumentWriteDocumentTypeEnum.serializer)
      ..add(MemberDossier.serializer)
      ..add(MemberHealth.serializer)
      ..add(MemberHealthWrite.serializer)
      ..add(MemberPage.serializer)
      ..add(MemberPhoto.serializer)
      ..add(MemberPhotoPage.serializer)
      ..add(MemberPhotoWrite.serializer)
      ..add(MemberUpdate.serializer)
      ..add(Membership.serializer)
      ..add(MembershipActionRequest.serializer)
      ..add(MembershipCreate.serializer)
      ..add(MembershipExtension.serializer)
      ..add(MembershipExtensionWrite.serializer)
      ..add(MembershipFreeze.serializer)
      ..add(MembershipFreezePage.serializer)
      ..add(MembershipFreezeStatusEnum.serializer)
      ..add(MembershipFreezeWrite.serializer)
      ..add(MembershipHistory.serializer)
      ..add(MembershipHistoryActionEnum.serializer)
      ..add(MembershipHistoryPage.serializer)
      ..add(MembershipPage.serializer)
      ..add(MembershipProduct.serializer)
      ..add(MembershipProductPage.serializer)
      ..add(MembershipProductWrite.serializer)
      ..add(MembershipStatus.serializer)
      ..add(Notification.serializer)
      ..add(NotificationPage.serializer)
      ..add(Occupancy.serializer)
      ..add(OccupancyByGateInner.serializer)
      ..add(PageMeta.serializer)
      ..add(Payment.serializer)
      ..add(PaymentAdjustRequest.serializer)
      ..add(PaymentCreate.serializer)
      ..add(PaymentHistory.serializer)
      ..add(PaymentHistoryActionEnum.serializer)
      ..add(PaymentMethod.serializer)
      ..add(PaymentMethodPage.serializer)
      ..add(PaymentMethodWrite.serializer)
      ..add(PaymentPage.serializer)
      ..add(PaymentReceipt.serializer)
      ..add(PaymentStatus.serializer)
      ..add(Permission.serializer)
      ..add(PermissionAction.serializer)
      ..add(PermissionPage.serializer)
      ..add(PersonalRecord.serializer)
      ..add(Principal.serializer)
      ..add(ProgressNote.serializer)
      ..add(ProgressNoteNoteTypeEnum.serializer)
      ..add(ProgressNotePage.serializer)
      ..add(ProgressNoteWrite.serializer)
      ..add(ProgressNoteWriteNoteTypeEnum.serializer)
      ..add(ProgressPhoto.serializer)
      ..add(ProgressPhotoComparison.serializer)
      ..add(ProgressPhotoComparisonComparisonByPose.serializer)
      ..add(ProgressPhotoComparisonPosePair.serializer)
      ..add(ProgressPhotoPage.serializer)
      ..add(ProgressPhotoPoseEnum.serializer)
      ..add(ProgressPhotoWrite.serializer)
      ..add(ProgressPhotoWritePoseEnum.serializer)
      ..add(PublicSettings.serializer)
      ..add(Ready.serializer)
      ..add(ReadyDatabaseEnum.serializer)
      ..add(ReadyJobs.serializer)
      ..add(ReadyStatusEnum.serializer)
      ..add(RefreshRequest.serializer)
      ..add(RejectRequest.serializer)
      ..add(Report.serializer)
      ..add(ReportType.serializer)
      ..add(ResetPasswordRequest.serializer)
      ..add(Role.serializer)
      ..add(RolePage.serializer)
      ..add(RolePermissionsWrite.serializer)
      ..add(RoleWrite.serializer)
      ..add(Schedule.serializer)
      ..add(ScheduleHistory.serializer)
      ..add(ScheduleHistoryPage.serializer)
      ..add(SchedulePage.serializer)
      ..add(ScheduleParticipant.serializer)
      ..add(ScheduleParticipantBookingStatusEnum.serializer)
      ..add(ScheduleStatus.serializer)
      ..add(ScheduleType.serializer)
      ..add(ScheduleTypePage.serializer)
      ..add(ScheduleTypeWrite.serializer)
      ..add(ScheduleWrite.serializer)
      ..add(SessionResponse.serializer)
      ..add(Setting.serializer)
      ..add(SettingCategory.serializer)
      ..add(SettingsList.serializer)
      ..add(SettingsWrite.serializer)
      ..add(SettingsWriteItemsInner.serializer)
      ..add(TenderLine.serializer)
      ..add(Trainer.serializer)
      ..add(TrainerAvailability.serializer)
      ..add(TrainerAvailabilityPage.serializer)
      ..add(TrainerAvailabilityWrite.serializer)
      ..add(TrainerCreate.serializer)
      ..add(TrainerPage.serializer)
      ..add(TrainerUpdate.serializer)
      ..add(User.serializer)
      ..add(UserStatus.serializer)
      ..add(UserType.serializer)
      ..add(WorkoutPlan.serializer)
      ..add(WorkoutPlanExercise.serializer)
      ..add(WorkoutPlanExercisesWrite.serializer)
      ..add(WorkoutPlanExercisesWriteExercisesInner.serializer)
      ..add(WorkoutPlanPage.serializer)
      ..add(WorkoutPlanStatusEnum.serializer)
      ..add(WorkoutPlanVersion.serializer)
      ..add(WorkoutPlanVersionPage.serializer)
      ..add(WorkoutPlanWrite.serializer)
      ..add(WorkoutSession.serializer)
      ..add(WorkoutSessionCreate.serializer)
      ..add(WorkoutSessionExercise.serializer)
      ..add(WorkoutSessionPage.serializer)
      ..add(WorkoutSetWrite.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Attendance)]),
          () => ListBuilder<Attendance>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AttendanceHistory)]),
          () => ListBuilder<AttendanceHistory>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AuditLog)]),
          () => ListBuilder<AuditLog>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Device)]),
          () => ListBuilder<Device>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DietLog)]),
          () => ListBuilder<DietLog>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DietPlan)]),
          () => ListBuilder<DietPlan>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DietPlanFood)]),
          () => ListBuilder<DietPlanFood>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DietPlanMeal)]),
          () => ListBuilder<DietPlanMeal>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DietPlanMealsWriteMealsInner)]),
          () => ListBuilder<DietPlanMealsWriteMealsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DietPlanMealsWriteMealsInnerFoodsInner)]),
          () => ListBuilder<DietPlanMealsWriteMealsInnerFoodsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DietPlanVersion)]),
          () => ListBuilder<DietPlanVersion>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EmergencyContact)]),
          () => ListBuilder<EmergencyContact>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Employee)]),
          () => ListBuilder<Employee>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ErrorDetail)]),
          () => ListBuilder<ErrorDetail>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Exercise)]),
          () => ListBuilder<Exercise>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Facility)]),
          () => ListBuilder<Facility>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Food)]),
          () => ListBuilder<Food>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Goal)]),
          () => ListBuilder<Goal>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GoalMetric)]),
          () => ListBuilder<GoalMetric>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(HealthCondition)]),
          () => ListBuilder<HealthCondition>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Measurement)]),
          () => ListBuilder<Measurement>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MeasurementValue)]),
          () => ListBuilder<MeasurementValue>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MeasurementValue)]),
          () => ListBuilder<MeasurementValue>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MedicalHistory)]),
          () => ListBuilder<MedicalHistory>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Member)]),
          () => ListBuilder<Member>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberDocument)]),
          () => ListBuilder<MemberDocument>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MemberPhoto)]),
          () => ListBuilder<MemberPhoto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Membership)]),
          () => ListBuilder<Membership>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MembershipFreeze)]),
          () => ListBuilder<MembershipFreeze>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MembershipHistory)]),
          () => ListBuilder<MembershipHistory>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MembershipProduct)]),
          () => ListBuilder<MembershipProduct>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Notification)]),
          () => ListBuilder<Notification>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(OccupancyByGateInner)]),
          () => ListBuilder<OccupancyByGateInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Payment)]),
          () => ListBuilder<Payment>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PaymentHistory)]),
          () => ListBuilder<PaymentHistory>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PaymentMethod)]),
          () => ListBuilder<PaymentMethod>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Permission)]),
          () => ListBuilder<Permission>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Permission)]),
          () => ListBuilder<Permission>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProgressNote)]),
          () => ListBuilder<ProgressNote>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProgressPhoto)]),
          () => ListBuilder<ProgressPhoto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProgressPhoto)]),
          () => ListBuilder<ProgressPhoto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProgressPhoto)]),
          () => ListBuilder<ProgressPhoto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Role)]),
          () => ListBuilder<Role>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Schedule)]),
          () => ListBuilder<Schedule>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ScheduleHistory)]),
          () => ListBuilder<ScheduleHistory>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ScheduleParticipant)]),
          () => ListBuilder<ScheduleParticipant>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ScheduleType)]),
          () => ListBuilder<ScheduleType>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Setting)]),
          () => ListBuilder<Setting>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SettingsWriteItemsInner)]),
          () => ListBuilder<SettingsWriteItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TenderLine)]),
          () => ListBuilder<TenderLine>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Trainer)]),
          () => ListBuilder<Trainer>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(TrainerAvailability)]),
          () => ListBuilder<TrainerAvailability>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(TrainerAvailability)]),
          () => ListBuilder<TrainerAvailability>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(WorkoutPlan)]),
          () => ListBuilder<WorkoutPlan>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(WorkoutPlanExercise)]),
          () => ListBuilder<WorkoutPlanExercise>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(WorkoutPlanExercisesWriteExercisesInner)]),
          () => ListBuilder<WorkoutPlanExercisesWriteExercisesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(WorkoutPlanVersion)]),
          () => ListBuilder<WorkoutPlanVersion>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(WorkoutSession)]),
          () => ListBuilder<WorkoutSession>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(WorkoutSessionExercise)]),
          () => ListBuilder<WorkoutSessionExercise>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
