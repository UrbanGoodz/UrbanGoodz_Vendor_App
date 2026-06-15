import 'package:flutter/material.dart';
import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

class OrderAnywhereSummaryCard extends StatelessWidget {
  final OrderAnywhereRequestModel request;
  const OrderAnywhereSummaryCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.ugWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _row('Business:', request.businessName),
        _row('Item:', request.itemName),
        _row('Qty:', '${request.quantity}'),
        _row('Est. Cost:', '\$${request.estimatedItemCost.toStringAsFixed(2)}'),
        if (request.id != null) _row('Request ID:', request.id!),
        _row('Status:', request.requestStatus.value.replaceAll('_', ' ')),
        _row('Payment:', request.paymentStatus.value),
        if (request.estimatedTotal > 0) _row('Total:', '\$${request.estimatedTotal.toStringAsFixed(2)}',
            isBold: true),
      ]),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }
}
