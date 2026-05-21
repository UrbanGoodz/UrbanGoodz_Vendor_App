import 'package:get/get.dart';
import 'package:sixam_mart/features/rental_module/rental_favorite/domain/services/taxi_favorite_service_interface.dart';

class TaxiFavoriteController extends GetxController implements GetxService {
  final TaxiFavoriteServiceInterface taxiFavoriteServiceInterface;

  TaxiFavoriteController({required this.taxiFavoriteServiceInterface});

  Future<void> getFavoriteTaxiList() async {}
}