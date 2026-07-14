import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';
import 'package:urban_goodz_driver/theme/app_theme.dart';
import 'package:urban_goodz_driver/services/api_client.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _api = Get.find<DriverApiService>();
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _identityNumberController = TextEditingController();

  String _selectedIdentityType = 'passport';
  String? _selectedZoneId;
  String? _selectedVehicleId;
  String _selectedEarningType = 'freelance'; // freelance or salary

  List<Map<String, dynamic>> _zones = [];
  List<Map<String, dynamic>> _vehicles = [];

  bool _loadingMetadata = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    setState(() {
      _loadingMetadata = true;
      _error = null;
    });
    try {
      final zonesData = await _api.getPublicZones();
      final vehiclesData = await _api.getPublicVehicles();
      setState(() {
        _zones = zonesData;
        _vehicles = vehiclesData;
        if (_zones.isNotEmpty) {
          _selectedZoneId = _zones.first['id']?.toString();
        }
        if (_vehicles.isNotEmpty) {
          _selectedVehicleId = _vehicles.first['id']?.toString();
        }
        _loadingMetadata = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load zones or vehicles: $e';
        _loadingMetadata = false;
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedZoneId == null) {
      setState(() => _error = 'Please select a zone.');
      return;
    }
    if (_selectedVehicleId == null) {
      setState(() => _error = 'Please select a vehicle.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final payload = {
      'f_name': _firstNameController.text.trim(),
      'l_name': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'password': _passwordController.text,
      'identity_type': _selectedIdentityType,
      'identity_number': _identityNumberController.text.trim(),
      'zone_id': int.tryParse(_selectedZoneId!) ?? 0,
      'vehicle_id': int.tryParse(_selectedVehicleId!) ?? 0,
      'earning': _selectedEarningType == 'freelance' ? 1 : 0,
      'type': 'is_delivery', // Required parameter by backend store route
    };

    try {
      await _api.registerDriver(payload);
      setState(() => _submitting = false);
      _showSuccessDialog();
    } catch (e) {
      String msg = 'Registration failed. Please check your inputs.';
      if (e is ApiException) {
        msg = e.message;
      }
      setState(() {
        _submitting = false;
        _error = msg;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Application Submitted'),
        content: const Text(
          'Your driver registration application has been submitted successfully. '
          'An administrator will review your details. You can log in once approved.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // pop dialog
              Get.back(); // pop registration screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _identityNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      appBar: AppBar(title: const Text('Register as Driver')),
      body: _loadingMetadata
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_error != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withAlpha(80)),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val == null || !val.contains('@')
                            ? 'Invalid email'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '+17135550100',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (val) =>
                            val == null || val.trim().length < 10
                            ? 'Min 10 digits'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: (val) => val == null || val.length < 8
                            ? 'Minimum 8 characters'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Identity Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedIdentityType,
                        decoration: const InputDecoration(
                          labelText: 'Identity Document Type',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'passport',
                            child: Text('Passport'),
                          ),
                          DropdownMenuItem(
                            value: 'driving_license',
                            child: Text('Driving License'),
                          ),
                          DropdownMenuItem(
                            value: 'nid',
                            child: Text('National ID'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedIdentityType = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _identityNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Identity Document Number',
                          prefixIcon: Icon(Icons.numbers_outlined),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Vehicle & Zone Assignment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_zones.isNotEmpty)
                        DropdownButtonFormField<String>(
                          value: _selectedZoneId,
                          decoration: const InputDecoration(
                            labelText: 'Preferred Zone',
                            prefixIcon: Icon(Icons.map_outlined),
                          ),
                          items: _zones.map((z) {
                            return DropdownMenuItem(
                              value: z['id']?.toString(),
                              child: Text(
                                z['name']?.toString() ?? 'Unknown Zone',
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedZoneId = val);
                            }
                          },
                        ),
                      const SizedBox(height: 12),
                      if (_vehicles.isNotEmpty)
                        DropdownButtonFormField<String>(
                          value: _selectedVehicleId,
                          decoration: const InputDecoration(
                            labelText: 'Vehicle Assignment',
                            prefixIcon: Icon(Icons.directions_car_outlined),
                          ),
                          items: _vehicles.map((v) {
                            final name =
                                '${v['make'] ?? ''} ${v['model'] ?? ''} (${v['type'] ?? ''})';
                            return DropdownMenuItem(
                              value: v['id']?.toString(),
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedVehicleId = val);
                            }
                          },
                        ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedEarningType,
                        decoration: const InputDecoration(
                          labelText: 'Earning Mode',
                          prefixIcon: Icon(Icons.payments_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'freelance',
                            child: Text('Freelance (per delivery)'),
                          ),
                          DropdownMenuItem(
                            value: 'salary',
                            child: Text('Salary (flat contract rate)'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedEarningType = val);
                          }
                        },
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.primary,
                        ),
                        onPressed: _submitting ? null : _register,
                        child: _submitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'SUBMIT APPLICATION',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
