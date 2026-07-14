import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/repositories/api_client.dart';

class VendorAuthController extends GetxController {
  var isLoggedIn = false.obs;
  var token = ''.obs;
  var isLoading = false.obs;

  var businessName = 'Staged Vendor Studio'.obs;
  var ownerName = 'Staged Contact'.obs;
  var phone = '+1 (713) 555-0100'.obs;
  var email = 'vendor@urbangoodz.com'.obs;
  var city = 'Houston, TX'.obs;
  var businessType = 'General Service'.obs;
  var addressNotes = 'Staged Studio, Suite 100'.obs;
  var storeStatus = 'open'.obs;

  // Earnings & Financial details from real profile
  var balance = 0.0.obs;
  var totalEarning = 0.0.obs;
  var todaysEarning = 0.0.obs;
  var weeklyEarning = 0.0.obs;
  var monthlyEarning = 0.0.obs;
  var withdrawableBalance = 0.0.obs;
  var cashInHands = 0.0.obs;
  var pendingWithdraw = 0.0.obs;
  var totalWithdrawn = 0.0.obs;
  var storeRating = 0.0.obs;
  var totalReviews = 0.obs;
  var orderCount = 0.obs;

  // Sizing Quote Requests list (Fashion Fit)
  var sizingQuoteRequests = <FashionFitQuoteRequest>[].obs;

