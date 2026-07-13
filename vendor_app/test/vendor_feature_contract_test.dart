import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:urban_goodz_vendor/models/reel_model.dart';
import 'package:urban_goodz_vendor/models/service_booking_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

void main() {
  test('expired Vendor token invokes session invalidation', () async {
    var invalidated = false;
    final api =
        VendorApiClient(
            client: MockClient(
              (_) async =>
                  http.Response(jsonEncode({'message': 'Token expired.'}), 401),
            ),
          )
          ..setToken('expired-fixture')
          ..onUnauthorized = () async => invalidated = true;
    await expectLater(
      api.get('vendor/profile'),
      throwsA(isA<VendorApiException>()),
    );
    expect(invalidated, isTrue);
  });

  test(
    'service booking mapping preserves server status and minor-unit amount',
    () {
      final booking = ServiceBookingModel.fromJson({
        'id': 9,
        'service_type': 'mobile_mechanic',
        'customer_name': 'Authorized Customer',
        'scheduled_at': '2026-07-12T15:30:00Z',
        'quoted_amount_minor': 12550,
        'status': 'confirmed',
        'created_at': '2026-07-11T10:00:00Z',
      });
      expect(booking.id, '9');
      expect(booking.serviceName, 'mobile mechanic');
      expect(booking.amount, 125.50);
      expect(booking.status, 'confirmed');
    },
  );

  test('reel mapping preserves moderation and owned product tags', () {
    final reel = ReelModel.fromJson({
      'id': 3,
      'description': 'Real reel',
      'publication_status': 'pending_review',
      'moderation_status': 'pending',
      'commerce_tags': [
        {'taggable_id': 44},
      ],
      'total_views': 8,
      'total_likes': 2,
    });
    expect(reel.isPublished, isFalse);
    expect(reel.publicationStatus, 'pending_review');
    expect(reel.productTag, ['44']);
  });

  test('repository sends real service transition route and payload', () async {
    late http.Request captured;
    final repository = VendorRepository(
      VendorApiClient(
        client: MockClient((request) async {
          captured = request;
          return http.Response(jsonEncode({'data': {}}), 200);
        }),
      )..setToken('fixture'),
    );
    await repository.updateServiceBookingStatus(
      '17',
      'en_route',
      notes: 'Leaving now',
    );
    expect(
      captured.url.path,
      endsWith('/api/v1/vendor/service-bookings/bookings/17/status'),
    );
    expect(jsonDecode(captured.body), {
      'status': 'en_route',
      'notes': 'Leaving now',
    });
  });

  test('release source contains no mock repository or runtime fallback', () {
    expect(
      File('lib/repositories/mock_vendor_data.dart').existsSync(),
      isFalse,
    );
    expect(File('lib/config/runtime_flags.dart').existsSync(), isFalse);
  });
}
