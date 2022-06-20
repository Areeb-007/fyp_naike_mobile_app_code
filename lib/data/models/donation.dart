
import 'user.dart';

class Donation {
  int? id;
  int? userID;
  int? subID;
  double? longitude;
  double? latitude;
  String? title;
  String? description;
  String? status;
  double? initialQuantity;
  double? currentQuantity;
  String? deliveryType;
  User? user;
  DateTime? createdOn;
  Donation(
      {this.id,
      this.userID,
      this.subID,
      this.longitude,
      this.latitude,
      this.title,
      this.description,
      this.status,
      this.initialQuantity,
      this.currentQuantity,
      this.deliveryType,
      this.user,
      this.createdOn});
  factory Donation.fromJson(Map<String, dynamic> item) {
    return Donation(
      id: int.parse(item['donationID'] == null ? '0' : item['donationID']),
      userID: int.parse(item['userID'] == null ? '0' : item['userID']),
      subID: int.parse(
          item['subCategoryID'] == null ? '0' : item['subCategoryID']),
      longitude: double.parse(item['longitude']),
      latitude: double.parse(item['latitude']),
      description: item['description'],
      status: item['status'],
      initialQuantity: double.parse(item['initialQuantity']),
      currentQuantity: double.parse(item['currentQuantity']),
      deliveryType: item['deliveryType'],
      title: item['title'],
      user: item['user'] != null ? User.fromJson(item['user']) : User(),
      createdOn: DateTime.parse(item['createdOn']),
    );
  }
}
