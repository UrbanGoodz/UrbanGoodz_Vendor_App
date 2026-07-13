import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart';

class MeasurementPhotoGuideScreen extends StatefulWidget {
  const MeasurementPhotoGuideScreen({super.key});
  @override
  State<MeasurementPhotoGuideScreen> createState() =>
      _MeasurementPhotoGuideScreenState();
}

class _MeasurementPhotoGuideScreenState
    extends State<MeasurementPhotoGuideScreen> {
  final service = FashionMeasurementApiService();
  final height = TextEditingController();
  final name = TextEditingController(text: 'My AI Fit Profile');
  final photos = <String, XFile>{};
  bool consent = false,
      shareMeasurements = true,
      sharePhotos = false,
      loading = false,
      approved = false;
  String units = 'in';
  String? error;
  FashionFitAnalysisResult? result;

  Future<void> _capture(String view) async {
    final photo = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(builder: (_) => _GuidedCameraCapture(view: view)),
    );
    if (photo != null && mounted) setState(() => photos[view] = photo);
  }

  Future<void> _analyze() async {
    final calibration = double.tryParse(height.text);
    if (!consent ||
        calibration == null ||
        calibration <= 0 ||
        !photos.containsKey('front') ||
        !photos.containsKey('side')) {
      setState(
        () => error =
            'Consent, calibration height, front photo, and side photo are required.',
      );
      return;
    }
    setState(() {
      loading = true;
      error = null;
      result = null;
    });
    try {
      await service.createAiProfile(
        name: name.text.trim(),
        units: units,
        height: calibration,
        shareMeasurements: shareMeasurements,
        sharePhotos: sharePhotos,
        fitPreferences: {'fit': 'standard'},
      );
      for (final entry in photos.entries) {
        await service.uploadMeasurementPhoto(
          entry.value,
          entry.key,
          heightRef: calibration,
        );
      }
      final analysis = await service.submitAndWaitForAnalysis();
      if (mounted) setState(() => result = analysis);
    } on FashionFitApiException catch (exception) {
      if (mounted) setState(() => error = exception.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _correct(Map<String, dynamic> measurement) async {
    final input = TextEditingController(text: measurement['value']?.toString());
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Correct ${measurement['name']}'),
        content: TextField(
          controller: input,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            suffixText: measurement['unit']?.toString(),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final value = double.tryParse(input.text);
              if (value == null) return;
              await service.correctMeasurement(
                int.parse(measurement['id'].toString()),
                value,
                measurement['unit']?.toString() ?? units,
              );
              measurement['value'] = value;
              Get.back();
              if (mounted) setState(() {});
            },
            child: const Text('Save correction'),
          ),
        ],
      ),
    );
  }

  Future<void> _approve() async {
    try {
      await service.approveProfile();
      if (mounted) setState(() => approved = true);
    } on FashionFitApiException catch (exception) {
      if (mounted) setState(() => error = exception.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Fashion Fit AI Photos')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'AI Body Measurement',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Take guided full-body photos. AI measurements are estimates; review and approve them before a provider can receive them.',
        ),
        CheckboxListTile(
          value: consent,
          onChanged: (value) => setState(() => consent = value ?? false),
          title: const Text(
            'I consent to private AI processing of these photos.',
          ),
          subtitle: const Text(
            'No photo is captured silently or uploaded until you press Analyze.',
          ),
        ),
        TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'Profile name'),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: height,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Calibration height',
                ),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: units,
              items: const [
                DropdownMenuItem(value: 'in', child: Text('inches')),
                DropdownMenuItem(value: 'cm', child: Text('cm')),
              ],
              onChanged: (value) => setState(() => units = value!),
            ),
          ],
        ),
        SwitchListTile(
          value: shareMeasurements,
          onChanged: (value) => setState(() => shareMeasurements = value),
          title: const Text(
            'Allow approved measurements for my provider request',
          ),
        ),
        SwitchListTile(
          value: sharePhotos,
          onChanged: (value) => setState(() => sharePhotos = value),
          title: const Text('Separately allow raw-photo sharing'),
          subtitle: const Text(
            'Off by default. Measurement permission never implies photo permission.',
          ),
        ),
        const Divider(),
        const Text(
          'Capture guidance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text(
          'Form-fitting clothing; even lighting; neutral pose; arms slightly away; feet and full body visible; camera level; one person only; no screenshots.',
        ),
        for (final view in ['front', 'side', 'back'])
          _PhotoTile(
            view: view,
            file: photos[view],
            requiredView: view != 'back',
            capture: () => _capture(view),
            remove: () => setState(() => photos.remove(view)),
          ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(error!, style: const TextStyle(color: Colors.red)),
          ),
        if (loading) ...[
          const LinearProgressIndicator(),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Uploading privately and waiting for server AI analysis...',
            ),
          ),
        ] else
          ElevatedButton.icon(
            onPressed: _analyze,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Confirm upload and analyze'),
          ),
        if (result != null)
          _Results(
            result: result!,
            correct: _correct,
            approve: _approve,
            approved: approved,
          ),
      ],
    ),
  );
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.view,
    required this.file,
    required this.requiredView,
    required this.capture,
    required this.remove,
  });
  final String view;
  final XFile? file;
  final bool requiredView;
  final VoidCallback capture, remove;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 96,
            child: file == null
                ? const Icon(Icons.accessibility_new, size: 48)
                : Image.file(File(file!.path), fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${view.toUpperCase()} view${requiredView ? ' *' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  view == 'side'
                      ? 'Turn 90 degrees, feet aligned, arms relaxed.'
                      : 'Face straight, head and feet inside the silhouette.',
                ),
                Wrap(
                  children: [
                    TextButton(
                      onPressed: capture,
                      child: Text(
                        file == null ? 'Open guided camera' : 'Retake',
                      ),
                    ),
                    if (file != null)
                      TextButton(
                        onPressed: remove,
                        child: const Text('Delete'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Results extends StatelessWidget {
  const _Results({
    required this.result,
    required this.correct,
    required this.approve,
    required this.approved,
  });
  final FashionFitAnalysisResult result;
  final Future<void> Function(Map<String, dynamic>) correct;
  final VoidCallback approve;
  final bool approved;
  @override
  Widget build(BuildContext context) {
    if (result.status == 'needs_retake') {
      return Card(
        color: Colors.orange.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Retake required',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...result.retakeInstructions.map(Text.new),
            ],
          ),
        ),
      );
    }
    if (result.status != 'completed') {
      return Text(
        'Analysis ${result.status}. No measurements were fabricated.',
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall confidence: ${((result.overallConfidence ?? 0) * 100).toStringAsFixed(0)}%',
            ),
            for (final row in result.measurements)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  row['name']?.toString().replaceAll('_', ' ') ?? 'Measurement',
                ),
                subtitle: Text(
                  'Source: ${row['source'] ?? 'AI'}; confidence ${((double.tryParse(row['confidence']?.toString() ?? '') ?? 0) * 100).toStringAsFixed(0)}%',
                ),
                trailing: TextButton(
                  onPressed: () => correct(row),
                  child: Text('${row['value']} ${row['unit']}'),
                ),
              ),
            ElevatedButton(
              onPressed: approved ? null : approve,
              child: Text(
                approved
                    ? 'Approved for provider requests'
                    : 'Approve measurements',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidedCameraCapture extends StatefulWidget {
  const _GuidedCameraCapture({required this.view});
  final String view;
  @override
  State<_GuidedCameraCapture> createState() => _GuidedCameraCaptureState();
}

class _GuidedCameraCaptureState extends State<_GuidedCameraCapture> {
  CameraController? controller;
  String? error;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No camera available.');
      controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (exception) {
      if (mounted) setState(() => error = 'Camera unavailable: $exception');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(title: Text('${widget.view.toUpperCase()} guided photo')),
    body: error != null
        ? Center(
            child: Text(error!, style: const TextStyle(color: Colors.white)),
          )
        : controller == null || !controller!.value.isInitialized
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller!),
              CustomPaint(
                painter: _SilhouettePainter(side: widget.view == 'side'),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Align head and feet inside the outline. Camera level, 6-10 feet away, even light, neutral pose.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton.large(
                    onPressed: () async {
                      final photo = await controller!.takePicture();
                      if (context.mounted) Navigator.pop(context, photo);
                    },
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ),
            ],
          ),
  );
}

class _SilhouettePainter extends CustomPainter {
  _SilhouettePainter({required this.side});
  final bool side;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final center = size.width / 2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center, size.height * .14),
        width: size.width * (side ? .13 : .18),
        height: size.height * .1,
      ),
      paint,
    );
    final path = Path()
      ..moveTo(center, size.height * .2)
      ..cubicTo(
        center - size.width * (side ? .07 : .17),
        size.height * .34,
        center - size.width * (side ? .06 : .14),
        size.height * .55,
        center - size.width * .08,
        size.height * .68,
      )
      ..lineTo(center - size.width * .12, size.height * .94)
      ..moveTo(center, size.height * .2)
      ..cubicTo(
        center + size.width * (side ? .07 : .17),
        size.height * .34,
        center + size.width * (side ? .06 : .14),
        size.height * .55,
        center + size.width * .08,
        size.height * .68,
      )
      ..lineTo(center + size.width * .12, size.height * .94);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
