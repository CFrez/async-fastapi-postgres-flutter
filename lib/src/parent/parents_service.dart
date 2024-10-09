import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family/main.dart';
import 'package:family/src/parent/parent_model.dart';
import 'package:family/src/parent/providers/parents_list_provider.dart';
import 'package:family/src/utils/api_service.dart';

const parentsBaseUrl = 'parents';

class ParentsService extends ApiService {
  List<Parent> parents = [];

  Future<List<Parent>> list() async {
    final data = await getList(parentsBaseUrl);
    parents = data.map((parent) => Parent.fromJson(parent)).toList();
    return parents;
  }

  Future<Parent> create(Parent parent) async {
    final data = await post(parentsBaseUrl, parent.toJson());
    // add parent vs refetch?
    final groceryItem = Parent.fromJson(data);
    getIt<ParentsListProvider>().fetchItems();
    return groceryItem;
  }

  Future<Parent> read(String parentId) async {
    final data = await get('$parentsBaseUrl/$parentId');
    return Parent.fromJson(data);
  }

  Future<Parent> update(Parent parent) async {
    final data = await patch('$parentsBaseUrl/${parent.id}', parent.toJson());
    final groceryItem = Parent.fromJson(data);
    getIt<ParentsListProvider>().fetchItems();
    return groceryItem;
  }

  Future<void> deleteParent(Parent parent) async {
    await super.delete('$parentsBaseUrl/${parent.id}');
    getIt<ParentsListProvider>().fetchItems();
  }
}

ParentsService _export() {
  final service = Provider((ref) => ParentsService());
  final container = ProviderContainer();
  return container.read(service);
}

final parentsService = _export();
