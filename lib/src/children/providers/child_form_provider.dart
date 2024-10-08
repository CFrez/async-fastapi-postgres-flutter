import 'package:family/src/children/child_model.dart';
import 'package:family/src/children/children_service.dart';
import 'package:flutter/material.dart';

abstract class ChildFormProvider extends ChangeNotifier {
  Child _child = Child();

  bool _isProcessing = false;
  final _form = GlobalKey<FormState>();

  // Getters
  Child get child;
  bool get isProcessing;
  GlobalKey<FormState> get form;
  String get birthdate;

  // Operations
  void clearChild();
  void setChild(Child child);
  Future<Child?> saveChild();
  Future<void> deleteChild(Child child);

  // Validation
  String? validateName(String? value);

  // Setters
  void setName(String name);
  void setBirthdate(DateTime birthdate);
  void setHobby(String hobby);
  void setParentId(String parentId);
}

class ChildFormProviderImpl extends ChildFormProvider {
  // ChildFormProviderImpl() {}

  void handleUpdate() {
    notifyListeners();
  }

  @override
  Child get child => _child;

  @override
  bool get isProcessing => _isProcessing;

  @override
  GlobalKey<FormState> get form => _form;

  @override
  String get birthdate =>
      _child.birthdate != null ? child.formatDate(_child.birthdate!) : '';

  @override
  void clearChild() {
    _child = Child();
    handleUpdate();
  }

  @override
  void setChild(Child child) {
    _child = child;
    handleUpdate();
  }

  @override
  Future<Child?> saveChild() async {
    if (!_form.currentState!.validate()) {
      handleUpdate();
      return null;
    }
    _isProcessing = true;
    final isNew = _child.id == null;
    final savedChild = isNew
        ? await childrenService.create(_child)
        : await childrenService.update(_child);
    _isProcessing = false;
    // ToastService.success('${savedChild.name} ${isNew ? 'added' : 'updated'}');
    return savedChild;
  }

  @override
  Future<void> deleteChild(Child child) async {
    _isProcessing = true;
    await childrenService.deleteChild(child);
    _isProcessing = false;
    // ToastService.success('${child.name} deleted');
    handleUpdate();
  }

  @override
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Child Name is Required';
    }
    return null;
  }

  @override
  void setName(String name) {
    _child.name = name;
    handleUpdate();
  }

  @override
  void setBirthdate(DateTime birthdate) {
    _child.birthdate = birthdate;
    handleUpdate();
  }

  @override
  void setHobby(String hobby) {
    _child.hobby = hobby;
    handleUpdate();
  }

  @override
  void setParentId(String parentId) {
    _child.parentId = parentId;
    handleUpdate();
  }
}
