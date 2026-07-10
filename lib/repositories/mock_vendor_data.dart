import 'package:urban_goodz_vendor/models/vendor_store_model.dart';
import 'package:urban_goodz_vendor/models/vendor_order_model.dart';
import 'package:urban_goodz_vendor/models/inventory_item_model.dart';
import 'package:urban_goodz_vendor/models/service_booking_model.dart';
import 'package:urban_goodz_vendor/models/promotion_model.dart';
import 'package:urban_goodz_vendor/models/reel_model.dart';
import 'package:urban_goodz_vendor/models/analytics_model.dart';
import 'package:urban_goodz_vendor/models/customer_review_model.dart';
import 'package:urban_goodz_vendor/models/revenue_model.dart';

class MockDashboardRepository {
  Future<VendorStoreModel> getVendorProfile() async {
    return const VendorStoreModel(
      id: 'store_001',
      name: 'Urban Goodz Grocery � Midtown',
      type: 'grocery',
      description:
          'Your premium urban grocery destination in the heart of Midtown Houston. Farm-fresh produce, artisanal goods, and everyday essentials curated for the modern city lifestyle.',
      address: '2800 Fannin St, Houston, TX 77002',
      phone: '(713) 555-0142',
      email: 'midtown@urbangoodz.com',
      logoUrl: 'assets/logos/ug_midtown.png',
      bannerUrl: 'assets/banners/midtown_banner.jpg',
      isOpen: true,
      openTime: '06:00 AM',
      closeTime: '10:00 PM',
      rating: 4.8,
      reviewCount: 342,
      totalOrders: 5678,
      totalRevenue: 284500.00,
      joinDate: '2023-03-15',
      categories: [
        'Produce', 'Dairy', 'Meat & Seafood', 'Bakery', 'Pantry', 'Beverages', 'Organic', 'International'
      ],
      features: {
        'delivery': true, 'pickup': true, 'catering': true, 'curbside': true, 'loyalty_program': true,
      },
    );
  }

  Future<Map<String, double>> getMetrics() async {
    return {
      'todayRevenue': 4850.75,
      'weeklyRevenue': 32150.00,
      'monthlyRevenue': 128600.50,
      'todayOrders': 47,
      'weeklyOrders': 312,
      'monthlyOrders': 1248,
      'activeOrders': 12,
      'pendingServiceBookings': 5,
      'averageRating': 4.8,
      'lowStockItems': 8,
    };
  }

  Future<List<VendorOrderModel>> getRecentOrders() async {
    return _recentOrders;
  }

  Future<List<InventoryItemModel>> getTopProducts() async {
    return [
      const InventoryItemModel(id: 'inv_101', name: 'Urban Goodz Organic Produce Box', sku: 'UGB-ORG-001', category: 'Produce', price: 45.00, costPrice: 28.50, stockQuantity: 120, unit: 'box', supplierName: 'Texas Fresh Farms'),
      const InventoryItemModel(id: 'inv_102', name: 'Signature Urban Goodz Cold Brew', sku: 'UGB-BEV-012', category: 'Beverages', price: 6.99, costPrice: 3.20, stockQuantity: 340, unit: 'bottle', supplierName: 'Houston Craft Beverage Co.'),
      const InventoryItemModel(id: 'inv_103', name: 'Urban Goodz Artisan Sourdough', sku: 'UGB-BAK-008', category: 'Bakery', price: 8.49, costPrice: 2.75, stockQuantity: 45, unit: 'loaf', supplierName: 'Third Ward Bakehouse'),
      const InventoryItemModel(id: 'inv_104', name: 'Texas Grass-Fed Beef Bundle', sku: 'UGB-MEA-022', category: 'Meat & Seafood', price: 89.99, costPrice: 55.00, stockQuantity: 28, unit: 'box', supplierName: "Rancher's Pride Texas Meats"),
      const InventoryItemModel(id: 'inv_105', name: 'Urban Goodz Pantry Starter Kit', sku: 'UGB-PAN-015', category: 'Pantry', price: 35.00, costPrice: 18.75, stockQuantity: 67, unit: 'box', supplierName: 'Urban Goodz Wholesale'),
    ];
  }

  Future<List<AnalyticsModel>> getRevenueChart() async {
    return [
      const AnalyticsModel(date: 'Mon', totalRevenue: 4250.00, totalOrders: 42),
      const AnalyticsModel(date: 'Tue', totalRevenue: 3820.50, totalOrders: 38),
      const AnalyticsModel(date: 'Wed', totalRevenue: 5100.75, totalOrders: 51),
      const AnalyticsModel(date: 'Thu', totalRevenue: 4780.25, totalOrders: 47),
      const AnalyticsModel(date: 'Fri', totalRevenue: 6720.00, totalOrders: 65),
      const AnalyticsModel(date: 'Sat', totalRevenue: 8210.50, totalOrders: 78),
      const AnalyticsModel(date: 'Sun', totalRevenue: 6450.00, totalOrders: 62),
    ];
  }

  static final List<VendorOrderModel> _recentOrders = [
    VendorOrderModel(
      id: 'ORD-2876', customerName: 'Maria Gonzalez', customerPhone: '(832) 555-0189',
      customerAddress: '1201 Westheimer Rd, Houston, TX 77006',
      items: [
        OrderItemModel(name: 'Urban Goodz Organic Produce Box', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Urban Goodz Artisan Sourdough', quantity: 2, price: 0.0),
      ],
      subtotal: 61.98, deliveryFee: 0, tax: 0, total: 61.98, status: 'preparing', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 10, 23),
      notes: 'Please leave at the front desk',
      driverName: 'James Carter',
    ),
    VendorOrderModel(
      id: 'ORD-2875', customerName: 'Kevin Tran', customerPhone: '(281) 555-0345',
      customerAddress: '4567 Bellaire Blvd, Houston, TX 77401',
      items: [
        OrderItemModel(name: 'Texas Grass-Fed Beef Bundle', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Signature Urban Goodz Cold Brew', quantity: 4, price: 0.0),
        OrderItemModel(name: 'Urban Goodz Pantry Starter Kit', quantity: 1, price: 0.0),
      ],
      subtotal: 152.95, deliveryFee: 0, tax: 0, total: 152.95, status: 'confirmed', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 09, 45), notes: '',
      driverName: 'Patricia Lewis',
    ),
    VendorOrderModel(
      id: 'ORD-2874', customerName: 'Aaliyah Washington', customerPhone: '(346) 555-0567',
      customerAddress: '8903 Scott St, Houston, TX 77021',
      items: [
        OrderItemModel(name: 'Urban Goodz Organic Produce Box', quantity: 2, price: 0.0),
      ],
      subtotal: 90.00, deliveryFee: 0, tax: 0, total: 90.00, status: 'ready', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 08, 30),
      notes: 'I will pick up at the side entrance',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2873', customerName: 'Carlos Ruiz', customerPhone: '(713) 555-0678',
      customerAddress: '2200 Navigation Blvd, Houston, TX 77003',
      items: [
        OrderItemModel(name: 'Urban Goodz Pantry Starter Kit', quantity: 3, price: 0.0),
        OrderItemModel(name: 'Signature Urban Goodz Cold Brew', quantity: 6, price: 0.0),
      ],
      subtotal: 146.94, deliveryFee: 0, tax: 0, total: 146.94, status: 'delivered', paymentMethod: 'cash', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 07, 06, 15), notes: '',
      driverName: 'Marcus Williams',
    ),
    VendorOrderModel(
      id: 'ORD-2872', customerName: 'Dr. Simone Dupont', customerPhone: '(281) 555-0890',
      customerAddress: '5500 Main St, Houston, TX 77004',
      items: [
        OrderItemModel(name: 'Urban Goodz Artisan Sourdough', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Urban Goodz Organic Produce Box', quantity: 1, price: 0.0),
      ],
      subtotal: 53.49, deliveryFee: 0, tax: 0, total: 53.49, status: 'pending', paymentMethod: 'card', paymentStatus: 'pending',
      createdAt: DateTime(2026, 06, 08, 11, 00),
      notes: 'Leave at the back door, please call upon arrival',
      driverName: '',
    ),
  ];
}

class MockOrdersRepository {
  Future<List<VendorOrderModel>> getAllOrders() async {
    return _allOrders;
  }

  Future<List<VendorOrderModel>> getOrdersByStatus(String status) async {
    return _allOrders.where((o) => o.status == status).toList();
  }

  Future<VendorOrderModel> getOrderById(String id) async {
    return _allOrders.firstWhere(
      (o) => o.id == id,
      orElse: () => _allOrders.first,
    );
  }

