import 'package:flutter/material.dart';

import '../domain/models/earn_money_opportunity_model.dart';
import '../domain/services/earn_money_api_service.dart';

class EarnMoneyScreen extends StatelessWidget {
  const EarnMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = EarnMoneyApiService();

    return Scaffold(
      appBar: AppBar(title: const Text('Earn Money')),
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
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Find ways to earn', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Food, shopping, logistics, medical courier, creator campaigns, referrals, and service bookings.'),
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
      child: ListTile(
        leading: CircleAvatar(child: Icon(opportunity.icon)),
        title: Text(opportunity.title),
        subtitle: Text('${opportunity.type}\n${opportunity.description}\n${opportunity.distanceLabel} • ${opportunity.scheduleLabel}'),
        isThreeLine: true,
        trailing: Text(opportunity.earningLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
