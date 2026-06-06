import 'package:flutter/material.dart';

class CreatorCommerceScreen extends StatelessWidget {
  const CreatorCommerceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creator Commerce')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(child: ListTile(title: Text('Shoppable Reels'), subtitle: Text('Creator-driven product discovery'))),
          Card(child: ListTile(title: Text('Featured Creators'), subtitle: Text('Local creators and influencers'))),
          Card(child: ListTile(title: Text('Tagged Products'), subtitle: Text('Purchase directly from content'))),
          Card(child: ListTile(title: Text('Creator Campaigns'), subtitle: Text('Promotions and sponsored content'))),
          Card(child: ListTile(title: Text('Revenue Dashboard'), subtitle: Text('Placeholder creator earnings'))),
        ],
      ),
    );
  }
}
