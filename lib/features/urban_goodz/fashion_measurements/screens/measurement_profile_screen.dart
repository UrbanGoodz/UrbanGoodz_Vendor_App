import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/measurement_engine_service.dart';

class MeasurementProfileScreen extends StatefulWidget {
  const MeasurementProfileScreen({super.key});

  @override
  State<MeasurementProfileScreen> createState() =>
      _MeasurementProfileScreenState();
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
  String _measurementStatus = 'Not started';
  String _paymentStatus = 'not_required';
  bool _frontPhotoSelected = false;
  bool _sidePhotoSelected = false;
  bool _backPhotoSelected = false;
  bool _freeTesterMode = true;

  // Real upload state
  XFile? _frontPhoto;
  XFile? _sidePhoto;
  XFile? _backPhoto;
  bool _isUploadingFront = false;
  bool _isUploadingSide = false;
  bool _isUploadingBack = false;

  // AI engine state
  bool _isAIProcessing = false;
  String? _aiFeedbackMessage;

  // Privacy boundary configuration
  bool _faceBlurEnabled = true;
  final String _faceBlurStatus = 'Blur active (faces automatically redacted)';
  final String _privacyReviewStatus = 'Safe for tailor review';
  final String _vendorPhotoVersion = 'V1 (Face redacted)';

  final ImagePicker _picker = ImagePicker();

  static const double _platformMeasurementFee = 4.99;
  static const double _vendorMeasurementReviewFee = 10.00;

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

