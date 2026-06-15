import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class MedicalCourierScreen extends StatelessWidget {
  const MedicalCourierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Courier')),
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
                Expanded(child: Text('Preview — not live medical transport. No HIPAA compliance or real logistics.', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Card(child: ListTile(title: Text('STAT Deliveries'), subtitle: Text('Preview — not yet operational'))),
                Card(child: ListTile(title: Text('Chain Of Custody'), subtitle: Text('Preview — not yet operational'))),
                Card(child: ListTile(title: Text('Temperature Logging'), subtitle: Text('Preview — not yet operational'))),
                Card(child: ListTile(title: Text('Medical Routes'), subtitle: Text('Preview — not yet operational'))),
                Card(child: ListTile(title: Text('Incident Reporting'), subtitle: Text('Preview — not yet operational'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
