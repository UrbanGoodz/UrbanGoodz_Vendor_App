import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class TailorServiceRequestScreen extends StatefulWidget {
  const TailorServiceRequestScreen({super.key});

  @override
  State<TailorServiceRequestScreen> createState() => _TailorServiceRequestScreenState();
}

class _TailorServiceRequestScreenState extends State<TailorServiceRequestScreen> {
  final TextEditingController _specialInstructionsController = TextEditingController();
  String _selectedService = 'Alterations';
  DateTime? _eventDeadline;

  @override
  void dispose() {
    _specialInstructionsController.dispose();
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
          'Request Bespoke Fitting',
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
                'Submit Sizing Request to Designer',
                style: robotoBold.copyWith(fontSize: 18, color: ugBlack),
              ),
              const SizedBox(height: 8),
              Text(
                'Preview how saved sizing data and photo references may be prepared for tailor/provider review. Live request submission is not connected yet.',
                style: robotoRegular.copyWith(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),

              // Service Category dropdown
              Text(
                'Select Sizing Service Class',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: ['Bespoke Design / Tailoring', 'Alterations & Hemming', 'Uniform Fitting', 'Creator Merch Customization'].map((fit) {
                  return DropdownMenuItem<String>(
                    value: fit,
                    child: Text(fit, style: robotoRegular),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedService = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Event deadline picker
              Text(
                'Required Delivery/Event Deadline',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 14)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _eventDeadline = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _eventDeadline == null
                            ? 'Select Date'
                            : '${_eventDeadline!.year}-${_eventDeadline!.month}-${_eventDeadline!.day}',
                        style: robotoRegular.copyWith(fontSize: 14, color: ugBlack),
                      ),
                      const Icon(Icons.calendar_month, color: ugOrange),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sizing profile selection info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ugCanvas.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ugCanvas),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_pin_rounded, color: ugOrange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sizing Profile Linked',
                            style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Your saved height, bust, waist, and sleeve measurements are shown as preview intake data for this request.',
                            style: robotoRegular.copyWith(fontSize: 12, color: ugBlack.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Special instructions
              Text(
                'Notes & Special Instructions',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _specialInstructionsController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'e.g. Broad shoulders, custom silk lining required, hem at ankles...',
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tailor request preview saved. Live provider submission is not connected yet.'),
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
                  child: Text('Preview Request Intake', style: robotoBold.copyWith(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
