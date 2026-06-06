class CommunityMarketplaceApiService {
  Future<List<Map<String,dynamic>>> getFeaturedGroups() async {
    return [
      {'groupName':'Houston Beauty','countryCode':'US','state':'TX','city':'Houston','zoneName':'Houston','isLaunchMarket':true},
      {'groupName':'Nationwide Small Business','countryCode':'US','zoneId':null,'isNationwide':true},
      {'groupName':'Worldwide Creator Network','countryCode':null,'zoneId':null,'isWorldwide':true}
    ];
  }
}
