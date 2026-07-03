import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

class MeasurementPhotoGuideScreen extends StatelessWidget {
  const MeasurementPhotoGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color ugCanvas = Color(0xFFE2D3BF);
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Photo-Assisted Sizing Guide',
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
                'Photo-Assisted Fitting',
                style: robotoBold.copyWith(fontSize: 22, color: ugBlack),
              ),
              const SizedBox(height: 8),
              Text(
                'Preview how front and side standing photos may help local Stylists estimate fit. Live upload, storage, privacy, and measurement accuracy still need production verification.',
                style: robotoRegular.copyWith(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),

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
                      style: robotoBold.copyWith(fontSize: 16, color: ugBlack),
                    ),
                    const SizedBox(height: 12),
                    _buildGuidelineRow(Icons.check_circle_outline, 'Wear form-fitting or thin clothing (e.g. leggings, T-shirt).'),
                    const SizedBox(height: 8),
                    _buildGuidelineRow(Icons.check_circle_outline, 'Stand straight against a plain wall or door.'),
                    const SizedBox(height: 8),
                    _buildGuidelineRow(Icons.check_circle_outline, 'Ensure the camera is at chest height, about 8-10 feet away.'),
                    const SizedBox(height: 8),
                    _buildGuidelineRow(Icons.check_circle_outline, 'Keep your full body visible (from head to toe) in the frame.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upload buttons
              Row(
                children: [
                  Expanded(
                    child: _buildPhotoUploadTile(
                      context,
                      title: 'Front View Photo',
                      orientation: 'front',
                      icon: Icons.portrait_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPhotoUploadTile(
                      context,
                      title: 'Side View Photo',
                      orientation: 'side',
                      icon: Icons.directions_run_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit buttons
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo upload preview selected. Stylist Review depends on the Fashion Fit request submission.'),
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
                  child: Text('Preview photo upload steps', style: robotoBold.copyWith(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelineRow(IconData icon, String ruleText) {
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ugOrange, size: 18),
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

  Widget _buildPhotoUploadTile(
    BuildContext context, {
    required String title,
    required String orientation,
    required IconData icon,
  }) {
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return InkWell(
      onTap: () {
        // Tester preview only; live upload is not connected here.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Take or upload photo preview selected for $orientation.'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: ugOrange.withValues(alpha: 0.8)),
            const SizedBox(height: 12),
            Text(
              title,
              style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
            ),
            const SizedBox(height: 4),
            Text(
              'Take or upload photo',
              style: robotoRegular.copyWith(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
