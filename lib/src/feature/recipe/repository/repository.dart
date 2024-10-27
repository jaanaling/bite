import 'package:application/src/core/utils/log.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecipeRepository {
  final String _recipesKey = 'recipes';
  List<Dessert> _recipes = [];

  Future<List<Dessert>> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Dessert> recipes = await _getRecipesFromPrefs(prefs);
    logger.d(recipes);

    if (recipes.isEmpty) {
      _recipes = await _getDefaultRecipes();
      await _saveRecipesToPrefs(prefs, _recipes);
      return _recipes;
    }

    _recipes = recipes;
    return _recipes;
  }

  Future<List<Dessert>> _getRecipesFromPrefs(SharedPreferences prefs) async {
    final String? recipesJson = prefs.getString(_recipesKey);
    if (recipesJson != null) {
      final List<dynamic> decodedJson =
          jsonDecode(recipesJson) as List<dynamic>;
      return decodedJson
          .map((json) => Dessert.fromJson(json as String))
          .toList();
    }
    return [];
  }

  Future<void> _saveRecipesToPrefs(
      SharedPreferences prefs, List<Dessert> recipes) async {
    await prefs.setString(
        _recipesKey, jsonEncode(recipes.map((e) => e.toJson()).toList()));
  }

  Future<void> addRecipe(Dessert recipe) async {
    _recipes.add(recipe);
    final prefs = await SharedPreferences.getInstance();
    await _saveRecipesToPrefs(prefs, _recipes);
  }

  Future<void> removeRecipe(String name) async {
    _recipes.removeWhere((recipe) => recipe.name == name);
    final prefs = await SharedPreferences.getInstance();
    await _saveRecipesToPrefs(prefs, _recipes);
  }

  Future<void> toggleFavorite(String name) async {
    final recipe = _recipes.firstWhere((recipe) => recipe.name == name);
    recipe.isFavorite = !recipe.isFavorite;
    final prefs = await SharedPreferences.getInstance();
    await _saveRecipesToPrefs(prefs, _recipes);
  }

  Future<List<Dessert>> _getDefaultRecipes() async {
    final String response =
        await rootBundle.loadString('assets/json/recipe.json');
    final List<dynamic> data = json.decode(response) as List<dynamic>;
    return data
        .map((json) => Dessert.fromMap(json as Map<String, dynamic>))
        .toList();
  }
}
