import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:application/routes/go_router_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>  RecipeBloc()..add(LoadRecipes()),
      child: CupertinoApp.router(
        routerConfig: buildGoRouter,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF6A00C7),
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              fontSize: 21,
            ),
          ),
        ),
      ),
    );
  }
}
