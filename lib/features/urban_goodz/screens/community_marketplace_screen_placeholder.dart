import 'package:flutter/material.dart';

class CommunityMarketplaceScreen extends StatelessWidget {
 const CommunityMarketplaceScreen({super.key});
 @override
 Widget build(BuildContext context){
  return Scaffold(
   appBar: AppBar(title: const Text('Community Marketplace')),
   body: ListView(
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
  );
 }
}
