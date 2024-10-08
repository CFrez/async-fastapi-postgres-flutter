import 'package:family/src/children/child_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family/src/utils/api_service.dart';

const childBaseUrl = 'children';

class ChildrenService extends ApiService {
  List<Child> children = [];

  Future<Child> create(Child child) async {
    final data = await post(childBaseUrl, child.toJson());
    // add child vs refetch?
    final groceryItem = Child.fromJson(data);
    return groceryItem;
  }

  Future<Child> update(Child child) async {
    final data = await patch('$childBaseUrl/${child.id}', child.toJson());
    final groceryItem = Child.fromJson(data);
    return groceryItem;
  }

  Future<void> deleteChild(Child child) async {
    await super.delete('$childBaseUrl/${child.id}');
  }
}

ChildrenService _export() {
  final service = Provider((ref) => ChildrenService());
  final container = ProviderContainer();
  return container.read(service);
}

final childrenService = _export();
