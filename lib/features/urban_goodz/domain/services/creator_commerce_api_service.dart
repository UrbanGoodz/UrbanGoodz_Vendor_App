import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';
import '../models/shoppable_reel_model.dart';

class CreatorCommerceApiService {
  static final List<Map<String, dynamic>> _localApplications = [];
  static final List<Map<String, dynamic>> _localPromotions = [];
  static String? _lastBackendMessage;

  String? get lastBackendMessage => _lastBackendMessage;
  List<Map<String, dynamic>> get localApplications => List.unmodifiable(_localApplications);

  ApiClient? get _apiClient => Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : null;

  Future<List<ShoppableReelModel>> getFeaturedReels() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      ShoppableReelModel(id:'1', title:'Summer Hair Bundle', creatorName:'Houston Beauty Creator', productName:'Hair Bundle', priceLabel:'\$89', likes:2400, views:12000, featured:true),
      ShoppableReelModel(id:'2', title:'Barber Essentials', creatorName:'Fade Specialist', productName:'Barber Kit', priceLabel:'\$59', likes:1800, views:9000),
      ShoppableReelModel(id:'3', title:'Urban Fashion Drop', creatorName:'Style Creator', productName:'Streetwear Collection', priceLabel:'\$120', likes:3400, views:18000),
    ];
  }

  Future<Map<String, dynamic>> submitCreatorApplication(Map<String, dynamic> payload) async {
    final record = {
      ...payload,
      'id': payload['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'status': 'submitted',
      'created_at': DateTime.now().toIso8601String(),
    };

    final apiClient = _apiClient;
    if (apiClient != null) {
      final response = await apiClient.postData(
        AppConstants.creatorCommerceApplicationsUri,
        record,
        handleError: false,
      );
      if ((response.statusCode == 200 || response.statusCode == 201) && response.body is Map) {
        final body = Map<String, dynamic>.from(response.body);
        final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
        _lastBackendMessage = 'Creator application submitted to backend for admin review.';
        _localApplications.insert(0, {...data, 'backend_limited': false});
        return {...data, 'backend_limited': false};
      }
      _lastBackendMessage = 'Creator backend unavailable (${response.statusCode ?? 'no response'}); saved locally for tester status only.';
    } else {
      _lastBackendMessage = 'Creator backend client unavailable; saved locally for tester status only.';
    }

    final fallback = {...record, 'backend_limited': true, 'admin_notes': _lastBackendMessage};
    _localApplications.insert(0, fallback);
    return fallback;
  }

  Future<Map<String, dynamic>> submitCreatorPromotion(Map<String, dynamic> payload) async {
    final record = {
      ...payload,
      'id': payload['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'status': 'submitted',
      'created_at': DateTime.now().toIso8601String(),
    };

    final apiClient = _apiClient;
    if (apiClient != null) {
      final response = await apiClient.postData(
        AppConstants.creatorCommercePromotionsUri,
        record,
        handleError: false,
      );
      if ((response.statusCode == 200 || response.statusCode == 201) && response.body is Map) {
        final body = Map<String, dynamic>.from(response.body);
        final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
        _lastBackendMessage = 'Creator promotion submitted to backend for admin review.';
        _localPromotions.insert(0, {...data, 'backend_limited': false});
        return {...data, 'backend_limited': false};
      }
      _lastBackendMessage = 'Creator promotion backend unavailable (${response.statusCode ?? 'no response'}); saved locally for tester status only.';
    } else {
      _lastBackendMessage = 'Creator backend client unavailable; saved locally for tester status only.';
    }

    final fallback = {...record, 'backend_limited': true, 'admin_notes': _lastBackendMessage};
    _localPromotions.insert(0, fallback);
    return fallback;
  }

  Future<List<Map<String, dynamic>>> getMyCreatorApplications() async {
    final apiClient = _apiClient;
    if (apiClient != null) {
      final response = await apiClient.getData(
        AppConstants.creatorCommerceCustomerApplicationsUri,
        handleError: false,
      );
      if (response.statusCode == 200 && response.body is Map && response.body['data'] is List) {
        return List<Map<String, dynamic>>.from(
          (response.body['data'] as List).map((item) => Map<String, dynamic>.from(item)),
        );
      }
    }

    return localApplications;
  }
}
