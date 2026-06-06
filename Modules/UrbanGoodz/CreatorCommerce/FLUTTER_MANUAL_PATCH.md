# Creator Commerce / Shoppable Reels Manual Patch

WARNING: Do not overwrite entire files.

## RouteHelper
Add import:
import 'package:sixam_mart/features/urban_goodz/screens/creator_commerce_screen.dart';

Add route:
static const String creatorCommerce = '/creator-commerce';
static String getCreatorCommerceRoute() => creatorCommerce;

Add GetPage registration.

## MenuScreen
Add menu item:
Creator Commerce
Shoppable Reels

## AppConstants
Add endpoint:
/api/v1/urban-goodz/creator-commerce/reels

## Placeholder Screen
Current file:
lib/features/urban_goodz/screens/creator_commerce_screen_placeholder.dart

Rename later when integration is available.
