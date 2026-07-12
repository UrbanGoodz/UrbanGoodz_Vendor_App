import 'package:get/get.dart';

class VendorAuthController extends GetxController {
  var isLoggedIn = false.obs;

  var businessName = 'Houston Fine Tailoring'.obs;
  var ownerName = 'Sarah Jenkins'.obs;
  var phone = '+1 (713) 555-0200'.obs;
  var email = 'sarah.tailor@urbangoodz.com'.obs;
  var city = 'Houston, TX'.obs;
  var businessType = 'Fashion Fit & Sizing'.obs;
  var addressNotes = 'Heights Studio, Suite 104'.obs;
  var storeStatus = 'open'.obs;

  // Sizing Quote Requests list (mock/staged for testing)
  var sizingQuoteRequests = <FashionFitQuoteRequest>[
    FashionFitQuoteRequest(
      id: 'REQ-3001',
      customerName: 'Marcus Aurelius',
      customerPhone: '+1 (832) 555-9876',
      chestSize: '40 in',
      waistSize: '34 in',
      inseam: '32 in',
      gender: 'Male',
      requestType: 'Custom Suit Sizing & Tailoring',
      status: 'pending',
      date: '2026-07-05',
    ),
    FashionFitQuoteRequest(
      id: 'REQ-3002',
      customerName: 'Helena Troy',
      customerPhone: '+1 (281) 555-4321',
      chestSize: '36 in',
      waistSize: '28 in',
      inseam: '30 in',
      gender: 'Female',
      requestType: 'Premium Alteration & Hemming',
      status: 'quoted',
      quoteAmount: 45.00,
      notes: 'Standard hemming request.',
      date: '2026-07-04',
    ),
  ].obs;

  void logout() {
    isLoggedIn.value = false;
  }
}

class FashionFitQuoteRequest {
  final String id;
  final String customerName;
  final String customerPhone;
  final String chestSize;
  final String waistSize;
  final String inseam;
  final String gender;
  final String requestType;
  final String date;
  
  String status;
  double? quoteAmount;
  String? notes;
  String? estCompletion;

  FashionFitQuoteRequest({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.chestSize,
    required this.waistSize,
    required this.inseam,
    required this.gender,
    required this.requestType,
    required this.status,
    required this.date,
    this.quoteAmount,
    this.notes,
    this.estCompletion,
  });
}
