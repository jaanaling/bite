import 'package:application/src/core/dependency_injection.dart';
import 'package:application/src/core/utils/log.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/feature/recipe/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository = locator<RecipeRepository>();

  RecipeBloc() : super(RecipeInitial()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<AddRecipe>(_onAddRecipe);
    on<RemoveRecipe>(_onRemoveRecipe);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadRecipes(
    LoadRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipes = await repository.loadRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to load recipes'));
    }
  }

  Future<void> _onAddRecipe(AddRecipe event, Emitter<RecipeState> emit) async {
    await repository.addRecipe(event.recipe);
    add(LoadRecipes());
  }

  Future<void> _onRemoveRecipe(
    RemoveRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    await repository.removeRecipe(event.name);
    add(LoadRecipes());
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<RecipeState> emit,
  ) async {
    await repository.toggleFavorite(event.name);
    add(LoadRecipes());
  }
}
