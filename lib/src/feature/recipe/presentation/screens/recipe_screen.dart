import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/feature/recipe/utils/utils.dart';
import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  final Dessert dessert;
  const RecipeScreen({super.key, required this.dessert});

  @override
  Widget build(BuildContext context) {
    return DessertGraphScreen(dessert: dessert);
  }
}
