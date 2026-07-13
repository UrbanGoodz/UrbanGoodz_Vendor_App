import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class ServiceProviderToolsScreen extends StatefulWidget {
  const ServiceProviderToolsScreen({super.key});
  @override
  State<ServiceProviderToolsScreen> createState() =>
      _ServiceProviderToolsScreenState();
}

class _ServiceProviderToolsScreenState
    extends State<ServiceProviderToolsScreen> {
  final repository = Get.find<VendorRepository>();
  Map<String, dynamic> profile = {};
  List<Map<String, dynamic>> services = [];
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
      profile = await repository.serviceProviderProfile();
      services = await repository.providerServices();
      error = null;
    } on VendorApiException catch (exception) {
      error = exception.message;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _editProfile() async {
    final business = TextEditingController(
      text: profile['business_name']?.toString(),
    );
    final description = TextEditingController(
      text: profile['description']?.toString(),
    );
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Provider profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: business,
              decoration: const InputDecoration(labelText: 'Business name'),
            ),
            TextField(
              controller: description,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await repository.updateServiceProviderProfile({
                'business_name': business.text.trim(),
                'description': description.text.trim(),
                'service_areas': <String>[],
                'location_modes': ['mobile', 'in_person'],
              });
              Get.back();
              await _load();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _addService() async {
    final name = TextEditingController();
    final price = TextEditingController();
    String category = 'barber';
    await showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Add service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: category,
                items:
                    const [
                          'barber',
                          'hair_stylist',
                          'braider',
                          'nail_technician',
                          'makeup_artist',
                          'mobile_mechanic',
                          'photographer',
                          'dj',
                          'contractor',
                          'tax_professional',
                          'home_health_provider',
                          'personal_trainer',
                        ]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value.replaceAll('_', ' ')),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setLocal(() => category = value!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Service name'),
              ),
              TextField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(price.text);
                if (name.text.trim().isEmpty || amount == null) return;
                await repository.saveProviderService({
                  'category': category,
                  'name': name.text.trim(),
                  'description': '',
                  'duration_minutes': 60,
                  'price_minor': (amount * 100).round(),
                  'deposit_minor': 0,
                  'currency': 'USD',
                  'requires_quote': false,
                  'is_active': true,
                });
                Get.back();
                await _load();
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setAvailability() async {
    await repository.updateProviderAvailability(
      List.generate(
        5,
        (day) => {
          'day_of_week': day + 1,
          'starts_at': '09:00',
          'ends_at': '17:00',
          'timezone': 'America/Chicago',
        },
      ),
    );
    Get.snackbar(
      'Availability saved',
      'Monday-Friday, 9:00 AM-5:00 PM Central.',
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Provider tools'),
      actions: [
        IconButton(onPressed: _editProfile, icon: const Icon(Icons.edit)),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _addService,
      child: const Icon(Icons.add),
    ),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (error != null)
                  Text(error!, style: const TextStyle(color: Colors.red)),
                Text(
                  profile['business_name']?.toString() ?? 'Service provider',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text('Approval: ${profile['approval_status'] ?? 'pending'}'),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _setAvailability,
                  icon: const Icon(Icons.schedule),
                  label: const Text('Set weekday availability'),
                ),
                const Divider(),
                const Text(
                  'Services',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (services.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No services configured.'),
                  ),
                for (final service in services)
                  ListTile(
                    title: Text(service['name']?.toString() ?? 'Service'),
                    subtitle: Text(
                      '${service['category']?.toString().replaceAll('_', ' ')} - \$${((int.tryParse(service['price_minor']?.toString() ?? '0') ?? 0) / 100).toStringAsFixed(2)}',
                    ),
                    trailing: Icon(
                      (service['is_active'] == true ||
                              service['is_active'] == 1)
                          ? Icons.check_circle
                          : Icons.pause_circle,
                    ),
                  ),
              ],
            ),
          ),
  );
}
