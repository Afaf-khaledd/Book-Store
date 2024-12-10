class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromDocument(Map<String, dynamic> doc, String id) {
    return CategoryModel(
      id: id,
      name: doc['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
