import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData dark({Color color = const Color(0xFFED9914)}) => ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: color,
  secondaryHeaderColor: AppConstants.ugBlack,
  disabledColor: AppConstants.canvas.withValues(alpha: 0.4),
  brightness: Brightness.dark,
  hintColor: AppConstants.canvas.withValues(alpha: 0.5),
  scaffoldBackgroundColor: AppConstants.ugBlack,
  canvasColor: AppConstants.ugBlack,
  cardColor: AppConstants.ugBlack,
  shadowColor: Colors.white.withValues(alpha: 0.03),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppConstants.seasoningOrange)),
  popupMenuTheme: PopupMenuThemeData(color: AppConstants.ugBlack, surfaceTintColor: AppConstants.ugBlack),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10),
  floatingActionButtonTheme: FloatingActionButtonThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
  bottomAppBarTheme: const BottomAppBarThemeData(
    surfaceTintColor: Colors.black, height: 60,
    padding: EdgeInsets.symmetric(vertical: 5),
  ),
  dividerTheme: DividerThemeData(thickness: 0.5, color: AppConstants.canvas.withValues(alpha: 0.2)),
  tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent), colorScheme: ColorScheme.dark(primary: AppConstants.seasoningOrange, secondary: AppConstants.ugBlack).copyWith(surface: AppConstants.ugBlack).copyWith(error: AppConstants.seasoningOrange).copyWith(surface: AppConstants.ugBlack),
);