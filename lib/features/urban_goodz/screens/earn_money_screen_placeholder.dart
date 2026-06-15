import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';

import '../domain/models/earn_money_opportunity_model.dart';
import '../domain/services/earn_money_api_service.dart';

class EarnMoneyScreen extends StatelessWidget {
  const EarnMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = EarnMoneyApiService();

    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text('Earn Money'),
        backgroundColor: AppConstants.ugBlack,
        foregroundColor: AppConstants.ugWhite,
      ),
      body: FutureBuilder<List<EarnMoneyOpportunityModel>>(
        future: service.getOpportunities(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final opportunities = snapshot.data!;
          final featured = opportunities.where((o) => o.isFeatured).toList();
          final secondary = opportunities.where((o) => !o.isFeatured).toList();

          VoidCallback? _navigationFor(EarnMoneyOpportunityModel opp) {
            switch (opp.id) {
              case '4' : return () => Get.toNamed(RouteHelper.getUrbanGoodzLoadBoardRoute());
              case '5' : return () => Get.toNamed(RouteHelper.getUrbanGoodzMedicalCourierRoute());
              case '10': return () => Get.toNamed(RouteHelper.getUrbanGoodzBookServicesRoute());
              case '2' : return () => Get.toNamed(RouteHelper.getOrderAnywhereRequestRoute());
              default  : return null;
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _EarnMoneyHeader(),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppConstants.seasoningOrange),
                    SizedBox(width: 8),
                    Expanded(child: Text('Rentals is fully functional. All other opportunities are preview-only and do not process live requests yet.',
                      style: TextStyle(fontSize: 12),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (featured.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.trending_up, size: 18, color: AppConstants.seasoningOrange),
                    const SizedBox(width: 6),
                    Text('Featured Opportunities',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.ugBlack),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...featured.map((o) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OpportunityCard(opportunity: o, isFeatured: true, onTap: _navigationFor(o)),
                )),
                const SizedBox(height: 16),
                Text('More Ways to Earn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.ugBlack),
                ),
                const SizedBox(height: 10),
                ...secondary.map((o) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _OpportunityCard(opportunity: o, isFeatured: false, onTap: _navigationFor(o)),
                )),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EarnMoneyHeader extends StatelessWidget {
  const _EarnMoneyHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.ugWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monetization_on, color: AppConstants.seasoningOrange, size: 28),
              const SizedBox(width: 8),
              const Text('Find ways to earn', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Preview features: logistics, medical courier, fashion, and more. Rentals is the only fully available option.',
            style: TextStyle(fontSize: 14, color: AppConstants.ugBlack.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final EarnMoneyOpportunityModel opportunity;
  final bool isFeatured;
  final VoidCallback? onTap;

  const _OpportunityCard({required this.opportunity, this.isFeatured = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.ugWhite,
          borderRadius: BorderRadius.circular(12),
          border: isFeatured ? Border.all(color: AppConstants.seasoningOrange, width: 1.5) : null,
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppConstants.seasoningOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(opportunity.icon, color: AppConstants.seasoningOrange, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(opportunity.title,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      if (opportunity.isBeta)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.dijon,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('PREVIEW',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppConstants.ugBlack),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${opportunity.type}',
                    style: TextStyle(fontSize: 12, color: AppConstants.seasoningOrange, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(opportunity.description,
                    style: TextStyle(fontSize: 13, color: AppConstants.ugBlack.withValues(alpha: 0.6)),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppConstants.seasoningOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(opportunity.earningLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isFeatured ? 15 : 13,
                  color: AppConstants.ugBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
