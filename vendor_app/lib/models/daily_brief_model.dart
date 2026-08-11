class DailyBriefModel {
  final bool success;
  final String? error;
  final String greeting;
  final String todaysOutlook;
  final List<DailyBriefMetric> keyMetrics;
  final List<String> actionItems;
  final String revenueForecast;
  final List<String> staffRecommendations;
  final String summary;
  final Map<String, dynamic>? metrics;

  const DailyBriefModel({
    required this.success,
    this.error,
    this.greeting = '',
    this.todaysOutlook = '',
    this.keyMetrics = const [],
    this.actionItems = const [],
    this.revenueForecast = '',
    this.staffRecommendations = const [],
    this.summary = '',
    this.metrics,
  });

  factory DailyBriefModel.fromJson(Map<String, dynamic> json) {
    final inner = json['brief'];
    final brief = inner is Map
        ? Map<String, dynamic>.from(inner)
        : <String, dynamic>{};
    final metrics = json['metrics'];
    return DailyBriefModel(
      success: json['success'] == true,
      error: json['error']?.toString(),
      greeting: brief['greeting']?.toString() ?? '',
      todaysOutlook: brief['todays_outlook']?.toString() ?? '',
      keyMetrics: _parseMetrics(brief['key_metrics']),
      actionItems: _parseStrings(brief['action_items']),
      revenueForecast: brief['revenue_forecast']?.toString() ?? '',
      staffRecommendations: _parseStrings(brief['staff_recommendations']),
      summary: brief['summary']?.toString() ?? '',
      metrics: metrics is Map ? Map<String, dynamic>.from(metrics) : null,
    );
  }

  static List<DailyBriefMetric> _parseMetrics(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((row) => DailyBriefMetric.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  static List<String> _parseStrings(Object? value) {
    if (value is! List) return const [];
    return value.map((item) => item?.toString() ?? '').toList();
  }
}

class DailyBriefMetric {
  final String label;
  final String value;
  final String status;

  const DailyBriefMetric({
    required this.label,
    required this.value,
    this.status = 'good',
  });

  factory DailyBriefMetric.fromJson(Map<String, dynamic> json) =>
      DailyBriefMetric(
        label: json['label']?.toString() ?? '',
        value: json['value']?.toString() ?? '',
        status: json['status']?.toString() ?? 'good',
      );
}
