import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

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
        title: const Text(
          'Earn Money Opportunities',
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
      body: FutureBuilder<List<EarnMoneyOpportunityModel>>(
        future: service.getOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.seasoningOrange,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Connection Error',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: AppConstants.ugBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load opportunities. Please check your network or try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppConstants.ugBlack.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 24),
                    UrbanGoodzActionButton(
                      label: 'Try Again',
                      onPressed: () {
                        // Triggers rebuild
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          final opportunities = snapshot.data ?? [];

          if (opportunities.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppConstants.seasoningOrange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.work_off_outlined, color: AppConstants.seasoningOrange, size: 48),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Earning Opportunities Found',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: AppConstants.ugBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No earning opportunities are listed in your area yet. Check back soon for new local runs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppConstants.ugBlack.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeDefault,
              right: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault,
              bottom: Dimensions.paddingSizeDefault + 80, // Safe bottom spacing
            ),
            itemCount: opportunities.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: Dimensions.paddingSizeDefault),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _EarnMoneyHeader(opportunityCount: opportunities.length);
              }

              final opportunity = opportunities[index - 1];
              return _OpportunityCard(opportunity: opportunity);
            },
          );
        },
      ),
    );
  }
}

class _EarnMoneyHeader extends StatelessWidget {
  final int opportunityCount;
  const _EarnMoneyHeader({required this.opportunityCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Stats Dashboard Area
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFAF7F2), AppConstants.canvas],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppConstants.seasoningOrange.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppConstants.ugBlack.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Earning Opportunity Hub',
                    style: TextStyle(
                      color: AppConstants.ugBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConstants.seasoningOrange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppConstants.seasoningOrange, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppConstants.seasoningOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'OPPORTUNITY FEED',
                          style: TextStyle(
                            color: AppConstants.seasoningOrange,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Available Gigs',
                      '$opportunityCount Listed',
                      Icons.work_history_outlined,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppConstants.ugBlack.withValues(alpha: 0.1)),
                  Expanded(
                    child: _buildStatItem(
                      'Est. Payout',
                      'Up to \$35/hr',
                      Icons.bolt_outlined,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppConstants.ugBlack.withValues(alpha: 0.1)),
                  Expanded(
                    child: _buildStatItem(
                      'Market Status',
                      'Demand Signals',
                      Icons.trending_up,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Summary Card
        Card(
          color: AppConstants.ugWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: AppConstants.seasoningOrange.withValues(alpha: 0.3),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Earning Paths',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.ugBlack,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Food, shopping, logistics, medical courier, creator campaigns, referrals, and service booking paths may appear here as opportunities become available.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3B332B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppConstants.seasoningOrange, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppConstants.ugBlack,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: AppConstants.ugBlack.withValues(alpha: 0.6),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final EarnMoneyOpportunityModel opportunity;

  const _OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.ugWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: opportunity.recommended 
              ? AppConstants.seasoningOrange 
              : AppConstants.ugBlack.withValues(alpha: 0.08), 
          width: opportunity.recommended ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.ugBlack.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            if (opportunity.recommended)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                color: AppConstants.seasoningOrange,
                child: const Row(
                  children: [
                    Icon(Icons.star, color: AppConstants.ugBlack, size: 12),
                    SizedBox(width: 6),
                    Text(
                      'RECOMMENDED FOR YOU',
                      style: TextStyle(
                        color: AppConstants.ugBlack,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppConstants.seasoningOrange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.seasoningOrange.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(opportunity.icon, color: AppConstants.seasoningOrange, size: 24),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: AppConstants.ugBlack,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppConstants.canvas.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            opportunity.type.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF5A4D41),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          opportunity.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: AppConstants.ugBlack.withValues(alpha: 0.75),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: AppConstants.ugBlack.withValues(alpha: 0.4), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              opportunity.distanceLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.ugBlack.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.access_time_outlined, color: AppConstants.ugBlack.withValues(alpha: 0.4), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              opportunity.scheduleLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.ugBlack.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        opportunity.earningLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: AppConstants.seasoningOrange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E276).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFE5E276), width: 1),
                        ),
                        child: const Text(
                          'Listed',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppConstants.ugBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
