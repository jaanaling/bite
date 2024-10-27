// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Node {
  String get name;
  int get percentage;
  bool get isSubstitutable;
}

class Dessert extends Node {
  final String id;
  final String name;
  final String imageUrl;
  final bool isVegan;
  final List<String> allergens;
  final List<Component> components;
  final List<Step> steps;
  bool isFavorite;
  final bool isSpicy;

  Dessert({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isVegan,
    required this.allergens,
    required this.components,
    required this.steps,
    required this.isFavorite,
    required this.isSpicy,
  });

  // Функция для поиска процента компонента по названию
  int? findComponentPercentageByName(String componentName) {
    for (var component in components) {
      int? percentage = _findComponentPercentageInComponent(component, componentName);
      if (percentage != null) {
        return percentage;
      }
    }
    return null; // Если компонент не найден
  }

  // Рекурсивный метод для поиска процента компонента в компоненте
  int? _findComponentPercentageInComponent(Component component, String componentName) {
    if (component.name == componentName) {
      return _calculateComponentPercentage(component); // Высчитываем процент компонента
    }
    // Рекурсивно проверяем подкомпоненты
    if (component.subComponents != null) {
      for (var subComponent in component.subComponents!) {
        int? percentage = _findComponentPercentageInComponent(subComponent, componentName);
        if (percentage != null) {
          return percentage;
        }
      }
    }
    return null; // Если компонент не найден в данном компоненте
  }

  // Функция для вычисления процента компонента
  int _calculateComponentPercentage(Component component) {
    if (component.ingredients != null) {
      int totalPercentage = 0;
      for (var ingredient in component.ingredients!) {
        totalPercentage += ingredient.percentage; // Суммируем проценты ингредиентов
      }
      return totalPercentage ~/ component.ingredients!.length; // Возвращаем средний процент
    }
    if (component.subComponents != null) {
      int totalPercentage = 0;
      for (var subComponent in component.subComponents!) {
        totalPercentage += _calculateComponentPercentage(subComponent); // Суммируем проценты подкомпонентов
      }
      return totalPercentage ~/ component.subComponents!.length; // Возвращаем средний процент
    }
    return 0; // Если нет ингредиентов или подкомпонентов
  }

  // Функция для поиска процента ингредиента по названию
  int? findIngredientPercentageByName(String ingredientName) {
    for (var component in components) {
      int? percentage = _findIngredientPercentageInComponent(component, ingredientName);
      if (percentage != null) {
        return percentage;
      }
    }
    return null; // Если ингредиент не найден
  }

  // Рекурсивный метод для поиска процента ингредиента в компоненте
  int? _findIngredientPercentageInComponent(Component component, String ingredientName) {
    if (component.ingredients != null) {
      for (var ingredient in component.ingredients!) {
        if (ingredient.name == ingredientName) {
          return ingredient.percentage; // Возвращаем процент ингредиента
        }
      }
    }
    // Рекурсивно проверяем подкомпоненты
    if (component.subComponents != null) {
      for (var subComponent in component.subComponents!) {
        int? percentage = _findIngredientPercentageInComponent(subComponent, ingredientName);
        if (percentage != null) {
          return percentage;
        }
      }
    }
    return null; // Если ингредиент не найден в данном компоненте
  }


  String? findIngredientTypeByName(String ingredientName) {
    for (var component in components) {
      String? type = _findIngredientTypeInComponent(component, ingredientName);
      if (type != null) {
        return type;
      }
    }
    return null; // Если ингредиент не найден
  }

  // Рекурсивный метод для поиска ингредиента в компоненте
  String? _findIngredientTypeInComponent(Component component, String ingredientName) {
    if (component.ingredients != null) {
      for (var ingredient in component.ingredients!) {
        if (ingredient.name == ingredientName) {
          return ingredient.category; // Возвращаем категорию ингредиента
        }
      }
    }
    // Рекурсивно проверяем подкомпоненты
    if (component.subComponents != null) {
      for (var subComponent in component.subComponents!) {
        String? type = _findIngredientTypeInComponent(subComponent, ingredientName);
        if (type != null) {
          return type;
        }
      }
    }
    return null; // Если ингредиент не найден в данном компоненте
  }

