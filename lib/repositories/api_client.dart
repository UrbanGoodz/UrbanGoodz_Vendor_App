import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/vendor_auth_controller.dart';

class ApiClient extends GetConnect {
  static const String baseUrlString = 'https://admin.urbangoodzdelivery.com/api/v1';

  @override
  void onInit() {
    httpClient.baseUrl = baseUrlString;
    httpClient.timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) {
      if (Get.isRegistered<VendorAuthController>()) {
        final authController = Get.find<VendorAuthController>();
        final tokenStr = authController.token.value;
        if (tokenStr.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $tokenStr';
        }
      }
      request.headers['Accept'] = 'application/json';
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        debugPrint('Unauthorized response detected, signing out.');
        if (Get.isRegistered<VendorAuthController>()) {
          Get.find<VendorAuthController>().logout();
        }
      }
      return response;
    });

    super.onInit();
  }
}
