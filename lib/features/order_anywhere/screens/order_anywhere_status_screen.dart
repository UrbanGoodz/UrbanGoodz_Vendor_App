import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order_anywhere/controllers/order_anywhere_controller.dart';
import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/order_anywhere/widgets/order_anywhere_summary_card.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';

class OrderAnywhereStatusScreen extends StatefulWidget {
  final String requestId;
  const OrderAnywhereStatusScreen({super.key, required this.requestId});

  @override
  State<OrderAnywhereStatusScreen> createState() => _OrderAnywhereStatusScreenState();
}

class _OrderAnywhereStatusScreenState extends State<OrderAnywhereStatusScreen> {
  late OrderAnywhereController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OrderAnywhereController>();
    controller.loadRequestById(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text('Request Status'),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: UrbanGoodzStatusBadge(status: 'Preview', isCompact: true),
            ),
          ),
        ],
      ),
      body: GetBuilder<OrderAnywhereController>(builder: (ctrl) {
        final req = ctrl.currentRequest;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: req.backendLimited ? Colors.red.shade50 : AppConstants.seasoningOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: req.backendLimited ? Colors.red.shade200 : AppConstants.seasoningOrange.withValues(alpha: 0.3)),
                ),
                child: Row(children: [
                  Icon(req.backendLimited ? Icons.warning_amber_outlined : Icons.info_outline, color: req.backendLimited ? Colors.red : AppConstants.seasoningOrange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      req.backendLimited
                          ? 'Backend-limited fallback: this request is only saved in the customer app session until the Order Anywhere backend endpoint is deployed.'
                          : 'Tester request flow. Live payment is not enabled; admin, vendor, and driver status updates are saved only through the tester backend endpoints.',
                      style: const TextStyle(fontSize: 12, color: AppConstants.ugBlack),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 20),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _statusColor(req.requestStatus).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _statusColor(req.requestStatus)),
                  ),
                  child: Text(
                    req.requestStatus.value.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: _statusColor(req.requestStatus)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              OrderAnywhereSummaryCard(request: req),

              const SizedBox(height: 20),
              _sectionLabel('Admin / Vendor Notes'),
              const SizedBox(height: 8),
              _noteCard('Admin notes', req.adminNotes),
              _noteCard('Vendor notes', req.vendorNotes),
              _noteCard('Driver notes', req.driverNotes ?? req.driverTaskStatus),

              const SizedBox(height: 20),

              _buildStatusTimeline(req.requestStatus),

              const SizedBox(height: 20),
              _sectionLabel('Payment'),
              const SizedBox(height: 8),

              if (req.paymentStatus == OrderAnywherePaymentStatus.unpaid && req.requestStatus.isPreDispatch) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Payment Required Before Dispatch',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text(
                      'COD is not available for Order Anywhere. Use TEST PAYMENT below to simulate pre-payment.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text('TEST PAYMENT ONLY — NOT PRODUCTION'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => ctrl.markTestPayment(),
                      ),
                    ),
                  ]),
                ),
              ],

              if (req.requestStatus == OrderAnywhereRequestStatus.submitted ||
                  req.paymentStatus == OrderAnywherePaymentStatus.paidTest) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Row(children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('Test payment recorded. Driver dispatch would be allowed in production.',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ]),
                ),
              ],

              const SizedBox(height: 20),
              _sectionLabel('Receipt & Reconciliation'),
              const SizedBox(height: 8),
              _buildReceiptSection(req),

              const SizedBox(height: 20),
              _sectionLabel('Driver Dispatch'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(Icons.local_shipping, size: 18, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Dispatch Status: Pending Backend',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ]),
                  SizedBox(height: 8),
                  Text(
                    'Driver dispatch is pending backend assignment. In production, dispatch will only begin after payment and admin reconciliation are complete.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF616161)),
                  ),
                ]),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => ctrl.cancelRequest(),
                  child: const Text('Cancel Request'),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusTimeline(OrderAnywhereRequestStatus current) {
    final steps = [
      OrderAnywhereRequestStatus.draft,
      OrderAnywhereRequestStatus.pendingPayment,
      OrderAnywhereRequestStatus.submitted,
      OrderAnywhereRequestStatus.adminReviewing,
      OrderAnywhereRequestStatus.needsInfo,
      OrderAnywhereRequestStatus.vendorRunnerAssigned,
      OrderAnywhereRequestStatus.driverAssigned,
      OrderAnywhereRequestStatus.inProgress,
      OrderAnywhereRequestStatus.outForDelivery,
      OrderAnywhereRequestStatus.delivered,
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionLabel('Status Timeline'),
      const SizedBox(height: 8),
      ...steps.map((step) {
        final index = steps.indexOf(step);
        final currentIndex = steps.indexOf(current);
        final isComplete = currentIndex >= index;
        final isCurrent = current == step;
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isComplete ? AppConstants.seasoningOrange : Colors.grey.shade300,
              ),
              child: Center(
                child: isComplete
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : Text('${index + 1}', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
              ),
            ),
            if (index < steps.length - 1)
              Container(width: 2, height: 24, color: isComplete ? AppConstants.seasoningOrange : Colors.grey.shade300),
          ]),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              step.value.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isComplete ? AppConstants.ugBlack : Colors.grey,
              ),
            ),
          ),
        ]);
      }),
    ]);
  }

  Widget _buildReceiptSection(OrderAnywhereRequestModel req) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _receiptRow('Estimated Total', '\$${req.estimatedTotal.toStringAsFixed(2)}'),
        _receiptRow('Actual Receipt Amount', req.receiptAmount != null
            ? '\$${req.receiptAmount!.toStringAsFixed(2)}'
            : 'Pending'),
        _receiptRow('Difference', req.receiptDifference != null
            ? '\$${req.receiptDifference!.toStringAsFixed(2)}'
            : 'Pending'),
        _receiptRow('Admin Reconciliation', req.reconciliationStatus ?? 'Pending backend'),
        const Divider(height: 16),
        const Text(
          'Receipt upload and final reconciliation are required before production launch.',
          style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
        ),
      ]),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _noteCard(String label, String? value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        '$label: ${value == null || value.isEmpty ? 'No notes yet' : value}',
        style: const TextStyle(fontSize: 12, color: AppConstants.ugBlack),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text, style: TextStyle(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: AppConstants.ugBlack));
  }

  Color _statusColor(OrderAnywhereRequestStatus status) {
    switch (status) {
      case OrderAnywhereRequestStatus.draft:
      case OrderAnywhereRequestStatus.pendingPayment:
        return Colors.orange;
      case OrderAnywhereRequestStatus.submitted:
      case OrderAnywhereRequestStatus.adminReviewing:
        return Colors.blue;
      case OrderAnywhereRequestStatus.needsInfo:
        return Colors.deepOrange;
      case OrderAnywhereRequestStatus.vendorRunnerAssigned:
      case OrderAnywhereRequestStatus.driverPending:
      case OrderAnywhereRequestStatus.driverAssigned:
      case OrderAnywhereRequestStatus.inProgress:
      case OrderAnywhereRequestStatus.purchasing:
        return Colors.purple;
      case OrderAnywhereRequestStatus.receiptUploaded:
      case OrderAnywhereRequestStatus.adjustmentRequired:
        return Colors.amber;
      case OrderAnywhereRequestStatus.outForDelivery:
        return Colors.teal;
      case OrderAnywhereRequestStatus.delivered:
      case OrderAnywhereRequestStatus.completed:
        return Colors.green;
      case OrderAnywhereRequestStatus.cancelled:
        return Colors.red;
      case OrderAnywhereRequestStatus.refunded:
        return Colors.grey;
    }
  }
}
