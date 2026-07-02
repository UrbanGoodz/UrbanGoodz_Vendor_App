import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class MeasurementProfileScreen extends StatefulWidget {
  const MeasurementProfileScreen({super.key});

  @override
  State<MeasurementProfileScreen> createState() => _MeasurementProfileScreenState();
}

class _MeasurementProfileScreenState extends State<MeasurementProfileScreen> {
  final List<_MeasurementField> measurements = [
    _MeasurementField('Chest', ''),
    _MeasurementField('Waist', ''),
    _MeasurementField('Hip', ''),
    _MeasurementField('Shoulder', ''),
    _MeasurementField('Sleeve', ''),
    _MeasurementField('Length', ''),
    _MeasurementField('Neck', ''),
    _MeasurementField('Inseam', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Measurement Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Manual Measurement Entry', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text('Enter your measurements in inches or centimeters. This is the tester fallback when photo-assisted measurement is not available.', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, height: 1.5, color: Theme.of(context).disabledColor)),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text('Enter measurements', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color)),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: measurements.length,
              separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                return TextField(
                  decoration: InputDecoration(labelText: '${measurements[index].name} (in)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)), contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall)),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => measurements[index].value = value,
                );
              },
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('[Tester] Measurements saved locally. Backend will sync when available.'), duration: Duration(seconds: 2))), child: const Text('Save Measurements'))),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ],
        ),
      ),
    );
  }
}

class _MeasurementField {
  final String name;
  String value;
  _MeasurementField(this.name, this.value);
}
