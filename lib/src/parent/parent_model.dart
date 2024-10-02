import 'package:family/src/children/child.dart';

class Parent {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String name = '';
  DateTime? birthdate;
  List<Child> children = [];

  Parent() {
    // Empty constructor for initialization
  }

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    name = json['name'];
    // TODO: Verify if this is the correct way to parse the date only from backend
    birthdate = json['birthdate'] ? DateTime.parse(json['birthdate']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'name': name,
      'birthdate': birthdate.toString(),
    };
  }
}