  static final List<VendorOrderModel> _allOrders = [
    VendorOrderModel(
      id: 'ORD-2901', customerName: 'Maria Gonzalez', customerPhone: '(832) 555-0189',
      customerAddress: '1201 Westheimer Rd, Houston, TX 77006',
      items: [
        OrderItemModel(name: 'Urban Goodz Organic Produce Box', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Fresh Avocados (4 ct)', quantity: 2, price: 0.0),
      ],
      subtotal: 56.98, deliveryFee: 0, tax: 0, total: 56.98, status: 'preparing', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 10, 23),
      notes: 'Please leave at the front desk',
      driverName: 'James Carter',
    ),
    VendorOrderModel(
      id: 'ORD-2902', customerName: 'Kevin Tran', customerPhone: '(281) 555-0345',
      customerAddress: '4567 Bellaire Blvd, Houston, TX 77401',
      items: [
        OrderItemModel(name: 'Texas Grass-Fed Beef Bundle', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Signature Urban Goodz Cold Brew (6 pk)', quantity: 2, price: 0.0),
        OrderItemModel(name: 'Urban Goodz Pantry Starter Kit', quantity: 1, price: 0.0),
      ],
      subtotal: 174.97, deliveryFee: 0, tax: 0, total: 174.97, status: 'confirmed', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 09, 45), notes: '',
      driverName: 'Patricia Lewis',
    ),
    VendorOrderModel(
      id: 'ORD-2903', customerName: 'Aaliyah Washington', customerPhone: '(346) 555-0567',
      customerAddress: '8903 Scott St, Houston, TX 77021',
      items: [
        OrderItemModel(name: 'Urban Goodz Organic Produce Box', quantity: 2, price: 0.0),
        OrderItemModel(name: 'Urban Goodz Artisan Sourdough', quantity: 1, price: 0.0),
      ],
      subtotal: 98.49, deliveryFee: 0, tax: 0, total: 98.49, status: 'ready', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 08, 30),
      notes: 'I will pick up at the side entrance',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2904', customerName: 'Carlos Ruiz', customerPhone: '(713) 555-0678',
      customerAddress: '2200 Navigation Blvd, Houston, TX 77003',
      items: [
        OrderItemModel(name: 'Urban Goodz Meal Prep Bundle', quantity: 2, price: 0.0),
        OrderItemModel(name: 'Signature Urban Goodz Cold Brew (6 pk)', quantity: 1, price: 0.0),
      ],
      subtotal: 154.99, deliveryFee: 0, tax: 0, total: 154.99, status: 'delivered', paymentMethod: 'cash', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 07, 06, 15), notes: '',
      driverName: 'Marcus Williams',
    ),
    VendorOrderModel(
      id: 'ORD-2905', customerName: 'Dr. Simone Dupont', customerPhone: '(281) 555-0890',
      customerAddress: '5500 Main St, Houston, TX 77004',
      items: [
        OrderItemModel(name: 'Urban Goodz Artisan Sourdough', quantity: 2, price: 0.0),
        OrderItemModel(name: 'Urban Goodz Organic Produce Box', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Texas Honey Jar (16 oz)', quantity: 1, price: 0.0),
      ],
      subtotal: 74.97, deliveryFee: 0, tax: 0, total: 74.97, status: 'pending', paymentMethod: 'card', paymentStatus: 'pending',
      createdAt: DateTime(2026, 06, 08, 11, 00),
      notes: 'Leave at the back door, please call upon arrival',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2906', customerName: 'James Okafor', customerPhone: '(832) 555-0901',
      customerAddress: '7823 Almeda Rd, Houston, TX 77054',
      items: [
        OrderItemModel(name: 'Urban Goodz Beauty Essentials Kit', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Shea Moisture Curl Shampoo', quantity: 2, price: 0.0),
      ],
      subtotal: 118.98, deliveryFee: 0, tax: 0, total: 118.98, status: 'preparing', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 09, 15), notes: '',
      driverName: 'Keisha Brown',
    ),
    VendorOrderModel(
      id: 'ORD-2907', customerName: 'Linda Chen', customerPhone: '(281) 555-1123',
      customerAddress: '15600 Bellaire Blvd, Houston, TX 77083',
      items: [
        OrderItemModel(name: 'Pharmacy Prescription Refill Pack', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Vitamin D3 2000 IU (90 ct)', quantity: 2, price: 0.0),
      ],
      subtotal: 63.98, deliveryFee: 0, tax: 0, total: 63.98, status: 'confirmed', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 08, 00),
      notes: 'Need signature for delivery',
      driverName: 'Robert Kim',
    ),
    VendorOrderModel(
      id: 'ORD-2908', customerName: 'Tanya Richards', customerPhone: '(713) 555-1345',
      customerAddress: '4500 Mount Vernon St, Houston, TX 77006',
      items: [
        OrderItemModel(name: 'Grocery Weekly Bundle', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Organic Free-Range Eggs (dozen)', quantity: 2, price: 0.0),
      ],
      subtotal: 135.98, deliveryFee: 0, tax: 0, total: 135.98, status: 'delivered', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 07, 04, 00), notes: '',
      driverName: 'Derek Johnson',
    ),
    VendorOrderModel(
      id: 'ORD-2909', customerName: 'Ramon Espinoza', customerPhone: '(346) 555-1567',
      customerAddress: '8901 Airline Dr, Houston, TX 77037',
      items: [
        OrderItemModel(name: 'Food Truck Catering - Taco Bar', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Fresh Agua Fresca (gal)', quantity: 3, price: 0.0),
      ],
      subtotal: 395.00, deliveryFee: 0, tax: 0, total: 395.00, status: 'confirmed', paymentMethod: 'bank_transfer', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 07, 02, 00),
      notes: 'Set up for 50 people, vegetarian options needed',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2910', customerName: 'Nia Thompson', customerPhone: '(832) 555-1678',
      customerAddress: '2300 Elgin St, Houston, TX 77004',
      items: [
        OrderItemModel(name: 'Handmade Candles Set (3 pk)', quantity: 2, price: 0.0),
        OrderItemModel(name: 'Urban Goodz Signature Soy Candle', quantity: 1, price: 0.0),
      ],
      subtotal: 74.99, deliveryFee: 0, tax: 0, total: 74.99, status: 'delivered', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 06, 07, 30), notes: '',
      driverName: 'Tamika Scott',
    ),
    VendorOrderModel(
      id: 'ORD-2911', customerName: 'David Okonkwo', customerPhone: '(281) 555-1890',
      customerAddress: '1250 Bay Area Blvd, Houston, TX 77058',
      items: [
        OrderItemModel(name: 'Personal Training Session (1 hr)', quantity: 4, price: 0.0),
      ],
      subtotal: 220.00, deliveryFee: 0, tax: 0, total: 220.00, status: 'pending', paymentMethod: 'card', paymentStatus: 'pending',
      createdAt: DateTime(2026, 06, 08, 07, 00),
      notes: 'Early morning session preferred',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2912', customerName: 'Sofia Martinez', customerPhone: '(713) 555-1901',
      customerAddress: '5600 Kirby Dr, Houston, TX 77005',
      items: [
        OrderItemModel(name: 'Urban Goodz Weekly Meal Prep - Vegan', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Organic Cold-Pressed Juice Pack', quantity: 2, price: 0.0),
      ],
      subtotal: 159.00, deliveryFee: 0, tax: 0, total: 159.00, status: 'preparing', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 06, 30), notes: '',
      driverName: 'Andre Mitchell',
    ),
    VendorOrderModel(
      id: 'ORD-2913', customerName: 'William Brooks', customerPhone: '(832) 555-2123',
      customerAddress: '7707 Fannin St, Houston, TX 77054',
      items: [
        OrderItemModel(name: 'AC Maintenance Service', quantity: 1, price: 0.0),
      ],
      subtotal: 120.00, deliveryFee: 0, tax: 0, total: 120.00, status: 'confirmed', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 07, 11, 00),
      notes: 'Apartment unit 4B, call when arriving',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2914', customerName: 'Priya Sharma', customerPhone: '(281) 555-2234',
      customerAddress: '9800 Town Park Dr, Houston, TX 77036',
      items: [
        OrderItemModel(name: 'Event Decor Setup - Birthday Package', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Custom Balloon Arch', quantity: 1, price: 0.0),
      ],
      subtotal: 625.00, deliveryFee: 0, tax: 0, total: 625.00, status: 'confirmed', paymentMethod: 'bank_transfer', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 06, 03, 00),
      notes: 'Setup must be complete by 10 AM, birthday theme is tropical',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2915', customerName: 'Terrence Jackson', customerPhone: '(713) 555-2345',
      customerAddress: '3400 Montrose Blvd, Houston, TX 77006',
      items: [
        OrderItemModel(name: 'Urban Goodz Fresh Juice Cleanse (3 Day)', quantity: 1, price: 0.0),
      ],
      subtotal: 85.00, deliveryFee: 0, tax: 0, total: 85.00, status: 'delivered', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 06, 08, 00), notes: '',
      driverName: 'Chris Davis',
    ),
    VendorOrderModel(
      id: 'ORD-2916', customerName: 'Fatima Hassan', customerPhone: '(346) 555-2567',
      customerAddress: '6700 Westpark Dr, Houston, TX 77057',
      items: [
        OrderItemModel(name: 'Natural Hair Care Bundle', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Mango & Turmeric Soap (3 bar set)', quantity: 2, price: 0.0),
      ],
      subtotal: 90.98, deliveryFee: 0, tax: 0, total: 90.98, status: 'ready', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 07, 05, 30), notes: '',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2917', customerName: 'Malik Johnson', customerPhone: '(713) 555-2678',
      customerAddress: '1200 Berry Rd, Houston, TX 77088',
      items: [
        OrderItemModel(name: 'Lawn Mowing Service', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Garden Weed Treatment', quantity: 1, price: 0.0),
      ],
      subtotal: 100.00, deliveryFee: 0, tax: 0, total: 100.00, status: 'completed', paymentMethod: 'cash', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 05, 09, 00),
      notes: 'Front and back yard, gate is unlocked',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2918', customerName: 'Olivia Chen', customerPhone: '(281) 555-2789',
      customerAddress: '2000 Holcombe Blvd, Houston, TX 77030',
      items: [
        OrderItemModel(name: 'Pharmacy OTC Medicine Kit', quantity: 1, price: 0.0),
        OrderItemModel(name: 'First Aid Essentials Bundle', quantity: 1, price: 0.0),
      ],
      subtotal: 73.00, deliveryFee: 0, tax: 0, total: 73.00, status: 'delivered', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 07, 10, 00),
      notes: 'Deliver to nurses station',
      driverName: 'Nancy Park',
    ),
    VendorOrderModel(
      id: 'ORD-2919', customerName: 'DeShawn Carter', customerPhone: '(713) 555-2901',
      customerAddress: '4501 Gulf Fwy, Houston, TX 77023',
      items: [
        OrderItemModel(name: 'Home Deep Clean Service', quantity: 1, price: 0.0),
      ],
      subtotal: 180.00, deliveryFee: 0, tax: 0, total: 180.00, status: 'pending', paymentMethod: 'card', paymentStatus: 'pending',
      createdAt: DateTime(2026, 06, 08, 12, 00),
      notes: '3 bedroom, 2 bath house. Focus on kitchen and bathrooms.',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2920', customerName: 'Isabella Ramirez', customerPhone: '(832) 555-3012',
      customerAddress: '8900 Hempstead Rd, Houston, TX 77008',
      items: [
        OrderItemModel(name: 'Urban Goodz Saturday Market Bundle', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Fresh Flowers Bouquet', quantity: 2, price: 0.0),
      ],
      subtotal: 119.00, deliveryFee: 0, tax: 0, total: 119.00, status: 'confirmed', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 05, 00), notes: '',
      driverName: 'Lamar Davis',
    ),
    VendorOrderModel(
      id: 'ORD-2921', customerName: 'Grace Nguyen', customerPhone: '(281) 555-3234',
      customerAddress: '11200 Westheimer Rd, Houston, TX 77042',
      items: [
        OrderItemModel(name: 'Beauty Supply - Hair Extensions Kit', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Edge Control Gel (3 pk)', quantity: 2, price: 0.0),
      ],
      subtotal: 164.98, deliveryFee: 0, tax: 0, total: 164.98, status: 'preparing', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 08, 07, 45), notes: '',
      driverName: 'Monique Thomas',
    ),
    VendorOrderModel(
      id: 'ORD-2922', customerName: 'Anthony Brown', customerPhone: '(346) 555-3456',
      customerAddress: '5500 Richmond Ave, Houston, TX 77056',
      items: [
        OrderItemModel(name: 'Urban Goodz Coffee Club Subscription', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Ethiopian Single Origin Beans (12 oz)', quantity: 2, price: 0.0),
      ],
      subtotal: 63.97, deliveryFee: 0, tax: 0, total: 63.97, status: 'delivered', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 06, 06, 00), notes: '',
      driverName: 'Thomas Wright',
    ),
    VendorOrderModel(
      id: 'ORD-2923', customerName: 'Kendra Lewis', customerPhone: '(713) 555-3678',
      customerAddress: '3210 Dowling St, Houston, TX 77004',
      items: [
        OrderItemModel(name: 'Event Vendor - Pop-up Booth Rental', quantity: 1, price: 0.0),
        OrderItemModel(name: 'Custom Banner & Signage Kit', quantity: 1, price: 0.0),
      ],
      subtotal: 335.00, deliveryFee: 0, tax: 0, total: 335.00, status: 'confirmed', paymentMethod: 'bank_transfer', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 05, 01, 00),
      notes: 'Booth at the Urban Goodz Summer Block Party',
      driverName: '',
    ),
    VendorOrderModel(
      id: 'ORD-2924', customerName: 'Christopher Moore', customerPhone: '(281) 555-3789',
      customerAddress: '2300 S Wayside Dr, Houston, TX 77023',
      items: [
        OrderItemModel(name: 'Home Business Starter Package', quantity: 1, price: 0.0),
      ],
      subtotal: 199.00, deliveryFee: 0, tax: 0, total: 199.00, status: 'delivered', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 05, 11, 00), notes: '',
      driverName: 'Shawn Robinson',
    ),
    VendorOrderModel(
      id: 'ORD-2925', customerName: 'Amara Osei', customerPhone: '(832) 555-3901',
      customerAddress: '6700 Harrisburg Blvd, Houston, TX 77011',
      items: [
        OrderItemModel(name: 'Service Provider - Photography Session', quantity: 1, price: 0.0),
      ],
      subtotal: 150.00, deliveryFee: 0, tax: 0, total: 150.00, status: 'confirmed', paymentMethod: 'card', paymentStatus: 'paid',
      createdAt: DateTime(2026, 06, 07, 03, 30),
      notes: 'Family portrait session, outdoor preferred',
      driverName: '',
    ),
  ];
}

class MockInventoryRepository {
  Future<List<InventoryItemModel>> getAllItems() async {
    return _allItems;
  }

  Future<List<InventoryItemModel>> getLowStockItems() async {
    return _allItems.where((item) => item.isLowStock || item.isOutOfStock).toList();
  }

  Future<List<InventoryItemModel>> getItemsByCategory(String category) async {
    return _allItems.where((item) => item.category == category).toList();
  }

  Future<InventoryItemModel> getItemById(String id) async {
    return _allItems.firstWhere(
      (item) => item.id == id,
      orElse: () => _allItems.first,
    );
  }