  void logout() {
    isLoggedIn.value = false;
    token.value = '';
    sizingQuoteRequests.clear();
    Get.snackbar(
      'Logged Out',
      'You have exited vendor mode.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<bool> login(String emailInput, String passwordInput) async {
    isLoading.value = true;
    try {
      final client = Get.find<ApiClient>();
      final response = await client.post('/auth/vendor/login', {
        'email': emailInput.trim(),
        'password': passwordInput,
        'vendor_type': 'owner',
      });

      if (response.status.isOk && response.body != null) {
        final body = response.body;
        if (body['token'] != null) {
          token.value = body['token'];
          isLoggedIn.value = true;
          await fetchProfile();
          isLoading.value = false;
          return true;
        }
      }
      
      final errors = response.body?['errors'];
      final message = (errors is List && errors.isNotEmpty)
          ? errors[0]['message']
          : 'Invalid credentials. Please try again.';
          
      Get.snackbar(
        'Authentication Failed',
        message.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Login exception: $e');
      Get.snackbar(
        'Connection Error',
        'Staged Mode: Offline or server unavailable. Continuing in offline preview.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isLoading.value = false;
    return false;
  }

  Future<bool> registerStore({
    required String fName,
    required String lName,
    required String emailInput,
    required String phoneInput,
    required String passwordInput,
    required String businessNameInput,
    required String addressInput,
    required String category,
  }) async {
    isLoading.value = true;
    try {
      final client = Get.find<ApiClient>();
      
      // Build standard registration form fields
      final response = await client.post('/auth/vendor/register', {
        'f_name': fName,
        'l_name': lName,
        'email': emailInput.trim(),
        'phone': phoneInput.trim(),
        'password': passwordInput,
        'minimum_delivery_time': '30',
        'maximum_delivery_time': '45',
        'delivery_time_type': 'min',
        'latitude': '29.7604',
        'longitude': '-95.3698',
        'zone_id': '1',
        'module_id': '1',
        'business_plan': 'commission',
        'translations': '[{"translationable_type":"App\\\\Models\\\\Store","key":"name","value":"$businessNameInput","locale":"en"},{"translationable_type":"App\\\\Models\\\\Store","key":"address","value":"$addressInput","locale":"en"}]',
        // In real backend, files are sent, but if mock/staged we fall back
        'logo': 'default.png',
        'cover_photo': 'default.png',
      });

      if (response.status.isOk && response.body != null) {
        Get.snackbar(
          'Registration Submitted',
          'Application placed successfully. Pending Admin review.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return true;
      }
      
      final errors = response.body?['errors'];
      final message = (errors is List && errors.isNotEmpty)
          ? errors[0]['message']
          : 'Registration failed. Check format/coordinates.';
          
      Get.snackbar(
        'Registration Failed',
        message.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Registration exception: $e');
      Get.snackbar(
        'Offline Staging',
        'Staging profile registered locally.',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Fallback
      businessName.value = businessNameInput;
      email.value = emailInput;
      phone.value = phoneInput;
      isLoggedIn.value = true;
      isLoading.value = false;
      return true;
    }
    isLoading.value = false;
    return false;
  }

  Future<void> fetchProfile() async {
    if (token.isEmpty) return;
    try {
      final client = Get.find<ApiClient>();
      final response = await client.get('/vendor/profile');
      if (response.status.isOk && response.body != null) {
        final body = response.body;
        email.value = body['email'] ?? '';
        phone.value = body['phone'] ?? '';
        ownerName.value = '${body['f_name'] ?? ''} ${body['l_name'] ?? ''}'.trim();
        
        balance.value = double.tryParse(body['balance']?.toString() ?? '0.0') ?? 0.0;
        totalEarning.value = double.tryParse(body['total_earning']?.toString() ?? '0.0') ?? 0.0;
        todaysEarning.value = double.tryParse(body['todays_earning']?.toString() ?? '0.0') ?? 0.0;
        weeklyEarning.value = double.tryParse(body['this_week_earning']?.toString() ?? '0.0') ?? 0.0;
        monthlyEarning.value = double.tryParse(body['this_month_earning']?.toString() ?? '0.0') ?? 0.0;
        withdrawableBalance.value = double.tryParse(body['withdraw_able_balance']?.toString() ?? '0.0') ?? 0.0;
        cashInHands.value = double.tryParse(body['cash_in_hands']?.toString() ?? '0.0') ?? 0.0;
        pendingWithdraw.value = double.tryParse(body['pending_withdraw']?.toString() ?? '0.0') ?? 0.0;
        totalWithdrawn.value = double.tryParse(body['total_withdrawn']?.toString() ?? '0.0') ?? 0.0;
        
        orderCount.value = int.tryParse(body['order_count']?.toString() ?? '0') ?? 0;

        final stores = body['stores'];
        if (stores != null) {
          businessName.value = stores['name'] ?? 'Houston Fine Tailoring';
          city.value = stores['address'] ?? 'Houston, TX';
          addressNotes.value = stores['address'] ?? 'Heights Studio';
          storeStatus.value = (stores['status'] == 1 || stores['isOpen'] == true) ? 'open' : 'closed';
          storeRating.value = double.tryParse(stores['rating']?.toString() ?? '4.8') ?? 4.8;
          totalReviews.value = int.tryParse(stores['totalReviews']?.toString() ?? '12') ?? 12;
          
          final module = stores['module'];
          if (module != null) {
            businessType.value = module['module_type'] ?? 'Fashion Fit & Sizing';
          }
        }
        
        await fetchFashionFitRequests();
      }
    } catch (e) {
      debugPrint('Fetch profile exception: $e');
    }
  }

  Future<void> fetchFashionFitRequests() async {
    if (token.isEmpty) return;
    try {
      final client = Get.find<ApiClient>();
      final response = await client.get('/vendor/fashion-fit/requests');
      if (response.status.isOk && response.body != null) {
        final List<dynamic> list = response.body['data'] ?? [];
        final mapped = list.map((json) {
          final profile = json['profile'] ?? {};
          final List<dynamic> estimates = json['estimates'] ?? [];
          final activeEstimate = estimates.isNotEmpty ? estimates.last : null;
          
          return FashionFitQuoteRequest(
            id: json['uuid'] ?? json['id']?.toString() ?? '',
            customerName: profile['name'] ?? 'Customer',
            customerPhone: profile['phone'] ?? '+18325559876',
            chestSize: profile['measurements']?['chest']?.toString() ?? 'N/A',
            waistSize: profile['measurements']?['waist']?.toString() ?? 'N/A',
            inseam: profile['measurements']?['inseam']?.toString() ?? 'N/A',
            gender: profile['gender'] ?? 'N/A',
            requestType: json['service_type'] ?? 'Alteration',
            status: json['status'] ?? 'pending',
            date: json['created_at']?.toString().split('T').first ?? '2026-07-14',
            quoteAmount: activeEstimate != null ? double.tryParse(activeEstimate['amount']?.toString() ?? '') : null,
            notes: activeEstimate?['notes'],
            estCompletion: activeEstimate != null ? '${activeEstimate['timeline_days']} Days' : null,
          );
        }).toList();
        
        sizingQuoteRequests.value = mapped;
      }
    } catch (e) {
      debugPrint('Error fetching Fashion Fit requests: $e');
    }
  }

  Future<void> updateFashionFitStatus(String requestUuid, String status) async {
    try {
      final client = Get.find<ApiClient>();
      final response = await client.post('/vendor/fashion-fit/requests/$requestUuid/status', {
        'status': status,
      });
      if (response.status.isOk) {
        Get.snackbar(
          'Workflow Updated',
          'Sizing project status is now: $status',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchFashionFitRequests();
      }
    } catch (e) {
      debugPrint('Error updating Fashion Fit status: $e');
    }
  }

  Future<void> submitFashionFitQuote(String requestUuid, double amount, String timelineDays, String notes) async {
    try {
      final client = Get.find<ApiClient>();
      final days = int.tryParse(timelineDays.replaceAll(RegExp(r'[^0-9]'), '')) ?? 3;
      final response = await client.post('/vendor/fashion-fit/requests/$requestUuid/estimates', {
        'amount': amount,
        'timeline_days': days,
        'notes': notes,
        'requirements': 'Material and tailoring constraints apply.',
      });
      if (response.status.isOk) {
        Get.snackbar(
          'Quote Submitted',
          'Estimate submitted successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchFashionFitRequests();
      }
    } catch (e) {
      debugPrint('Error submitting Fashion Fit quote: $e');
    }
  }

  Future<void> updateFcmToken(String fcmToken) async {
    if (token.isEmpty) return;
    try {
      final client = Get.find<ApiClient>();
      final response = await client.put(
        '/vendor/update-fcm-token',
        {
          'fcm_token': fcmToken,
        },
        headers: {
          'vendorType': 'owner',
        },
      );
      if (response.status.isOk) {
        debugPrint('FCM Token registered on backend successfully.');
      }
    } catch (e) {
      debugPrint('Error updating FCM Token: $e');
    }
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
