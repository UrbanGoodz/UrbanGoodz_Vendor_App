import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

class BookServicesScreen extends StatelessWidget {
  const BookServicesScreen({super.key});

  static const List<Map<String, String>> _services = [
    {'title': 'Professional Barber', 'price': 'Est: \$40+'},
    {'title': 'Custom Hair Stylist', 'price': 'Est: \$80+'},
    {'title': 'Braider & Weave Specialist', 'price': 'Est: \$120+'},
    {'title': 'Nail Technician', 'price': 'Est: \$50+'},
    {'title': 'Makeup Artist', 'price': 'Est: \$65+'},
    {'title': 'Mobile Auto Mechanic', 'price': 'Est: \$90+'},
    {'title': 'Event Photographer', 'price': 'Est: \$150/hr'},
    {'title': 'Live DJ & Sound Tech', 'price': 'Est: \$200/hr'},
    {'title': 'Home Improvement Contractor', 'price': 'Est: Varies'},
    {'title': 'Tax & Financial Professional', 'price': 'Est: \$100+'},
    {'title': 'Home Health Care Provider', 'price': 'Est: Varies'},
    {'title': 'Personal Fitness Trainer', 'price': 'Est: \$60/hr'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Book Anything',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppConstants.ugBlack,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
      ),
      body: Column(
        children: [
          const UrbanGoodzPreviewBanner(
            message: 'Book Anything - Custom local service bookings and vendor scheduling are currently in early access testing mode.',
          ),
          
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: AppConstants.ugWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.25)),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.ugBlack.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bespoke Service Bookings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.ugBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Direct scheduling for trusted local providers. Secure appointments, manage deposit fees, and coordinate logistics directly through the app.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.ugBlack.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final serviceController = TextEditingController();
                                final dateTimeController = TextEditingController();
                                final locationController = TextEditingController();
                                final notesController = TextEditingController();
                                final formKey = GlobalKey<FormState>();

                                return AlertDialog(
                                  title: const Text('Book a Service [Tester Preview]', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  content: SingleChildScrollView(
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Request custom local help, appointments, or services.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: serviceController,
                                            decoration: const InputDecoration(labelText: 'Service Needed *', border: OutlineInputBorder()),
                                            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: dateTimeController,
                                            decoration: const InputDecoration(labelText: 'Preferred Date/Time *', border: OutlineInputBorder()),
                                            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: locationController,
                                            decoration: const InputDecoration(labelText: 'Location / Address *', border: OutlineInputBorder()),
                                            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: notesController,
                                            maxLines: 2,
                                            decoration: const InputDecoration(labelText: 'Additional Notes', border: OutlineInputBorder()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: AppConstants.seasoningOrange, foregroundColor: AppConstants.ugBlack),
                                      onPressed: () {
                                        if (formKey.currentState?.validate() ?? false) {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Booking Requested'),
                                              content: const Text('Your service booking request has been logged in tester preview! A local provider will be matched once live.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Submit Request'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.ugBlack,
                            side: const BorderSide(color: AppConstants.seasoningOrange),
                          ),
                          child: const Text('Request Service'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: UrbanGoodzActionButton(
                          label: 'Become Provider',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Provider Application'),
                                content: const Text('Provider registration form will be live soon! Interest logged in preview mode.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
                top: Dimensions.paddingSizeSmall,
                bottom: Dimensions.paddingSizeDefault + 80, // Safe bottom spacing
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final svc = _services[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.ugWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppConstants.seasoningOrange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.event_available_outlined,
                              color: AppConstants.seasoningOrange,
                              size: 16,
                            ),
                          ),
                          const UrbanGoodzStatusBadge(status: 'Preview', isCompact: true),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            svc['title'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: AppConstants.ugBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            svc['price'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: AppConstants.ugBlack.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
