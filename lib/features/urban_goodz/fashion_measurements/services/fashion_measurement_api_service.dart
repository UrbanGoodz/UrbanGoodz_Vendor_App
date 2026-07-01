import 'dart:convert';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_profile_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_photo_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_request_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_service_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_quote_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/fashion_order_status_model.dart';

class FashionMeasurementApiService {
  // TODO: Add these URI constants to AppConstants once integrated:
  // static const String fashionMeasurementProfileUri = '/api/v1/customer/fashion/measurement-profiles';
  // static const String fashionMeasurementPhotoUri = '/api/v1/customer/fashion/measurement-photos';
  // static const String fashionMeasurementRequestUri = '/api/v1/customer/fashion/measurement-requests';
  // static const String fashionTailorServicesUri = '/api/v1/customer/fashion/tailor-services';
  // static const String fashionTailorQuotesUri = '/api/v1/customer/fashion/tailor-quotes';
  // static const String fashionOrderStatusUri = '/api/v1/customer/fashion/order-statuses';

  Future<MeasurementProfileModel?> getMeasurementProfile(int userId) async {
    // Placeholder GET request returning mock data
    await Future.delayed(const Duration(milliseconds: 500));
    return MeasurementProfileModel(
      id: 1,
      userId: userId,
      profileName: "My Fitting Profile",
      height: 70.0,
      chestBust: 40.0,
      waist: 34.0,
      hips: 42.0,
      inseam: 32.0,
      sleeve: 34.5,
      shoulderWidth: 18.0,
      neck: 15.5,
      preferredFit: "Regular",
      notes: "Preferred slim fit on cuffs.",
      updatedAt: DateTime.now(),
    );
  }

  Future<bool> saveMeasurementProfile(MeasurementProfileModel profile) async {
    // Placeholder POST request
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<MeasurementPhotoModel?> uploadMeasurementPhoto(String path, String orientation) async {
    // Placeholder Multipart POST request for reference photos
    await Future.delayed(const Duration(milliseconds: 1000));
    return MeasurementPhotoModel(
      id: 100,
      photoUrl: "https://test.urbangoodzdelivery.com/storage/app/public/measurements/photo_100.png",
      orientation: orientation,
      heightRef: 70.0,
      status: "pending",
      uploadedAt: DateTime.now(),
    );
  }

  Future<List<TailorServiceModel>> getTailorServices(int storeId) async {
    // Placeholder GET request for services
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TailorServiceModel(
        id: 1,
        storeId: storeId,
        serviceName: "Custom Tuxedo Fitting & Alteration",
        description: "Bespoke tuxedo fitting with photo-assisted measurement intake review.",
        basePrice: 150.0,
        durationDays: 14,
      ),
      TailorServiceModel(
        id: 2,
        storeId: storeId,
        serviceName: "Standard Pants Hemming",
        description: "Quick hem adjustment for trousers or suits.",
        basePrice: 20.0,
        durationDays: 3,
      ),
    ];
  }

  Future<bool> submitMeasurementRequest(MeasurementRequestModel request) async {
    // Placeholder POST request for tailor review
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<List<TailorQuoteModel>> getTailorQuotes(int requestId) async {
    // Placeholder GET request for quotes
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TailorQuoteModel(
        id: 10,
        requestId: requestId,
        serviceId: 1,
        quoteAmount: 165.0,
        comments: "Includes extra lining fabric for custom comfort.",
        isAccepted: false,
        offeredAt: DateTime.now(),
      )
    ];
  }

  Future<bool> acceptQuote(int quoteId) async {
    // Placeholder POST quote acceptance
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<FashionOrderStatusModel?> getFashionOrderStatus(int orderId) async {
    // Placeholder GET status
    await Future.delayed(const Duration(milliseconds: 500));
    return FashionOrderStatusModel(
      id: 5,
      orderId: orderId,
      currentStatus: "Measuring",
      updatedAt: DateTime.now(),
      statusNotes: "Tailor review preview is checking photo alignment estimates.",
    );
  }
}
