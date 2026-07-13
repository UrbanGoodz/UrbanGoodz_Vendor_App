import 'dart:convert';

import 'package:http/http.dart' as http;

class VendorApiException implements Exception {
  final int statusCode;
  final String message;
  final Object? body;

  const VendorApiException(this.statusCode, this.message, [this.body]);

  @override
  String toString() => message;
}

class VendorApiClient {
  VendorApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const baseUrl = String.fromEnvironment(
    'VENDOR_API_BASE_URL',
    defaultValue: 'https://admin.urbangoodzdelivery.com/api/v1',
  );

  final http.Client _client;
  String? _token;
  Future<void> Function()? onUnauthorized;

  void setToken(String? token) => _token = token;

  Future<Object?> get(String path, {Map<String, Object?>? query}) =>
      _send('GET', path, query: query);

  Future<Object?> post(String path, {Map<String, Object?>? body}) =>
      _send('POST', path, body: body);

  Future<Object?> put(String path, {Map<String, Object?>? body}) =>
      _send('PUT', path, body: body);

  Future<Object?> delete(String path, {Map<String, Object?>? body}) =>
      _send('DELETE', path, body: body);

  Future<Object?> multipart(
    String path, {
    required Map<String, String> fields,
    required Map<String, String> files,
    String method = 'POST',
  }) async {
    final uri = Uri.parse('$baseUrl/${path.replaceFirst(RegExp(r'^/'), '')}');
    final request = http.MultipartRequest(method, uri)
      ..headers.addAll(_headers(includeContentType: false))
      ..fields.addAll(fields);
    for (final entry in files.entries) {
      request.files.add(
        await http.MultipartFile.fromPath(entry.key, entry.value),
      );
    }
    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    return _decodeResponse(response);
  }

  Future<Object?> _send(
    String method,
    String path, {
    Map<String, Object?>? query,
    Map<String, Object?>? body,
  }) async {
    final uri = Uri.parse('$baseUrl/${path.replaceFirst(RegExp(r'^/'), '')}')
        .replace(
          queryParameters: query?.map(
            (key, value) => MapEntry(key, value?.toString() ?? ''),
          ),
        );
    final headers = _headers();
    final encodedBody = body == null ? null : jsonEncode(body);
    late http.Response response;
    switch (method) {
      case 'POST':
        response = await _client.post(uri, headers: headers, body: encodedBody);
        break;
      case 'PUT':
        response = await _client.put(uri, headers: headers, body: encodedBody);
        break;
      case 'DELETE':
        response = await _client.delete(
          uri,
          headers: headers,
          body: encodedBody,
        );
        break;
      default:
        response = await _client.get(uri, headers: headers);
        break;
    }
    return _decodeResponse(response);
  }

  Map<String, String> _headers({
    bool includeContentType = true,
  }) => <String, String>{
    'Accept': 'application/json',
    if (includeContentType) 'Content-Type': 'application/json',
    'vendorType': 'owner',
    'languageCode': 'en',
    if (_token != null && _token!.isNotEmpty) 'Authorization': 'Bearer $_token',
  };

  Future<Object?> _decodeResponse(http.Response response) async {
    Object? decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = response.body;
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (response.statusCode == 401 && onUnauthorized != null) {
        await onUnauthorized!();
      }
      throw VendorApiException(
        response.statusCode,
        _errorMessage(decoded) ??
            'Vendor API request failed (${response.statusCode}).',
        decoded,
      );
    }
    return decoded;
  }

  String? _errorMessage(Object? body) {
    if (body is! Map) return body?.toString();
    final errors = body['errors'];
    if (errors is List && errors.isNotEmpty && errors.first is Map) {
      return errors.first['message']?.toString();
    }
    return body['message']?.toString();
  }
}
