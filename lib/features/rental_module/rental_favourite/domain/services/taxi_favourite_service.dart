
import 'package:sixam_mart/features/rental_module/rental_favorite/domain/repositories/taxi_favorite_repository_interface.dart';
import 'package:sixam_mart/features/rental_module/rental_favorite/domain/services/taxi_favorite_service_interface.dart';

class TaxiFavoriteService implements TaxiFavoriteServiceInterface {
  final TaxiFavoriteRepositoryInterface taxiFavoriteRepositoryInterface;
  TaxiFavoriteService({required this.taxiFavoriteRepositoryInterface});

}