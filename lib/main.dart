import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app_widget.dart';
import 'src/feature/home/view/widget/onboarding_module.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    ModularApp(
      module: OnBoardingModule(),
      child: const AppWidget(),
    ),
  );
}
