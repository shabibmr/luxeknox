import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for DIETApi
void main() {
  final instance = ApiClient().getDIETApi();

  group(DIETApi, () {
    // Copy a template onto a member
    //
    //Future<DietPlan> assignDietPlan(int id, AssignPlanRequest assignPlanRequest) async
    test('test assignDietPlan', () async {
      // TODO
    });

    // Create a diet plan (also creates version 1)
    //
    //Future<DietPlan> createDietPlan(DietPlanWrite dietPlanWrite) async
    test('test createDietPlan', () async {
      // TODO
    });

    // Create a food
    //
    //Future<Food> createFood(FoodWrite foodWrite) async
    test('test createFood', () async {
      // TODO
    });

    // Plan with current version meals
    //
    //Future<DietPlan> getDietPlan(int id) async
    test('test getDietPlan', () async {
      // TODO
    });

    // Food detail
    //
    //Future<Food> getFood(int id) async
    test('test getFood', () async {
      // TODO
    });

    // Diet adherence history
    //
    //Future<DietLogPage> listDietLogs(int id, { int limit, String cursor }) async
    test('test listDietLogs', () async {
      // TODO
    });

    // Diet plan versions
    //
    //Future<DietPlanVersionPage> listDietPlanVersions(int id) async
    test('test listDietPlanVersions', () async {
      // TODO
    });

    // Diet plans and templates
    //
    //Future<DietPlanPage> listDietPlans({ int limit, int offset, int memberId, bool isTemplate }) async
    test('test listDietPlans', () async {
      // TODO
    });

    // Food library
    //
    //Future<FoodPage> listFoods({ int limit, int offset, String q }) async
    test('test listFoods', () async {
      // TODO
    });

    // Publish a draft diet plan
    //
    //Future<DietPlan> publishDietPlan(int id) async
    test('test publishDietPlan', () async {
      // TODO
    });

    // Upsert a day's intake log
    //
    //Future<DietLog> putDietLog(int id, Date date, DietLogWrite dietLogWrite) async
    test('test putDietLog', () async {
      // TODO
    });

    // Replace current-version meals (inserts a new version)
    //
    //Future<DietPlan> replaceDietPlanMeals(int id, DietPlanMealsWrite dietPlanMealsWrite) async
    test('test replaceDietPlanMeals', () async {
      // TODO
    });

    // Update diet plan metadata (requires row_version)
    //
    //Future<DietPlan> updateDietPlan(int id, DietPlanWrite dietPlanWrite) async
    test('test updateDietPlan', () async {
      // TODO
    });

    // Update a food
    //
    //Future<Food> updateFood(int id, FoodWrite foodWrite) async
    test('test updateFood', () async {
      // TODO
    });

  });
}
