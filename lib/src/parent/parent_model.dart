import 'package:intl/intl.dart';

import 'package:family/src/children/child_model.dart';

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
    birthdate = DateTime.parse(json['birthdate']);
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((child) {
        children.add(Child.fromJson(child));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'name': name,
      'birthdate':
          birthdate != null ? DateFormat('yyyy-MM-dd').format(birthdate!) : '',
    };
  }
}
