import 'user.dart';

class Need {
  int? id;
  int? userID;
  int? subID;
  int? donationID;
  double? longitude;
  double? latitude;
  String? title;
  String? description;
  DateTime? deadLine;
  String? status;
  double? initialQuantity;
  double? currentQuantity;
  int? needCount;
  int? resolvedCount;
  String? deliveryType;
  User? user;
  DateTime? createdOn;
  Need(
      {this.id,
      this.userID,
      this.subID,
      this.donationID,
      this.longitude,
      this.latitude,
      this.title,
      this.description,
      this.deadLine,
      this.status,
      this.initialQuantity,
      this.currentQuantity,
      this.needCount,
      this.resolvedCount,
      this.deliveryType,
      this.user,
      this.createdOn});
  factory Need.fromJson(Map<String, dynamic> item) {
    return Need(
      id: int.parse(item['needID']),
      title: item['title'],
      userID: int.parse(item['userID']),
      subID: int.parse(item['subCategoryID']),
      donationID:
          item['donationID'] == null ? null : int.parse(item['donationID']),
      longitude: double.parse(item['longitude']),
      latitude: double.parse(item['latitude']),
      description: item['description'],
      deadLine: DateTime.tryParse(item['deadline']),
      status: item['status'],
      initialQuantity: double.tryParse(item['initialQuantity']),
      currentQuantity: double.tryParse(item['currentQuantity']),
      needCount: int.parse(item['needCount']),
      resolvedCount: int.parse(item['resolveCount']),
      deliveryType: item['deliveryType'],
      user: item['user'] != null ? User.fromJson(item['user']) : User(),
      createdOn: DateTime.tryParse(item['createdOn']),
    );
  }
}
