import 'package:flutter_test/flutter_test.dart';
import 'package:urban_goodz_vendor/models/daily_brief_model.dart';

void main() {
  test('parses nested daily brief payload', () {
    final model = DailyBriefModel.fromJson({
      'success': true,
      'brief': {
        'greeting': "Good morning! Here's your daily brief for Monday, August 10.",
        'todays_outlook': '24 orders so far today. 5 pending, 12 in progress.',
        'key_metrics': [
          {'label': 'Orders Today', 'value': '24', 'status': 'good'},
          {'label': 'Pending', 'value': '5', 'status': 'warning'},
          {'label': 'Revenue So Far', 'value': '\$1,240.00', 'status': 'good'},
        ],
        'action_items': ['Review and accept pending orders'],
        'revenue_forecast': 'Yesterday same day had 18 orders.',
        'staff_recommendations': ['Schedule one extra courier for peak hours.'],
        'summary': 'Operational overview for the day.',
      },
      'metrics': {
        'vendor_id': 7,
        'date': 'Monday, August 10, 2026',
        'todays_orders_total': 24,
      },
    });

    expect(model.success, isTrue);
    expect(model.error, isNull);
    expect(model.greeting, contains('Good morning'));
    expect(model.todaysOutlook, contains('24 orders so far today'));
    expect(model.keyMetrics, hasLength(3));
    expect(model.keyMetrics.first.label, 'Orders Today');
    expect(model.keyMetrics.first.value, '24');
    expect(model.keyMetrics.first.status, 'good');
    expect(model.keyMetrics[1].status, 'warning');
    expect(model.actionItems, ['Review and accept pending orders']);
    expect(model.revenueForecast, 'Yesterday same day had 18 orders.');
    expect(model.staffRecommendations, hasLength(1));
    expect(model.summary, 'Operational overview for the day.');
    expect(model.metrics, isNotNull);
    expect(model.metrics!['todays_orders_total'], 24);
  });

  test('parses deterministic fallback brief with raw_ai', () {
    final model = DailyBriefModel.fromJson({
      'success': true,
      'brief': {
        'greeting': "Good morning! Here's your daily brief for Monday, August 10.",
        'todays_outlook': '0 orders so far today. 0 pending, 0 in progress.',
        'key_metrics': [
          {'label': 'Orders Today', 'value': '0', 'status': 'good'},
        ],
        'action_items': ['No pending orders. Monitor for new incoming orders.'],
        'revenue_forecast': 'Yesterday same day had 0 orders.',
        'staff_recommendations': [],
        'summary': 'Showing fallback briefing. AI analysis unavailable.',
        'raw_ai': 'not valid json',
      },
      'metrics': {},
    });

    expect(model.success, isTrue);
    expect(model.greeting, contains('daily brief'));
    expect(model.summary, contains('fallback briefing'));
    expect(model.actionItems, hasLength(1));
  });

  test('parses service failure payload', () {
    final model = DailyBriefModel.fromJson({
      'success': false,
      'error': 'Unable to generate daily briefing.',
    });

    expect(model.success, isFalse);
    expect(model.error, 'Unable to generate daily briefing.');
    expect(model.greeting, isEmpty);
    expect(model.keyMetrics, isEmpty);
    expect(model.actionItems, isEmpty);
  });

  test('handles missing brief gracefully', () {
    final model = DailyBriefModel.fromJson({});

    expect(model.success, isFalse);
    expect(model.error, isNull);
    expect(model.greeting, isEmpty);
    expect(model.todaysOutlook, isEmpty);
    expect(model.keyMetrics, isEmpty);
    expect(model.actionItems, isEmpty);
    expect(model.metrics, isNull);
  });
}
