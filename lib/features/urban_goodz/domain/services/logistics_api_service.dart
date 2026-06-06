import '../models/logistics_opportunity_model.dart';
import 'package:flutter/material.dart';

class LogisticsApiService {
 Future<List<LogisticsOpportunityModel>> getLoads() async {
  await Future.delayed(const Duration(milliseconds:300));
  return const [
   LogisticsOpportunityModel(id:'1',title:'Same-Day Retail Run',category:'Same-Day Delivery',pickupLabel:'Warehouse',dropoffLabel:'Store',vehicleType:'Cargo Van',payLabel:'\$85',distanceLabel:'22 mi',scheduleLabel:'Today',icon:Icons.airport_shuttle_outlined),
   LogisticsOpportunityModel(id:'2',title:'Enterprise Route',category:'Enterprise Delivery',pickupLabel:'Distribution Hub',dropoffLabel:'Office Campus',vehicleType:'Box Truck',payLabel:'\$240',distanceLabel:'74 mi',scheduleLabel:'Scheduled',icon:Icons.inventory_2_outlined),
  ];
 }
}
