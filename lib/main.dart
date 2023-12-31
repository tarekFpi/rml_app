import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tmv_lite/core/theme/app_theme.dart';
import 'package:tmv_lite/features/auth/auth_controller.dart';
import 'package:tmv_lite/features/auth/login_screen.dart';
import 'package:tmv_lite/features/nav/nav_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tmv_lite/utils/hexcolor.dart';
import 'package:upgrader/upgrader.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.transparent
    ..indicatorColor = HexColor("#5154B2")
    ..textColor = Colors.black
    ..maskColor = Colors.white.withOpacity(0.8)
  ..boxShadow = [];
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final destination =
        authController.isLoggedIn() ? const NavScreen() : const LoginScreen();

    FlutterNativeSplash.remove();

    return OKToast(child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Runner Motors - TMV Lite',
      theme: AppTheme.lightTheme(),
      themeMode: ThemeMode.light,
      home: UpgradeAlert(
          upgrader: Upgrader(
              showLater: false,
              showIgnore: false, durationUntilAlertAgain: const Duration(seconds: 1)),
          child: destination),
      builder: EasyLoading.init(),
    ));
  }
}
