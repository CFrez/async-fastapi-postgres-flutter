import 'package:intl/intl.dart';

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

  String formatDate(DateTime date) {
    return DateFormat('MM-dd-yyyy').format(date);
  }

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    name = json['name'];
    birthdate = DateTime.parse(json['birthdate']);
  }

  Map<String, dynamic> toJson() {
    print(birthdate);
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
