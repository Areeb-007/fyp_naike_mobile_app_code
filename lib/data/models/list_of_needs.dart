import 'need.dart';

class NeedsList {
  late List<Need> list;
  NeedsList({list}) {
    list = [
      Need(
          id: 1,
          userID: 1,
          subID: 1,
          longitude: 123.123,
          latitude: 321.123,
          description: 'description for need one',
          deadLine: DateTime.now(),
          status: 'Active',
          initialQuantity: 10,
          currentQuantity: 0,
          needCount: 0,
          resolvedCount: 0,
          deliveryType: 'Pick Up and Drop Off'),
      Need(
          id: 2,
          userID: 2,
          subID: 1,
          longitude: 123.123,
          latitude: 321.123,
          description: 'description for need two',
          deadLine: DateTime.now(),
          status: 'Active',
          initialQuantity: 10,
          currentQuantity: 0,
          needCount: 0,
          resolvedCount: 0,
          deliveryType: 'Pick Up and Drop Off'),
      Need(
          id: 1,
          userID: 1,
          subID: 1,
          longitude: 123.123,
          latitude: 321.123,
          description: 'description for need three',
          deadLine: DateTime.now(),
          status: 'Active',
          initialQuantity: 10,
          currentQuantity: 0,
          needCount: 0,
          resolvedCount: 0,
          deliveryType: 'Pick Up and Drop Off')
    ];
  }
  factory NeedsList.fromJson(Map<String, dynamic> item) {
    var listOfNeeds = item['listOfNeeds'] as List;
    List<Need> tempList = listOfNeeds.map((n) => Need.fromJson(n)).toList();
    return NeedsList(list: tempList);
  }

  List<Need> get getListofNeeds => this.list;
}
