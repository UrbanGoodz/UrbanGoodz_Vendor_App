import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/helper/get_di.dart' as di;

/// Initializes the full GetX dependency graph for the sixam_mart root app.
///
/// - Mocks SharedPreferences so ApiClient / ThemeController / etc. can read
///   stored values without real persistent storage.
/// - Calls [di.init()] which registers every repository, service and controller
///   via [Get.lazyPut] (controllers stay uninstantiated until [Get.find] or
///   [GetBuilder] resolves them).
/// - Returns the localisation map that [MyApp] expects as its [languages]
///   parameter.
///
/// Call this in `setUp` **after** `Get.testMode = true`.
Future<Map<String, Map<String, String>>> initTestDependencies() async {
  SharedPreferences.setMockInitialValues({});
  return di.init();
}

/// Resets the GetX instance manager.
///
/// Call this in `tearDown` after every test.
void resetGetx() {
  Get.reset();
}
