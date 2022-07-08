import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    this.status,
    this.category,
  });

  String? status;
  List<CategoryElement>? category;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        status: json["status"],
        category: List<CategoryElement>.from(
            json["category"].map((x) => CategoryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "category": List<dynamic>.from(category!.map((x) => x.toJson())),
      };
}

class CategoryElement {
  CategoryElement({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CategoryElement.fromJson(Map<String, dynamic> json) =>
      CategoryElement(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
