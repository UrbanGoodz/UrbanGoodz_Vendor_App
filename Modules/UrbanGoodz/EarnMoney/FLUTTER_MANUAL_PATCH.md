# Urban Goodz Earn Money - Manual Flutter Patch

WARNING: Do not overwrite entire files. Apply only targeted insertions.

## File
lib/helper/route_helper.dart

### Import
Insert:
import 'package:sixam_mart/features/urban_goodz/screens/earn_money_screen.dart';

### Route constants
Insert:
static const String earnMoney = '/earn-money';
static String getEarnMoneyRoute() => earnMoney;

### GetPage registration
Insert:
GetPage(
  name: earnMoney,
  page: () => const EarnMoneyScreen(),
),

## File
lib/features/menu/screens/menu_screen.dart

Locate existing Earnings section.

Insert one PortionWidget:

PortionWidget(
  icon: Images.dmIcon,
  title: 'Earn Money',
  route: RouteHelper.getEarnMoneyRoute(),
)

## File
lib/util/app_constants.dart

Insert:
static const String earnMoneyOpportunitiesUri =
  '/api/v1/urban-goodz/earn-money/opportunities';

## Screen File
Current placeholder implementation exists at:

lib/features/urban_goodz/screens/earn_money_screen_placeholder.dart

Rename to:

lib/features/urban_goodz/screens/earn_money_screen.dart

when full routing work is available.
