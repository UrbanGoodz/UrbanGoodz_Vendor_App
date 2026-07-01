import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/urban_goodz/discovery/discovery_api_service.dart';
import 'package:sixam_mart/features/urban_goodz/discovery/discovery_search_capture_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/module_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class DiscoveryNoResultsWidget extends StatefulWidget {
  final String searchText;
  final bool isStoreSearch;

  const DiscoveryNoResultsWidget({
    super.key,
    required this.searchText,
    required this.isStoreSearch,
  });

  @override
  State<DiscoveryNoResultsWidget> createState() =>
      _DiscoveryNoResultsWidgetState();
}

class _DiscoveryNoResultsWidgetState extends State<DiscoveryNoResultsWidget> {
  late final TextEditingController _queryController;
  String _urgency = 'soon';
  bool _notifyMe = true;
  bool _sourceRequest = true;
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  static const Color _orange = Color(0xFFED9914);
  static const Color _black = Color(0xFF161616);
  static const Color _dijon = Color(0xFFE5E276);

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(text: widget.searchText.trim());
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double maxWidth = isDesktop ? 720 : double.infinity;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            padding: EdgeInsets.all(
              isDesktop
                  ? Dimensions.paddingSizeExtraLarge
                  : Dimensions.paddingSizeLarge,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              border: Border.all(color: _orange.withValues(alpha: 0.35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: _black.withValues(alpha: 0.08),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBadge(),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Text(
                  _isSubmitted
                      ? 'Request captured'
                      : 'Can\'t find it yet? Urban Goodz can help.',
                  style: robotoBold.copyWith(
                    color: _black,
                    fontSize: isDesktop ? 26 : 22,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  _isSubmitted
                      ? 'Thanks. This search is now a demand signal for local discovery and future marketplace opportunities.'
                      : 'Tell us what you need and Urban Goodz can help capture demand and explore local provider options.',
                  style: robotoRegular.copyWith(
                    color: _black.withValues(alpha: 0.7),
                    height: 1.45,
                    fontSize: 14,
                  ),
                ),
                if (_isSubmitted) ...[
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.25), width: 1),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          color: Colors.green,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Demand Signal Registered',
                          style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: _black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Urban Goodz has saved your request.',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: _black.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  
                  // "What happens next?" section
                  Text(
                    'What Happens Next?',
                    style: robotoBold.copyWith(
                      color: _black,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  
                  // Timeline steps
                  _buildTimelineStep(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    title: 'Search Request Captured',
                    description: 'Demand signal recorded in our system to prioritize local supplier sourcing.',
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    icon: Icons.search,
                    iconColor: _orange,
                    title: 'Local Provider Matching',
                    description: 'Our team analyzes local business catalogs & creator networks to match your needs.',
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    icon: Icons.notifications_active_outlined,
                    iconColor: _black.withValues(alpha: 0.5),
                    title: 'Alert Notification',
                    description: 'We will notify you via in-app alerts as soon as matched items are available.',
                    isLast: true,
                  ),
                  
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  
                  // Suggestion Chips / Next Actions
                  Text(
                    'Try other Urban Goodz services:',
                    style: robotoMedium.copyWith(
                      color: _black.withValues(alpha: 0.6),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        backgroundColor: _orange.withValues(alpha: 0.12),
                        side: BorderSide(color: _orange.withValues(alpha: 0.3)),
                        label: Text('Open UG Hub', style: robotoBold.copyWith(color: _black, fontSize: 12)),
                        onPressed: () => Get.offNamed(RouteHelper.getUrbanGoodzHubRoute()),
                      ),
                      ActionChip(
                        backgroundColor: _black.withValues(alpha: 0.05),
                        side: BorderSide(color: _black.withValues(alpha: 0.15)),
                        label: Text('Ask UG AI', style: robotoBold.copyWith(color: _black, fontSize: 12)),
                        onPressed: () => Get.offNamed(RouteHelper.getUrbanGoodzAIRoute()),
                      ),
                      ActionChip(
                        backgroundColor: _black.withValues(alpha: 0.05),
                        side: BorderSide(color: _black.withValues(alpha: 0.15)),
                        label: Text('Back to Home', style: robotoBold.copyWith(color: _black, fontSize: 12)),
                        onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute()),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ],
                const SizedBox(height: Dimensions.paddingSizeLarge),
                if (!_isSubmitted) ...[
                  TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      labelText: 'What were you looking for?',
                      labelStyle: const TextStyle(color: _orange, fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: _orange, width: 2),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _black.withValues(alpha: 0.15), width: 1.5),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  DropdownButtonFormField<String>(
                    initialValue: _urgency,
                    decoration: InputDecoration(
                      labelText: 'How soon do you need it?',
                      labelStyle: const TextStyle(color: _orange, fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: _orange, width: 2),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _black.withValues(alpha: 0.15), width: 1.5),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'today', child: Text('Today')),
                      DropdownMenuItem(value: 'soon', child: Text('Soon')),
                      DropdownMenuItem(
                        value: 'future',
                        child: Text('Future interest'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _urgency = value ?? _urgency),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _sourceRequest,
                    activeColor: _orange,
                    checkColor: _black,
                    title: Text(
                      'Ask Urban Goodz to capture demand and explore options',
                      style: robotoMedium.copyWith(color: _black, fontSize: 14),
                    ),
                    onChanged: (value) =>
                        setState(() => _sourceRequest = value ?? true),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _notifyMe,
                    activeColor: _orange,
                    checkColor: _black,
                    title: Text(
                      'Notify me when it becomes available',
                      style: robotoMedium.copyWith(color: _black, fontSize: 14),
                    ),
                    onChanged: (value) =>
                        setState(() => _notifyMe = value ?? true),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orange,
                        foregroundColor: _black,
                        elevation: 2,
                        shadowColor: _orange.withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeDefault,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusDefault,
                          ),
                        ),
                      ),
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: _black),
                            )
                          : Text(
                              'Submit Search Request',
                              style: robotoBold.copyWith(color: _black, fontSize: 14, letterSpacing: 0.5),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _dijon.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _dijon, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.explore_outlined, color: _black, size: 14),
          const SizedBox(width: 6),
          Text(
            'Urban Goodz Discovery',
            style: robotoBold.copyWith(
              color: _black,
              fontSize: 11,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final String query = _queryController.text.trim();
    if (query.isEmpty) {
      Get.snackbar('Search request', 'Please enter what you are looking for.');
      return;
    }

    setState(() => _isSubmitting = true);

    final DiscoveryApiService service = DiscoveryApiService(
      apiClient: Get.find<ApiClient>(),
    );
    final Response response = await service.captureSearch(_buildCapture(query));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _isSubmitted = response.statusCode == 200 || response.statusCode == 201;
    });

    if (!_isSubmitted) {
      Get.snackbar(
        'Search request',
        response.statusText ?? 'Unable to submit this request right now.',
      );
    }
  }

