class CarRentalState {
  static final List<Map<String, dynamic>> vehicles = [
    {
      'id': 'v1',
      'name': 'Tesla Model Y',
      'type': 'Electric SUV',
      'seats': 5,
      'price': 75.00,
      'location': 'Galleria Area',
      'isFavorited': false,
      'availability': 'Available',
    },
    {
      'id': 'v2',
      'name': 'Ford Bronco',
      'type': 'Off-Road SUV',
      'seats': 5,
      'price': 85.00,
      'location': 'Downtown',
      'isFavorited': false,
      'availability': 'Available',
    },
    {
      'id': 'v3',
      'name': 'Chevrolet Corvette',
      'type': 'Sports Coupe',
      'seats': 2,
      'price': 180.00,
      'location': 'Medical Center',
      'isFavorited': false,
      'availability': 'Available',
    },
    {
      'id': 'v4',
      'name': 'Toyota RAV4',
      'type': 'SUV',
      'seats': 5,
      'price': 55.00,
      'location': 'Hobby Airport',
      'isFavorited': false,
      'availability': 'Available',
    },
    {
      'id': 'v5',
      'name': 'Mercedes-Benz C-Class',
      'type': 'Luxury Sedan',
      'seats': 5,
      'price': 110.00,
      'location': 'Memorial City',
      'isFavorited': false,
      'availability': 'Available',
    },
  ];

  static final List<Map<String, dynamic>> requests = [];

  static void toggleFavorite(String id) {
    for (var v in vehicles) {
      if (v['id'] == id) {
        v['isFavorited'] = !(v['isFavorited'] as bool);
        break;
      }
    }
  }

  static void addRequest(Map<String, dynamic> request) {
    requests.add(request);
  }

  static List<Map<String, dynamic>> getFavorites() {
    return vehicles.where((v) => v['isFavorited'] == true).toList();
  }
}
