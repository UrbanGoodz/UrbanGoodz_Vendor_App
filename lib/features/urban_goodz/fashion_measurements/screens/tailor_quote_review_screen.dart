import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class TailorQuoteReviewScreen extends StatelessWidget {
  const TailorQuoteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color ugCanvas = Color(0xFFE2D3BF);
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Review Fitting Quote',
          style: robotoBold.copyWith(color: ugBlack),
        ),
        backgroundColor: ugCanvas,
        iconTheme: const IconThemeData(color: ugBlack),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom fitting preview banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  border: Border.all(color: Colors.amber.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quote Status: Pending Acceptance',
                      style: robotoBold.copyWith(fontSize: 14, color: ugOrange),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preview how a tailor estimate may appear after manual profile and photo-reference review.',
                      style: robotoRegular.copyWith(fontSize: 13, color: ugBlack),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Quote breakdown',
                style: robotoBold.copyWith(fontSize: 18, color: ugBlack),
              ),
              const SizedBox(height: 12),

              _buildQuoteItem('Bespoke Creation (Tuxedo)', '\$150.00'),
            _buildQuoteItem('Photo Reference Review', '\$15.00'),
              _buildQuoteItem('Service Taxes', '\$10.25'),
              const Divider(height: 32),
              _buildQuoteItem('Total Estimate', '\$175.25', isTotal: true),
              const SizedBox(height: 24),

              Text(
                'Tailor Notes',
                style: robotoBold.copyWith(fontSize: 16, color: ugBlack),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  'Based on the manual profile and photo-reference preview, the tailor may suggest fit adjustments before any production work starts.',
                  style: robotoRegular.copyWith(fontSize: 13, color: Colors.grey.shade800, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Quote Declined.')),
                        );
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Decline Quote',
                        style: robotoBold.copyWith(color: Colors.red, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quote acceptance preview selected. Live payment and production status are not connected yet.'),
                            backgroundColor: ugOrange,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ugOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Preview Acceptance',
                        style: robotoBold.copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteItem(String name, String value, {bool isTotal = false}) {
    const Color ugBlack = Color(0xFF161616);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: isTotal
                ? robotoBold.copyWith(fontSize: 16, color: ugBlack)
                : robotoRegular.copyWith(fontSize: 14, color: ugBlack.withValues(alpha: 0.8)),
          ),
          Text(
            value,
            style: isTotal
                ? robotoBold.copyWith(fontSize: 18, color: ugBlack)
                : robotoRegular.copyWith(fontSize: 14, color: ugBlack),
          ),
        ],
      ),
    );
  }
}
