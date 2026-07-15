import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urban_goodz_driver/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.dark,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.35;

    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(logoSize * 0.2),
              ),
              child: Center(
                child: Text(
                  'UG',
                  style: TextStyle(
                    fontSize: logoSize * 0.4,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.dark,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Text(
              'Urban Goodz',
              style: TextStyle(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.w800,
                color: AppTheme.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              'DRIVER',
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: size.height * 0.08),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
