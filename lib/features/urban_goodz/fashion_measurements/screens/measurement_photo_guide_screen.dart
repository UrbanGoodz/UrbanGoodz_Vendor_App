import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/styles.dart';

class MeasurementPhotoGuideScreen extends StatefulWidget {
  const MeasurementPhotoGuideScreen({super.key});

  @override
  State<MeasurementPhotoGuideScreen> createState() => _MeasurementPhotoGuideScreenState();
}

class _MeasurementPhotoGuideScreenState extends State<MeasurementPhotoGuideScreen> {
  Uint8List? _frontPhotoBytes;
  String? _frontPhotoName;

  Uint8List? _sidePhotoBytes;
  String? _sidePhotoName;

  Uint8List? _backPhotoBytes;
  String? _backPhotoName;

  bool _isGenerating = false;
  bool _estimateGenerated = false;

  final FashionMeasurementApiService _apiService = FashionMeasurementApiService();

  Future<void> _pickImage(String orientation) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          if (orientation == 'front') {
            _frontPhotoBytes = result.files.single.bytes;
            _frontPhotoName = result.files.single.name;
          } else if (orientation == 'side') {
            _sidePhotoBytes = result.files.single.bytes;
            _sidePhotoName = result.files.single.name;
          } else if (orientation == 'back') {
            _backPhotoBytes = result.files.single.bytes;
            _backPhotoName = result.files.single.name;
          }
        });

        showCustomSnackBar('Photo added successfully for $orientation view.', isError: false);
      }
    } catch (e) {
      showCustomSnackBar('Failed to pick photo: $e', isError: true);
    }
  }

  void _clearPhoto(String orientation) {
    setState(() {
      if (orientation == 'front') {
        _frontPhotoBytes = null;
        _frontPhotoName = null;
      } else if (orientation == 'side') {
        _sidePhotoBytes = null;
        _sidePhotoName = null;
      } else if (orientation == 'back') {
        _backPhotoBytes = null;
        _backPhotoName = null;
      }
    });
  }

  Future<void> _generateEstimate() async {
    if (_frontPhotoBytes == null || _sidePhotoBytes == null) return;

    setState(() {
      _isGenerating = true;
    });

    // Simulate upload and AI processing
    await Future.delayed(const Duration(seconds: 2));

    // Upload to local / API client state map
    await _apiService.uploadMeasurementPhoto(
      XFile.fromData(_frontPhotoBytes!, name: _frontPhotoName ?? 'front_view.jpg'),
      'front',
    );

    await _apiService.uploadMeasurementPhoto(
      XFile.fromData(_sidePhotoBytes!, name: _sidePhotoName ?? 'side_view.jpg'),
      'side',
    );

    if (_backPhotoBytes != null) {
      await _apiService.uploadMeasurementPhoto(
        XFile.fromData(_backPhotoBytes!, name: _backPhotoName ?? 'back_view.jpg'),
        'back',
      );
    }

    setState(() {
      _isGenerating = false;
      _estimateGenerated = true;
    });
  }

  void showCustomSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFFED9914),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color ugCanvas = Color(0xFFE2D3BF);
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);
    const Color ugYellow = Color(0xFFE5E276);

    if (_estimateGenerated) {
      return _buildEstimateView(ugCanvas, ugOrange, ugBlack, ugYellow);
    }

    final bool canSubmit = _frontPhotoBytes != null && _sidePhotoBytes != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Photo-Assisted Sizing Guide',
          style: robotoBold.copyWith(color: ugBlack),
        ),
        backgroundColor: ugCanvas,
        iconTheme: IconThemeData(color: ugBlack),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo-Assisted Sizing',
                style: robotoBold.copyWith(fontSize: 22, color: ugBlack),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload front and side standing photos to generate an AI-Assisted Tester Estimate. Submissions are saved locally for this session and attached to Stylist Requests.',
                style: robotoRegular.copyWith(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
              ),
              const SizedBox(height: 20),

              // Guidelines panel
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to take or upload photos:',
                      style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
                    ),
                    const SizedBox(height: 12),
                    _buildGuidelineRow(Icons.check_circle_outline, 'Wear form-fitting or thin clothing (e.g. leggings, T-shirt).', ugOrange, ugBlack),
                    const SizedBox(height: 8),
                    _buildGuidelineRow(Icons.check_circle_outline, 'Stand straight against a plain wall or door.', ugOrange, ugBlack),
                    const SizedBox(height: 8),
                    _buildGuidelineRow(Icons.check_circle_outline, 'Ensure the camera is at chest height, about 8-10 feet away.', ugOrange, ugBlack),
                    const SizedBox(height: 8),
                    _buildGuidelineRow(Icons.check_circle_outline, 'Keep your full body visible (from head to toe) in the frame.', ugOrange, ugBlack),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Progress Section
              Text(
                'Upload Progress',
                style: robotoBold.copyWith(fontSize: 16, color: ugBlack),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: ugCanvas.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProgressIndicator('Front Photo', _frontPhotoBytes != null, true, ugBlack),
                    _buildProgressIndicator('Side Photo', _sidePhotoBytes != null, true, ugBlack),
                    _buildProgressIndicator('Back Photo', _backPhotoBytes != null, false, ugBlack),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upload Cards
              Text(
                'Sizing Photos',
                style: robotoBold.copyWith(fontSize: 16, color: ugBlack),
              ),
              const SizedBox(height: 12),

              _buildPhotoCard(
                title: 'Front View Photo *',
                instruction: 'Face camera, arms slightly away, full body visible',
                bytes: _frontPhotoBytes,
                orientation: 'front',
                icon: Icons.portrait_rounded,
                ugOrange: ugOrange,
                ugBlack: ugBlack,
              ),
              const SizedBox(height: 16),

              _buildPhotoCard(
                title: 'Side View Photo *',
                instruction: 'Turn sideways, stand straight, full body visible',
                bytes: _sidePhotoBytes,
                orientation: 'side',
                icon: Icons.directions_run_rounded,
                ugOrange: ugOrange,
                ugBlack: ugBlack,
              ),
              const SizedBox(height: 16),

              _buildPhotoCard(
                title: 'Back View Photo (Optional)',
                instruction: 'Back facing camera, full body visible, helpful for fit',
                bytes: _backPhotoBytes,
                orientation: 'back',
                icon: Icons.portrait_rounded,
                ugOrange: ugOrange,
                ugBlack: ugBlack,
              ),
              const SizedBox(height: 32),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: canSubmit && !_isGenerating ? _generateEstimate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ugOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isGenerating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            ),
                            const SizedBox(width: 12),
                            Text('Analyzing Sizing Data...', style: robotoBold.copyWith(fontSize: 15)),
                          ],
                        )
                      : Text('Generate AI-Assisted Tester Estimate', style: robotoBold.copyWith(fontSize: 15)),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelineRow(IconData icon, String ruleText, Color ugOrange, Color ugBlack) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ugOrange, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            ruleText,
            style: robotoRegular.copyWith(fontSize: 13, color: ugBlack.withValues(alpha: 0.8)),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(String label, bool isAdded, bool isRequired, Color ugBlack) {
    return Row(
      children: [
        Icon(
          isAdded ? Icons.check_circle : (isRequired ? Icons.radio_button_unchecked : Icons.add_circle_outline),
          color: isAdded ? const Color(0xFFED9914) : (isRequired ? Colors.redAccent.shade100 : Colors.grey),
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          label + (!isAdded && !isRequired ? ' (Opt)' : ''),
          style: robotoMedium.copyWith(
            fontSize: 11,
            color: isAdded ? ugBlack : (isRequired ? Colors.redAccent.shade200 : Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard({
    required String title,
    required String instruction,
    required Uint8List? bytes,
    required String orientation,
    required IconData icon,
    required Color ugOrange,
    required Color ugBlack,
  }) {
    final bool isAdded = bytes != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAdded ? ugOrange : Colors.grey.shade300,
          width: isAdded ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: isAdded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image preview container
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Image.memory(
                      bytes,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFFED9914), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Added successfully',
                                style: robotoRegular.copyWith(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () => _pickImage(orientation),
                        icon: const Icon(Icons.refresh, size: 14, color: Color(0xFFED9914)),
                        label: Text(
                          'Replace',
                          style: robotoBold.copyWith(fontSize: 11, color: const Color(0xFFED9914)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: () => _pickImage(orientation),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    Icon(icon, size: 40, color: ugOrange.withValues(alpha: 0.8)),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      instruction,
                      style: robotoRegular.copyWith(fontSize: 11, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEstimateView(Color ugCanvas, Color ugOrange, Color ugBlack, Color ugYellow) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'AI-Assisted Tester Estimate',
          style: robotoBold.copyWith(color: ugBlack),
        ),
        backgroundColor: ugCanvas,
        iconTheme: IconThemeData(color: ugBlack),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, size: 48, color: Colors.green.shade700),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'AI estimate successfully generated',
                style: robotoBold.copyWith(fontSize: 18, color: Colors.green.shade800),
              ),
            ),
            const SizedBox(height: 24),

            // Warning about tester mock accuracy
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ugYellow.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ugOrange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFED9914), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tester Sizing Preview Mode: Real facial cropping, privacy filters, and AI measurement accuracy are simulated for this build.',
                      style: robotoRegular.copyWith(fontSize: 11, color: ugBlack),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Estimated Fit Dimensions',
              style: robotoBold.copyWith(fontSize: 16, color: ugBlack),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildEstimateRow('Reference Height', '70.0 in (Default)', ugBlack),
                  const Divider(height: 20),
                  _buildEstimateRow('Estimated Chest/Bust', '40.0 in (Based on Front View)', ugBlack),
                  const Divider(height: 20),
                  _buildEstimateRow('Estimated Waist', '34.0 in (Based on Side View)', ugBlack),
                  const Divider(height: 20),
                  _buildEstimateRow('Estimated Hips', '42.0 in (Based on Profile)', ugBlack),
                  const Divider(height: 20),
                  _buildEstimateRow('AI Match Confidence', '94% (High Accuracy Simulation)', ugBlack, valueColor: Colors.green.shade700),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // CTAs
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.getUrbanGoodzFashionMeasurementProfileRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ugBlack,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Review / Edit in Measurement Profile', style: robotoBold.copyWith(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.getUrbanGoodzFashionTailorRequestRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ugOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Continue to Stylist Request', style: robotoBold.copyWith(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _estimateGenerated = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Upload Different Photos', style: robotoBold.copyWith(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimateRow(String label, String value, Color ugBlack, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: robotoRegular.copyWith(fontSize: 13, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: robotoBold.copyWith(fontSize: 13, color: valueColor ?? ugBlack),
        ),
      ],
    );
  }
}
