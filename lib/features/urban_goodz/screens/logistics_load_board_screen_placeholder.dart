import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/urban_goodz/domain/models/logistics_opportunity_model.dart';
import 'package:sixam_mart/features/urban_goodz/domain/services/logistics_api_service.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

class LogisticsLoadBoardScreen extends StatefulWidget {
  const LogisticsLoadBoardScreen({super.key});

  @override
  State<LogisticsLoadBoardScreen> createState() => _LogisticsLoadBoardScreenState();
}

class _LogisticsLoadBoardScreenState extends State<LogisticsLoadBoardScreen> {
  late Future<List<LogisticsOpportunityModel>> _loadsFuture;
  LogisticsApiService? _service;

  static const List<LogisticsOpportunityModel> _fallbackLoads = [];

  @override
  void initState() {
    super.initState();
    _loadsFuture = _loadBackendLoads();
  }

  void _reloadLoads() {
    setState(() {
      _loadsFuture = _loadBackendLoads();
    });
  }

  Future<List<LogisticsOpportunityModel>> _loadBackendLoads() async {
    try {
      final service = _service ??= LogisticsApiService();
      return service.getLoads();
    } catch (_) {
      return const <LogisticsOpportunityModel>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Load Board - Local Logistics',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppConstants.ugBlack,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
      ),
      body: FutureBuilder<List<LogisticsOpportunityModel>>(
        future: _loadsFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final backendLoads = snapshot.data ?? const <LogisticsOpportunityModel>[];
          final usingFallback = !isLoading && (snapshot.hasError || backendLoads.isEmpty);
          final loads = usingFallback ? _fallbackLoads : backendLoads;

          return Column(
            children: [
              UrbanGoodzPreviewBanner(
                message: usingFallback
                    ? 'Opportunity Network - Backend load feed unavailable; showing fallback loads for validation.'
                    : 'Opportunity Network - Available loads are loaded from the backend opportunity feed.',
              ),
              _DispatchStatusBar(usingFallback: usingFallback),
              _LoadBoardSummary(onRefresh: _reloadLoads),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppConstants.seasoningOrange))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        itemCount: loads.length,
                        separatorBuilder: (_, _) => const SizedBox(height: Dimensions.paddingSizeSmall),
                        itemBuilder: (context, index) => _LoadCard(
                          load: loads[index],
                          service: _service,
                          usingFallback: usingFallback,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DispatchStatusBar extends StatelessWidget {
  final bool usingFallback;

  const _DispatchStatusBar({required this.usingFallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppConstants.ugBlack,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.wifi_tethering, color: AppConstants.seasoningOrange, size: 18),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Dispatch load feed',
                style: TextStyle(
                  color: AppConstants.ugWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: usingFallback ? AppConstants.seasoningOrange : Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              usingFallback ? 'Fallback' : 'Live',
              style: TextStyle(
                color: usingFallback ? AppConstants.seasoningOrange : Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadBoardSummary extends StatelessWidget {
  final VoidCallback onRefresh;

  const _LoadBoardSummary({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: AppConstants.ugWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: AppConstants.ugBlack.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logistics Opportunities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppConstants.ugBlack,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Review available backend loads, route previews, equipment requirements, and payout estimates. Drivers can validate accept/load-status flows against the current backend sprint.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppConstants.ugBlack.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: UrbanGoodzActionButton(
                label: 'Refresh Load Feed',
                onPressed: onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadCard extends StatelessWidget {
  final LogisticsOpportunityModel load;
  final LogisticsApiService? service;
  final bool usingFallback;

  const _LoadCard({
    required this.load,
    required this.service,
    required this.usingFallback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showLoadDetails(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.ugWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.canvas.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(load.icon, color: AppConstants.seasoningOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    load.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: AppConstants.ugBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${load.pickupLabel} -> ${load.dropoffLabel}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: AppConstants.ugBlack.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${load.vehicleType} / ${load.distanceLabel}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: AppConstants.ugBlack.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  load.payLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: AppConstants.ugBlack,
                  ),
                ),
                const SizedBox(height: 6),
                UrbanGoodzStatusBadge(
                  status: usingFallback ? 'Fallback' : load.scheduleLabel,
                  isCompact: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(usingFallback ? 'Load Details [Fallback]' : 'Load Details'),
        content: Text(
          '"${load.title}"\n\n'
          'Pickup: ${load.pickupLabel}\n'
          'Dropoff: ${load.dropoffLabel}\n'
          'Type: ${load.category}\n'
          'Equipment: ${load.vehicleType}\n'
          'Distance: ${load.distanceLabel}\n'
          'Payout: ${load.payLabel}\n\n'
          '${usingFallback ? 'Backend load feed was unavailable, so this action is preview-only.' : 'Accept calls POST ${AppConstants.ugLoadBoardLoadsUri}/{id}/accept.'}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.seasoningOrange,
              foregroundColor: AppConstants.ugBlack,
            ),
            onPressed: () async {
              Navigator.pop(context);
              if (usingFallback) {
                Get.snackbar('Tester fallback', 'Load accept is preview-only while backend data is unavailable.');
                return;
              }
              final activeService = service;
              if (activeService == null) {
                Get.snackbar('Load accept unavailable', 'API client is not ready for this session.');
                return;
              }
              final response = await activeService.acceptLoad(load.id);
              if (response.statusCode == 200) {
                final body = response.body;
                final message = body is Map
                    ? body['message']?.toString()
                    : null;
                Get.snackbar(
                  'Load accepted',
                  message ?? 'Load accepted successfully.',
                );
              } else {
                Get.snackbar('Load accept failed', response.statusText ?? 'Backend did not accept this load.');
              }
            },
            child: const Text('Accept Load'),
          ),
        ],
      ),
    );
  }
}
