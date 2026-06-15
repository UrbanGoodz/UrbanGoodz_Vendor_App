import 'package:flutter/material.dart';
import '../models/earn_money_opportunity_model.dart';

class EarnMoneyApiService {
  Future<List<EarnMoneyOpportunityModel>> getOpportunities() async {
    await Future.delayed(const Duration(milliseconds: 300));

    /// Revenue features first (featured), then secondary
    return const [
      EarnMoneyOpportunityModel(id: '4', title: 'Local Logistics Load', type: 'Logistics Loads', description: 'Small freight and commercial deliveries. Earn per load.', earningLabel: '\$35–\$150/load', distanceLabel: '5–50 mi', scheduleLabel: 'Scheduled', icon: Icons.local_shipping_outlined, isFeatured: true, isBeta: true),
      EarnMoneyOpportunityModel(id: '5', title: 'Medical Courier Route', type: 'Medical Courier', description: 'Healthcare and pharmacy transport. Priority routing.', earningLabel: '\$25–\$45/hr', distanceLabel: 'Route Based', scheduleLabel: 'Priority', icon: Icons.medical_services_outlined, isFeatured: true, isBeta: true),
      EarnMoneyOpportunityModel(id: '10', title: 'Fashion & Tailoring', type: 'Fashion & Tailoring', description: 'Alterations, custom fit, and style consultations.', earningLabel: '\$30–\$75/hr', distanceLabel: 'Local', scheduleLabel: 'Appointment', icon: Icons.cut_outlined, isFeatured: true, isBeta: true),
      EarnMoneyOpportunityModel(id: '1', title: 'Retail Shopping Run', type: 'Shopping Jobs', description: 'Shop and deliver retail purchases.', earningLabel: '\$15–\$28/hr', distanceLabel: '1–10 mi', scheduleLabel: 'Flexible', icon: Icons.shopping_bag_outlined),
      EarnMoneyOpportunityModel(id: '2', title: 'Order Anywhere Pickup', type: 'Order Anywhere', description: 'Purchase and deliver from non-partner merchants.', earningLabel: '\$20–\$40/job', distanceLabel: 'Variable', scheduleLabel: 'On Demand', icon: Icons.add_location_alt_outlined),
      EarnMoneyOpportunityModel(id: '3', title: 'Food Delivery Rush', type: 'Food Delivery', description: 'Deliver restaurant orders during peak demand.', earningLabel: '\$18–\$32/hr', distanceLabel: '2–8 mi', scheduleLabel: 'Now', icon: Icons.delivery_dining, recommended: true),
      EarnMoneyOpportunityModel(id: '6', title: 'Daily Route Assignment', type: 'Scheduled Routes', description: 'Recurring pickup and delivery routes.', earningLabel: '\$120–\$250/day', distanceLabel: 'Route Based', scheduleLabel: 'Daily', icon: Icons.event_available_outlined),
      EarnMoneyOpportunityModel(id: '7', title: 'Creator Promotion Campaign', type: 'Creator Campaigns', description: 'Promote local businesses and events.', earningLabel: '\$50–\$500', distanceLabel: 'Remote', scheduleLabel: 'Campaign', icon: Icons.video_camera_back_outlined),
      EarnMoneyOpportunityModel(id: '8', title: 'Merchant Referral Bonus', type: 'Merchant Referrals', description: 'Refer new businesses to Urban Goodz.', earningLabel: '\$100–\$1K+', distanceLabel: 'N/A', scheduleLabel: 'Anytime', icon: Icons.handshake_outlined),
      EarnMoneyOpportunityModel(id: '9', title: 'Service Booking Lead', type: 'Service Bookings', description: 'Generate service bookings and appointments.', earningLabel: 'Commission', distanceLabel: 'Local', scheduleLabel: 'Flexible', icon: Icons.home_repair_service_outlined),
    ];
  }
}
