import 'package:flutter/material.dart';
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
        title: const Text(
          'Earn Money',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppConstants.ugBlack,
          ),
        ),
      ),
      body: FutureBuilder<List<EarnMoneyOpportunityModel>>(
        future: service.getOpportunities(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final opportunities = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: opportunities.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const _EarnMoneyHeader();
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
  const _EarnMoneyHeader();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.ugWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppConstants.seasoningOrange.withValues(alpha: 0.45),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find ways to earn',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppConstants.ugBlack,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Food, shopping, logistics, medical courier, creator campaigns, referrals, and service bookings.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF3B332B),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final EarnMoneyOpportunityModel opportunity;

  const _OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.ugWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppConstants.ugBlack.withValues(alpha: 0.12)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.seasoningOrange.withValues(alpha: 0.14),
          child: Icon(opportunity.icon, color: AppConstants.seasoningOrange),
        ),
        title: Text(
          opportunity.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppConstants.ugBlack,
          ),
        ),
        subtitle: Text(
          '${opportunity.type}\n${opportunity.description}\n${opportunity.distanceLabel} - ${opportunity.scheduleLabel}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A4037),
            height: 1.35,
          ),
        ),
        isThreeLine: true,
        trailing: Text(
          opportunity.earningLabel,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppConstants.ugBlack,
          ),
        ),
      ),
    );
  }
}
