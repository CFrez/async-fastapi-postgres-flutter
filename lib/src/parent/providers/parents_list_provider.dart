import 'package:flutter/material.dart';

import 'package:family/src/parent/parent_model.dart';
import 'package:family/src/parent/parents_service.dart';

abstract class ParentsListProvider extends ChangeNotifier {
  bool isLoading = true;
  List<Parent> _parents = [];

  // Getters
  List<Parent> get parents;

  // Operations
  Future<void> fetchItems();
  Future<void> fetchParent(String parentId);
  void setItems(List<Parent> parents);
}

class ParentsListProviderImpl extends ParentsListProvider {
  ParentsListProviderImpl() {
    _init();
  }

  Future<void> _init() async {
    await fetchItems();
  }

  @override
  List<Parent> get parents => _parents;

  @override
  Future<void> fetchItems() async {
    isLoading = true;
    setItems([]);
    final parents = await parentsService.list();
    setItems(parents);
    isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> fetchParent(String parentId) async {
    isLoading = true;
    final parent = await parentsService.read(parentId);
    final index = _parents.indexWhere((element) => element.id == parentId);
    _parents[index] = parent;
    isLoading = false;
    notifyListeners();
  }

  @override
  void setItems(List<Parent> parents) {
    _parents = parents;
    notifyListeners();
  }
}
