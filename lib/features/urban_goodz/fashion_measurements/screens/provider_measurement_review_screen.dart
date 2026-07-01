import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class ProviderMeasurementReviewScreen extends StatefulWidget {
  const ProviderMeasurementReviewScreen({super.key});

  @override
  State<ProviderMeasurementReviewScreen> createState() => _ProviderMeasurementReviewScreenState();
}

class _ProviderMeasurementReviewScreenState extends State<ProviderMeasurementReviewScreen> {
  final TextEditingController _chestController = TextEditingController(text: '40.0');
  final TextEditingController _waistController = TextEditingController(text: '34.0');
  final TextEditingController _hipsController = TextEditingController(text: '42.0');
  final TextEditingController _adjustedNotesController = TextEditingController();

  @override
  void dispose() {
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _adjustedNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color ugCanvas = Color(0xFFE2D3BF);
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Provider Measurement Review',
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
              Text(
                'Review Sizing Request & Posture Photos',
                style: robotoBold.copyWith(fontSize: 18, color: ugBlack),
              ),
              const SizedBox(height: 8),
              Text(
                'Customer height reference: 70 inches. Adjust estimated values below based on reference front/side photos.',
                style: robotoRegular.copyWith(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),

              // Photos preview section
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.portrait, color: ugOrange, size: 36),
                          const SizedBox(height: 8),
                          Text('Front Reference Photo', style: robotoBold.copyWith(fontSize: 12, color: ugBlack)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.directions_run, color: ugOrange, size: 36),
                          const SizedBox(height: 8),
                          Text('Side Reference Photo', style: robotoBold.copyWith(fontSize: 12, color: ugBlack)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Adjust/Confirm Measurements (inches)',
                style: robotoBold.copyWith(fontSize: 16, color: ugBlack),
              ),
              const SizedBox(height: 12),

              _buildAdjustmentField('Chest/Bust', _chestController),
              _buildAdjustmentField('Waist', _waistController),
              _buildAdjustmentField('Hips', _hipsController),
              const SizedBox(height: 16),

              Text(
                'Provider Feedback & Adjustments',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _adjustedNotesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Adjusted chest to 40.5 after posture photo review...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Requested Clarification from Customer.')),
                        );
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ugOrange),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Request Fitting Session',
                        style: robotoBold.copyWith(color: ugOrange, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Measurement review preview saved. No live invoice was sent.'),
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
                        'Save Preview Review',
                        style: robotoBold.copyWith(fontSize: 13),
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

  Widget _buildAdjustmentField(String label, TextEditingController controller) {
    const Color ugBlack = Color(0xFF161616);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
