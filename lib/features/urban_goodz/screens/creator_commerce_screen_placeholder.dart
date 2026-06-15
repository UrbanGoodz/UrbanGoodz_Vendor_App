import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class CreatorCommerceScreen extends StatelessWidget {
  const CreatorCommerceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creator Commerce')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppConstants.seasoningOrange.withValues(alpha: 0.12),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppConstants.seasoningOrange),
                SizedBox(width: 8),
                Expanded(child: Text('Preview — creator commerce features are not yet available.', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Card(child: ListTile(title: Text('Shoppable Reels'), subtitle: Text('Preview — not yet operational'))),
                Card(child: ListTile(title: Text('Featured Creators'), subtitle: Text('Preview — not yet operational'))),
                Card(child: ListTile(title: Text('Tagged Products'), subtitle: Text('Preview — not yet operational'))),
                Card(child: ListTile(title: Text('Creator Campaigns'), subtitle: Text('Preview — not yet operational'))),
                Card(child: ListTile(title: Text('Revenue Dashboard'), subtitle: Text('Preview — not yet operational'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
