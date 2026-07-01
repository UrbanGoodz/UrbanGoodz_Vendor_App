import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class MeasurementProfileScreen extends StatefulWidget {
  const MeasurementProfileScreen({super.key});

  @override
  State<MeasurementProfileScreen> createState() => _MeasurementProfileScreenState();
}

class _WebMeasurementField {
  final String label;
  final String hint;
  final TextEditingController controller;

  _WebMeasurementField(this.label, this.hint, this.controller);
}

class _MeasurementProfileScreenState extends State<MeasurementProfileScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipsController = TextEditingController();
  final TextEditingController _inseamController = TextEditingController();
  final TextEditingController _sleeveController = TextEditingController();
  final TextEditingController _shoulderController = TextEditingController();
  final TextEditingController _neckController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _preferredFit = 'Regular';

  @override
  void dispose() {
    _heightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _inseamController.dispose();
    _sleeveController.dispose();
    _shoulderController.dispose();
    _neckController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color ugCanvas = Color(0xFFE2D3BF);
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    final fields = [
      _WebMeasurementField('Height (inches)', 'e.g. 70', _heightController),
      _WebMeasurementField('Chest/Bust (inches)', 'e.g. 40', _chestController),
      _WebMeasurementField('Waist (inches)', 'e.g. 34', _waistController),
      _WebMeasurementField('Hips (inches)', 'e.g. 42', _hipsController),
      _WebMeasurementField('Inseam (inches)', 'e.g. 32', _inseamController),
      _WebMeasurementField('Sleeve Length (inches)', 'e.g. 34.5', _sleeveController),
      _WebMeasurementField('Shoulder Width (inches)', 'e.g. 18', _shoulderController),
      _WebMeasurementField('Neck (inches)', 'e.g. 15.5', _neckController),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Measurement Profile',
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
                'Enter manual sizing references below. Tailors will use these as starting estimates, along with photo uploads, before starting work.',
                style: robotoRegular.copyWith(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),

              // Sizing Inputs Grid
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  final field = fields[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            field.label,
                            style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: field.controller,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: field.hint,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Preferred Fit dropdown
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Preferred Fit',
                      style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: _preferredFit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: ['Slim', 'Regular', 'Loose'].map((fit) {
                        return DropdownMenuItem<String>(
                          value: fit,
                          child: Text(fit, style: robotoRegular),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _preferredFit = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Additional Notes
              Text(
                'Fitting Notes & Special Alterations',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Broad shoulders, prefer roomier leg openings...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Save to API
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitting Profile Saved Successfully!'),
                        backgroundColor: ugOrange,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ugOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Save Sizing Profile', style: robotoBold.copyWith(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
