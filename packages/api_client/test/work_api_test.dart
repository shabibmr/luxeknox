import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for WORKApi
void main() {
  final instance = ApiClient().getWORKApi();

  group(WORKApi, () {
    // Copy a template onto a member (new plan + version 1)
    //
    //Future<WorkoutPlan> assignWorkoutPlan(int id, AssignPlanRequest assignPlanRequest) async
    test('test assignWorkoutPlan', () async {
      // TODO
    });

    // Complete a session
    //
    //Future<WorkoutSession> completeWorkoutSession(int id) async
    test('test completeWorkoutSession', () async {
      // TODO
    });

    // Create an exercise
    //
    //Future<Exercise> createExercise(ExerciseWrite exerciseWrite) async
    test('test createExercise', () async {
      // TODO
    });

    // Create a plan (also creates version 1)
    //
    //Future<WorkoutPlan> createWorkoutPlan(WorkoutPlanWrite workoutPlanWrite) async
    test('test createWorkoutPlan', () async {
      // TODO
    });

    // Exercise detail
    //
    //Future<Exercise> getExercise(int id) async
    test('test getExercise', () async {
      // TODO
    });

    // Plan with current version line items
    //
    //Future<WorkoutPlan> getWorkoutPlan(int id) async
    test('test getWorkoutPlan', () async {
      // TODO
    });

    // Exercise library
    //
    //Future<ExercisePage> listExercises({ int limit, int offset, String q, String primaryMuscleGroup, String equipmentNeeded, String difficultyLevel }) async
    test('test listExercises', () async {
      // TODO
    });

    // Plan version snapshots
    //
    //Future<WorkoutPlanVersionPage> listWorkoutPlanVersions(int id) async
    test('test listWorkoutPlanVersions', () async {
      // TODO
    });

    // Workout plans and templates
    //
    //Future<WorkoutPlanPage> listWorkoutPlans({ int limit, int offset, int memberId, bool isTemplate }) async
    test('test listWorkoutPlans', () async {
      // TODO
    });

    // Workout history
    //
    //Future<WorkoutSessionPage> listWorkoutSessions({ int limit, String cursor, int memberId }) async
    test('test listWorkoutSessions', () async {
      // TODO
    });

    // Log a set
    //
    //Future<WorkoutSessionExercise> logWorkoutSet(int id, WorkoutSetWrite workoutSetWrite) async
    test('test logWorkoutSet', () async {
      // TODO
    });

    // Publish a draft plan
    //
    //Future<WorkoutPlan> publishWorkoutPlan(int id) async
    test('test publishWorkoutPlan', () async {
      // TODO
    });

    // Replace current-version line items (inserts a new version)
    //
    //Future<WorkoutPlan> replaceWorkoutPlanExercises(int id, WorkoutPlanExercisesWrite workoutPlanExercisesWrite) async
    test('test replaceWorkoutPlanExercises', () async {
      // TODO
    });

    // Start a live session
    //
    //Future<WorkoutSession> startWorkoutSession(WorkoutSessionCreate workoutSessionCreate) async
    test('test startWorkoutSession', () async {
      // TODO
    });

    // Update or deactivate an exercise
    //
    //Future<Exercise> updateExercise(int id, ExerciseWrite exerciseWrite) async
    test('test updateExercise', () async {
      // TODO
    });

    // Update plan metadata (requires row_version)
    //
    //Future<WorkoutPlan> updateWorkoutPlan(int id, WorkoutPlanWrite workoutPlanWrite) async
    test('test updateWorkoutPlan', () async {
      // TODO
    });

  });
}
