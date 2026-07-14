import 'dart:convert';

import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/api/local_client.dart';
import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/brands/domain/models/brands_model.dart';
import 'package:sixam_mart/features/brands/domain/repositories/brands_repository_interface.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';

class BrandsRepository implements BrandsRepositoryInterface{
  final ApiClient apiClient;
  BrandsRepository({required this.apiClient});

  @override
  Future<List<BrandModel>?> getBrandList({required DataSourceEnum source}) async {
    List<BrandModel>? brandList;
    String cacheId = '${AppConstants.brandListUri}-${Get.find<SplashController>().module!.id!}';

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.brandListUri);
        if (response.statusCode == 200) {
          brandList = [];
          response.body.forEach((brand) => brandList!.add(BrandModel.fromJson(brand)));
          LocalClient.organize(source, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(source, cacheId, null, null);
        if(cacheResponseData != null) {
          brandList = [];
          jsonDecode(cacheResponseData).forEach((brand) => brandList!.add(BrandModel.fromJson(brand)));
        }
    }

    return brandList;
  }

  @override
  Future<ItemModel?> getBrandItemList({required int brandId, int? offset}) async {
    ItemModel? brandItemModel;
    Response response = await apiClient.getData('${AppConstants.brandItemUri}/$brandId?offset=$offset&limit=12');
    if (response.statusCode == 200) {
       brandItemModel = ItemModel.fromJson(response.body);
    }
    return brandItemModel;
  }

  @override
  Future add(value) async {
    return null;
  }

  @override
  Future delete(int? id) async {
    return null;
  }

  @override
  Future get(String? id) async {
    return null;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) async {
    return null;
  }

  @override
  Future getList({int? offset}) async {
    return getBrandList(source: DataSourceEnum.client);
  }

}