  static final List<InventoryItemModel> _allItems = [
    const InventoryItemModel(id: 'inv_001', name: 'Urban Goodz Organic Gala Apples', sku: 'UGB-PRO-001', category: 'Produce', description: 'Crisp, sweet organic apples from Texas orchards', price: 3.99, costPrice: 1.80, stockQuantity: 120, lowStockThreshold: 20, unit: 'lb', supplierName: 'Texas Fresh Farms', isFeatured: true, reorderPoint: 25),
    const InventoryItemModel(id: 'inv_002', name: 'Organic Bananas Bunch', sku: 'UGB-PRO-002', category: 'Produce', description: 'Fair trade organic bananas', price: 1.99, costPrice: 0.85, stockQuantity: 200, lowStockThreshold: 30, unit: 'lb', supplierName: 'Texas Fresh Farms', reorderPoint: 40),
    const InventoryItemModel(id: 'inv_003', name: 'Fresh Spinach Bundle', sku: 'UGB-PRO-003', category: 'Produce', description: 'Locally sourced baby spinach', price: 4.49, costPrice: 2.10, stockQuantity: 45, lowStockThreshold: 15, unit: 'bag', supplierName: 'Houston Hydroponics', reorderPoint: 15),
    const InventoryItemModel(id: 'inv_004', name: 'Heirloom Tomato Medley', sku: 'UGB-PRO-004', category: 'Produce', description: 'Mixed heirloom tomatoes from local farms', price: 5.99, costPrice: 2.75, stockQuantity: 60, lowStockThreshold: 15, unit: 'lb', supplierName: 'Texas Fresh Farms', isFeatured: true, reorderPoint: 20),
    const InventoryItemModel(id: 'inv_005', name: 'Urban Goodz Signature Cold Brew', sku: 'UGB-BEV-001', category: 'Beverages', description: 'Small-batch cold brew, 32 oz bottle', price: 6.99, costPrice: 3.20, stockQuantity: 240, lowStockThreshold: 30, unit: 'bottle', supplierName: 'Houston Craft Beverage Co.', isFeatured: true, reorderPoint: 50),
    const InventoryItemModel(id: 'inv_006', name: 'Organic Green Juice Blend', sku: 'UGB-BEV-002', category: 'Beverages', description: 'Cold-pressed kale, spinach, apple, ginger', price: 8.99, costPrice: 4.50, stockQuantity: 85, lowStockThreshold: 20, unit: 'bottle', supplierName: 'Juice Revival Houston', reorderPoint: 20),
    const InventoryItemModel(id: 'inv_007', name: 'Coconut Water (6 pk)', sku: 'UGB-BEV-003', category: 'Beverages', description: 'Pure young coconut water, no added sugar', price: 14.99, costPrice: 8.00, stockQuantity: 55, lowStockThreshold: 15, unit: 'box', supplierName: 'Tropical Imports LLC', reorderPoint: 15),
    const InventoryItemModel(id: 'inv_008', name: 'Urban Goodz Artisan Sourdough Loaf', sku: 'UGB-BAK-001', category: 'Bakery', description: '24-hour fermented sourdough, baked fresh daily', price: 8.49, costPrice: 2.75, stockQuantity: 30, lowStockThreshold: 10, unit: 'loaf', supplierName: 'Third Ward Bakehouse', isFeatured: true, reorderPoint: 15),
    const InventoryItemModel(id: 'inv_009', name: 'Gluten-Free Banana Nut Muffin (4 ct)', sku: 'UGB-BAK-002', category: 'Bakery', description: 'Moist gluten-free muffins made with organic bananas', price: 10.99, costPrice: 5.00, stockQuantity: 18, lowStockThreshold: 8, unit: 'box', supplierName: 'Third Ward Bakehouse', reorderPoint: 10),
    const InventoryItemModel(id: 'inv_010', name: 'Brown Butter Chocolate Chip Cookie', sku: 'UGB-BAK-003', category: 'Bakery', description: 'House-made cookies with premium chocolate', price: 3.49, costPrice: 1.25, stockQuantity: 65, lowStockThreshold: 20, unit: 'piece', supplierName: 'Third Ward Bakehouse', reorderPoint: 25),
    const InventoryItemModel(id: 'inv_011', name: 'Texas Grass-Fed Ribeye Steak', sku: 'UGB-MEA-001', category: 'Meat & Seafood', description: '12 oz prime ribeye, grass-fed, no hormones', price: 18.99, costPrice: 11.50, stockQuantity: 40, lowStockThreshold: 10, unit: 'lb', supplierName: "Rancher's Pride Texas Meats", isFeatured: true, reorderPoint: 15),
    const InventoryItemModel(id: 'inv_012', name: 'Wild-Caught Gulf Shrimp (2 lb)', sku: 'UGB-MEA-002', category: 'Meat & Seafood', description: 'Fresh Gulf shrimp, wild-caught, peeled', price: 22.99, costPrice: 14.00, stockQuantity: 25, lowStockThreshold: 8, unit: 'box', supplierName: 'Gulf Coast Seafood Co.', reorderPoint: 12),
    const InventoryItemModel(id: 'inv_013', name: 'Free-Range Chicken Breast (1 lb)', sku: 'UGB-MEA-003', category: 'Meat & Seafood', description: 'Air-chilled, free-range chicken breast', price: 9.99, costPrice: 5.50, stockQuantity: 60, lowStockThreshold: 15, unit: 'lb', supplierName: "Rancher's Pride Texas Meats", reorderPoint: 20),
    const InventoryItemModel(id: 'inv_014', name: 'Organic Whole Milk (gal)', sku: 'UGB-DAI-001', category: 'Dairy', description: 'Grass-fed organic whole milk', price: 6.99, costPrice: 3.75, stockQuantity: 35, lowStockThreshold: 12, unit: 'gal', supplierName: 'Texas Dairy Farms Co-op', reorderPoint: 15),
    const InventoryItemModel(id: 'inv_015', name: 'Artisanal Sharp Cheddar Block (8 oz)', sku: 'UGB-DAI-002', category: 'Dairy', description: 'Aged 12 months, Vermont-style cheddar', price: 7.99, costPrice: 4.25, stockQuantity: 22, lowStockThreshold: 8, unit: 'piece', supplierName: 'Artisan Cheese Collective', reorderPoint: 10),
    const InventoryItemModel(id: 'inv_016', name: 'Greek Yogurt (32 oz)', sku: 'UGB-DAI-003', category: 'Dairy', description: 'Plain whole milk Greek yogurt, no added sugar', price: 6.49, costPrice: 3.00, stockQuantity: 28, lowStockThreshold: 10, unit: 'tub', supplierName: 'Texas Dairy Farms Co-op', reorderPoint: 12),
    const InventoryItemModel(id: 'inv_017', name: 'Urban Goodz Organic All-Purpose Flour (5 lb)', sku: 'UGB-PAN-001', category: 'Pantry', description: 'Stone-ground organic all-purpose flour', price: 7.99, costPrice: 3.50, stockQuantity: 50, lowStockThreshold: 15, unit: 'bag', supplierName: 'Urban Goodz Wholesale', reorderPoint: 15),
    const InventoryItemModel(id: 'inv_018', name: 'Extra Virgin Olive Oil (16.9 oz)', sku: 'UGB-PAN-002', category: 'Pantry', description: 'First cold press, Italian single-origin', price: 14.99, costPrice: 8.00, stockQuantity: 35, lowStockThreshold: 10, unit: 'bottle', supplierName: 'Urban Goodz Wholesale', isFeatured: true, reorderPoint: 12),
    const InventoryItemModel(id: 'inv_019', name: 'Quinoa (2 lb)', sku: 'UGB-PAN-003', category: 'Pantry', description: 'Organic tri-color quinoa', price: 9.99, costPrice: 5.25, stockQuantity: 40, lowStockThreshold: 12, unit: 'bag', supplierName: 'Urban Goodz Wholesale', reorderPoint: 12),
    const InventoryItemModel(id: 'inv_020', name: 'Mango & Turmeric Handmade Soap (3 bar set)', sku: 'UGB-HBC-001', category: 'Beauty & Body', description: 'Handcrafted with shea butter, mango oil, and turmeric', price: 12.99, costPrice: 5.50, stockQuantity: 8, lowStockThreshold: 10, unit: 'box', supplierName: 'Natural Glow Body Co.', isFeatured: true, reorderPoint: 15),
    const InventoryItemModel(id: 'inv_021', name: 'Shea Moisture Curl Enhancing Shampoo', sku: 'UGB-HBC-002', category: 'Beauty & Body', description: 'Sulfate-free curl shampoo with shea butter and hibiscus', price: 14.99, costPrice: 7.50, stockQuantity: 23, lowStockThreshold: 10, unit: 'bottle', supplierName: 'Natural Glow Body Co.', reorderPoint: 12),
    const InventoryItemModel(id: 'inv_022', name: 'Vitamin D3 2000 IU (90 ct)', sku: 'UGB-PHA-001', category: 'Pharmacy', description: 'High potency vitamin D3 for immune support', price: 15.99, costPrice: 8.00, stockQuantity: 75, lowStockThreshold: 20, unit: 'bottle', supplierName: 'MedSource Pharmaceuticals', reorderPoint: 25),
    const InventoryItemModel(id: 'inv_023', name: 'Probiotic Digestive Support (30 ct)', sku: 'UGB-PHA-002', category: 'Pharmacy', description: '10-strain probiotic with prebiotic fiber', price: 24.99, costPrice: 13.00, stockQuantity: 0, lowStockThreshold: 15, unit: 'bottle', supplierName: 'MedSource Pharmaceuticals', reorderPoint: 20),
    const InventoryItemModel(id: 'inv_024', name: 'Allergy Relief 24 Hour (30 ct)', sku: 'UGB-PHA-003', category: 'Pharmacy', description: 'Non-drowsy loratadine antihistamine', price: 18.99, costPrice: 9.50, stockQuantity: 120, lowStockThreshold: 25, unit: 'bottle', supplierName: 'MedSource Pharmaceuticals', reorderPoint: 30),
    const InventoryItemModel(id: 'inv_025', name: 'Urban Goodz Pantry Starter Kit', sku: 'UGB-KIT-001', category: 'Kits & Bundles', description: 'Essentials: olive oil, flour, quinoa, spices, honey', price: 35.00, costPrice: 18.75, stockQuantity: 45, lowStockThreshold: 10, unit: 'box', supplierName: 'Urban Goodz Wholesale', isFeatured: true, reorderPoint: 15),
    const InventoryItemModel(id: 'inv_026', name: 'Organic Produce Gift Box', sku: 'UGB-KIT-002', category: 'Kits & Bundles', description: 'Seasonal organic fruits and vegetables gift box', price: 45.00, costPrice: 28.50, stockQuantity: 100, lowStockThreshold: 15, unit: 'box', supplierName: 'Texas Fresh Farms', isFeatured: true, reorderPoint: 20),
    const InventoryItemModel(id: 'inv_027', name: 'Texas Wildflower Honey (16 oz)', sku: 'UGB-PAN-004', category: 'Pantry', description: 'Raw, unfiltered honey from Texas wildflowers', price: 12.99, costPrice: 6.00, stockQuantity: 3, lowStockThreshold: 10, unit: 'jar', supplierName: 'Texas Honey Farms', reorderPoint: 12),
    const InventoryItemModel(id: 'inv_028', name: 'Urban Goodz Natural Deodorant', sku: 'UGB-HBC-003', category: 'Beauty & Body', description: 'Aluminum-free, coconut oil & shea butter deodorant', price: 9.99, costPrice: 4.25, stockQuantity: 15, lowStockThreshold: 10, unit: 'stick', supplierName: 'Natural Glow Body Co.', reorderPoint: 12),
    const InventoryItemModel(id: 'inv_029', name: 'Fresh Basil Plant (live)', sku: 'UGB-PRO-005', category: 'Produce', description: 'Potted sweet basil, grown in Houston greenhouse', price: 5.99, costPrice: 2.50, stockQuantity: 12, lowStockThreshold: 8, unit: 'pot', supplierName: 'Houston Hydroponics', reorderPoint: 10),
    const InventoryItemModel(id: 'inv_030', name: 'Ethiopian Single Origin Coffee (12 oz)', sku: 'UGB-BEV-004', category: 'Beverages', description: 'Light roast, floral notes, whole bean', price: 16.99, costPrice: 9.00, stockQuantity: 35, lowStockThreshold: 10, unit: 'bag', supplierName: 'Houston Craft Beverage Co.', isFeatured: true, reorderPoint: 15),
    const InventoryItemModel(id: 'inv_031', name: 'Organic Free-Range Eggs (dozen)', sku: 'UGB-DAI-004', category: 'Dairy', description: 'Pasture-raised, organic brown eggs', price: 7.99, costPrice: 4.00, stockQuantity: 48, lowStockThreshold: 12, unit: 'box', supplierName: 'Texas Dairy Farms Co-op', reorderPoint: 18),
    const InventoryItemModel(id: 'inv_032', name: 'Edge Control Gel (3 pk)', sku: 'UGB-HBC-004', category: 'Beauty & Body', description: 'Strong hold, alcohol-free edge control', price: 9.99, costPrice: 4.00, stockQuantity: 55, lowStockThreshold: 15, unit: 'bottle', supplierName: 'Natural Glow Body Co.', reorderPoint: 20),
    const InventoryItemModel(id: 'inv_033', name: 'Black Seed Oil (8 oz)', sku: 'UGB-PHA-004', category: 'Pharmacy', description: 'Cold-pressed nigella sativa oil, immune support', price: 19.99, costPrice: 10.00, stockQuantity: 18, lowStockThreshold: 8, unit: 'bottle', supplierName: 'MedSource Pharmaceuticals', reorderPoint: 10),
    const InventoryItemModel(id: 'inv_034', name: 'Urban Goodz Signature Candle - Vanilla Oud', sku: 'UGB-HOM-001', category: 'Home & Decor', description: 'Soy wax candle, 60-hour burn time', price: 18.99, costPrice: 8.50, stockQuantity: 22, lowStockThreshold: 8, unit: 'piece', supplierName: 'Third Ward Artisans', isFeatured: true, reorderPoint: 10),
    const InventoryItemModel(id: 'inv_035', name: 'Handwoven Basket Set (3)', sku: 'UGB-HOM-002', category: 'Home & Decor', description: 'Fair trade handwoven baskets from Ghana', price: 45.00, costPrice: 22.00, stockQuantity: 7, lowStockThreshold: 5, unit: 'set', supplierName: 'Global Artisan Imports', reorderPoint: 6),
    const InventoryItemModel(id: 'inv_036', name: 'Urban Goodz Tote Bag - Limited Edition', sku: 'UGB-ACC-001', category: 'Accessories', description: 'Heavy-duty canvas tote with Urban Goodz branding', price: 24.99, costPrice: 10.00, stockQuantity: 150, lowStockThreshold: 30, unit: 'piece', supplierName: 'Urban Goodz Merch', isFeatured: true, reorderPoint: 40),
    const InventoryItemModel(id: 'inv_037', name: 'Reusable Produce Bags (6 ct)', sku: 'UGB-ACC-002', category: 'Accessories', description: 'Organic cotton mesh produce bags', price: 14.99, costPrice: 6.00, stockQuantity: 90, lowStockThreshold: 20, unit: 'box', supplierName: 'Urban Goodz Merch', reorderPoint: 25),
    const InventoryItemModel(id: 'inv_038', name: 'Fresh Corn Tortillas (30 ct)', sku: 'UGB-PAN-005', category: 'Pantry', description: 'Stone-ground heirloom corn, made fresh', price: 5.99, costPrice: 2.50, stockQuantity: 42, lowStockThreshold: 15, unit: 'pack', supplierName: 'Houston Tortilleria', reorderPoint: 15),
    const InventoryItemModel(id: 'inv_039', name: 'Organic Strawberries (1 lb)', sku: 'UGB-PRO-006', category: 'Produce', description: 'Sweet organic strawberries from Poteet, TX', price: 5.99, costPrice: 2.75, stockQuantity: 2, lowStockThreshold: 12, unit: 'box', supplierName: 'Texas Fresh Farms', reorderPoint: 15),
    const InventoryItemModel(id: 'inv_040', name: 'Grass-Fed Beef Bone Broth (32 oz)', sku: 'UGB-MEA-004', category: 'Meat & Seafood', description: 'Slow-simmered bone broth with organic vegetables', price: 9.99, costPrice: 5.00, stockQuantity: 20, lowStockThreshold: 8, unit: 'bottle', supplierName: "Rancher's Pride Texas Meats", reorderPoint: 10),
  ];
}

