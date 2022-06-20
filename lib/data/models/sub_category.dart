class SubCategory {
  int? subID;
  int? categoryID;
  String? name;
  String? unit;
  int? maxLimit;

  SubCategory(
      {this.subID, this.categoryID, this.name, this.unit, this.maxLimit});

  factory SubCategory.fromJson(Map<String, dynamic> item) {
    return SubCategory(
        subID: int.parse(item['subCategoryID']),
        categoryID: int.parse(item['categoryID']),
        name: item['name'] == null ? '' : item['name'],
        unit: item['unit'] == null ? '' : item['name'],
        maxLimit: int.parse(item['maxLimit'] == null ? '0' : item['maxLimit']));
  }
}
