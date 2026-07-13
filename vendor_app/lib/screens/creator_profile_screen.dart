import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class CreatorProfileScreen extends StatefulWidget {
  const CreatorProfileScreen({super.key});
  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  final repository = Get.find<VendorRepository>();
  final handle = TextEditingController();
  final name = TextEditingController();
  final bio = TextEditingController();
  bool loading = true;
  String status = 'pending';
  String? error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final row = await repository.creatorProfile();
      handle.text = row['handle']?.toString() ?? '';
      name.text = row['display_name']?.toString() ?? '';
      bio.text = row['bio']?.toString() ?? '';
      status = row['status']?.toString() ?? 'pending';
      error = null;
    } on VendorApiException catch (e) {
      error = e.message;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _save() async {
    try {
      await repository.updateCreatorProfile({
        'handle': handle.text.trim(),
        'display_name': name.text.trim(),
        'bio': bio.text.trim(),
        'niches': <String>[],
        'social_links': <String, Object?>{},
      });
      await _load();
      if (mounted) {
        Get.snackbar('Saved', 'Creator profile submitted for Admin review.');
      }
    } on VendorApiException catch (e) {
      setState(() => error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Creator profile')),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Chip(label: Text('Status: ${status.toUpperCase()}')),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              TextField(
                controller: handle,
                decoration: const InputDecoration(labelText: 'Creator handle'),
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Display name'),
              ),
              TextField(
                controller: bio,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save and submit'),
              ),
            ],
          ),
  );
}
