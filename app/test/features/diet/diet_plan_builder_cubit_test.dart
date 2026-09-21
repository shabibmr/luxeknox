import 'package:app/features/diet/domain/entities/diet_plan.dart';
import 'package:app/features/diet/domain/entities/diet_plan_status.dart';
import 'package:app/features/diet/domain/usecases/create_diet_plan_usecase.dart';
import 'package:app/features/diet/domain/usecases/get_diet_plan_usecase.dart';
import 'package:app/features/diet/domain/usecases/replace_diet_plan_meals_usecase.dart';
import 'package:app/features/diet/domain/usecases/update_diet_plan_usecase.dart';
import 'package:app/features/diet/presentation/cubit/diet_plan_builder_cubit.dart';
import 'package:app/features/foods/domain/entities/food.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGet extends Mock implements GetDietPlanUseCase {}

class _MockCreate extends Mock implements CreateDietPlanUseCase {}

class _MockUpdate extends Mock implements UpdateDietPlanUseCase {}

class _MockReplace extends Mock implements ReplaceDietPlanMealsUseCase {}

void main() {
  late _MockGet getPlan;
  late _MockCreate createPlan;
  late _MockUpdate updatePlan;
  late _MockReplace replaceMeals;

  setUpAll(() {
    registerFallbackValue(
      const CreateDietPlanParams(title: 'x'),
    );
    registerFallbackValue(
      const UpdateDietPlanParams(id: '1', rowVersion: 1),
    );
    registerFallbackValue(
      const ReplaceDietPlanMealsParams(id: '1', rowVersion: 1, meals: []),
    );
  });

  setUp(() {
    getPlan = _MockGet();
    createPlan = _MockCreate();
    updatePlan = _MockUpdate();
    replaceMeals = _MockReplace();
  });

  DietPlanBuilderCubit buildCubit() => DietPlanBuilderCubit(
        getPlan,
        createPlan,
        updatePlan,
        replaceMeals,
      );

  blocTest<DietPlanBuilderCubit, DietPlanBuilderState>(
    'init without planId emits empty ready state',
    build: buildCubit,
    act: (cubit) => cubit.init(),
    expect: () => [
      isA<DietPlanBuilderReady>()
          .having((s) => s.title, 'title', '')
          .having((s) => s.meals, 'meals', isEmpty),
    ],
  );

  blocTest<DietPlanBuilderCubit, DietPlanBuilderState>(
    'addMeal / addFood / save create+replace path',
    build: () {
      when(() => createPlan(any())).thenAnswer(
        (_) async => const Right(
          DietPlan(
            id: '9',
            title: 'Cut',
            isTemplate: false,
            status: DietPlanStatus.draft,
            rowVersion: 1,
          ),
        ),
      );
      when(() => replaceMeals(any())).thenAnswer(
        (_) async => const Right(
          DietPlan(
            id: '9',
            title: 'Cut',
            isTemplate: false,
            status: DietPlanStatus.draft,
            rowVersion: 2,
            meals: [],
          ),
        ),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.init();
      cubit.setTitle('Cut');
      cubit.addMeal(mealName: 'Breakfast');
      final ready = cubit.state as DietPlanBuilderReady;
      cubit.addFood(
        ready.meals.first.key,
        const Food(
          id: '3',
          name: 'Egg',
          servingUnit: 'g',
          calories: 70,
          proteinGrams: 6,
          carbsGrams: 1,
          fatGrams: 5,
          isVerified: true,
        ),
      );
      await cubit.save();
    },
    expect: () => [
      isA<DietPlanBuilderReady>(),
      isA<DietPlanBuilderReady>().having((s) => s.title, 'title', 'Cut'),
      isA<DietPlanBuilderReady>().having((s) => s.meals.length, 'meals', 1),
      isA<DietPlanBuilderReady>().having(
        (s) => s.meals.first.foods.length,
        'foods',
        1,
      ),
      isA<DietPlanBuilderReady>().having((s) => s.saving, 'saving', true),
      isA<DietPlanBuilderReady>()
          .having((s) => s.planId, 'planId', '9')
          .having((s) => s.dirty, 'dirty', false)
          .having((s) => s.saving, 'saving', false),
    ],
  );
}
