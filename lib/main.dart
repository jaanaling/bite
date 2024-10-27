import 'dart:async';
import 'package:application/src/core/dependency_injection.dart';
import 'package:application/src/feature/app/presentation/app_root.dart';
import 'package:core_amplitude/core_amplitude.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    setupDependencyInjection();

    // await AmplitudeUtil.initializeAmplitude('your_amplitude_key');

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(
      const AppRoot(),
    );
}