  DiscoverySearchCaptureModel _buildCapture(String query) {
    final ModuleModel? module = ModuleHelper.getModule();
    final AddressModel? address = AddressHelper.getUserAddressFromSharedPref();
    return DiscoverySearchCaptureModel(
      searchQuery: query,
      moduleId: module?.id,
      moduleName: module?.moduleName,
      moduleType: module?.moduleType,
      zoneId: address?.zoneId ?? _firstZoneId(address),
      zoneName: null,
      country: Get.find<SplashController>().configModel?.country,
      userId: _currentUserId(),
      devicePlatform: _devicePlatform(),
      timestamp: DateTime.now().toUtc().toIso8601String(),
      intentGuess: _guessIntent(query, module),
      urgency: _urgency,
      notifyMe: _notifyMe,
      sourceRequest: _sourceRequest,
      requestType: widget.isStoreSearch ? 'store' : 'item',
    );
  }

  int? _currentUserId() {
    if (!AuthHelper.isLoggedIn() || !Get.isRegistered<ProfileController>()) {
      return null;
    }
    return Get.find<ProfileController>().userInfoModel?.id;
  }

  int? _firstZoneId(AddressModel? address) {
    final List<int>? zoneIds = address?.zoneIds;
    return zoneIds != null && zoneIds.isNotEmpty ? zoneIds.first : null;
  }

  String _devicePlatform() {
    if (GetPlatform.isWeb) return 'web';
    if (GetPlatform.isAndroid) return 'android';
    if (GetPlatform.isIOS) return 'ios';
    if (GetPlatform.isWindows) return 'windows';
    if (GetPlatform.isMacOS) return 'macos';
    if (GetPlatform.isLinux) return 'linux';
    return 'unknown';
  }

  String _guessIntent(String query, ModuleModel? module) {
    final String value =
        '${query.toLowerCase()} ${module?.moduleName?.toLowerCase() ?? ''} ${module?.moduleType?.toLowerCase() ?? ''}';
    if (_hasAny(value, ['rental', 'rent', 'vehicle', 'car'])) {
      return 'rental';
    }
    if (_hasAny(value, ['event', 'creator', 'ticket', 'pop up', 'popup'])) {
      return 'event';
    }
    if (_hasAny(value, ['courier', 'parcel', 'delivery', 'ship'])) {
      return 'courier';
    }
    if (_hasAny(value, ['service', 'book', 'appointment', 'repair'])) {
      return 'service';
    }
    if (_hasAny(value, ['restaurant', 'food', 'truck', 'meal', 'catering'])) {
      return 'food';
    }
    if (_hasAny(value, ['pharmacy', 'health', 'medical', 'medicine'])) {
      return 'medical';
    }
    if (_hasAny(value, ['fashion', 'clothes', 'shoe', 'sneaker', 'beauty'])) {
      return 'fashion';
    }
    if (_hasAny(value, ['business', 'vendor', 'store', 'shop'])) {
      return 'business';
    }
    if (widget.isStoreSearch) {
      return 'business';
    }
    if (query.trim().isNotEmpty) {
      return 'product';
    }
    return 'unknown';
  }

  bool _hasAny(String value, List<String> needles) {
    return needles.any(value.contains);
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withValues(alpha: 0.3), width: 1),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: iconColor.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: robotoBold.copyWith(fontSize: 14, color: _black),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: robotoRegular.copyWith(fontSize: 12, color: _black.withValues(alpha: 0.6), height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
