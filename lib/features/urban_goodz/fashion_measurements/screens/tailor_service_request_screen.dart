import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_request_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart';
import 'package:sixam_mart/util/styles.dart';

class TailorServiceRequestScreen extends StatefulWidget {
  const TailorServiceRequestScreen({super.key});

  @override
  State<TailorServiceRequestScreen> createState() =>
      _TailorServiceRequestScreenState();
}

class _TailorServiceRequestScreenState
    extends State<TailorServiceRequestScreen> {
  final TextEditingController _specialInstructionsController =
      TextEditingController();
  final TextEditingController _itemWantedController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String _selectedService = 'Alterations';
  DateTime? _eventDeadline;
  XFile? _inspirationImage;
  bool _consentToSharePhotos = false;
  bool _isSubmitting = false;
  String _status = 'Pending Stylist Review';
  String? _submissionMessage;
  final ImagePicker _picker = ImagePicker();
  final FashionMeasurementApiService _fashionService = FashionMeasurementApiService();

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    _itemWantedController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickInspirationImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() => _inspirationImage = image);
    }
  }

  Future<void> _submitRequest() async {
    if (_itemWantedController.text.trim().isEmpty) {
      _showError('Enter the item wanted before sending to a Stylist.');
      return;
    }
    if (_eventDeadline == null) {
      _showError('Select a due date before sending to a Stylist.');
      return;
    }
    if (_budgetController.text.trim().isEmpty) {
      _showError('Enter a budget before sending to a Stylist.');
      return;
    }
    if (!_consentToSharePhotos) {
      _showError('Consent is required before photos can be shared with a Stylist.');
      return;
    }

    final draftProfile = _fashionService.draftProfile;
    final draftPhotos = _fashionService.draftPhotos;
    final request = MeasurementRequestModel(
      id: DateTime.now().millisecondsSinceEpoch,
      profileId: draftProfile?.id,
      frontPhotoId: draftPhotos['front']?.id,
      sidePhotoId: draftPhotos['side']?.id,
      backPhotoId: draftPhotos['back']?.id,
      measurementSource: 'ai_assisted_tester_estimate',
      measurementStatus: 'Needs Stylist Review',
      reviewStatus: 'Pending Stylist Review',
      itemWanted: _itemWantedController.text.trim(),
      requestType: _selectedService,
      inspirationImageReference: _inspirationImage?.name,
      dueDate: _eventDeadline,
      budget: double.tryParse(_budgetController.text.trim()),
      notes: _specialInstructionsController.text.trim(),
      consentToSharePhotos: _consentToSharePhotos,
      customerProfile: draftProfile?.toJson(),
      measurements: draftProfile?.toJson(),
      photoReferences: {
        'front': draftPhotos['front']?.toJson(),
        'side': draftPhotos['side']?.toJson(),
        'back': draftPhotos['back']?.toJson(),
      },
      status: 'Pending Stylist Review',
      createdAt: DateTime.now(),
      requestedAt: DateTime.now(),
    );

    setState(() {
      _isSubmitting = true;
      _submissionMessage = null;
    });

    final backendSynced = await _fashionService.submitMeasurementRequest(request);
    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _status = backendSynced ? 'Pending Stylist Review' : 'Pending Stylist Review (backend limited)';
      _submissionMessage = backendSynced
          ? 'Stylist Request submitted to backend for review.'
          : 'Stylist Request saved locally because backend submission is unavailable. ${_fashionService.lastBackendMessage ?? ''}';
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
          'Stylist Request',
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
                'Send to Stylist',
                style: robotoBold.copyWith(fontSize: 18, color: ugBlack),
              ),
              const SizedBox(height: 8),
              Text(
                'Send saved sizing data, private photo references, and notes for Stylist Review. If the backend accepts the request, it becomes retrievable by admin/stylist review tools.',
                style: robotoRegular.copyWith(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),

              // Service Category dropdown
              Text(
                'Alteration/custom outfit request',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedService,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                items:
                    [
                      'Custom Design / Styling',
                      'Custom Outfit Request',
                      'Alterations & Hemming',
                      'Uniform Fitting',
                      'Creator Merch Customization',
                    ].map((fit) {
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

              Text(
                'Item wanted',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _itemWantedController,
                decoration: InputDecoration(
                  hintText: 'e.g. custom blazer, altered dress, fitted pants',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
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
                        style: robotoRegular.copyWith(
                          fontSize: 14,
                          color: ugBlack,
                        ),
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
                            style: robotoBold.copyWith(
                              fontSize: 14,
                              color: ugBlack,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Your saved height, bust, waist, and sleeve measurements are shown as preview intake data for this request.',
                            style: robotoRegular.copyWith(
                              fontSize: 12,
                              color: ugBlack.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                          'Measurement profile and private photo references will attach to Stylist Requests when backend submission is available.',
                            style: robotoBold.copyWith(
                              fontSize: 12,
                              color: ugOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Budget',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _budgetController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'e.g. 150.00',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _pickInspirationImage,
                icon: const Icon(Icons.image_outlined),
                label: Text(_inspirationImage == null
                    ? 'Add inspiration image optional'
                    : 'Inspiration image: ${_inspirationImage!.name}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ugBlack,
                  side: const BorderSide(color: ugOrange),
                ),
              ),
              const SizedBox(height: 16),

              // Special instructions
              Text(
                'Stylist Notes',
                style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _specialInstructionsController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'e.g. Broad shoulders, custom silk lining required, hem at ankles...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),

              CheckboxListTile(
                value: _consentToSharePhotos,
                activeColor: ugOrange,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'I consent to share my private measurement photos and sizing profile with the Stylist for review only.',
                  style: robotoBold.copyWith(fontSize: 13, color: ugBlack),
                ),
                subtitle: Text(
                  'Photos must not be posted to Creator Commerce, community, reels, public feeds, or marketing screens.',
                  style: robotoRegular.copyWith(fontSize: 12, color: Colors.grey.shade700),
                ),
                onChanged: (value) => setState(() => _consentToSharePhotos = value ?? false),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ugCanvas.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ugOrange.withValues(alpha: 0.25)),
                ),
                child: Text(
                  'Status: $_status\nAvailable statuses: Pending Stylist Review, Stylist Reviewing, More Photos Needed, Mockup Ready, Quote Ready, Completed.',
                  style: robotoMedium.copyWith(fontSize: 12, color: ugBlack),
                ),
              ),
              if (_submissionMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _submissionMessage!,
                  style: robotoBold.copyWith(fontSize: 12, color: ugOrange),
                ),
              ],
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ugOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isSubmitting ? 'Sending...' : 'Send to Stylist',
                    style: robotoBold.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
