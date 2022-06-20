class Categories {
  int categoryID;
  String name;
  Categories({required this.categoryID, required this.name});
  factory Categories.fromJson(Map<String, dynamic> item) {
    return Categories(
      categoryID: int.parse(item['categoryID']),
      name: item['name'],
    );
  }
}
