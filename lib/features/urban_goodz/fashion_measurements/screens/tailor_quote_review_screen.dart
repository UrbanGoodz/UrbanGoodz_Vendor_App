import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_quote_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart';

class TailorQuoteReviewScreen extends StatefulWidget {
  const TailorQuoteReviewScreen({super.key});
  @override
  State<TailorQuoteReviewScreen> createState() =>
      _TailorQuoteReviewScreenState();
}

class _TailorQuoteReviewScreenState extends State<TailorQuoteReviewScreen> {
  final service = FashionMeasurementApiService();
  final quotes = <TailorQuoteModel>[];
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
      final userId = Get.isRegistered<ProfileController>()
          ? (Get.find<ProfileController>().userInfoModel?.id ?? 0)
          : 0;
      final requests = await service.getSubmittedRequests(userId);
      quotes.clear();
      for (final request in requests) {
        if (request.id != null) {
          quotes.addAll(await service.getTailorQuotes(request.id!));
        }
      }
      error = null;
    } on FashionFitApiException catch (e) {
      error = e.message;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _decision(TailorQuoteModel quote, bool accept) async {
    if (quote.id == null) return;
    try {
      if (accept) {
        await service.acceptQuote(quote.id!);
      } else {
        await service.declineQuote(quote.id!);
      }
      await _load();
      if (mounted) {
        Get.snackbar(
          'Decision recorded',
          accept
              ? 'Estimate accepted. Sandbox payment is available only when configured by Admin.'
              : 'Estimate declined and provider access revoked.',
        );
      }
    } on FashionFitApiException catch (e) {
      setState(() => error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Fashion Fit estimates'),
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
        : quotes.isEmpty
        ? const Center(child: Text('No provider estimates yet.'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quotes.length,
            itemBuilder: (_, i) {
              final quote = quotes[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${quote.quoteAmount?.toStringAsFixed(2) ?? '—'}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (quote.comments != null) Text(quote.comments!),
                      Text(
                        'Status: ${quote.isAccepted == true ? 'accepted' : 'submitted'}',
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _decision(quote, false),
                              child: const Text('Decline'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _decision(quote, true),
                              child: const Text('Accept'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}
