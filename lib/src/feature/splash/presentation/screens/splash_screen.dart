import 'package:advertising_id/advertising_id.dart';
import 'package:application/routes/route_value.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startLoading(context);
  }

  Future<void> startLoading(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await AdvertisingId.id(true);
    context.go(RouteValue.home.path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            IconProvider.splash.buildImageUrl(),
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: const CupertinoActivityIndicator(
              color: Colors.black12,
              radius: 44,
            ),
          ),
        ),
      ],
    );
  }
}
