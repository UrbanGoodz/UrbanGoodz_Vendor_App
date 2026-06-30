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
              border: Border.all(color: _orange.withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: _black.withValues(alpha: 0.12),
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
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  _isSubmitted
                      ? 'Thanks. This search is now a demand signal for local sourcing, business discovery, and future marketplace opportunities.'
                      : 'Tell us what you need and we\'ll use this search to discover demand, source local providers, and create future opportunities.',
                  style: robotoRegular.copyWith(
                    color: _black.withValues(alpha: 0.76),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                if (!_isSubmitted) ...[
                  TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      labelText: 'What were you looking for?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  DropdownButtonFormField<String>(
                    value: _urgency,
                    decoration: InputDecoration(
                      labelText: 'How soon do you need it?',
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
                    title: Text(
                      'Ask Urban Goodz to find, book, or source it',
                      style: robotoMedium.copyWith(color: _black),
                    ),
                    onChanged: (value) =>
                        setState(() => _sourceRequest = value ?? true),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _notifyMe,
                    activeColor: _orange,
                    title: Text(
                      'Notify me when it becomes available',
                      style: robotoMedium.copyWith(color: _black),
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
                        elevation: 0,
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
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Submit Search Request',
                              style: robotoBold.copyWith(color: _black),
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
        horizontal: Dimensions.paddingSizeSmall,
        vertical: Dimensions.paddingSizeExtraSmall,
      ),
      decoration: BoxDecoration(
        color: _dijon.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Text(
        'Urban Goodz Discovery',
        style: robotoBold.copyWith(
          color: _black,
          fontSize: Dimensions.fontSizeSmall,
        ),
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
    if (_hasAny(value, ['rental', 'rent', 'vehicle', 'car'])) return 'rental';
    if (_hasAny(value, ['event', 'creator', 'ticket', 'pop up', 'popup']))
      return 'event';
    if (_hasAny(value, ['courier', 'parcel', 'delivery', 'ship']))
      return 'courier';
    if (_hasAny(value, ['service', 'book', 'appointment', 'repair']))
      return 'service';
    if (_hasAny(value, ['restaurant', 'food', 'truck', 'meal', 'catering']))
      return 'food';
    if (_hasAny(value, ['pharmacy', 'health', 'medical', 'medicine']))
      return 'medical';
    if (_hasAny(value, ['fashion', 'clothes', 'shoe', 'sneaker', 'beauty']))
      return 'fashion';
    if (_hasAny(value, ['business', 'vendor', 'store', 'shop']))
      return 'business';
    if (widget.isStoreSearch) return 'business';
    if (query.trim().isNotEmpty) return 'product';
    return 'unknown';
  }

  bool _hasAny(String value, List<String> needles) {
    return needles.any(value.contains);
  }
}
