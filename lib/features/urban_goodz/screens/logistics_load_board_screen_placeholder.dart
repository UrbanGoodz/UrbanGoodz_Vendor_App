import 'package:flutter/material.dart';
class LogisticsLoadBoardScreen extends StatelessWidget {
 const LogisticsLoadBoardScreen({super.key});
 @override Widget build(BuildContext context){return Scaffold(appBar:AppBar(title:const Text('Load Board')),body:ListView(children:const [ListTile(title:Text('Same-Day Delivery')),ListTile(title:Text('Last-Mile Delivery')),ListTile(title:Text('Middle-Mile Route')),ListTile(title:Text('Cargo Van Load')),ListTile(title:Text('Pickup Truck Load')),ListTile(title:Text('Box Truck Load')),ListTile(title:Text('Medical Adjacent Route')),ListTile(title:Text('Retail Replenishment')),ListTile(title:Text('Enterprise Delivery'))]));}
}
