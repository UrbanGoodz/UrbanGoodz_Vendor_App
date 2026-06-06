import '../models/shoppable_reel_model.dart';

class CreatorCommerceApiService {
  Future<List<ShoppableReelModel>> getFeaturedReels() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      ShoppableReelModel(id:'1', title:'Summer Hair Bundle', creatorName:'Houston Beauty Creator', productName:'Hair Bundle', priceLabel:'\$89', likes:2400, views:12000, featured:true),
      ShoppableReelModel(id:'2', title:'Barber Essentials', creatorName:'Fade Specialist', productName:'Barber Kit', priceLabel:'\$59', likes:1800, views:9000),
      ShoppableReelModel(id:'3', title:'Urban Fashion Drop', creatorName:'Style Creator', productName:'Streetwear Collection', priceLabel:'\$120', likes:3400, views:18000),
    ];
  }
}
