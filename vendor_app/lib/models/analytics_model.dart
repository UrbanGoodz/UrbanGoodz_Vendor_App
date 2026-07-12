class AnalyticsModel {
  final String label;
  final double value;
  final double growthPercentage;
  final String category;
  final String date;
  final int totalOrders;
  final double totalRevenue;
  final double averageOrderValue;
  final String topSellingCategory;
  final int newCustomers;
  final int returningCustomers;
  final double cancellationRate;
  final double fulfillmentTime;
  final Map<String, int>? popularTimeSlots;
  final Map<String, double>? revenueByCategory;

  const AnalyticsModel({
    this.label = '',
    this.value = 0.0,
    this.growthPercentage = 0.0,
    this.category = '',
    required this.date,
    this.totalOrders = 0,
    this.totalRevenue = 0.0,
    this.averageOrderValue = 0.0,
    this.topSellingCategory = '',
    this.newCustomers = 0,
    this.returningCustomers = 0,
    this.cancellationRate = 0.0,
    this.fulfillmentTime = 0.0,
    this.popularTimeSlots,
    this.revenueByCategory,
  });
}

class CategoryPerformance {
  final String category;
  final double revenue;
  final double percentage;

  CategoryPerformance({
    required this.category,
    required this.revenue,
    required this.percentage,
  });
}

class TimeSlotData {
  final String hour;
  final int orderCount;

  TimeSlotData({
    required this.hour,
    required this.orderCount,
  });
}
