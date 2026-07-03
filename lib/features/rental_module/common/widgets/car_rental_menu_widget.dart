import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class CarRentalMenuWidget extends StatelessWidget {
  const CarRentalMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF161616),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFED9914).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      color: Color(0xFFED9914),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Car Rentalz',
                        style: robotoBold.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                ],
              ),

              const SizedBox(height: 24),

              // Disclaimer Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFED9914).withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFFED9914), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Simulated Environment',
                          style: robotoBold.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Car Rentalz is currently running in local-only tester mode. You can search, browse listings, add items to your wishlist, and submit mockup rental requests. No real credit cards or charges will be applied.',
                      style: robotoRegular.copyWith(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Requirements
              Text(
                'Rental Requirements',
                style: robotoBold.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              _buildRequirementRow(
                Icons.assignment_ind_outlined,
                'Valid Driver\'s License',
                'Must be presented at the time of vehicle pickup or handover.',
              ),
              _buildRequirementRow(
                Icons.phone_in_talk_outlined,
                'Pickup/Return Coordination',
                'Handover coordinates and timing will be coordinated directly by phone.',
              ),
              _buildRequirementRow(
                Icons.fact_check_outlined,
                'Provider Review & Approval',
                'All requests require manual approval from the fleet administrator.',
              ),
              _buildRequirementRow(
                Icons.no_accounts_outlined,
                'No Real Transactions',
                'Test submissions do not charge currency or process insurance.',
              ),

              const SizedBox(height: 40),

              // Return Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED9914),
                    foregroundColor: const Color(0xFF161616),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final splashController = Get.find<SplashController>();
                    if (splashController.module != null &&
                        splashController.configModel!.module == null &&
                        splashController.moduleList != null &&
                        splashController.moduleList!.length != 1) {
                      splashController.removeModule();
                      Get.find<StoreController>().resetStoreData();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Return to Urban Goodz Home',
                        style: robotoBold.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFE2D3BF), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: robotoBold.copyWith(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: robotoRegular.copyWith(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.5),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
