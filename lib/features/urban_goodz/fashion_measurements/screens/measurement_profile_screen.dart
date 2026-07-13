import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart';
import 'package:sixam_mart/helper/route_helper.dart';

class MeasurementProfileScreen extends StatefulWidget {
  const MeasurementProfileScreen({super.key});
  @override
  State<MeasurementProfileScreen> createState() =>
      _MeasurementProfileScreenState();
}

class _MeasurementProfileScreenState extends State<MeasurementProfileScreen> {
  final service = FashionMeasurementApiService();
  Map<String, dynamic>? profile;
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      profile = await service.loadLatestProfile();
      error = null;
    } on FashionFitApiException catch (e) {
      error = e.message;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _correct(Map<String, dynamic> row) async {
    final input = TextEditingController(text: row['value']?.toString());
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Correct ${row['name']}'),
        content: TextField(
          controller: input,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(suffixText: row['unit']?.toString()),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final value = double.tryParse(input.text);
              if (value == null) return;
              await service.correctMeasurement(
                int.parse(row['id'].toString()),
                value,
                row['unit']?.toString() ?? 'in',
              );
              Get.back();
              await _load();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Measurement profile'),
      actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
    ),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : error != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error!),
                ElevatedButton(onPressed: _load, child: const Text('Retry')),
              ],
            ),
          )
        : profile == null
        ? _empty()
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                profile!['name']?.toString() ?? 'AI Fit Profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text('Status: ${profile!['status'] ?? 'unknown'}'),
              Text(
                'Generated with model: ${profile!['model_version'] ?? 'pending'}',
              ),
              const SizedBox(height: 12),
              const Text(
                'AI measurements and customer corrections',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              for (final row in _measurements())
                ListTile(
                  title: Text(
                    row['name']?.toString().replaceAll('_', ' ') ??
                        'Measurement',
                  ),
                  subtitle: Text(
                    'Confidence ${((double.tryParse(row['confidence']?.toString() ?? '') ?? 0) * 100).toStringAsFixed(0)}% • ${row['source'] ?? 'AI'}${row['requires_confirmation'] == true ? ' • confirmation required' : ''}',
                  ),
                  trailing: TextButton(
                    onPressed: () => _correct(row),
                    child: Text('${row['value']} ${row['unit']}'),
                  ),
                ),
              if (profile!['status'] == 'customer_review')
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await service.approveProfile();
                      await _load();
                    } on FashionFitApiException catch (e) {
                      setState(() => error = e.message);
                    }
                  },
                  child: const Text('Approve final profile'),
                ),
              OutlinedButton(
                onPressed: () async {
                  await service.revokeSharing();
                  await _load();
                },
                child: const Text('Revoke all sharing'),
              ),
              TextButton(
                onPressed: () async {
                  await service.deleteProfile();
                  await _load();
                },
                child: const Text(
                  'Delete profile',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
  );
  Widget _empty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('No AI measurement profile yet.'),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () =>
              Get.toNamed(RouteHelper.getUrbanGoodzFashionPhotoGuideRoute()),
          child: const Text('Start guided photo measurement'),
        ),
      ],
    ),
  );
  List<Map<String, dynamic>> _measurements() {
    final value = profile?['measurements'];
    return value is List
        ? value
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : [];
  }
}
