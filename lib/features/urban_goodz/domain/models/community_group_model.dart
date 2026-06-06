class CommunityGroupModel {
  final String id;
  final int? zoneId;
  final String zoneName;
  final String city;
  final String state;
  final String serviceArea;
  final String category;
  final String groupName;
  final int memberCount;
  final int postCount;
  final bool isNationwide;
  final bool isFeatured;

  const CommunityGroupModel({
    required this.id,
    required this.zoneId,
    required this.zoneName,
    required this.city,
    required this.state,
    required this.serviceArea,
    required this.category,
    required this.groupName,
    required this.memberCount,
    required this.postCount,
    required this.isNationwide,
    required this.isFeatured,
  });

  factory CommunityGroupModel.fromJson(Map<String, dynamic> json) {
    final String zoneName = json['zone_name']?.toString() ?? json['zoneName']?.toString() ?? 'Nationwide';
    final String category = json['category']?.toString() ?? 'Community';

    return CommunityGroupModel(
      id: json['id']?.toString() ?? '',
      zoneId: int.tryParse(json['zone_id']?.toString() ?? json['zoneId']?.toString() ?? ''),
      zoneName: zoneName,
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      serviceArea: json['service_area']?.toString() ?? json['serviceArea']?.toString() ?? '',
      category: category,
      groupName: json['group_name']?.toString() ?? json['groupName']?.toString() ?? '$zoneName $category',
      memberCount: int.tryParse(json['member_count']?.toString() ?? json['memberCount']?.toString() ?? '') ?? 0,
      postCount: int.tryParse(json['post_count']?.toString() ?? json['postCount']?.toString() ?? '') ?? 0,
      isNationwide: json['is_nationwide'] == true || json['isNationwide'] == true,
      isFeatured: json['is_featured'] == true || json['isFeatured'] == true,
    );
  }
}
