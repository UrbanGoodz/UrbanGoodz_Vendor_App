import 'package:get/get.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/favorite/domain/repositories/favorite_repository_interface.dart';
import 'package:sixam_mart/features/favorite/domain/services/favorite_service_interface.dart';
import 'package:sixam_mart/helper/address_helper.dart';

class FavoriteService implements FavoriteServiceInterface {
  final FavoriteRepositoryInterface favoriteRepositoryInterface;
  FavoriteService({required this.favoriteRepositoryInterface});

  @override
  Future<Response> getFavoriteList() async {
    return await favoriteRepositoryInterface.getList();
  }

  @override
  Future<ResponseModel> addFavoriteList(int? id, bool isStore) async {
    return await favoriteRepositoryInterface.add(null, isStore: isStore, id: id);
  }

  @override
  Future<ResponseModel> removeFavoriteList(int? id, bool isStore) async {
    return await favoriteRepositoryInterface.delete(id, isStore: isStore);
  }

  @override
  List<Item?> wishItemList(Item item) {
    List<Item?> wishItemList = [];
    for (var zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (var module in zone.modules!) {
        if(module.id == item.moduleId){
          if(module.pivot!.zoneId == item.zoneId){
            wishItemList.add(item);
          }
        }
      }
    }
    return wishItemList;
  }

  @override
  List<int?> wishItemIdList (Item item) {
    List<int?> wishItemIdList = [];
    for (var zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (var module in zone.modules!) {
        if(module.id == item.moduleId){
          if(module.pivot!.zoneId == item.zoneId){
            wishItemIdList.add(item.id);
          }
        }
      }
    }
    return wishItemIdList;
  }

  @override
  List<Store?> wishStoreList(dynamic store) {
    List<Store?> wishStoreList = [];
    for (var zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (var module in zone.modules!) {
        if(module.id == Store.fromJson(store).moduleId){
          if(module.pivot!.zoneId == Store.fromJson(store).zoneId){
            wishStoreList.add(Store.fromJson(store));
          }
        }
      }
    }
    return wishStoreList;
  }

  @override
  List<int?> wishStoreIdList(dynamic store) {
    List<int?> wishStoreIdList = [];
    for (var zone in AddressHelper.getUserAddressFromSharedPref()!.zoneData!) {
      for (var module in zone.modules!) {
        if(module.id == Store.fromJson(store).moduleId){
          if(module.pivot!.zoneId == Store.fromJson(store).zoneId){
            wishStoreIdList.add(Store.fromJson(store).id);
          }
        }
      }
    }
    return wishStoreIdList;
  }

}