import 'package:application/src/feature/recipe/repository/repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupDependencyInjection() {
  locator.registerSingleton(RecipeRepository());
}
