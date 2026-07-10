import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/order_anywhere/controllers/order_anywhere_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class OrderAnywhereReviewScreen extends StatelessWidget {
  const OrderAnywhereReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text('Review Request'),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
      ),
      body: GetBuilder<OrderAnywhereController>(builder: (ctrl) {
        final req = ctrl.currentRequest;
        final serviceFee = req.serviceFeeCalculated;
        final deliveryFee = req.deliveryFee;
        final tip = req.tip;
        final itemCost = req.estimatedItemCost * req.quantity;
        final total = itemCost + deliveryFee + serviceFee + tip;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.3)),
                ),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(Icons.warning_amber_rounded, color: AppConstants.seasoningOrange, size: 18),
                    SizedBox(width: 8),
                    Text('TEST ESTIMATE',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.seasoningOrange)),
                  ]),
                  SizedBox(height: 4),
                  Text(
                    'Backend final pricing required before production. This is a local test calculation only.',
                    style: TextStyle(fontSize: 12, color: AppConstants.ugBlack),
                  ),
                ]),
              ),

              const SizedBox(height: 20),

              _sectionLabel('Request Summary'),
              const SizedBox(height: 8),
              _summaryRow('Business', req.businessName),
              _summaryRow('Item', req.itemName),
              _summaryRow('Quantity', '${req.quantity}'),
              _summaryRow('Pickup', req.pickupPreference.label),
              _summaryRow('Urgency', req.urgency.label),
              const Divider(height: 24),

              _sectionLabel('Estimated Cost Breakdown'),
              const SizedBox(height: 8),
              _summaryRow('Item Cost (${req.quantity} × \$${req.estimatedItemCost.toStringAsFixed(2)})',
                  '\$${itemCost.toStringAsFixed(2)}'),
              _summaryRow('Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
              _summaryRow('Service Fee (15% / min \$5)', '\$${serviceFee.toStringAsFixed(2)}'),
              _summaryRow('Tip',
                  tip > 0 ? '\$${tip.toStringAsFixed(2)}' : 'None'),
              const Divider(height: 24),
              _summaryRow('Estimated Total', '\$${total.toStringAsFixed(2)}',
                  isTotal: true),

              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Drivers cannot accept unpaid Order Anywhere requests. '
                  'Final receipt may require refund or additional approval.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),

              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Row(children: [
                  Icon(Icons.block, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Cash on Delivery (COD) is not available for Order Anywhere. '
                        'Payment must be made before dispatch.',
                        style: TextStyle(fontSize: 12, color: Colors.red)),
                  ),
                ]),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.seasoningOrange,
                    foregroundColor: AppConstants.ugWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: ctrl.isSubmitting ? null : () => ctrl.submitRequest(),
                  child: ctrl.isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Submit Request — Test Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: AppConstants.ugBlack));
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal))),
          const SizedBox(width: 12),
          Text(value, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }
}
