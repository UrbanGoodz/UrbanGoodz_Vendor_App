import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/util/app_constants.dart';

class FashionMeasurementIntakeScreen extends StatefulWidget {
  const FashionMeasurementIntakeScreen({super.key});

  @override
  State<FashionMeasurementIntakeScreen> createState() => _FashionMeasurementIntakeScreenState();
}

class _FashionMeasurementIntakeScreenState extends State<FashionMeasurementIntakeScreen> {
  bool frontPhotoSelected = false;
  bool sidePhotoSelected = false;
  bool backPhotoSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo-Assisted Measurements')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(color: AppConstants.seasoningOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('[TESTER PREVIEW] Photo-Assisted Intake', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text('Mobile: Take or upload photo. Desktop: File picker available but not primary flow.', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, height: 1.5, color: Theme.of(context).disabledColor)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text('Note: Face blur and AI measurement accuracy are not available in this preview.', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontStyle: FontStyle.italic, color: Theme.of(context).disabledColor)),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text('Required photos', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color)),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            _PhotoCard(title: 'Front Photo', subtitle: 'Face forward, arms relaxed', isSelected: frontPhotoSelected, required: true, onTap: () {
              setState(() => frontPhotoSelected = true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('[Tester] Photo selected (mock).'), duration: Duration(seconds: 1)));
            }),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            _PhotoCard(title: 'Side Photo', subtitle: 'Profile view', isSelected: sidePhotoSelected, required: true, onTap: () {
              setState(() => sidePhotoSelected = true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('[Tester] Photo selected (mock).'), duration: Duration(seconds: 1)));
            }),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            _PhotoCard(title: 'Back Photo', subtitle: 'Back view (optional)', isSelected: backPhotoSelected, required: false, onTap: () {
              setState(() => backPhotoSelected = true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('[Tester] Photo selected (mock).'), duration: Duration(seconds: 1)));
            }),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (frontPhotoSelected && sidePhotoSelected) ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('[Tester] Photos submitted. Backend will process when available.'), duration: Duration(seconds: 2))) : null, child: const Text('Submit Photos'))),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ],
        ),
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool required;
  final VoidCallback onTap;
  const _PhotoCard({required this.title, required this.subtitle, required this.isSelected, required this.required, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.seasoningOrange.withValues(alpha: 0.12) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          border: Border.all(color: isSelected ? AppConstants.seasoningOrange : Theme.of(context).dividerColor.withValues(alpha: 0.12), width: isSelected ? 2 : 0.5),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: isSelected ? AppConstants.seasoningOrange.withValues(alpha: 0.2) : Theme.of(context).disabledColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Icon(isSelected ? Icons.check_circle : Icons.photo_camera, color: isSelected ? AppConstants.seasoningOrange : Theme.of(context).disabledColor, size: 32),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Text(title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)), if (required) Text(' *', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.red))]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(subtitle, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                  if (isSelected) Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall), child: Text('Selected', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: AppConstants.seasoningOrange, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