class MockServiceBookingsRepository {
  Future<List<ServiceBookingModel>> getAllBookings() async {
    return _allBookings;
  }

  Future<List<ServiceBookingModel>> getBookingsByStatus(String status) async {
    return _allBookings.where((b) => b.status == status).toList();
  }

  Future<List<ServiceBookingModel>> getUpcomingBookings() async {
    return _allBookings.where((b) => b.status == 'confirmed' || b.status == 'pending').toList();
  }

  static final List<ServiceBookingModel> _allBookings = [
    ServiceBookingModel(id: 'BK-001', serviceName: 'Home Deep Clean Service', customerName: 'Rashida Williams', customerEmail: 'rashida@example.com', bookingDate: DateTime(2026, 6, 10), timeSlot: '09:00 AM', amount: 180.00, status: 'confirmed', notes: 'Eco-friendly cleaning, 3BR/2BA', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-002', serviceName: 'Lawn Mowing & Landscaping', customerName: 'Michael Thompson', customerEmail: 'michael@example.com', bookingDate: DateTime(2026, 6, 9), timeSlot: '08:00 AM', amount: 65.00, status: 'in_progress', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-003', serviceName: 'AC Maintenance & Tune-Up', customerName: 'Elena Reyes', customerEmail: 'elena@example.com', bookingDate: DateTime(2026, 6, 12), timeSlot: '02:00 PM', amount: 120.00, status: 'confirmed', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-004', serviceName: 'Personal Training Session', customerName: 'Darnell Washington', customerEmail: 'darnell@example.com', bookingDate: DateTime(2026, 6, 8), timeSlot: '06:00 AM', amount: 55.00, status: 'completed', createdAt: DateTime(2026, 6, 1)),
    ServiceBookingModel(id: 'BK-005', serviceName: 'Event Decor & Setup', customerName: 'Tamara Johnson', customerEmail: 'tamara@example.com', bookingDate: DateTime(2026, 6, 15), timeSlot: '08:00 AM', amount: 450.00, status: 'confirmed', notes: '40th birthday party, gold/white theme', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-006', serviceName: 'Deep Carpet Cleaning', customerName: 'Fatima Hassan', customerEmail: 'fatima@example.com', bookingDate: DateTime(2026, 6, 11), timeSlot: '10:00 AM', amount: 150.00, status: 'pending', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-007', serviceName: 'Mobile Car Detailing', customerName: 'Carlos Gutierrez', customerEmail: 'carlos@example.com', bookingDate: DateTime(2026, 6, 13), timeSlot: '09:00 AM', amount: 85.00, status: 'confirmed', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-008', serviceName: 'Furniture Assembly Service', customerName: 'Jennifer Kim', customerEmail: 'jennifer@example.com', bookingDate: DateTime(2026, 6, 14), timeSlot: '01:00 PM', amount: 95.00, status: 'pending', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-009', serviceName: 'Plumbing - Leaky Faucet Repair', customerName: 'Harold Mitchell', customerEmail: 'harold@example.com', bookingDate: DateTime(2026, 6, 9), timeSlot: '03:00 PM', amount: 75.00, status: 'cancelled', createdAt: DateTime(2026, 6, 5)),
    ServiceBookingModel(id: 'BK-010', serviceName: 'Private Chef - In-Home Dinner', customerName: 'Angela Crawford', customerEmail: 'angela@example.com', bookingDate: DateTime(2026, 6, 20), timeSlot: '06:00 PM', amount: 350.00, status: 'confirmed', notes: 'Vegetarian menu, 6 guests', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-011', serviceName: 'Pest Control Treatment', customerName: 'Samuel Davis', customerEmail: 'samuel@example.com', bookingDate: DateTime(2026, 6, 18), timeSlot: '08:00 AM', amount: 110.00, status: 'confirmed', createdAt: DateTime(2026, 6, 8)),
    ServiceBookingModel(id: 'BK-012', serviceName: 'Photography - Family Portrait', customerName: 'Amara Osei', customerEmail: 'amara@example.com', bookingDate: DateTime(2026, 6, 22), timeSlot: '10:00 AM', amount: 200.00, status: 'confirmed', notes: 'Outdoor at Memorial Park', createdAt: DateTime(2026, 6, 8)),
  ];
}

class MockPromotionsRepository {
  Future<List<PromotionModel>> getAllPromotions() async {
    return _allPromotions;
  }

  Future<List<PromotionModel>> getActivePromotions() async {
    return _allPromotions.where((p) => p.isActive).toList();
  }

  Future<List<PromotionModel>> getPromotionsByDiscountType(String type) async {
    return _allPromotions.where((p) => p.discountType == type).toList();
  }

  static final List<PromotionModel> _allPromotions = [
    PromotionModel(id: 'PROMO-001', title: 'Houston Grand Opening Sale', description: 'Celebrating our Midtown flagship! Get 20% off orders over \$50.', discountType: 'percentage', discountValue: 20.0, code: 'HOUSTON20', minOrderAmount: 50.0, startDate: DateTime(2026, 6, 1), endDate: DateTime(2026, 7, 1), usageLimit: 500, usageCount: 187, isActive: true, imageUrl: ''),
    PromotionModel(id: 'PROMO-002', title: 'Summer Grocery Bundle', description: 'Buy 2 Urban Goodz grocery bundles and get the 3rd free.', discountType: 'bogo', discountValue: 100.0, startDate: DateTime(2026, 6, 1), endDate: DateTime(2026, 7, 15), usageLimit: 300, usageCount: 89, isActive: true, imageUrl: ''),
    PromotionModel(id: 'PROMO-003', title: 'Beauty Supply Weekend Blowout', description: '\$10 off beauty and body orders of \$50 or more.', discountType: 'fixed', discountValue: 10.0, code: 'BEAUTY10', minOrderAmount: 50.0, startDate: DateTime(2026, 6, 12), endDate: DateTime(2026, 6, 15), usageLimit: 200, usageCount: 45, isActive: true, imageUrl: ''),
    PromotionModel(id: 'PROMO-004', title: 'Pharmacy Loyalty Rewards', description: 'Earn 5x loyalty points on pharmacy and wellness purchases.', discountType: 'points', discountValue: 5.0, startDate: DateTime(2026, 6, 1), endDate: DateTime(2026, 6, 30), usageLimit: 1000, usageCount: 234, isActive: true, imageUrl: ''),
    PromotionModel(id: 'PROMO-005', title: 'Free Delivery Weekend', description: 'No delivery fees this weekend! Fri 6PM to Sun midnight.', discountType: 'free_shipping', discountValue: 0.0, code: 'FREEDELIVERY', minOrderAmount: 15.0, startDate: DateTime(2026, 6, 12), endDate: DateTime(2026, 6, 14), usageLimit: 500, usageCount: 312, isActive: true, imageUrl: ''),
    PromotionModel(id: 'PROMO-006', title: 'Meal Prep Monday Flash Sale', description: 'All meal prep bundles 25% off. Today only!', discountType: 'percentage', discountValue: 25.0, code: 'MONDAY25', startDate: DateTime(2026, 6, 8), endDate: DateTime(2026, 6, 8), usageLimit: 100, usageCount: 67, isActive: true, imageUrl: ''),
    PromotionModel(id: 'PROMO-007', title: 'Juneteenth Celebration Special', description: '15% off all orders from Black-owned vendors.', discountType: 'percentage', discountValue: 15.0, code: 'JUNETEENTH', minOrderAmount: 25.0, startDate: DateTime(2026, 6, 15), endDate: DateTime(2026, 6, 20), usageLimit: 400, usageCount: 0, isActive: true, imageUrl: ''),
    PromotionModel(id: 'PROMO-008', title: 'First Time Catering Order', description: '\$50 off catering orders of \$200 or more.', discountType: 'fixed', discountValue: 50.0, code: 'CATER50', minOrderAmount: 200.0, startDate: DateTime(2026, 5, 1), endDate: DateTime(2026, 8, 1), usageLimit: 100, usageCount: 100, isActive: false, imageUrl: ''),
  ];
}

class MockReelsRepository {
  Future<List<ReelModel>> getAllReels() async {
    return _allReels;
  }

  Future<List<ReelModel>> getPublishedReels() async {
    return _allReels.where((r) => r.isPublished).toList();
  }

  Future<List<ReelModel>> getReelsByType(String type) async {
    return _allReels.where((r) => r.type == type).toList();
  }

  static final List<ReelModel> _allReels = [
    ReelModel(id: 'REEL-001', title: 'How to Style Your Natural Hair with Urban Goodz Products', description: 'Watch as celebrity stylist Keisha Thomas shows you three gorgeous natural hair styles using our Shea Moisture Curl Collection. Perfect for summer!', videoUrl: 'reels/natural_hair_styling.mp4', thumbnailUrl: 'thumbnails/natural_hair_thumb.jpg', type: 'tutorial', duration: '3:45', views: 15280, likes: 2341, comments: 187, shares: 892, isPublished: true, createdAt: DateTime(2026, 5, 28), tags: ['natural hair', 'tutorial', 'beauty', 'curly hair', 'summer styles'], productTag: ['inv_021', 'inv_032']),
    ReelModel(id: 'REEL-002', title: 'Behind the Scenes: Fresh Grocery Delivery at Urban Goodz Midtown', description: 'Ever wonder how your organic produce gets from the farm to your door? Join us for a behind-the-scenes look at our morning delivery operation.', videoUrl: 'reels/bts_delivery.mp4', thumbnailUrl: 'thumbnails/bts_delivery_thumb.jpg', type: 'behind_scenes', duration: '2:30', views: 8940, likes: 1203, comments: 95, shares: 445, isPublished: true, createdAt: DateTime(2026, 6, 1), tags: ['behind the scenes', 'grocery delivery', 'Houston', 'organic', 'Urban Goodz'], productTag: ['inv_001', 'inv_026']),
    ReelModel(id: 'REEL-003', title: "Customer Spotlight: Maria's Organic Kitchen", description: "Meet Maria Gonzalez, one of our favorite customers! Watch her cook a delicious weeknight dinner using only Urban Goodz Organic products.", videoUrl: 'reels/customer_spotlight_maria.mp4', thumbnailUrl: 'thumbnails/maria_kitchen_thumb.jpg', type: 'customer_testimonial', duration: '4:15', views: 21300, likes: 3420, comments: 256, shares: 1204, isPublished: true, createdAt: DateTime(2026, 6, 3), tags: ['customer spotlight', 'cooking', 'organic', 'recipe', 'Houston'], productTag: ['inv_001', 'inv_003', 'inv_004', 'inv_012']),
    ReelModel(id: 'REEL-004', title: 'New Arrivals: Urban Goodz Summer Collection 2026', description: 'Check out our hottest new products hitting the shelves this summer! From cold brew to candles, we have everything you need.', videoUrl: 'reels/summer_collection.mp4', thumbnailUrl: 'thumbnails/summer_collection_thumb.jpg', type: 'product_showcase', duration: '1:55', views: 12450, likes: 1876, comments: 134, shares: 678, isPublished: true, createdAt: DateTime(2026, 6, 5), tags: ['new arrivals', 'summer', 'products', 'Urban Goodz', 'Houston'], productTag: ['inv_005', 'inv_034', 'inv_036', 'inv_030']),
    ReelModel(id: 'REEL-005', title: 'Announcing: Urban Goodz Pharmacy & Wellness Center', description: 'We are thrilled to announce our new Pharmacy & Wellness Center opening in Third Ward! Your health, our commitment.', videoUrl: 'reels/pharmacy_announcement.mp4', thumbnailUrl: 'thumbnails/pharmacy_thumb.jpg', type: 'announcement', duration: '1:20', views: 32100, likes: 4521, comments: 412, shares: 2105, isPublished: true, createdAt: DateTime(2026, 6, 2), tags: ['announcement', 'pharmacy', 'Third Ward', 'wellness', 'Urban Goodz'], productTag: ['inv_022', 'inv_023', 'inv_024']),
    ReelModel(id: 'REEL-006', title: '5 Minute Meal Prep: Urban Goodz Grocery Bundle Challenge', description: 'Can you prep a week of healthy meals in just 5 minutes? We challenged Chef David to do it with our Organic Weekly Bundle!', videoUrl: 'reels/meal_prep_challenge.mp4', thumbnailUrl: 'thumbnails/meal_prep_thumb.jpg', type: 'tutorial', duration: '5:00', views: 19800, likes: 2890, comments: 210, shares: 1567, isPublished: false, createdAt: DateTime(2026, 6, 7), tags: ['meal prep', 'challenge', 'cooking', 'healthy', 'Urban Goodz'], productTag: ['inv_025', 'inv_026', 'inv_005']),
  ];
}

class MockAnalyticsRepository {
  Future<List<AnalyticsModel>> getAnalytics(String startDate, String endDate) async {
    return _last90Days;
  }

  Future<AnalyticsModel> getDailyAnalytics(String date) async {
    return _last90Days.firstWhere(
      (a) => a.date == date,
      orElse: () => _last90Days.last,
    );
  }

  Future<List<AnalyticsModel>> getWeeklyBreakdown() async {
    return _weeklyBreakdown;
  }

  Future<Map<String, double>> getMonthlyComparison() async {
    return {
      'current_month_revenue': 128600.50,
      'previous_month_revenue': 112450.00,
      'growth_percentage': 14.4,
      'current_month_orders': 1248,
      'previous_month_orders': 1102,
      'order_growth_percentage': 13.3,
    };
  }

  Future<Map<String, double>> getCategoryPerformance() async {
    return {
      'Produce': 38450.00, 'Meat & Seafood': 28700.00, 'Beverages': 22100.00,
      'Pantry': 18500.00, 'Dairy': 14200.00, 'Beauty & Body': 9800.00,
      'Bakery': 7600.00, 'Pharmacy': 6800.00, 'Kits & Bundles': 12500.00,
      'Home & Decor': 4200.00, 'Accessories': 3100.00,
    };
  }

  Future<Map<String, int>> getPeakHours() async {
    return {
      '6 AM - 8 AM': 145, '8 AM - 10 AM': 312, '10 AM - 12 PM': 278,
      '12 PM - 2 PM': 198, '2 PM - 4 PM': 156, '4 PM - 6 PM': 289,
      '6 PM - 8 PM': 345, '8 PM - 10 PM': 189,
    };
  }

  Future<Map<String, dynamic>> getCustomerAcquisitionData() async {
    return {
      'new_customers_this_month': 187,
      'returning_customers_this_month': 1061,
      'customer_retention_rate': 0.73,
      'average_customer_lifetime_value': 420.00,
      'top_acquisition_channels': {'Referral': 35, 'Social Media': 28, 'Walk-in': 22, 'Online Search': 15},
    };
  }

  static final List<AnalyticsModel> _last90Days = [
    AnalyticsModel(date: 'Mon', totalOrders: 28, totalRevenue: 2450.00, averageOrderValue: 87.50, topSellingCategory: 'Produce', newCustomers: 8, returningCustomers: 20, cancellationRate: 0.03, fulfillmentTime: 42.0),
    AnalyticsModel(date: 'Tue', totalOrders: 32, totalRevenue: 2780.00, averageOrderValue: 86.88, topSellingCategory: 'Produce', newCustomers: 10, returningCustomers: 22, cancellationRate: 0.02, fulfillmentTime: 40.5),
    AnalyticsModel(date: 'Wed', totalOrders: 35, totalRevenue: 3100.00, averageOrderValue: 88.57, topSellingCategory: 'Meat & Seafood', newCustomers: 9, returningCustomers: 26, cancellationRate: 0.04, fulfillmentTime: 41.0),
    AnalyticsModel(date: 'Thu', totalOrders: 30, totalRevenue: 2650.00, averageOrderValue: 88.33, topSellingCategory: 'Produce', newCustomers: 7, returningCustomers: 23, cancellationRate: 0.03, fulfillmentTime: 43.2),
    AnalyticsModel(date: 'Fri', totalOrders: 38, totalRevenue: 3420.00, averageOrderValue: 90.00, topSellingCategory: 'Beverages', newCustomers: 12, returningCustomers: 26, cancellationRate: 0.02, fulfillmentTime: 39.8),
    AnalyticsModel(date: 'Sat', totalOrders: 42, totalRevenue: 3780.00, averageOrderValue: 90.00, topSellingCategory: 'Produce', newCustomers: 14, returningCustomers: 28, cancellationRate: 0.01, fulfillmentTime: 38.5),
    AnalyticsModel(date: 'Sun', totalOrders: 36, totalRevenue: 3150.00, averageOrderValue: 87.50, topSellingCategory: 'Dairy', newCustomers: 11, returningCustomers: 25, cancellationRate: 0.03, fulfillmentTime: 41.5),
    AnalyticsModel(date: 'Mon', totalOrders: 34, totalRevenue: 2980.00, averageOrderValue: 87.65, topSellingCategory: 'Produce', newCustomers: 9, returningCustomers: 25, cancellationRate: 0.02, fulfillmentTime: 40.0),
    AnalyticsModel(date: 'Tue', totalOrders: 33, totalRevenue: 2890.00, averageOrderValue: 87.58, topSellingCategory: 'Pantry', newCustomers: 8, returningCustomers: 25, cancellationRate: 0.04, fulfillmentTime: 42.8),
    AnalyticsModel(date: 'Wed', totalOrders: 37, totalRevenue: 3250.00, averageOrderValue: 87.84, topSellingCategory: 'Produce', newCustomers: 10, returningCustomers: 27, cancellationRate: 0.02, fulfillmentTime: 40.3),
    AnalyticsModel(date: 'Thu', totalOrders: 40, totalRevenue: 3600.00, averageOrderValue: 90.00, topSellingCategory: 'Meat & Seafood', newCustomers: 13, returningCustomers: 27, cancellationRate: 0.01, fulfillmentTime: 39.0),
    AnalyticsModel(date: 'Mon', totalOrders: 45, totalRevenue: 4050.00, averageOrderValue: 90.00, topSellingCategory: 'Beverages', newCustomers: 15, returningCustomers: 30, cancellationRate: 0.02, fulfillmentTime: 38.0, popularTimeSlots: {'6 AM - 8 AM': 5, '8 AM - 10 AM': 12, '10 AM - 12 PM': 10, '12 PM - 2 PM': 6, '2 PM - 4 PM': 4, '4 PM - 6 PM': 7, '6 PM - 8 PM': 3}, revenueByCategory: {'Produce': 1250.00, 'Meat & Seafood': 890.00, 'Beverages': 650.00, 'Pantry': 480.00, 'Dairy': 350.00, 'Beauty & Body': 180.00, 'Bakery': 150.75, 'Pharmacy': 120.00, 'Kits & Bundles': 450.00, 'Home & Decor': 85.00, 'Accessories': 45.00}),
  ];

  static final List<AnalyticsModel> _weeklyBreakdown = [
    AnalyticsModel(date: 'Week 1 (Jun 1-7)', totalOrders: 498, totalRevenue: 46140.00, averageOrderValue: 92.65, topSellingCategory: 'Produce', newCustomers: 170, returningCustomers: 328, cancellationRate: 0.014, fulfillmentTime: 33.9),
    AnalyticsModel(date: 'Week 4 (May 25-31)', totalOrders: 456, totalRevenue: 41080.00, averageOrderValue: 90.09, topSellingCategory: 'Produce', newCustomers: 151, returningCustomers: 305, cancellationRate: 0.016, fulfillmentTime: 35.0),
    AnalyticsModel(date: 'Week 3 (May 18-24)', totalOrders: 425, totalRevenue: 38250.00, averageOrderValue: 90.00, topSellingCategory: 'Meat & Seafood', newCustomers: 140, returningCustomers: 285, cancellationRate: 0.017, fulfillmentTime: 36.2),
    AnalyticsModel(date: 'Week 2 (May 11-17)', totalOrders: 398, totalRevenue: 35850.00, averageOrderValue: 90.08, topSellingCategory: 'Beverages', newCustomers: 131, returningCustomers: 267, cancellationRate: 0.018, fulfillmentTime: 37.1),
    AnalyticsModel(date: 'Week 1 (May 4-10)', totalOrders: 365, totalRevenue: 32850.00, averageOrderValue: 90.00, topSellingCategory: 'Produce', newCustomers: 120, returningCustomers: 245, cancellationRate: 0.019, fulfillmentTime: 38.0),
  ];
}

class MockCustomerReviewsRepository {
  Future<List<CustomerReviewModel>> getAllReviews() async {
    return _allReviews;
  }

  Future<List<CustomerReviewModel>> getReviewsByRating(int rating) async {
    return _allReviews.where((r) => r.rating == rating).toList();
  }

  Future<List<CustomerReviewModel>> getUnrepliedReviews() async {
    return _allReviews.where((r) => r.vendorReply == null || r.vendorReply!.isEmpty).toList();
  }

  static final List<CustomerReviewModel> _allReviews = [
    CustomerReviewModel(id: 'REV-001', customerName: 'Maria Gonzalez', customerAvatar: 'avatars/maria_g.jpg', rating: 5, comment: 'The organic produce box is amazing! Everything was so fresh and lasted over a week. The avocados were perfectly ripe. I am a customer for life!', serviceName: 'Urban Goodz Organic Produce Box', orderId: 'ORD-2876', createdAt: DateTime(2026, 4, 10), vendorReply: 'Thank you so much Maria! We take pride in sourcing the freshest produce from local Texas farms. See you next week!', helpfulCount: 24, images: ['reviews/maria_produce_1.jpg'], isVerified: true),
    CustomerReviewModel(id: 'REV-002', customerName: 'Kevin Tran', customerAvatar: 'avatars/kevin_t.jpg', rating: 5, comment: 'The Texas Grass-Fed Beef Bundle is incredible value. The ribeyes were restaurant quality. Cold brew is also top-notch. Highly recommend!', serviceName: 'Texas Grass-Fed Beef Bundle', orderId: 'ORD-2875', createdAt: DateTime(2026, 4, 11), vendorReply: 'Kevin, we are thrilled you enjoyed the beef bundle! Our ranchers take great care in their craft. Thanks for supporting local Texas agriculture!', helpfulCount: 18, isVerified: true),
    CustomerReviewModel(id: 'REV-003', customerName: 'Aaliyah Washington', customerAvatar: 'avatars/aaliyah_w.jpg', rating: 5, comment: 'Quick pickup and the produce was beautiful. The sourdough is the best I have had outside of San Francisco. Keep up the great work!', serviceName: 'Urban Goodz Artisan Sourdough', orderId: 'ORD-2874', createdAt: DateTime(2026, 4, 12), vendorReply: 'Thank you Aaliyah! Our bakers at Third Ward Bakehouse put so much love into every loaf. See you soon!', helpfulCount: 12, isVerified: true),
    CustomerReviewModel(id: 'REV-004', customerName: 'Carlos Ruiz', customerAvatar: 'avatars/carlos_r.jpg', rating: 4, comment: 'Good service overall. The meal prep bundle was tasty but I wish there were more variety in the sides. Delivery was on time though.', serviceName: 'Urban Goodz Meal Prep Bundle', orderId: 'ORD-2873', createdAt: DateTime(2026, 4, 13), vendorReply: 'Carlos, thank you for the feedback! We are updating our meal prep menu this month with more variety including new sides and plant-based options. Stay tuned!', helpfulCount: 8, isVerified: true),
    CustomerReviewModel(id: 'REV-005', customerName: 'Dr. Simone Dupont', customerAvatar: 'avatars/simone_d.jpg', rating: 5, comment: 'As a physician, I appreciate how fresh and high-quality the produce is at Urban Goodz. The sourdough is a family favorite. My kids devour it!', serviceName: 'Urban Goodz Artisan Sourdough', orderId: 'ORD-2872', createdAt: DateTime(2026, 4, 14), vendorReply: 'Dr. Dupont, what an honor to have your stamp of approval! Knowing that medical professionals trust our products means the world to us.', helpfulCount: 32, isVerified: true),
    CustomerReviewModel(id: 'REV-006', customerName: 'James Okafor', customerAvatar: 'avatars/james_o.jpg', rating: 5, comment: 'The Beauty Essentials Kit is everything I needed! My wife loved the Shea Moisture products. Will definitely be ordering again.', serviceName: 'Urban Goodz Beauty Essentials Kit', orderId: 'ORD-2906', createdAt: DateTime(2026, 4, 15), vendorReply: 'James, we are so happy it was a hit with your wife! Our beauty collection is curated with the best natural hair and body care products.', helpfulCount: 15, isVerified: true),
    CustomerReviewModel(id: 'REV-007', customerName: 'Linda Chen', customerAvatar: 'avatars/linda_c.jpg', rating: 4, comment: 'Pharmacy delivery was convenient and the vitamins were well-packaged. Would be nice if they accepted insurance directly for prescription items.', serviceName: 'Pharmacy Prescription Refill Pack', orderId: 'ORD-2907', createdAt: DateTime(2026, 4, 16), vendorReply: 'Great suggestion Linda! We are working on integrating insurance billing for prescription orders. Should be available next quarter!', helpfulCount: 20, isVerified: true),
    CustomerReviewModel(id: 'REV-008', customerName: 'Tanya Richards', customerAvatar: 'avatars/tanya_r.jpg', rating: 5, comment: 'The Grocery Weekly Bundle saves me so much time and money! I love that I do not have to think about meal planning. Everything is perfectly portioned.', serviceName: 'Grocery Weekly Bundle', orderId: 'ORD-2908', createdAt: DateTime(2026, 4, 17), vendorReply: 'Tanya, that is exactly what we designed it for! Busy professionals deserve healthy eating without the stress. Thanks for being an awesome customer!', helpfulCount: 27, images: ['reviews/tanya_bundle_1.jpg', 'reviews/tanya_bundle_2.jpg'], isVerified: true),
    CustomerReviewModel(id: 'REV-009', customerName: 'Ramon Espinoza', customerAvatar: 'avatars/ramon_e.jpg', rating: 5, comment: 'Booked the taco bar catering for our office party and it was a huge hit! Everyone raved about the al pastor. Best decision ever!', serviceName: 'Food Truck Catering - Taco Bar', orderId: 'ORD-2909', createdAt: DateTime(2026, 4, 18), vendorReply: 'Ramon, your office party was lively! So glad the taco bar was a success. We would love to cater your next event too!', helpfulCount: 42, images: ['reviews/ramon_tacos_1.jpg', 'reviews/ramon_tacos_2.jpg', 'reviews/ramon_tacos_3.jpg'], isVerified: true),
    CustomerReviewModel(id: 'REV-010', customerName: 'Nia Thompson', customerAvatar: 'avatars/nia_t.jpg', rating: 5, comment: 'The handmade candles are BEAUTIFUL. I bought them as gifts and ended up keeping one for myself. The vanilla oud scent is perfection.', serviceName: 'Handmade Candles Set', orderId: 'ORD-2910', createdAt: DateTime(2026, 4, 19), vendorReply: 'Nia, we totally understand keeping one for yourself! Our artisans pour so much love into each candle. Thanks for supporting local makers!', helpfulCount: 31, images: ['reviews/nia_candles_1.jpg'], isVerified: true),
    CustomerReviewModel(id: 'REV-011', customerName: 'Sofia Martinez', customerAvatar: 'avatars/sofia_m.jpg', rating: 4, comment: 'The vegan meal prep was delicious but the cold pressed juice pack had one bottle that leaked during delivery. Otherwise great experience.', serviceName: 'Urban Goodz Weekly Meal Prep - Vegan', orderId: 'ORD-2912', createdAt: DateTime(2026, 4, 20), vendorReply: 'Sofia, we apologize for the leak! We are improving our packaging for the juice bottles. Please reach out for a replacement on your next order.', helpfulCount: 6, isVerified: true),
    CustomerReviewModel(id: 'REV-012', customerName: 'Fatima Hassan', customerAvatar: 'avatars/fatima_h.jpg', rating: 5, comment: 'The Natural Hair Care Bundle has transformed my routine! The edge control gel is the strongest hold I have ever used without flaking. Game changer!', serviceName: 'Natural Hair Care Bundle', orderId: 'ORD-2916', createdAt: DateTime(2026, 4, 21), vendorReply: 'Fatima, we are so happy to hear that! Our team carefully selects each product for quality. Your natural hair journey is beautiful!', helpfulCount: 38, images: ['reviews/fatima_hair_1.jpg', 'reviews/fatima_hair_2.jpg'], isVerified: true),
    CustomerReviewModel(id: 'REV-013', customerName: 'Olivia Chen', customerAvatar: 'avatars/olivia_c.jpg', rating: 3, comment: 'The OTC medicine kit was convenient but I found the prices slightly higher than my local pharmacy. Delivery was fast though.', serviceName: 'Pharmacy OTC Medicine Kit', orderId: 'ORD-2918', createdAt: DateTime(2026, 4, 22), vendorReply: 'Olivia, thank you for your honest feedback. We aim to be competitive while ensuring product quality. We are reviewing our pharmacy pricing this month!', helpfulCount: 9, isVerified: true),
    CustomerReviewModel(id: 'REV-014', customerName: 'DeShawn Carter', customerAvatar: 'avatars/deshawn_c.jpg', rating: 5, comment: 'Booked a home deep clean and was blown away by the thoroughness. They even organized my pantry! Worth every penny.', serviceName: 'Home Deep Clean Service', orderId: 'ORD-2919', createdAt: DateTime(2026, 4, 23), vendorReply: 'DeShawn, our cleaning team takes pride in going above and beyond! An organized pantry is our signature touch. Thank you for the review!', helpfulCount: 22, images: ['reviews/deshawn_clean_1.jpg'], isVerified: true),
    CustomerReviewModel(id: 'REV-015', customerName: 'Isabella Ramirez', customerAvatar: 'avatars/isabella_r.jpg', rating: 5, comment: 'The Saturday Market Bundle is my new weekend tradition! The flowers were gorgeous and the produce was picked that morning I could tell. Absolutely love it!', serviceName: 'Urban Goodz Saturday Market Bundle', orderId: 'ORD-2920', createdAt: DateTime(2026, 4, 24), vendorReply: 'Isabella, the Saturday Market Bundle is our passion project! We source from the best farmers market vendors in Houston. See you next Saturday!', helpfulCount: 17, isVerified: true),
    CustomerReviewModel(id: 'REV-016', customerName: 'Grace Nguyen', customerAvatar: 'avatars/grace_n.jpg', rating: 4, comment: 'The hair extensions kit was good quality but took a bit longer to deliver than expected. The edge control gel is fantastic though!', serviceName: 'Beauty Supply - Hair Extensions Kit', orderId: 'ORD-2921', createdAt: DateTime(2026, 4, 25), vendorReply: 'Grace, we apologize for the delay. We are expanding our beauty supply delivery fleet to ensure faster service. Thank you for your patience!', helpfulCount: 5, isVerified: true),
    CustomerReviewModel(id: 'REV-017', customerName: 'Anthony Brown', customerAvatar: 'avatars/anthony_b.jpg', rating: 5, comment: 'Coffee Club subscription is the best thing I have done this year. The Ethiopian single origin is smooth and flavorful. Freshly roasted too!', serviceName: 'Urban Goodz Coffee Club Subscription', orderId: 'ORD-2922', createdAt: DateTime(2026, 4, 26), vendorReply: 'Anthony, welcome to the Coffee Club! We roast every batch within 48 hours of shipping. Glad you are enjoying the Ethiopian beans!', helpfulCount: 14, isVerified: true),
    CustomerReviewModel(id: 'REV-018', customerName: 'Kendra Lewis', customerAvatar: 'avatars/kendra_l.jpg', rating: 5, comment: 'We rented a booth through Urban Goodz for the Summer Block Party and it was incredibly well-organized. Great exposure for our small business!', serviceName: 'Event Vendor - Pop-up Booth Rental', orderId: 'ORD-2923', createdAt: DateTime(2026, 4, 27), vendorReply: 'Kendra, it was a pleasure having you at the Block Party! We love supporting local entrepreneurs. Looking forward to the next event!', helpfulCount: 45, images: ['reviews/kendra_booth_1.jpg', 'reviews/kendra_booth_2.jpg'], isVerified: true),
    CustomerReviewModel(id: 'REV-019', customerName: 'Christopher Moore', customerAvatar: 'avatars/christopher_m.jpg', rating: 4, comment: 'The Home Business Starter Package gave me everything I needed to get my side hustle running. Great resources and products included.', serviceName: 'Home Business Starter Package', orderId: 'ORD-2924', createdAt: DateTime(2026, 4, 28), vendorReply: 'Christopher, we are rooting for your business! The starter package is designed to set you up for success. Let us know how we can support further!', helpfulCount: 11, isVerified: true),
    CustomerReviewModel(id: 'REV-020', customerName: 'Malik Johnson', customerAvatar: 'avatars/malik_j.jpg', rating: 5, comment: 'Lawn mowing service was professional and on time. They even trimmed the hedges without me asking. Five stars all the way!', serviceName: 'Lawn Mowing Service', orderId: 'ORD-2917', createdAt: DateTime(2026, 4, 29), vendorReply: 'Malik, our landscaping team believes in going the extra mile. A well-maintained yard makes all the difference! Thanks for the kind words.', helpfulCount: 19, isVerified: true),
  ];
}

class MockRevenueTrackingRepository {
  Future<List<RevenueModel>> getRevenueData(String startDate, String endDate) async {
    return _allRevenueEntries;
  }

  Future<List<RevenueModel>> getRevenueBySource(String source) async {
    return _allRevenueEntries.where((r) => r.source == source).toList();
  }

  Future<Map<String, double>> getRevenueSummary() async {
    return {
      'total_revenue_60_days': 284500.00,
      'total_orders_revenue': 221450.00,
      'total_service_bookings': 42500.00,
      'total_catering': 18500.00,
      'total_delivery_fees': 12800.00,
      'total_tips': 6200.00,
      'total_promotions_used': 3500.00,
      'total_payouts_made': 45000.00,
      'net_revenue': 239500.00,
    };
  }

  Future<Map<String, double>> getTransactionTypeBreakdown() async {
    return {
      'sales': 248950.00,
      'refunds': -3200.00,
      'fees': -4250.00,
      'payouts': -45000.00,
    };
  }

  static final List<RevenueModel> _allRevenueEntries = [
    RevenueModel(id: 'REV-0401', date: DateTime(2026, 4, 30) , source: 'order', amount: 2450.00, transactionType: 'sale', orderId: 'ORD-2601', status: 'completed', notes: 'Grocery delivery - Midtown'),
    RevenueModel(id: 'REV-0402', date: DateTime(2026, 5, 1) , source: 'delivery_fee', amount: 180.00, transactionType: 'sale', orderId: 'ORD-2601', status: 'completed', notes: 'Delivery fees collected'),
    RevenueModel(id: 'REV-0403', date: DateTime(2026, 5, 2) , source: 'order', amount: 2780.00, transactionType: 'sale', orderId: 'ORD-2602', status: 'completed', notes: 'Grocery delivery - Bellaire'),
    RevenueModel(id: 'REV-0404', date: DateTime(2026, 5, 3) , source: 'order', amount: 3100.00, transactionType: 'sale', orderId: 'ORD-2603', status: 'completed', notes: 'Beauty supply order - Galleria'),
    RevenueModel(id: 'REV-0405', date: DateTime(2026, 5, 4) , source: 'service_booking', amount: 450.00, transactionType: 'sale', orderId: 'BK-045', status: 'completed', notes: 'Event decor setup - W Dallas'),
    RevenueModel(id: 'REV-0406', date: DateTime(2026, 5, 5) , source: 'tips', amount: 25.00, transactionType: 'sale', orderId: 'ORD-2604', status: 'completed', notes: 'Delivery tip - James C.'),
    RevenueModel(id: 'REV-0407', date: DateTime(2026, 5, 6) , source: 'order', amount: 2650.00, transactionType: 'sale', orderId: 'ORD-2605', status: 'completed', notes: 'Grocery delivery - Third Ward'),
    RevenueModel(id: 'REV-0408', date: DateTime(2026, 5, 7) , source: 'catering', amount: 850.00, transactionType: 'sale', orderId: 'ORD-2606', status: 'completed', notes: 'Office lunch catering - 20 ppl'),
    RevenueModel(id: 'REV-0409', date: DateTime(2026, 5, 8) , source: 'order', amount: 3420.00, transactionType: 'sale', orderId: 'ORD-2607', status: 'completed', notes: 'Weekly bundle orders - Midtown'),
    RevenueModel(id: 'REV-0410', date: DateTime(2026, 5, 9) , source: 'delivery_fee', amount: 210.00, transactionType: 'sale', orderId: 'ORD-2607', status: 'completed', notes: 'Delivery fees'),
    RevenueModel(id: 'REV-0411', date: DateTime(2026, 5, 10) , source: 'order', amount: 3780.00, transactionType: 'sale', orderId: 'ORD-2608', status: 'completed', notes: 'Weekend bulk orders'),
    RevenueModel(id: 'REV-0412', date: DateTime(2026, 5, 11) , source: 'tips', amount: 40.00, transactionType: 'sale', orderId: 'ORD-2608', status: 'completed', notes: 'Delivery tips'),
    RevenueModel(id: 'REV-0413', date: DateTime(2026, 5, 12) , source: 'order', amount: 3150.00, transactionType: 'sale', orderId: 'ORD-2609', status: 'completed', notes: 'Dairy & produce orders'),
    RevenueModel(id: 'REV-0414', date: DateTime(2026, 5, 13) , source: 'promotions', amount: -125.00, transactionType: 'sale', orderId: 'ORD-2609', status: 'completed', notes: 'HOUSTON20 coupon applied'),
    RevenueModel(id: 'REV-0415', date: DateTime(2026, 5, 14) , source: 'order', amount: 2980.00, transactionType: 'sale', orderId: 'ORD-2610', status: 'completed', notes: 'Mixed vendor orders'),
    RevenueModel(id: 'REV-0416', date: DateTime(2026, 5, 15) , source: 'order', amount: 2890.00, transactionType: 'sale', orderId: 'ORD-2611', status: 'completed', notes: 'Pantry restock orders'),
    RevenueModel(id: 'REV-0417', date: DateTime(2026, 5, 16) , source: 'service_booking', amount: 180.00, transactionType: 'sale', orderId: 'BK-046', status: 'completed', notes: 'Home deep clean - Holman St'),
    RevenueModel(id: 'REV-0418', date: DateTime(2026, 5, 17) , source: 'order', amount: 3250.00, transactionType: 'sale', orderId: 'ORD-2612', status: 'completed', notes: 'Meat & seafood orders'),
    RevenueModel(id: 'REV-0419', date: DateTime(2026, 5, 18) , source: 'order', amount: 3600.00, transactionType: 'sale', orderId: 'ORD-2613', status: 'completed', notes: 'Weekend produce rush'),
    RevenueModel(id: 'REV-0420', date: DateTime(2026, 5, 19) , source: 'delivery_fee', amount: 240.00, transactionType: 'sale', orderId: 'ORD-2613', status: 'completed', notes: 'Delivery fees'),
    RevenueModel(id: 'REV-0421', date: DateTime(2026, 5, 20) , source: 'order', amount: 4050.00, transactionType: 'sale', orderId: 'ORD-2614', status: 'completed', notes: 'Beverage bulk order'),
    RevenueModel(id: 'REV-0422', date: DateTime(2026, 5, 21) , source: 'order', amount: 3380.00, transactionType: 'sale', orderId: 'ORD-2615', status: 'completed', notes: 'General grocery'),
    RevenueModel(id: 'REV-0423', date: DateTime(2026, 5, 22) , source: 'tips', amount: 35.00, transactionType: 'sale', orderId: 'ORD-2615', status: 'completed', notes: 'Delivery tips'),
    RevenueModel(id: 'REV-0424', date: DateTime(2026, 5, 23) , source: 'order', amount: 3050.00, transactionType: 'sale', orderId: 'ORD-2616', status: 'completed', notes: 'Dairy & bakery'),
    RevenueModel(id: 'REV-0425', date: DateTime(2026, 5, 24) , source: 'catering', amount: 1200.00, transactionType: 'sale', orderId: 'ORD-2617', status: 'completed', notes: 'Corporate catering - 30 ppl'),
    RevenueModel(id: 'REV-0426', date: DateTime(2026, 5, 25) , source: 'order', amount: 3120.00, transactionType: 'sale', orderId: 'ORD-2618', status: 'completed', notes: 'Produce & pantry'),
    RevenueModel(id: 'REV-0427', date: DateTime(2026, 5, 26) , source: 'order', amount: 2950.00, transactionType: 'sale', orderId: 'ORD-2619', status: 'completed', notes: 'Organic weekly orders'),
    RevenueModel(id: 'REV-0428', date: DateTime(2026, 5, 27) , source: 'delivery_fee', amount: 195.00, transactionType: 'sale', orderId: 'ORD-2619', status: 'completed', notes: 'Delivery fees'),
    RevenueModel(id: 'REV-0429', date: DateTime(2026, 5, 28) , source: 'order', amount: 3480.00, transactionType: 'sale', orderId: 'ORD-2620', status: 'completed', notes: 'Saturday market rush'),
    RevenueModel(id: 'REV-0430', date: DateTime(2026, 5, 29) , source: 'tips', amount: 55.00, transactionType: 'sale', orderId: 'ORD-2620', status: 'completed', notes: 'Weekend delivery tips'),
    RevenueModel(id: 'REV-0431', date: DateTime(2026, 5, 30) , source: 'order', amount: 3690.00, transactionType: 'sale', orderId: 'ORD-2621', status: 'completed', notes: 'Beauty & body orders'),
    RevenueModel(id: 'REV-0432', date: DateTime(2026, 5, 31) , source: 'service_booking', amount: 350.00, transactionType: 'sale', orderId: 'BK-047', status: 'completed', notes: 'Private chef dinner - River Oaks'),
    RevenueModel(id: 'REV-0433', date: DateTime(2026, 6, 1) , source: 'order', amount: 3960.00, transactionType: 'sale', orderId: 'ORD-2622', status: 'completed', notes: 'Meat & seafood weekend'),
    RevenueModel(id: 'REV-0434', date: DateTime(2026, 6, 2) , source: 'order', amount: 4230.00, transactionType: 'sale', orderId: 'ORD-2623', status: 'completed', notes: 'Produce box subscriptions'),
    RevenueModel(id: 'REV-0435', date: DateTime(2026, 6, 3) , source: 'order', amount: 3560.00, transactionType: 'sale', orderId: 'ORD-2624', status: 'completed', notes: 'Month-end pantry restocks'),
    RevenueModel(id: 'REV-0436', date: DateTime(2026, 6, 4) , source: 'delivery_fee', amount: 230.00, transactionType: 'sale', orderId: 'ORD-2624', status: 'completed', notes: 'Delivery fees'),
    RevenueModel(id: 'REV-0437', date: DateTime(2026, 6, 5) , source: 'order', amount: 3350.00, transactionType: 'sale', orderId: 'ORD-2625', status: 'completed', notes: 'May Day orders'),
    RevenueModel(id: 'REV-0438', date: DateTime(2026, 6, 6) , source: 'order', amount: 3100.00, transactionType: 'sale', orderId: 'ORD-2626', status: 'completed', notes: 'Beverage and dairy'),
    RevenueModel(id: 'REV-0439', date: DateTime(2026, 6, 7) , source: 'catering', amount: 950.00, transactionType: 'sale', orderId: 'ORD-2627', status: 'completed', notes: 'Brunch catering - 25 ppl'),
    RevenueModel(id: 'REV-0440', date: DateTime(2026, 6, 8) , source: 'order', amount: 3280.00, transactionType: 'sale', orderId: 'ORD-2628', status: 'completed', notes: 'Meat & produce'),
    RevenueModel(id: 'REV-0441', date: DateTime(2026, 4, 10) , source: 'order', amount: 3600.00, transactionType: 'sale', orderId: 'ORD-2629', status: 'completed', notes: 'Weekly bundles'),
    RevenueModel(id: 'REV-0442', date: DateTime(2026, 4, 11) , source: 'tips', amount: 30.00, transactionType: 'sale', orderId: 'ORD-2629', status: 'completed', notes: 'Cinco de Mayo delivery tips'),
    RevenueModel(id: 'REV-0443', date: DateTime(2026, 4, 12) , source: 'order', amount: 3870.00, transactionType: 'sale', orderId: 'ORD-2630', status: 'completed', notes: 'Cinco de Mayo specials'),
    RevenueModel(id: 'REV-0444', date: DateTime(2026, 4, 13) , source: 'order', amount: 4140.00, transactionType: 'sale', orderId: 'ORD-2631', status: 'completed', notes: 'Produce & beverage bulk'),
    RevenueModel(id: 'REV-0445', date: DateTime(2026, 4, 14) , source: 'order', amount: 3450.00, transactionType: 'sale', orderId: 'ORD-2632', status: 'completed', notes: 'Dairy & bakery'),
    RevenueModel(id: 'REV-0446', date: DateTime(2026, 4, 15) , source: 'delivery_fee', amount: 210.00, transactionType: 'sale', orderId: 'ORD-2632', status: 'completed', notes: 'Delivery fees'),
    RevenueModel(id: 'REV-0447', date: DateTime(2026, 4, 16) , source: 'order', amount: 3150.00, transactionType: 'sale', orderId: 'ORD-2633', status: 'completed', notes: 'Pantry restock'),
    RevenueModel(id: 'REV-0448', date: DateTime(2026, 4, 17) , source: 'order', amount: 3320.00, transactionType: 'sale', orderId: 'ORD-2634', status: 'completed', notes: 'Beauty supply orders'),
    RevenueModel(id: 'REV-0449', date: DateTime(2026, 4, 18) , source: 'order', amount: 3080.00, transactionType: 'sale', orderId: 'ORD-2635', status: 'completed', notes: 'Mother Day gift bundles'),
    RevenueModel(id: 'REV-0450', date: DateTime(2026, 4, 19) , source: 'tips', amount: 65.00, transactionType: 'sale', orderId: 'ORD-2635', status: 'completed', notes: 'Mother Day tips'),
    RevenueModel(id: 'REV-0451', date: DateTime(2026, 4, 20) , source: 'order', amount: 3690.00, transactionType: 'sale', orderId: 'ORD-2636', status: 'completed', notes: 'Meat & seafood'),
    RevenueModel(id: 'REV-0452', date: DateTime(2026, 4, 21) , source: 'service_booking', amount: 550.00, transactionType: 'sale', orderId: 'BK-048', status: 'completed', notes: 'Event decor - Graduation party'),
    RevenueModel(id: 'REV-0453', date: DateTime(2026, 4, 22) , source: 'order', amount: 3960.00, transactionType: 'sale', orderId: 'ORD-2637', status: 'completed', notes: 'Organic produce week'),
    RevenueModel(id: 'REV-0454', date: DateTime(2026, 4, 23) , source: 'order', amount: 4320.00, transactionType: 'sale', orderId: 'ORD-2638', status: 'completed', notes: 'Beverage bulk order'),
    RevenueModel(id: 'REV-0455', date: DateTime(2026, 4, 24) , source: 'delivery_fee', amount: 250.00, transactionType: 'sale', orderId: 'ORD-2638', status: 'completed', notes: 'Delivery fees'),
    RevenueModel(id: 'REV-0456', date: DateTime(2026, 4, 25) , source: 'order', amount: 3780.00, transactionType: 'sale', orderId: 'ORD-2639', status: 'completed', notes: 'Mixed grocery'),
    RevenueModel(id: 'REV-0457', date: DateTime(2026, 4, 26) , source: 'order', amount: 3450.00, transactionType: 'sale', orderId: 'ORD-2640', status: 'completed', notes: 'Weekend produce'),
    RevenueModel(id: 'REV-0458', date: DateTime(2026, 4, 27) , source: 'tips', amount: 45.00, transactionType: 'sale', orderId: 'ORD-2640', status: 'completed', notes: 'Weekend tips'),
    RevenueModel(id: 'REV-0459', date: DateTime(2026, 4, 28) , source: 'order', amount: 3580.00, transactionType: 'sale', orderId: 'ORD-2641', status: 'completed', notes: 'Brunch bundles'),
    RevenueModel(id: 'REV-0460', date: DateTime(2026, 4, 29) , source: 'order', amount: 3250.00, transactionType: 'sale', orderId: 'ORD-2642', status: 'completed', notes: 'Pharmacy & wellness'),
    RevenueModel(id: 'REV-0461', date: DateTime(2026, 4, 30) , source: 'order', amount: 3870.00, transactionType: 'sale', orderId: 'ORD-2643', status: 'completed', notes: 'Kits & bundles'),
    RevenueModel(id: 'REV-0462', date: DateTime(2026, 5, 1) , source: 'catering', amount: 1500.00, transactionType: 'sale', orderId: 'ORD-2644', status: 'completed', notes: 'Corporate lunch - 40 ppl'),
    RevenueModel(id: 'REV-0463', date: DateTime(2026, 5, 2) , source: 'order', amount: 4140.00, transactionType: 'sale', orderId: 'ORD-2645', status: 'completed', notes: 'Produce subscriptions'),
    RevenueModel(id: 'REV-0464', date: DateTime(2026, 5, 3) , source: 'order', amount: 3650.00, transactionType: 'sale', orderId: 'ORD-2646', status: 'completed', notes: 'Dairy & bakery'),
    RevenueModel(id: 'REV-0465', date: DateTime(2026, 5, 4) , source: 'delivery_fee', amount: 220.00, transactionType: 'sale', orderId: 'ORD-2646', status: 'completed', notes: 'Delivery fees'),
    RevenueModel(id: 'REV-0466', date: DateTime(2026, 5, 5) , source: 'order', amount: 3750.00, transactionType: 'sale', orderId: 'ORD-2647', status: 'completed', notes: 'Beauty & body bulk'),
    RevenueModel(id: 'REV-0467', date: DateTime(2026, 5, 6) , source: 'order', amount: 3450.00, transactionType: 'sale', orderId: 'ORD-2648', status: 'completed', notes: 'Pantry restock'),
    RevenueModel(id: 'REV-0468', date: DateTime(2026, 5, 7) , source: 'order', amount: 4050.00, transactionType: 'sale', orderId: 'ORD-2649', status: 'completed', notes: 'Saturday peak orders'),
    RevenueModel(id: 'REV-0469', date: DateTime(2026, 5, 8) , source: 'order', amount: 4320.00, transactionType: 'sale', orderId: 'ORD-2650', status: 'completed', notes: 'Sunday grocery rush'),
    RevenueModel(id: 'REV-0470', date: DateTime(2026, 5, 9) , source: 'tips', amount: 50.00, transactionType: 'sale', orderId: 'ORD-2650', status: 'completed', notes: 'Weekend tips'),
    RevenueModel(id: 'REV-0471', date: DateTime(2026, 5, 10) , source: 'order', amount: 4680.00, transactionType: 'sale', orderId: 'ORD-2651', status: 'completed', notes: 'Memorial Day BBQ bundles'),
    RevenueModel(id: 'REV-0472', date: DateTime(2026, 5, 11) , source: 'order', amount: 4050.00, transactionType: 'sale', orderId: 'ORD-2652', status: 'completed', notes: 'Meat & seafood holiday'),
    RevenueModel(id: 'REV-0473', date: DateTime(2026, 5, 12) , source: 'order', amount: 3720.00, transactionType: 'sale', orderId: 'ORD-2653', status: 'completed', notes: 'Post-holiday restock'),
    RevenueModel(id: 'REV-0474', date: DateTime(2026, 5, 13) , source: 'catering', amount: 1800.00, transactionType: 'sale', orderId: 'ORD-2654', status: 'completed', notes: 'End of month corporate'),
    RevenueModel(id: 'REV-0475', date: DateTime(2026, 5, 14) , source: 'order', amount: 3920.00, transactionType: 'sale', orderId: 'ORD-2655', status: 'completed', notes: 'May closing week'),
    RevenueModel(id: 'REV-0476', date: DateTime(2026, 5, 15) , source: 'delivery_fee', amount: 280.00, transactionType: 'sale', orderId: 'ORD-2655', status: 'completed', notes: 'Delivery fees'),
    RevenueModel(id: 'REV-0477', date: DateTime(2026, 5, 16) , source: 'order', amount: 4320.00, transactionType: 'sale', orderId: 'ORD-2656', status: 'completed', notes: 'June opening day'),
    RevenueModel(id: 'REV-0478', date: DateTime(2026, 5, 17) , source: 'order', amount: 4550.00, transactionType: 'sale', orderId: 'ORD-2657', status: 'completed', notes: 'Grand opening promo orders'),
    RevenueModel(id: 'REV-0479', date: DateTime(2026, 5, 18) , source: 'promotions', amount: -250.00, transactionType: 'sale', orderId: 'ORD-2657', status: 'completed', notes: 'HOUSTON20 promo applied'),
    RevenueModel(id: 'REV-0480', date: DateTime(2026, 5, 19) , source: 'order', amount: 5020.00, transactionType: 'sale', orderId: 'ORD-2658', status: 'completed', notes: 'Beauty & pharmacy launch'),
    RevenueModel(id: 'REV-0481', date: DateTime(2026, 5, 20) , source: 'order', amount: 4680.00, transactionType: 'sale', orderId: 'ORD-2659', status: 'completed', notes: 'Beverage subscription week'),
    RevenueModel(id: 'REV-0482', date: DateTime(2026, 5, 21) , source: 'tips', amount: 60.00, transactionType: 'sale', orderId: 'ORD-2659', status: 'completed', notes: 'Delivery tips'),
    RevenueModel(id: 'REV-0483', date: DateTime(2026, 5, 22) , source: 'service_booking', amount: 400.00, transactionType: 'sale', orderId: 'BK-049', status: 'completed', notes: 'Deep clean - Montrose'),
    RevenueModel(id: 'REV-0484', date: DateTime(2026, 5, 23) , source: 'order', amount: 5220.00, transactionType: 'sale', orderId: 'ORD-2660', status: 'completed', notes: 'Saturday block party prep'),
    RevenueModel(id: 'REV-0485', date: DateTime(2026, 5, 24) , source: 'delivery_fee', amount: 320.00, transactionType: 'sale', orderId: 'ORD-2660', status: 'completed', notes: 'Weekend delivery fees'),
    RevenueModel(id: 'REV-0486', date: DateTime(2026, 5, 25) , source: 'order', amount: 5580.00, transactionType: 'sale', orderId: 'ORD-2661', status: 'completed', notes: 'Sunday peak - all categories'),
    RevenueModel(id: 'REV-0487', date: DateTime(2026, 5, 26) , source: 'order', amount: 4850.75, transactionType: 'sale', orderId: 'ORD-2662', status: 'completed', notes: 'Current day - partial data'),
    RevenueModel(id: 'REV-0488', date: DateTime(2026, 5, 27) , source: 'tips', amount: 75.00, transactionType: 'sale', orderId: 'ORD-2662', status: 'completed', notes: 'Tips so far today'),
    RevenueModel(id: 'REV-0489', date: DateTime(2026, 5, 28) , source: 'order', amount: -180.00, transactionType: 'refund', orderId: 'ORD-2608', status: 'completed', notes: 'Customer refund - damaged produce'),
    RevenueModel(id: 'REV-0490', date: DateTime(2026, 5, 29) , source: 'order', amount: -95.00, transactionType: 'refund', orderId: 'ORD-2626', status: 'completed', notes: 'Customer refund - wrong item'),
  ];
}

class MockVendorData {
  static const VendorStoreModel store = VendorStoreModel(
    id: 'store_001', name: 'Urban Goodz Grocery - Midtown', type: 'grocery',
    description: 'Your premium urban grocery destination in the heart of Midtown Houston.',
    address: '2800 Fannin St, Houston, TX 77002', phone: '(713) 555-0142', email: 'midtown@urbangoodz.com',
    logoUrl: 'assets/logos/ug_midtown.png', bannerUrl: 'assets/banners/midtown_banner.jpg',
    isOpen: true, openTime: '06:00 AM', closeTime: '10:00 PM',
    rating: 4.8, reviewCount: 342, totalOrders: 5678, totalRevenue: 284500.00,
    joinDate: '2023-03-15',
    categories: ['Produce', 'Dairy', 'Meat & Seafood', 'Bakery', 'Pantry', 'Beverages', 'Organic', 'International'],
    features: {'delivery': true, 'pickup': true, 'catering': true, 'curbside': true, 'loyalty_program': true},
  );

  static List<VendorOrderModel> get orders => MockOrdersRepository._allOrders;
  static List<InventoryItemModel> get inventory => MockInventoryRepository._allItems;
  static List<ServiceBookingModel> get serviceBookings => MockServiceBookingsRepository._allBookings;
  static List<PromotionModel> get promotions => MockPromotionsRepository._allPromotions;
  static List<ReelModel> get reels => MockReelsRepository._allReels;
  static List<AnalyticsModel> get analytics => MockAnalyticsRepository._last90Days;
  static List<CustomerReviewModel> get customerReviews => MockCustomerReviewsRepository._allReviews;
  static List<RevenueModel> get revenueEntries => MockRevenueTrackingRepository._allRevenueEntries;

  static const Map<String, double> categoryBreakdown = {
    'Produce': 45200.00, 'Dairy': 28400.00, 'Meat & Seafood': 38500.00, 'Bakery': 19200.00,
    'Pantry': 34100.00, 'Beverages': 22300.00, 'Organic': 15800.00, 'International': 12600.00,
  };

  static final List<MapEntry<String, int>> popularTimeSlots = [
    const MapEntry('08:00 - 10:00', 156),
    const MapEntry('10:00 - 12:00', 234),
    const MapEntry('12:00 - 14:00', 312),
    const MapEntry('14:00 - 16:00', 189),
    const MapEntry('16:00 - 18:00', 278),
    const MapEntry('18:00 - 20:00', 245),
    const MapEntry('20:00 - 22:00', 123),
  ];

  static const List<double> revenueChartData = [4250.00, 3820.50, 5100.75, 4780.25, 6720.00, 8210.50, 6450.00];

  static final List<Map<String, String>> drivers = [
    {'id': 'DRV-001', 'name': 'Marcus Williams'},
    {'id': 'DRV-002', 'name': 'Jasmine Carter'},
    {'id': 'DRV-003', 'name': 'Carlos Mendez'},
    {'id': 'DRV-004', 'name': 'Aisha Patel'},
    {'id': 'DRV-005', 'name': 'Terrence Jackson'},
  ];
}
