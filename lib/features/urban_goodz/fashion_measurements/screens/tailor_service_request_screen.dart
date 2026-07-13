import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_request_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_service_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart';

class TailorServiceRequestScreen extends StatefulWidget {
  const TailorServiceRequestScreen({super.key});
  @override
  State<TailorServiceRequestScreen> createState() =>
      _TailorServiceRequestScreenState();
}

class _TailorServiceRequestScreenState
    extends State<TailorServiceRequestScreen> {
  final service = FashionMeasurementApiService();
  final garment = TextEditingController();
  final notes = TextEditingController();
  final budget = TextEditingController();
  List<TailorServiceModel> providers = [];
  TailorServiceModel? provider;
  String type = 'alterations';
  DateTime? due;
  bool sharePhotos = false, loading = true, saving = false;
  String? error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await service.loadLatestProfile();
      providers = await service.getTailorServices(0);
      if (providers.isNotEmpty) provider = providers.first;
    } on FashionFitApiException catch (e) {
      error = e.message;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _submit() async {
    if (provider?.id == null || garment.text.trim().isEmpty || due == null) {
      setState(
        () => error =
            'Select an approved provider, garment/service, and completion date.',
      );
      return;
    }
    setState(() => saving = true);
    try {
      await service.submitMeasurementRequest(
        MeasurementRequestModel(
          vendorId: provider!.id,
          itemWanted: garment.text.trim(),
          requestType: type,
          notes: notes.text.trim(),
          budget: double.tryParse(budget.text),
          dueDate: due,
          consentToSharePhotos: sharePhotos,
        ),
      );
      if (mounted) {
        Get.snackbar(
          'Submitted',
          'Fashion Fit request sent to the authorized provider.',
        );
        Navigator.pop(context);
      }
    } on FashionFitApiException catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Fashion Fit provider request')),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              DropdownButtonFormField<TailorServiceModel>(
                initialValue: provider,
                decoration: const InputDecoration(
                  labelText: 'Approved provider',
                ),
                items: providers
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.serviceName ?? 'Provider'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => provider = v),
              ),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Service type'),
                items:
                    const [
                          'alterations',
                          'custom_garment',
                          'styling',
                          'uniform',
                        ]
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text(v.replaceAll('_', ' ')),
                          ),
                        )
                        .toList(),
                onChanged: (v) => setState(() => type = v!),
              ),
              TextField(
                controller: garment,
                decoration: const InputDecoration(
                  labelText: 'Garment or service',
                ),
              ),
              TextField(
                controller: budget,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Budget (optional)',
                ),
              ),
              TextField(
                controller: notes,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              ListTile(
                title: Text(
                  due == null
                      ? 'Select requested completion date'
                      : due!.toLocal().toString().split(' ').first,
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final value = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (value != null) setState(() => due = value);
                },
              ),
              SwitchListTile(
                value: sharePhotos,
                onChanged: (v) => setState(() => sharePhotos = v),
                title: const Text('Share raw photos with this provider'),
                subtitle: const Text(
                  'Separate from approved measurement sharing. Leave off unless needed.',
                ),
              ),
              ElevatedButton(
                onPressed: saving ? null : _submit,
                child: Text(
                  saving ? 'Submitting…' : 'Submit authorized request',
                ),
              ),
            ],
          ),
  );
}
