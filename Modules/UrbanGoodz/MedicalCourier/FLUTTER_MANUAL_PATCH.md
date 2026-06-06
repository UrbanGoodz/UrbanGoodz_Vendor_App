# Medical Courier Flutter Manual Patch

WARNING: Do not overwrite entire files.
Apply targeted insertions only.

## RouteHelper
Add import:
import 'package:sixam_mart/features/urban_goodz/screens/medical_courier_screen.dart';

Add route:
static const String medicalCourier = '/medical-courier';
static String getMedicalCourierRoute() => medicalCourier;

Add GetPage:
GetPage(
  name: medicalCourier,
  page: () => const MedicalCourierScreen(),
),

## MenuScreen
Add menu entry:
PortionWidget(
  icon: Images.dmIcon,
  title: 'Medical Courier',
  route: RouteHelper.getMedicalCourierRoute(),
)

## AppConstants
Add endpoint:
static const String medicalCourierJobsUri =
 '/api/v1/urban-goodz/medical-courier/jobs';

## Placeholder Screen
Current file:
lib/features/urban_goodz/screens/medical_courier_screen_placeholder.dart

Rename later:
lib/features/urban_goodz/screens/medical_courier_screen.dart
