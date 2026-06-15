import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class LogisticsLoadBoardScreen extends StatelessWidget {
  const LogisticsLoadBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Load Board')),
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
                Expanded(child: Text('Preview — load posting, carrier matching, and dispatch are not yet implemented.', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                ListTile(title: Text('Same-Day Delivery')),
                ListTile(title: Text('Last-Mile Delivery')),
                ListTile(title: Text('Middle-Mile Route')),
                ListTile(title: Text('Cargo Van Load')),
                ListTile(title: Text('Pickup Truck Load')),
                ListTile(title: Text('Box Truck Load')),
                ListTile(title: Text('Medical Adjacent Route')),
                ListTile(title: Text('Retail Replenishment')),
                ListTile(title: Text('Enterprise Delivery')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
