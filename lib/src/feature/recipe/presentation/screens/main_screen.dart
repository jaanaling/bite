import 'package:application/routes/route_value.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/feature/recipe/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isVeg = false;
  bool isHot = false;
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 55,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recipes',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: 'Montserrat',
                    fontSize: 37,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: -0.74,
                  ),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                  overflow: TextOverflow.clip,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isHot = !isHot;
                        });
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isHot ? Color(0xFFE00F0F) : Color(0xFF9F9F9F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11),
                          child: SvgPicture.asset(
                            IconProvider.hot.buildImageUrl(),
                          ),
                        ),
                      ),
                    ),
                    Gap(5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isVeg = !isVeg;
                        });
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isVeg ? Color(0xFF3CC93C) : Color(0xFF9F9F9F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11),
                          child: SvgPicture.asset(
                            IconProvider.veg.buildImageUrl(),
                          ),
                        ),
                      ),
                    ),
                    Gap(5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavourite = !isFavourite;
                        });
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isFavourite
                              ? Color(0xFFFD75FF)
                              : Color(0xFF9F9F9F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11),
                          child: Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(10),
          BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) {
              if (state is RecipeLoaded) {
                final List<Dessert> filteredRecipes = state.recipes
                    .where((r) => isVeg ? r.isVegan == isVeg : true)
                    .where((r) => isHot ? r.isSpicy == isHot : true)
                    .where(
                        (r) => isFavourite ? r.isFavorite == isFavourite : true)
                    .toList();

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(17),
                  itemCount: filteredRecipes.length,
                  separatorBuilder: (_, __) => const Gap(21),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      context.push(
                        '${RouteValue.home.path}/${RouteValue.recipe.path}',
                        extra: filteredRecipes[index],
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.23,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(48)),
                        boxShadow: [
                          const BoxShadow(
                            color: Color.fromRGBO(56, 4, 118, 0.37),
                            offset: Offset(0, 19),
                            blurRadius: 27.4,
                            spreadRadius: -8,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(
                              const Color(0xFF6A00C7),
                              Colors.white,
                              0.2,
                            )!,
                            const Color(0xFF6A00C7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(48),
                                      bottomLeft: Radius.circular(48),
                                    ),
                                    child: GestureDetector(
                                      child: Image.asset(
                                        filteredRecipes[index].imageUrl,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                      
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 21,
                                      top: 20,
                                    ),
                                    child: Text(
                                      filteredRecipes[index].name,
                                      style: const TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 3.1,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.51),
                                          ),
                                        ],
                                        fontFamily: 'Montserrat',
                                        fontSize: 29,
                                        fontWeight: FontWeight.w600,
                                        height: 1.0,
                                        textBaseline: TextBaseline.alphabetic,
                                      ),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(0, 23, 0, 23),
                              itemCount: filteredRecipes[index]
                                      .allergens
                                      .length +
                                  (filteredRecipes[index].isFavorite ? 1 : 0),
                              separatorBuilder:
                                  (BuildContext context, int index) => Gap(8),
                              itemBuilder: (BuildContext context, int id) =>
                                  Align(
                                alignment: Alignment.center,
                                child: filteredRecipes[index].isFavorite &&
                                        id ==
                                            filteredRecipes[index]
                                                .allergens
                                                .length
                                    ? Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    : SvgPicture.asset(
                                        alignment: Alignment.center,
                                        width: 30,
                                        height: 30,
                                        getAllergenIcon(
                                          filteredRecipes[index].allergens[id],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  String getAllergenIcon(String allergen) {
    switch (allergen) {
      case "Cocoa":
        return IconProvider.cocoa.buildImageUrl();
      case "Egg":
        return IconProvider.egg.buildImageUrl();
      case "Fish":
        return IconProvider.fish.buildImageUrl();
      case "Gluten":
        return IconProvider.gluten.buildImageUrl();
      case "Meat":
        return IconProvider.meat.buildImageUrl();
      case "Nuts":
        return IconProvider.nuts.buildImageUrl();
      case "Dairy":
        return IconProvider.dairy.buildImageUrl();

      default:
        return IconProvider.cocoa.buildImageUrl();
    }
  }
}
