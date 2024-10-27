import 'package:application/src/feature/recipe/model/recipe.dart' as recipe;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ListScreen extends StatefulWidget {
  final recipe.Dessert dessert;
  const ListScreen({super.key, required this.dessert});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final step = widget.dessert.steps[sliderValue];
    final stepSum = step.usedIngredients.isNotEmpty
        ? step.usedIngredients
            .map((e) => e.quantity)
            .reduce((value, element) => value + element)
        : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleButton(
                color: Color(0xFF9F9F9F),
                onTap: () {
                  context.pop();
                },
                icon: CupertinoIcons.chevron_back,
              ),
            
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.dessert.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25, color: Colors.black, letterSpacing: 0.5),
                  ),
                ),
              ),
            ],
          ),
          Gap(16),
          SizedBox(
            width: width * 0.91,
            height: width * 0.91,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: width * 0.91,
                  height: width * 0.91,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF8526EA), Color(0xFF6900C6)],
                    ),
                    shape: OvalBorder(),
                    shadows: [
                      BoxShadow(
                        color: Color(0x5E370475),
                        blurRadius: 27.40,
                        offset: Offset(0, 19),
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${sliderValue + 1}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 99,
                  ),
                ),
                if (step.usedIngredients.isNotEmpty)
                  Positioned(top: height * 0.005, child: getNode(step, 0)),
                if (step.usedIngredients.length > 1)
                  Positioned(
                    top: height * 0.096,
                    right: width * 0.072,
                    child: getNode(step, 1),
                  ),
                if (step.usedIngredients.length > 2)
                  Positioned(
                    top: height * 0.096,
                    left: width * 0.05,
                    child: getNode(step, 2),
                  ),
                if (step.usedIngredients.length > 3)
                  Positioned(
                    bottom: height * 0.052,
                    right: width * 0.086,
                    child: getNode(step, 3),
                  ),
                if (step.usedIngredients.length > 4)
                  Positioned(
                    bottom: height * 0.063,
                    left: width * 0.13,
                    child: getNode(step, 4),
                  ),
              ],
            ),
          ),
          Gap(16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (step.usedIngredients.isNotEmpty)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 36),
                        child: IngredientListWidget(
                          ingredients: step.usedIngredients,
                        ),
                      ),
                    ),
                  const Text(
                    'RECIPE:',
                    style: TextStyle(
                      fontSize: 22,
                      color: CupertinoColors.systemGrey,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Gap(8),
                  Text(
                    step.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.darkBackgroundGray,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FlutterSlider(
            min: 0,
            max: widget.dessert.steps.length.ceilToDouble() - 1,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              sliderValue = (lowerValue as double).ceil();
              setState(() {});
            },
            tooltip: FlutterSliderTooltip(disabled: true),
            trackBar: FlutterSliderTrackBar(
              activeTrackBar: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFDA7FF), Color(0xFFF961FF)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              activeTrackBarHeight: 18,
              inactiveTrackBarHeight: 18,
              inactiveTrackBar: BoxDecoration(
                color: const Color(0xFFAC85FC),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            handler: FlutterSliderHandler(
              decoration: const BoxDecoration(),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const ShapeDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.03, 0.47),
                      radius: 0.92,
                      colors: [Color(0xFFFDA7FF), Color(0xFFF961FF)],
                    ),
                    shape: OvalBorder(
                      side: BorderSide(width: 4, color: Colors.white),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            values: [sliderValue.ceilToDouble()],
          ),
        ],
      ),
    );
  }

  double calculatePercentage(int percentage) {
    return (percentage) / 100 * 104;
  }

  Widget getNode(recipe.Step step, int ingredientIndex) {
    final name = step.usedIngredients.first.name;
    String category = widget.dessert.findIngredientTypeByName(name) ?? '';
    final percentage = category.isNotEmpty
        ? widget.dessert.findIngredientPercentageByName(name) ?? 0
        : widget.dessert.findComponentPercentageByName(name) ?? 0;
    return recipe.NodeWidget(
      size: calculatePercentage(percentage),
      label: name,
      fontSize: 22 * (percentage / 100),
      category: category,
    );
  }
}

class IngredientListWidget extends StatelessWidget {
  final List<recipe.UsedIngredient> ingredients;

  IngredientListWidget({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INGREDIENTS:',
          style: TextStyle(
            fontSize: 22,
            color: CupertinoColors.systemGrey,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        ListView.builder(
          itemCount: ingredients.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final ingredient = ingredients[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoListTile(
                padding: EdgeInsets.zero,
                title: Text(
                  ingredient.name,
                  style:
                      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontSize: 16,
                            color: Colors.black,
                            letterSpacing: 0.5,
                          ),
                ),
                trailing: Text(
                  '${ingredient.quantity}',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(color: CupertinoColors.systemGrey),
                ),
              ),
            );
          },
        ),
      ],
    );
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
