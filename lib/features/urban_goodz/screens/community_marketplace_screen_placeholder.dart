import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class CommunityMarketplaceScreen extends StatelessWidget {
  const CommunityMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Marketplace')),
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
                Expanded(child: Text('Preview — community features are not yet available.', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ListTile(title: Text('Featured Zone Groups')),
                ListTile(title: Text('Trending Local Posts')),
                ListTile(title: Text('Nationwide Discussions')),
                ListTile(title: Text('Business Recommendations')),
                ListTile(title: Text('Ask The Community')),
                ListTile(title: Text('Earn Money Opportunities')),
                Card(child: ListTile(title: Text('Post Actions'), subtitle: Text('View Business • Order Anywhere • Book Service • Request Delivery • Rent Now • Follow'))),
                Card(child: ListTile(title: Text('Photos & Videos'), subtitle: Text('Media placeholders'))),
                Card(child: ListTile(title: Text('Experience Sharing'), subtitle: Text('Community reviews and recommendations'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
