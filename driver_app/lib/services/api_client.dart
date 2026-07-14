import 'package:get/get.dart';
import 'package:urban_goodz_driver/config/api_config.dart';
import 'package:urban_goodz_driver/controllers/driver_auth_controller.dart';

/// Thin wrapper around GetConnect that injects the driver token as a `?token=`
/// query parameter on every request. The backend `dm.api` middleware validates
/// `?token=` against delivery_men.auth_token — it does NOT read Bearer headers.
class ApiClient extends GetConnect {
  ApiClient() {
    baseUrl = ApiConfig.baseUrl;
    timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<void>((request) {
      request.headers['Accept'] = 'application/json';
      return request;
    });
  }

  Map<String, String> get _authQuery {
    try {
      final auth = Get.find<DriverAuthController>();
      final t = auth.token.value;
      if (t.isNotEmpty) return {'token': t};
    } catch (_) {}
    return {};
  }

  Future<Response> authGet(String path, {Map<String, dynamic>? query}) {
    final merged = <String, dynamic>{..._authQuery, ...?query};
    return get(path, query: merged);
  }

  Future<Response> authPost(
    String path,
    dynamic body, {
    Map<String, dynamic>? query,
  }) {
    final merged = <String, dynamic>{..._authQuery, ...?query};
    return post(path, body, query: merged);
  }

  Future<Response> authPut(
    String path,
    dynamic body, {
    Map<String, dynamic>? query,
  }) {
    final merged = <String, dynamic>{..._authQuery, ...?query};
    return put(path, body, query: merged);
  }

  Future<Response> authDelete(String path, {Map<String, dynamic>? query}) {
    final merged = <String, dynamic>{..._authQuery, ...?query};
    return delete(path, query: merged);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  ApiException(this.statusCode, this.message, [this.errors]);

  @override
  String toString() =>
      'ApiException($statusCode): $message${errors != null ? ' $errors' : ''}';
}