  Future<void> _pickPhoto(String orientation) async {
    try {
      setState(() {
        if (orientation == 'front') _isUploadingFront = true;
        if (orientation == 'side') _isUploadingSide = true;
        if (orientation == 'back') _isUploadingBack = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      // Simulate a small upload delay for upload status experience
      await Future.delayed(const Duration(milliseconds: 1000));

      if (image != null) {
        setState(() {
          if (orientation == 'front') {
            _frontPhoto = image;
            _frontPhotoSelected = true;
          } else if (orientation == 'side') {
            _sidePhoto = image;
            _sidePhotoSelected = true;
          } else if (orientation == 'back') {
            _backPhoto = image;
            _backPhotoSelected = true;
          }
          
          if (_frontPhotoSelected && _sidePhotoSelected) {
            _measurementStatus = 'Photos uploaded';
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$orientation photo uploaded successfully (local reference saved).',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Auto-run AI Sizing if height is provided and both front & side photos are uploaded
        if (_frontPhoto != null && _sidePhoto != null) {
          _runAISizingEstimation();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open image picker: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        if (orientation == 'front') _isUploadingFront = false;
        if (orientation == 'side') _isUploadingSide = false;
        if (orientation == 'back') _isUploadingBack = false;
      });
    }
  }

  Future<void> _runAISizingEstimation() async {
    final double? height = double.tryParse(_heightController.text);
    if (height == null || height <= 0) {
      setState(() {
        _aiFeedbackMessage = 'Please enter a valid Height (inches) above to run AI-assisted sizing estimate.';
      });
      return;
    }

    setState(() {
      _isAIProcessing = true;
      _aiFeedbackMessage = 'Processing front & side silhouettes... calibrating scale...';
    });

    try {
      final engine = MeasurementEngineService();
      final result = await engine.estimateFromPhotos(
        frontPhoto: _frontPhoto!,
        sidePhoto: _sidePhoto!,
        heightInches: height,
      );

      setState(() {
        _chestController.text = result.chest.toString();
        _waistController.text = result.waist.toString();
        _hipsController.text = result.hips.toString();
        _inseamController.text = result.inseam.toString();
        _sleeveController.text = result.sleeve.toString();
        _shoulderController.text = result.shoulder.toString();
        
        _measurementStatus = 'Estimated';
        _aiFeedbackMessage = 'AI Estimate completed successfully (Confidence: ${(result.confidence * 100).toInt()}%).\nValues auto-populated below. Please verify and manually adjust if needed.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI Sizing Estimation completed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _aiFeedbackMessage = 'AI Sizing Estimation failed: $e';
      });
    } finally {
      setState(() {
        _isAIProcessing = false;
      });
    }
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
      _WebMeasurementField(
        'Sleeve Length (inches)',
        'e.g. 34.5',
        _sleeveController,
      ),
      _WebMeasurementField(
        'Shoulder Width (inches)',
        'e.g. 18',
        _shoulderController,
      ),
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
                style: robotoRegular.copyWith(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),

              _buildStatusBadge(ugOrange, ugBlack),
              const SizedBox(height: 20),

              // Sizing Inputs Grid
              Text(
                'Manual Measurement Fallback',
                style: robotoBold.copyWith(fontSize: 18, color: ugBlack),
              ),
              const SizedBox(height: 8),
              Text(
                'Use these fields when photo-assisted measurement is not available or when a tailor needs manual sizing references.',
                style: robotoRegular.copyWith(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),

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
                            style: robotoBold.copyWith(
                              fontSize: 15,
                              color: ugBlack,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: field.controller,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              hintText: field.hint,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
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

              _buildPhotoAssistedSection(ugCanvas, ugOrange, ugBlack),
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
                  hintText:
                      'e.g. Broad shoulders, prefer roomier leg openings...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Validation: if front or side is selected, BOTH front and side are required!
                    if ((_frontPhotoSelected || _sidePhotoSelected) &&
                        (!_frontPhotoSelected || !_sidePhotoSelected)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Validation Error: Both front and side photos are required for photo-assisted sizing estimation.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Payment Validation: if not free tester mode, status must be paid/waived
                    if (!_freeTesterMode && _paymentStatus == 'pending') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Payment Required: Please simulate payment below or enable Free Tester Mode to bypass.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sizing Profile saved successfully!'),
                        backgroundColor: Colors.green,
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
                  child: Text(
                    'Save Sizing Profile',
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

  Widget _buildStatusBadge(Color ugOrange, Color ugBlack) {
    const statuses = [
      'Not started',
      'Manual only',
      'Photos needed',
      'Payment required',
      'Payment pending',
      'Paid',
      'Photos uploaded',
      'Estimating',
      'Estimated',
      'Needs customer review',
      'Ready for tailor review',
      'Tailor review paid',
      'Tailor adjusted',
      'Approved',
      'Cancelled',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ugOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ugOrange.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.fact_check_outlined, color: ugOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Measurement Status',
                  style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _measurementStatus,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  items: statuses.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: robotoRegular.copyWith(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _measurementStatus = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoAssistedSection(
    Color ugCanvas,
    Color ugOrange,
    Color ugBlack,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ugCanvas.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ugOrange.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_camera_front_outlined, color: ugOrange),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Photo-Assisted Measurement',
                  style: robotoBold.copyWith(fontSize: 18, color: ugBlack),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tester preview: photos may be used later for AI-assisted or tailor-assisted measurement review. This screen does not claim exact automatic measurements.',
            style: robotoRegular.copyWith(
              fontSize: 13,
              color: ugBlack.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 14),
          _buildInstructionRow('Stand straight'),
          _buildInstructionRow('Keep arms slightly away from your sides'),
          _buildInstructionRow('Keep your full body visible from head to toe'),
          _buildInstructionRow('Wear fitted clothing'),
          _buildInstructionRow('Use good lighting'),
          _buildInstructionRow('Use a plain background'),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              final tiles = [
                _buildPhotoTile(
                  title: 'Front photo',
                  selected: _frontPhotoSelected,
                  isUploading: _isUploadingFront,
                  fileName: _frontPhoto?.name,
                  icon: Icons.accessibility_new_outlined,
                  onTap: () => _pickPhoto('front'),
                ),
                _buildPhotoTile(
                  title: 'Side photo',
                  selected: _sidePhotoSelected,
                  isUploading: _isUploadingSide,
                  fileName: _sidePhoto?.name,
                  icon: Icons.directions_walk_outlined,
                  onTap: () => _pickPhoto('side'),
                ),
                _buildPhotoTile(
                  title: 'Optional back photo',
                  selected: _backPhotoSelected,
                  isUploading: _isUploadingBack,
                  fileName: _backPhoto?.name,
                  icon: Icons.accessibility_outlined,
                  onTap: () => _pickPhoto('back'),
                ),
              ];

              if (isNarrow) {
                return Column(
                  children: tiles
                      .map(
                        (tile) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: tile,
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                children: tiles
                    .map(
                      (tile) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: tile,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          if (_isAIProcessing) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(ugOrange),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'AI Sizing Estimation in progress...',
                    style: robotoMedium.copyWith(fontSize: 13, color: ugOrange),
                  ),
                ),
              ],
            ),
          ],
          if (_aiFeedbackMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ugOrange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ugOrange.withValues(alpha: 0.2)),
              ),
              child: Text(
                _aiFeedbackMessage!,
                style: robotoMedium.copyWith(fontSize: 12, color: ugBlack),
              ),
            ),
          ],
          const SizedBox(height: 14),
          _buildPricingPreview(ugOrange, ugBlack),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.privacy_tip_outlined, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Sizing Privacy Guard',
                      style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Private customer photos are processed locally on device and are never posted to public creator feeds or public galleries.',
                  style: robotoRegular.copyWith(fontSize: 12, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  value: _faceBlurEnabled,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.green,
                  title: Text(
                    'Automatic Face Blur Redaction',
                    style: robotoBold.copyWith(fontSize: 12, color: ugBlack),
                  ),
                  subtitle: Text(
                    'Obscures the facial region before sharing photo reference with vendors.',
                    style: robotoRegular.copyWith(fontSize: 10, color: Colors.grey.shade600),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _faceBlurEnabled = value;
                    });
                  },
                ),
                const Divider(height: 16),
                _buildPrivacyMetadataRow('Privacy status:', _faceBlurEnabled ? _faceBlurStatus : 'Unblurred (Developer override)'),
                _buildPrivacyMetadataRow('Review policy:', _privacyReviewStatus),
                _buildPrivacyMetadataRow('Share version:', _faceBlurEnabled ? _vendorPhotoVersion : 'V1 (Raw photo)'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              'Photos are used only to help estimate fit and support tailoring requests. Do not upload images you do not want reviewed for sizing assistance.',
              style: robotoRegular.copyWith(
                fontSize: 12,
                color: ugBlack.withValues(alpha: 0.82),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(String text) {
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: ugOrange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: robotoRegular.copyWith(
                fontSize: 13,
                color: ugBlack.withValues(alpha: 0.82),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: robotoRegular.copyWith(fontSize: 11, color: Colors.grey.shade600)),
          Text(value, style: robotoBold.copyWith(fontSize: 11, color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _buildPhotoTile({
    required String title,
    required bool selected,
    required IconData icon,
    required VoidCallback onTap,
    bool isUploading = false,
    String? fileName,
  }) {
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return InkWell(
      onTap: isUploading ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        constraints: const BoxConstraints(minHeight: 122),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? ugOrange : Colors.grey.shade300),
        ),
        child: isUploading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(ugOrange),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: ugOrange, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: robotoBold.copyWith(fontSize: 13, color: ugBlack),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    selected
                        ? (fileName != null ? 'File: $fileName' : 'Preview selected')
                        : 'Take/upload preview',
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontSize: 11,
                      color: selected ? Colors.green : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPricingPreview(Color ugOrange, Color ugBlack) {
    final platformFee = _freeTesterMode ? 0.0 : _platformMeasurementFee;
    final vendorFee = _freeTesterMode ? 0.0 : _vendorMeasurementReviewFee;
    final totalFee = platformFee + vendorFee;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ugOrange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments_outlined, color: ugOrange),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Photo-Assisted Measurement Pricing',
                  style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _freeTesterMode
                ? 'Tester mode: no charge. Payment can be bypassed only while free tester mode is enabled.'
                : 'Customer must see and confirm measurement fees before submitting photos.',
            style: robotoRegular.copyWith(
              fontSize: 12,
              color: ugBlack.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _freeTesterMode,
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeThumbColor: ugOrange,
            title: Text(
              'Free tester mode',
              style: robotoBold.copyWith(fontSize: 13, color: ugBlack),
            ),
            subtitle: Text(
              'Preview of admin-controlled tester pricing.',
              style: robotoRegular.copyWith(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _freeTesterMode = value;
                _paymentStatus = value ? 'not_required' : 'pending';
                _measurementStatus = value
                    ? _measurementStatus
                    : 'Payment required';
              });
            },
          ),
          const Divider(height: 20),
          _buildFeeRow(
            'Urban Goodz AI-assisted measurement estimate',
            platformFee,
            ugBlack,
          ),
          _buildFeeRow('Tailor measurement review', vendorFee, ugBlack),
          const SizedBox(height: 6),
          _buildFeeRow(
            'Total measurement fee',
            totalFee,
            ugBlack,
            isTotal: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _paymentStatus,
            decoration: InputDecoration(
              labelText: 'Payment status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
            ),
            items:
                const [
                  'not_required',
                  'pending',
                  'paid',
                  'waived',
                  'failed',
                  'refunded',
                ].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _paymentStatus = value;
                  if (value == 'pending') {
                    _measurementStatus = 'Payment pending';
                  } else if (value == 'paid') {
                    _measurementStatus = 'Paid';
                  }
                });
              }
            },
          ),
          if (!_freeTesterMode && _paymentStatus == 'pending') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _paymentStatus = 'paid';
                    _measurementStatus = 'Paid';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment Simulated Successfully! Status updated to Paid.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.credit_card_outlined, size: 18),
                label: const Text('Simulate Payment Checkout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ugOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            'What this fee covers: a photo-assisted estimate for tailoring review. Refund, credit, and final fee rules are admin/vendor settings and are preview-only here.',
            style: robotoRegular.copyWith(
              fontSize: 12,
              color: ugBlack.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeRow(
    String label,
    double amount,
    Color ugBlack, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: isTotal
                  ? robotoBold.copyWith(fontSize: 13, color: ugBlack)
                  : robotoRegular.copyWith(
                      fontSize: 12,
                      color: ugBlack.withValues(alpha: 0.8),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: isTotal
                ? robotoBold.copyWith(fontSize: 14, color: ugBlack)
                : robotoRegular.copyWith(fontSize: 12, color: ugBlack),
          ),
        ],
      ),
    );
  }
}
