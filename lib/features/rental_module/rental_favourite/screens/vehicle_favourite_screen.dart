import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/rental_module/common/car_rental_state.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class VehicleFavouriteScreen extends StatefulWidget {
  const VehicleFavouriteScreen({super.key});

  @override
  VehicleFavouriteScreenState createState() => VehicleFavouriteScreenState();
}

class VehicleFavouriteScreenState extends State<VehicleFavouriteScreen> with SingleTickerProviderStateMixin {
  
  void _triggerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = CarRentalState.getFavorites();

    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      appBar: AppBar(
        title: Text(
          'Rental Wishlist',
          style: robotoBold.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color(0xFF161616),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFED9914).withValues(alpha: 0.12),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Color(0xFFED9914), size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tester Wishlist Preview - Saved locally for this session.',
                      style: robotoRegular.copyWith(
                        color: const Color(0xFFE2D3BF),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Saved rental vehicles will appear here.',
                            style: robotoMedium.copyWith(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      itemCount: favorites.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final v = favorites[index];
                        return _buildFavoriteCard(v);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> v) {
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFED9914).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.directions_car_filled_outlined,
                    color: Color(0xFFED9914),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v['name'] ?? '',
                        style: robotoBold.copyWith(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${v['type']} • ${v['seats']} seats',
                        style: robotoRegular.copyWith(
                          fontSize: 11,
                          color: const Color(0xFFE2D3BF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        v['location'] ?? '',
                        style: robotoRegular.copyWith(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    CarRentalState.toggleFavorite(v['id']);
                    _triggerUpdate();
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Color(0xFFED9914),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${v['price'].toStringAsFixed(2)} / day',
                  style: robotoBold.copyWith(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED9914),
                    foregroundColor: const Color(0xFF161616),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () => _showRequestDialog(v),
                  child: Text(
                    'Request Rental',
                    style: robotoBold.copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDialog(Map<String, dynamic> v) {
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
                      const SizedBox(height: 4),
                      Text('Daily Rate: \$${v['price'].toStringAsFixed(2)} / day', style: robotoRegular.copyWith(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                CarRentalState.addRequest({
                  'vehicleName': v['name'],
                  'pickupLocation': 'Saved Wishlist Request',
                  'pickupDate': 'TBD',
                  'returnDate': 'TBD',
                  'total': v['price'] * 2,
                  'renterName': nameController.text,
                  'phone': phoneController.text,
                  'notes': notesController.text,
                  'status': 'Pending Provider Review',
                });
                Get.back();
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
