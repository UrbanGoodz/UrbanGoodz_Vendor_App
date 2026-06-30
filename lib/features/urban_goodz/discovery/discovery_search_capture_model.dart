class DiscoverySearchCaptureModel {
  final String searchQuery;
  final int? moduleId;
  final String? moduleName;
  final String? moduleType;
  final int? categoryId;
  final String? categoryName;
  final int? zoneId;
  final String? zoneName;
  final String? city;
  final String? state;
  final String? country;
  final int? userId;
  final String devicePlatform;
  final String timestamp;
  final String intentGuess;
  final String urgency;
  final bool notifyMe;
  final bool sourceRequest;
  final String? requestType;

  const DiscoverySearchCaptureModel({
    required this.searchQuery,
    this.moduleId,
    this.moduleName,
    this.moduleType,
    this.categoryId,
    this.categoryName,
    this.zoneId,
    this.zoneName,
    this.city,
    this.state,
    this.country,
    this.userId,
    required this.devicePlatform,
    required this.timestamp,
    required this.intentGuess,
    required this.urgency,
    required this.notifyMe,
    required this.sourceRequest,
    this.requestType,
  });

  Map<String, dynamic> toJson() => {
    'search_query': searchQuery,
    'query': searchQuery,
    'module_id': moduleId,
    'module_name': moduleName,
    'module_type': moduleType,
    'category_id': categoryId,
    'category_name': categoryName,
    'zone_id': zoneId,
    'zone_name': zoneName,
    'city': city,
    'state': state,
    'country': country,
    'user_id': userId,
    'device_platform': devicePlatform,
    'timestamp': timestamp,
    'intent_guess': intentGuess,
    'urgency': urgency,
    'notify_me': notifyMe,
    'source_request': sourceRequest,
    'request_type': requestType,
  };
}
