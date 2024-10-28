import 'dart:math';

import 'package:application/routes/route_value.dart';
import 'package:application/src/core/utils/log.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class DessertGraphScreen extends StatefulWidget {
  final Dessert dessert;

  const DessertGraphScreen({required this.dessert});

  @override
  _DessertGraphScreenState createState() => _DessertGraphScreenState();
}

class _DessertGraphScreenState extends State<DessertGraphScreen> {
  double _scale = 0.6;
  Offset _offset = Offset.zero;
  final double _zoomStep = 0.1;
  Offset _startFocalPoint = Offset.zero;
  double _startScale = 0.6;

  final Map<String, Offset> _componentPositions = {};
  final Map<String, Offset> _ingredientPositions = {};

  void _zoomIn() {
    setState(() {
      _scale += _zoomStep;
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale - _zoomStep).clamp(0.5, 3.0);
    });
  }

  void _onJoystickMove(double dx, double dy) {
    setState(() {
      _offset += Offset(-dx * 25, -dy * 25);
    });
  }

  void _resetPosition() {
    setState(() {
      _scale = 0.6;
      _offset = Offset.zero;
    });
  }

  Future<void> share(String name, GlobalKey shareButtonKey) async {
    await Share.share(
      '''
Hey! 🍜 I just found this amazing $name recipe – it’s super easy to make! Thought you’d like to try it too! Let me know if you give it a go 😊👩‍🍳👨‍🍳 😆''',
      subject: 'I just found this amazing recipe!',
      sharePositionOrigin: shareButtonRect(shareButtonKey),
    );
  }

  Rect? shareButtonRect(GlobalKey shareButtonKey) {
    RenderBox? renderBox =
        shareButtonKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return Rect.fromCenter(
      center: position + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startFocalPoint = details.focalPoint;
    _startScale = _scale;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double baseSize = screenWidth * 0.5;
        final GlobalKey shareKey = GlobalKey();
        print(screenWidth * 30);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: (details) {
                setState(() {
                  _scale = _startScale * details.scale;
                  final Offset delta = details.focalPoint - _startFocalPoint;
                  _offset += delta;
                  _startFocalPoint = details.focalPoint;
                });
              },
              child: Transform(
                transform: Matrix4.identity()..scale(_scale),
                alignment: FractionalOffset.center,
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: screenWidth * 30,
                        height: screenHeight * 30,
                        color: Colors.transparent,
                      ),
                      ..._buildComponents(screenWidth, screenHeight, baseSize),
                      Center(
                        child: Transform(
                          transform: Matrix4.identity()
                            ..translate(_offset.dx, _offset.dy),
                          alignment: FractionalOffset.center,
                          child: NodeWidget(
                            size: baseSize,
                            label: widget.dessert.name,
                            fontSize: baseSize * 0.2,
                            category: "Dish",
                            data: widget.dessert,
                            onTap: (String d) {},
                            dessert: widget.dessert,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _zoomIn,
                    child: Icon(Icons.zoom_in),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _zoomOut,
                    child: Icon(Icons.zoom_out),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _resetPosition,
                    child: Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: CircleButton(
                color: Color(0xFF9F9F9F),
                onTap: () {
                  context.pop();
                },
                icon: CupertinoIcons.chevron_back,
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Row(
                children: [
                  CircleButton(
                    key: shareKey,
                    color: Color(0xFFD121A1),
                    onTap: () async {
                      await share(widget.dessert.name, shareKey);
                    },
                    icon: Icons.share,
                  ),
                  SizedBox(width: 10),
                  CircleButton(
                    color: Color(0xFF6A00C7),
                    onTap: () {
                      context
                          .read<RecipeBloc>()
                          .add(ToggleFavorite(widget.dessert.name));
                      setState(() {});
                    },
                    icon: widget.dessert.isFavorite
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                  ),
                  SizedBox(width: 10),
                  CircleButton(
                    color: Color(0xFFFFAA75),
                    onTap: () {
                      context.push(
                          '${RouteValue.home.path}/${RouteValue.recipe.path}/${RouteValue.list.path}',
                          extra: widget.dessert);
                    },
                    icon: CupertinoIcons.list_bullet,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Joystick(
                base: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                stick: JoystickStick(
                  decoration: JoystickStickDecoration(
                    color: const Color(0xFF6A00C7),
                    shadowColor: Colors.grey.withOpacity(0.5),
                  ),
                ),
                listener: (details) {
                  _onJoystickMove(details.x, details.y);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildComponents(
    double screenWidth,
    double screenHeight,
    double parentSize,
  ) {
    final List<Widget> components = [];
    final Offset center = Offset(screenWidth / 2.2, screenHeight / 2.2);
    final double maxDistance = min(screenWidth, screenHeight) / 2;

    final List<Offset> occupiedPositions = [];

    for (final component in widget.dessert.components) {
      // Добавляем основной компонент и его подкомпоненты и ингредиенты
      components.addAll(
        _buildComponentWithSubComponentsAndIngredients(
          component,
          center,
          parentSize,
          maxDistance,
          occupiedPositions,
        ),
      );
    }

    return components;
  }

  List<Widget> _buildComponentWithSubComponentsAndIngredients(
    Component component,
    Offset parentPosition,
    double parentSize,
    double maxDistance,
    List<Offset> occupiedPositions, [
    bool isRec = false,
  ]) {
    final List<Widget> result = [];
    final double componentSize = parentSize * (component.percentage / 100);
    Offset position;

    if (_componentPositions.containsKey(component.name)) {
      position = _componentPositions[component.name]!;
    } else {
      position = _findValidPosition(
        component,
        parentPosition,
        maxDistance,
        componentSize,
        occupiedPositions,
      );
      occupiedPositions.add(position);
      _componentPositions[component.name] = position;
    }

    double angle = atan2(
      position.dy - (parentPosition.dy),
      position.dx - (parentPosition.dx),
    );
    if (angle == 0.0) {
      angle = atan2(position.dy + 150, position.dx);
    }

    logger.d(
      "  position ${position.dx} ${position.dy} parentPosition ${parentPosition.dx} ${parentPosition.dy} angle^ $angle com ${component.name}",
    );
    if (component.ingredients?.isNotEmpty ?? false) {
      result.addAll(
        _buildIngredients(
          component,
          position,
          componentSize,
          parentPosition.dx * 2,
          parentPosition.dy * 2,
          occupiedPositions,
          angle,
        ),
      );
    }
    // Линия между родителем и компонентом должна быть под компонентом
    result.insert(
      0, // Вставляем в начало списка, чтобы линии были под компонентом

      Transform(
        transform: Matrix4.identity()..translate(_offset.dx, _offset.dy),
        alignment: FractionalOffset.center,
        child: CustomPaint(
          painter: LinePainter(
            start: parentPosition,
            end: position,
          ),
        ),
      ),
    );

    // Сам компонент
    result.add(
      Positioned(
        left: position.dx - componentSize / 2,
        top: position.dy - componentSize / 2,
        child: Transform(
          transform: Matrix4.identity()..translate(_offset.dx, _offset.dy),
          alignment: FractionalOffset.center,
          child: NodeWidget(
            size: componentSize,
            label: component.name,
            fontSize: componentSize * 0.2,
            isSubstitutable: component.substitutes?.isNotEmpty ?? false,
            category: component.name,
            data: component,
            onTap: (String name) {
              setState(() {
                if (_componentPositions.containsKey(component.name)) {
                  _componentPositions[name] =
                      _componentPositions[component.name]!;
                  _componentPositions.remove(component.name);
                }
              });
            },
            dessert: widget.dessert,
          ),
        ),
      ),
    );

    // Добавляем подкомпоненты аналогично ингредиентам
    if (component.subComponents?.isNotEmpty ?? false) {
      for (final subComponent in component.subComponents!) {
        final double subComponentSize =
            componentSize * (subComponent.percentage / 100);
        Offset subPosition;

        if (_componentPositions.containsKey(subComponent.name)) {
          subPosition = _componentPositions[subComponent.name]!;
        } else {
          subPosition = _calculateSubComponentPosition(
            subComponent,
            position,
            angle,
            subComponentSize,
            occupiedPositions,
          );
        }
        result.insert(
          0, // Линия под субкомпонентом
          Transform(
            transform: Matrix4.identity()..translate(_offset.dx, _offset.dy),
            child: CustomPaint(
              painter: LinePainter(
                start: position,
                end: subPosition,
              ),
            ),
          ),
        );
        if (isRec) {
          result.add(
            Positioned(
              left: subPosition.dx - subComponentSize / 2,
              top: subPosition.dy - subComponentSize / 2,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(_offset.dx, _offset.dy),
                alignment: FractionalOffset.center,
                child: NodeWidget(
                  size: subComponentSize,
                  label: subComponent.name,
                  fontSize: subComponentSize * 0.2,
                  isSubstitutable:
                      subComponent.substitutes?.isNotEmpty ?? false,
                  data: subComponent,
                  category: subComponent.name,
                  onTap: (String name) {
                    setState(() {
                      if (_componentPositions.containsKey(subComponent.name)) {
                        _componentPositions[name] =
                            _componentPositions[subComponent.name]!;
                        _componentPositions.remove(subComponent.name);
                      }
                    });
                  },
                  dessert: widget.dessert,
                ),
              ),
            ),
          );
        }

        // Рекурсивный вызов для вложенных подкомпонентов
        result.addAll(
          _buildComponentWithSubComponentsAndIngredients(
            subComponent,
            subPosition,
            subComponentSize,
            maxDistance,
            occupiedPositions,
            true,
          ),
        );
      }
    }

    // Добавляем ингредиенты компонента

    return result;
  }

  Offset _calculateSubComponentPosition(
    Component subComponent,
    Offset parentPosition,
    double angle,
    double subComponentSize,
    List<Offset> occupiedPositions,
  ) {
    Offset position;
    Random random = Random();

    // Устанавливаем минимальное расстояние для субкомпонента
    double distance = subComponentSize + 80; // 100 - минимальное расстояние

    // Случайное смещение
    double offsetX = ((random.nextDouble() - 0.5) + 0.1) * distance;
    double offsetY = ((random.nextDouble() - 0.5) + 0.1) * distance;

    position = Offset(
      parentPosition.dx + distance * cos(angle) + offsetX,
      parentPosition.dy + distance * sin(angle) + offsetY,
    );

    // Проверка на перекрытие
    if (_isOverlapping(position, subComponentSize, occupiedPositions)) {
      return _calculateSubComponentPosition(
        subComponent,
        parentPosition,
        angle,
        subComponentSize,
        occupiedPositions,
      );
    }

    occupiedPositions.add(position);
    _componentPositions[subComponent.name] = position;

    return position;
  }

  Offset _calculateIngredientPosition(
    Ingredient ingredient,
    Offset parentPosition,
    double angle,
    double ingredientSize,
    List<Offset> occupiedPositions,
  ) {
    Offset position = Offset.zero;
    Random random = Random();

    // Устанавливаем минимальное расстояние для ингредиентов
    double distance = (ingredientSize + 80); // 80 - минимальное расстояние

    // Случайное смещение
    double offsetX = ((random.nextDouble() - 0.5) + 0.1) * distance;
    double offsetY = ((random.nextDouble() - 0.5) + 0.1) * distance;

    position = Offset(
      parentPosition.dx + distance * cos(angle) + offsetX,
      parentPosition.dy + distance * sin(angle) + offsetY,
    );

    // Проверка на перекрытие
    if (_isOverlapping(position, ingredientSize, occupiedPositions)) {
      return _calculateIngredientPosition(
        ingredient,
        parentPosition,
        angle,
        ingredientSize,
        occupiedPositions,
      );
    }

    occupiedPositions.add(position);
    _ingredientPositions[ingredient.name] = position;

    return position;
  }

  Offset _findValidPosition(
    Component component,
    Offset center,
    double maxDistance,
    double componentSize,
    List<Offset> occupiedPositions,
  ) {
    int attempts = 0;
    Offset position;
    Random random = Random();

    while (attempts < 100) {
      final double angle = random.nextDouble() * 2 * pi;
      double distance = maxDistance * (component.percentage / 100) +
          componentSize; // Увеличиваем расстояние
      distance = max(
        distance,
        componentSize + 130,
      ); // Гарантируем, что минимальное расстояние в 2 размера компонента

      position = Offset(
        center.dx + distance * cos(angle),
        center.dy + distance * sin(angle),
      );

      if (!_isOverlapping(position, componentSize, occupiedPositions)) {
        return position;
      }

      attempts++;
    }

    return Offset.zero; // Если не удалось найти позицию
  }

  List<Widget> _buildIngredients(
    Component component,
    Offset parentPosition,
    double parentSize,
    double screenWidth,
    double screenHeight,
    List<Offset> occupiedPositions,
    double angle, // Передаем угол субкомпонента
  ) {
    final List<Widget> ingredients = [];

    if (component.ingredients != null && component.ingredients!.isNotEmpty) {
      for (final ingredient in component.ingredients!) {
        final double ingredientSize =
            parentSize * (ingredient.percentage / 100);
        Offset position;

        if (_ingredientPositions.containsKey(ingredient.name)) {
          position = _ingredientPositions[ingredient.name]!;
        } else {
          position = _calculateIngredientPosition(
            ingredient,
            parentPosition,
            angle, // Используем тот же угол, что и для субкомпонента
            ingredientSize,
            occupiedPositions,
          );
        }

        ingredients.add(
          Transform(
            transform: Matrix4.identity()..translate(_offset.dx, _offset.dy),
            alignment: FractionalOffset.center,
            child: CustomPaint(
              painter: LinePainter(
                start: parentPosition,
                end: position,
              ),
            ),
          ),
        );

        ingredients.add(
          Positioned(
            left: position.dx - ingredientSize / 2,
            top: position.dy - ingredientSize / 2,
            child: Transform(
              transform: Matrix4.identity()..translate(_offset.dx, _offset.dy),
              alignment: FractionalOffset.center,
              child: NodeWidget(
                size: ingredientSize,
                label: ingredient.name,
                fontSize: ingredientSize * 0.2,
                isSubstitutable: ingredient.isSubstitutable,
                category: ingredient.category,
                data: ingredient,
                onTap: (String name) {
                  setState(() {
                    if (_ingredientPositions.containsKey(ingredient.name)) {
                      _ingredientPositions[name] =
                          _ingredientPositions[ingredient.name]!;
                      _ingredientPositions.remove(ingredient.name);
                    }
                  });
                },
                dessert: widget.dessert,
              ),
            ),
          ),
        );

        // Сохраняем позицию ингредиента
        _ingredientPositions[ingredient.name] = position;
      }
    }

    return ingredients;
  }

  bool _isOverlapping(
    Offset position,
    double size,
    List<Offset> occupiedPositions,
  ) {
    // Минимальное расстояние - это размер ноды
    final threshold = size;
    for (final occupiedPosition in occupiedPositions) {
      final double distance = (position - occupiedPosition).distance;
      if (distance < threshold) {
        return true;
      }
    }
    return false;
  }

  void _resetComponentPositions() {
    _componentPositions.clear();
    _ingredientPositions.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}

class CircleButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final IconData icon;

  const CircleButton({
    required this.color,
    required this.onTap,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(56, 4, 118, 0.37),
              offset: Offset(0, 19),
              blurRadius: 27.4,
              spreadRadius: -8,
            ),
          ],
          gradient: RadialGradient(
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
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
        ),
      ),
    );
  }
}
