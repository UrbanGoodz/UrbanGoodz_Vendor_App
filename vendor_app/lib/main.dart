import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:urban_goodz_vendor/controllers/vendor_auth_controller.dart';
import 'package:urban_goodz_vendor/screens/dashboard_screen.dart';
import 'package:urban_goodz_vendor/screens/vendor_onboarding_screen.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(VendorAuthController());
    return Obx(() {
      return GetMaterialApp(
        title: 'Urban Goodz Vendor',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: authController.isLoggedIn.value
            ? DashboardScreen()
            : const VendorOnboardingScreen(),
      );
    });
  }
}
