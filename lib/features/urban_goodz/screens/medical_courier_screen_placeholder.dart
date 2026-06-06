import 'package:flutter/material.dart';

class MedicalCourierScreen extends StatelessWidget {
  const MedicalCourierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Courier')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(child: ListTile(title: Text('STAT Deliveries'), subtitle: Text('Priority healthcare transport'))),
          Card(child: ListTile(title: Text('Chain Of Custody'), subtitle: Text('Track handoffs and signatures'))),
          Card(child: ListTile(title: Text('Temperature Logging'), subtitle: Text('Placeholder compliance workflow'))),
          Card(child: ListTile(title: Text('Medical Routes'), subtitle: Text('Placeholder route assignments'))),
          Card(child: ListTile(title: Text('Incident Reporting'), subtitle: Text('Placeholder incident workflow'))),
        ],
      ),
    );
  }
}
