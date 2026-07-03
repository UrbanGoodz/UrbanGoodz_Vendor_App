import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/rental_module/common/car_rental_state.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class TaxiHomeScreen extends StatefulWidget {
  const TaxiHomeScreen({super.key});

  @override
  State<TaxiHomeScreen> createState() => _TaxiHomeScreenState();
}

class _TaxiHomeScreenState extends State<TaxiHomeScreen> {
  final TextEditingController _locationController = TextEditingController(text: 'Houston Galleria, TX');
  final TextEditingController _pickupDateController = TextEditingController(text: '2026-07-04');
  final TextEditingController _returnDateController = TextEditingController(text: '2026-07-06');
  
  String _selectedType = 'All Types';
  final List<String> _vehicleTypes = ['All Types', 'SUV', 'Luxury Sedan', 'Electric SUV', 'Sports Coupe'];

  void _triggerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  int _calculateDays() {
    try {
      final pickup = DateTime.parse(_pickupDateController.text.trim());
      final dropoff = DateTime.parse(_returnDateController.text.trim());
      final diff = dropoff.difference(pickup).inDays;
      return diff > 0 ? diff : 1;
    } catch (_) {
      return 2; // default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter sample vehicles
    final filteredVehicles = CarRentalState.vehicles.where((v) {
      if (_selectedType == 'All Types') return true;
      return v['type'] == _selectedType;
    }).toList();

    return Container(
      color: const Color(0xFF161616),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Car Rentalz',
                        style: robotoBold.copyWith(
                          fontSize: 26,
                          color: Colors.white,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Find your perfect ride',
                        style: robotoRegular.copyWith(
                          fontSize: 13,
                          color: const Color(0xFFE2D3BF),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E276),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'TESTER PREVIEW',
                      style: robotoBold.copyWith(
                        fontSize: 9,
                        color: const Color(0xFF161616),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search Filter panel
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFED9914).withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    // Location field
                    TextField(
                      controller: _locationController,
                      style: robotoMedium.copyWith(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Pickup Location',
                        labelStyle: const TextStyle(color: Color(0xFFE2D3BF), fontSize: 12),
                        prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFFED9914)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFED9914)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Date Row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pickupDateController,
                            style: robotoMedium.copyWith(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              labelText: 'Pickup Date',
                              labelStyle: const TextStyle(color: Color(0xFFE2D3BF), fontSize: 11),
                              prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFFED9914), size: 18),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFED9914)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _returnDateController,
                            style: robotoMedium.copyWith(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              labelText: 'Return Date',
                              labelStyle: const TextStyle(color: Color(0xFFE2D3BF), fontSize: 11),
                              prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFFED9914), size: 18),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFED9914)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Horizontal Category Chips
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _vehicleTypes.length,
                  itemBuilder: (context, index) {
                    final type = _vehicleTypes[index];
                    final isSelected = type == _selectedType;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedType = type;
                            });
                          }
                        },
                        labelStyle: robotoMedium.copyWith(
                          fontSize: 12,
                          color: isSelected ? const Color(0xFF161616) : Colors.white,
                        ),
                        selectedColor: const Color(0xFFED9914),
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        checkmarkColor: const Color(0xFF161616),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFFED9914) : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Listings Title
              Text(
                'Available Fleet',
                style: robotoBold.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Vehicle List
              filteredVehicles.isEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      alignment: Alignment.center,
                      child: Text(
                        'No vehicles found in this category.',
                        style: robotoRegular.copyWith(color: Colors.white54, fontSize: 13),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredVehicles.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final v = filteredVehicles[index];
                        return _buildVehicleCard(v);
                      },
                    ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> v) {
    final bool isFav = v['isFavorited'] as bool;
    final int days = _calculateDays();
    final double total = days * (v['price'] as double);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          // Upper Info row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Icon/Box
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFED9914).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car_filled_outlined,
                    color: Color(0xFFED9914),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),

                // Specs
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v['name'] ?? '',
                        style: robotoBold.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            v['type'] ?? '',
                            style: robotoRegular.copyWith(
                              fontSize: 11,
                              color: const Color(0xFFE2D3BF),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.fiber_manual_record, size: 4, color: Colors.white30),
                          const SizedBox(width: 8),
                          Icon(Icons.airline_seat_recline_normal, size: 12, color: Colors.white.withValues(alpha: 0.5)),
                          const SizedBox(width: 2),
                          Text(
                            '${v['seats']} seats',
                            style: robotoRegular.copyWith(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: Color(0xFFE5E276)),
                          const SizedBox(width: 4),
                          Text(
                            v['location'] ?? '',
                            style: robotoRegular.copyWith(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Favorite action
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    CarRentalState.toggleFavorite(v['id']);
                    _triggerUpdate();
                  },
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? const Color(0xFFED9914) : Colors.white24,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

          // Price & Request row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${v['price'].toStringAsFixed(2)} / day',
                      style: robotoBold.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total: \$${total.toStringAsFixed(2)} ($days days)',
                      style: robotoRegular.copyWith(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED9914),
                    foregroundColor: const Color(0xFF161616),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _showRequestDialog(v, total),
                  child: Text(
                    'Request Rental',
                    style: robotoBold.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDialog(Map<String, dynamic> v, double totalCost) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF161616),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFFED9914).withValues(alpha: 0.3)),
        ),
        title: Text(
          'Rental Request Preview',
          style: robotoBold.copyWith(color: Colors.white, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Specs Summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v['name'] ?? '',
                        style: robotoBold.copyWith(color: const Color(0xFFED9914), fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text('Pickup: ${_locationController.text}', style: robotoRegular.copyWith(color: Colors.white70, fontSize: 11)),
                      Text('Dates: ${_pickupDateController.text} to ${_returnDateController.text}', style: robotoRegular.copyWith(color: Colors.white70, fontSize: 11)),
                      Text('Daily Rate: \$${v['price'].toStringAsFixed(2)} / day', style: robotoRegular.copyWith(color: Colors.white70, fontSize: 11)),
                      const Divider(color: Colors.white24, height: 12),
                      Text(
                        'Estimated Total: \$${totalCost.toStringAsFixed(2)}',
                        style: robotoBold.copyWith(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Intake fields
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Renter Name *',
                    labelStyle: TextStyle(color: Color(0xFFE2D3BF), fontSize: 12),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFED9914))),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                  ),
                  validator: (val) => val?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone / Contact *',
                    labelStyle: TextStyle(color: Color(0xFFE2D3BF), fontSize: 12),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFED9914))),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                  ),
                  validator: (val) => val?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: notesController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Special Notes',
                    labelStyle: TextStyle(color: Color(0xFFE2D3BF), fontSize: 12),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFED9914))),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFED9914), foregroundColor: const Color(0xFF161616)),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                // Log request in state
                CarRentalState.addRequest({
                  'vehicleName': v['name'],
                  'pickupLocation': _locationController.text,
                  'pickupDate': _pickupDateController.text,
                  'returnDate': _returnDateController.text,
                  'total': totalCost,
                  'renterName': nameController.text,
                  'phone': phoneController.text,
                  'notes': notesController.text,
                  'status': 'Pending Provider Review',
                });

                Get.back();
                
                // Show confirmation modal
                Get.dialog(
                  AlertDialog(
                    backgroundColor: const Color(0xFF161616),
                    surfaceTintColor: Colors.transparent,
                    title: const Text('Request Received', style: TextStyle(color: Colors.white)),
                    content: const Text(
                      'Car Rental request received in tester preview. No live payments or reservations were processed.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('OK', style: TextStyle(color: Color(0xFFED9914))),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Submit Rental Request'),
          ),
        ],
      ),
    );
  }
}
