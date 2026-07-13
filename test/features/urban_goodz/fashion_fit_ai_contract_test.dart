import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_request_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_quote_model.dart';

void main() {
  test('Fashion Fit request preserves backend UUID ownership context', () {
    final request = MeasurementRequestModel.fromJson({
      'id': 7,
      'uuid': '4ec763ec-3b73-4f8f-8df2-b6e33c4031be',
      'vendor_id': 12,
      'status': 'submitted',
    });
    expect(request.id, 7);
    expect(request.uuid, '4ec763ec-3b73-4f8f-8df2-b6e33c4031be');
    expect(request.vendorId, 12);
  });

  test('provider estimate maps authoritative amount and status', () {
    final quote = TailorQuoteModel.fromJson({
      'id': 4,
      'request_id': 7,
      'amount': '145.50',
      'notes': 'Seven days',
      'status': 'accepted',
      'created_at': '2026-07-12T12:00:00Z',
    });
    expect(quote.quoteAmount, 145.5);
    expect(quote.comments, 'Seven days');
    expect(quote.isAccepted, isTrue);
  });

  test(
    'release Fashion Fit source uses server AI and no local fabricated engine',
    () {
      final service = File(
        'lib/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart',
      ).readAsStringSync();
      final camera = File(
        'lib/features/urban_goodz/fashion_measurements/screens/measurement_photo_guide_screen.dart',
      ).readAsStringSync();
      expect(
        File(
          'lib/features/urban_goodz/fashion_measurements/services/measurement_engine_service.dart',
        ).existsSync(),
        isFalse,
      );
      expect(service, contains('/analyses'));
      expect(service, contains('confirmed_for_upload'));
      expect(service, contains('/approve'));
      expect(service, isNot(contains('heightInches *')));
      expect(camera, contains('CameraPreview'));
      expect(camera, contains('_SilhouettePainter'));
      expect(camera, contains('Separately allow raw-photo sharing'));
    },
  );

  test(
    'API client does not log tokens headers or sensitive request bodies',
    () {
      final source = File('lib/api/api_client.dart').readAsStringSync();
      expect(source, isNot(contains("print('Token:")));
      expect(source, isNot(contains('Header:')));
      expect(source, isNot(contains('API Body:')));
    },
  );
}
