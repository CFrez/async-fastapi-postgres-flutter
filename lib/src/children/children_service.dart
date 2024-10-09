import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family/main.dart';
import 'package:family/src/children/child_model.dart';
import 'package:family/src/parent/providers/parent_details_provider.dart';
import 'package:family/src/utils/api_service.dart';

const childBaseUrl = 'children';

class ChildrenService extends ApiService {
  Future<Child> create(Child child) async {
    final data = await post(childBaseUrl, child.toJson());
    final createdChild = Child.fromJson(data);
    getIt<ParentDetailsProvider>().refreshParent();
    return createdChild;
  }

  Future<Child> update(Child child) async {
    final data = await patch('$childBaseUrl/${child.id}', child.toJson());
    final updatedChild = Child.fromJson(data);
    getIt<ParentDetailsProvider>().refreshParent();
    return updatedChild;
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
