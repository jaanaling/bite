import 'package:application/routes/root_navigation_screen.dart';
import 'package:application/routes/route_value.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/feature/recipe/presentation/screens/list_screen.dart';
import 'package:application/src/feature/recipe/presentation/screens/main_screen.dart';
import 'package:application/src/feature/recipe/presentation/screens/recipe_screen.dart';
import 'package:application/src/feature/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildGoRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          child: RootNavigationScreen(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: RouteValue.home.path,
              builder: (context, state) => ColoredBox(
                color: Colors.white,
                child: MainScreen(key: UniqueKey()),
              ),
              routes: <RouteBase>[
                GoRoute(
                  path: RouteValue.recipe.path,
                  builder: (context, state) => ColoredBox(
                    color: Colors.white,
                    child: RecipeScreen(
                      key: UniqueKey(),
                      dessert: state.extra as Dessert,
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: RouteValue.list.path,
                      builder: (context, state) => ColoredBox(
                        color: Colors.white,
                        child: ListScreen(
                          dessert: state.extra as Dessert,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen(key: UniqueKey());
          },
        ),
      ],
    ),
  ],
);