  factory Dessert.fromJson(String source) =>
      Dessert.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'isVegan': isVegan,
      'allergens': allergens,
      'components': components.map((x) => x.toMap()).toList(),
      'steps': steps.map((x) => x.toMap()).toList(),
      'isFavorite': isFavorite,
      'isSpicy': isSpicy,
    };
  }

  factory Dessert.fromMap(Map<String, dynamic> map) {
    return Dessert(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      isVegan: map['isVegan'] as bool,
      allergens: List<String>.from(map['allergens'] as List<dynamic>),
      components: List<Component>.from(
        (map['components'] as List<dynamic>).map<Component>(
          (x) => Component.fromMap(x as Map<String, dynamic>),
        ),
      ),
      steps: List<Step>.from(
        (map['steps'] as List<dynamic>).map<Step>(
          (x) => Step.fromMap(x as Map<String, dynamic>),
        ),
      ),
      isFavorite: map['isFavorite'] as bool,
      isSpicy: map['isSpicy'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Dessert(id: $id, name: $name, imageUrl: $imageUrl, isVegan: $isVegan, allergens: $allergens, components: $components, steps: $steps, isFavorite: $isFavorite, isSpicy: $isSpicy)';
  }

  @override
  int get percentage => 100; // Базовый размер для десерта

  @override
  bool get isSubstitutable => false;
}

class Component extends Node {
  final String name;
  final List<Ingredient>? ingredients;
  final int percentage;
  final List<Component>? subComponents;
  final List<Component>? substitutes;

  Component({
    required this.name,
    required this.percentage,
    required this.ingredients,
    this.subComponents,
    this.substitutes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'ingredients': ingredients?.map((x) => x.toMap()).toList(),
      'percentage': percentage,
      'subComponents': subComponents?.map((x) => x.toMap()).toList(),
      'substitutes': substitutes?.map((x) => x.toMap()).toList(),
    };
  }

  factory Component.fromMap(Map<String, dynamic> map) {
    return Component(
      name: map['name'] as String,
      percentage: map['percentage'] as int,
      ingredients: map['ingredients'] != null
          ? List<Ingredient>.from(
              (map['ingredients'] as List<dynamic>).map<Ingredient>(
                (x) => Ingredient.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      subComponents: map['subComponents'] != null
          ? List<Component>.from(
              (map['subComponents'] as List<dynamic>).map<Component>(
                (x) => Component.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      substitutes: map['substitutes'] != null
          ? List<Component>.from(
              (map['substitutes'] as List<dynamic>).map<Component>(
                (x) => Component.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      name: json['name'] as String,
      percentage: json['percentage'] as int,
      ingredients: json['ingredients'] != null
          ? List<Ingredient>.from(
              (json['ingredients'] as List<dynamic>).map<Ingredient>(
                (x) => Ingredient.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      subComponents: json['subComponents'] != null
          ? List<Component>.from(
              (json['subComponents'] as List<dynamic>).map<Component>(
                (x) => Component.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      substitutes: json['substitutes'] != null
          ? List<Component>.from(
              (json['substitutes'] as List<dynamic>).map<Component>(
                (x) => Component.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  @override
  bool get isSubstitutable =>
      subComponents != null && subComponents!.isNotEmpty;
}

class Ingredient extends Node {
  final String name;
  final String category;
  final int percentage;
  final bool isSubstitutable;
  final List<Ingredient>? substitutes;

  Ingredient({
    required this.name,
    required this.category,
    required this.percentage,
    required this.isSubstitutable,
    this.substitutes,
  });

  int get ingredientPercentage => this.percentage; // Процент для ингредиента

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      category: json['category'] as String,
      percentage: json['percentage'] as int,
      isSubstitutable: json['isSubstitutable'] as bool,
      substitutes: json['substitutes'] != null
          ? List<Ingredient>.from(
              (json['substitutes'] as List<dynamic>).map(
                (substituteMap) =>
                    Ingredient.fromMap(substituteMap as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'percentage': percentage,
      'isSubstitutable': isSubstitutable,
      'substitutes': substitutes?.map((x) => x.toMap()).toList(),
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] as String,
      category: map['category'] as String,
      percentage: map['percentage'] as int,
      isSubstitutable: map['isSubstitutable'] != null
          ? map['isSubstitutable'] as bool
          : false,
      substitutes: map['substitutes'] != null
          ? List<Ingredient>.from(
              (map['substitutes'] as List<dynamic>).map<Ingredient>(
                (substituteMap) {
                  // Проверяем, является ли substituteMap картой
                  if (substituteMap is Map<String, dynamic>) {
                    return Ingredient.fromMap(substituteMap);
                  } else {
                    print(
                        'Unexpected type for substitute: ${substituteMap.runtimeType}');
                    throw const FormatException(
                        'Expected a Map<String, dynamic> for substitutes');
                  }
                },
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());
}

class UsedIngredient {
  final String name; // Название ингредиента
  final int quantity; // Количество ингредиента
  final String? substitute; // Заменитель, если есть

  UsedIngredient({
    required this.name,
    required this.quantity,
    this.substitute,
  });

  factory UsedIngredient.fromJson(Map<String, dynamic> json) {
    return UsedIngredient(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      substitute: json['substitute'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'substitute': substitute,
    };
  }

  factory UsedIngredient.fromMap(Map<String, dynamic> map) {
    return UsedIngredient(
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      substitute: map['substitute'] as String?,
    );
  }
}

class Step {
  final int stepNumber;
  final String description;
  final List<UsedIngredient> usedIngredients;

  Step({
    required this.stepNumber,
    required this.description,
    required this.usedIngredients,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      stepNumber: json['stepNumber'] as int,
      description: json['description'] as String,
      usedIngredients: (json['usedIngredients'] as List)
          .map(
            (usedIngredientJson) => UsedIngredient.fromJson(
              usedIngredientJson as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stepNumber': stepNumber,
      'description': description,
      'usedIngredients': usedIngredients.map((x) => x.toMap()).toList(),
    };
  }

  factory Step.fromMap(Map<String, dynamic> map) {
    return Step(
      stepNumber: map['stepNumber'] as int,
      description: map['description'] as String,
      usedIngredients: List<UsedIngredient>.from(
        (map['usedIngredients'] as List).map<UsedIngredient>(
          (x) => UsedIngredient.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());
}

class NodeWidget extends StatelessWidget {
  final double size;
  final String label;
  final double fontSize;
  final bool isSubstitutable;
  final String category;
  final Function()? onTap;

  const NodeWidget({
    required this.size,
    required this.label,
    required this.fontSize,
    this.category = "",
    this.isSubstitutable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = category == "Proteins"
        ? const Color(0xFFE76E24)
        : category == "Vegetables"
            ? const Color(0xFF37CD19)
            : category == "Spices"
                ? const Color(0xFFCD1997)
                : category == "Sauces"
                    ? const Color(0xFFE72424)
                    : category == "Grains"
                        ? const Color(0xFFE7A224)
                        : category == "Carbohydrates"
                            ? const Color.fromARGB(255, 226, 64, 15)
                            : const Color(0xFF6A00C7);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: category == "Dish" ? size * 1.2 : size,
        height: size * 0.8,
        decoration: BoxDecoration(
          shape: category == "Dish" ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: category == "Dish"
              ? const BorderRadius.all(Radius.circular(48))
              : null,
          boxShadow: category == "Dish"
              ? [
                  const BoxShadow(
                    color: Color.fromRGBO(56, 4, 118, 0.37),
                    offset: Offset(0, 19),
                    blurRadius: 27.4,
                    spreadRadius: -8,
                  ),
                ]
              : null,
          gradient: category == "Dish"
              ? LinearGradient(
                  colors: [
                    Color.lerp(
                      color,
                      Colors.white,
                      0.2,
                    )!,
                    color,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : RadialGradient(
                  colors: [
                    Color.lerp(
                      color,
                      Colors.white,
                      0.4,
                    )!,
                    color,
                  ],
                  radius: 0.8148,
                  center: const Alignment(0.2975 * 2 - 1, 0.2107 * 2 - 1),
                  stops: [0.0, 1.0],
                ),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              shadows: [
                Shadow(
                  offset: Offset(0, 4),
                  blurRadius: 3.1,
                  color: Color.fromRGBO(0, 0, 0, 0.51),
                ),
              ],
              fontFamily: 'Montserrat',
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.0,
              textBaseline: TextBaseline.alphabetic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  LinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.44)
      ..strokeWidth = 2.0;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
