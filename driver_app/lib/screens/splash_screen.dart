import 'package:flutter/material.dart';
import 'package:urban_goodz_driver/theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Center(
                child: Text(
                  'UG',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.dark,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Urban Goodz',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppTheme.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Driver',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 48),
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
