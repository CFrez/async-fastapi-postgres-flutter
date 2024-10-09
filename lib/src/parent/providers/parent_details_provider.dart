import 'package:flutter/material.dart';

import 'package:family/src/parent/parent_model.dart';
import 'package:family/src/parent/parents_service.dart';

abstract class ParentDetailsProvider extends ChangeNotifier {
  Parent _parent = Parent();
  bool _isProcessing = false;
  final _form = GlobalKey<FormState>();

  // Getters
  Parent get parent;
  bool get isProcessing;
  GlobalKey<FormState> get form;

  // Operations
  void clearParent();
  void setParent(Parent parent);
  Future<Parent?> saveParent();
  Future<void> deleteParent(Parent parent);
  void refreshParent();

  // Validation
  String? validateName(String? value);
  String? validateBirthdate(String? value);

  // Setters
  void setName(String name);
  void setBirthdate(DateTime birthdate);
}

class ParentDetailsProviderImpl extends ParentDetailsProvider {
  void handleUpdate() {
    notifyListeners();
  }

  @override
  Parent get parent => _parent;

  @override
  bool get isProcessing => _isProcessing;

  @override
  GlobalKey<FormState> get form => _form;

  @override
  void clearParent() {
    _parent = Parent();
    handleUpdate();
  }

  @override
  void setParent(Parent parent) {
    _parent = parent;
    handleUpdate();
  }

  @override
  void refreshParent() async {
    if (_parent.id == null) {
      return;
    }
    final parent = await parentsService.read(_parent.id!);
    _parent = parent;

    handleUpdate();
  }

  @override
  Future<Parent?> saveParent() async {
    if (!_form.currentState!.validate()) {
      handleUpdate();
      return null;
    }
    _isProcessing = true;
    final isNew = _parent.id == null;
    final savedParent = isNew
        ? await parentsService.create(_parent)
        : await parentsService.update(_parent);
    _isProcessing = false;
    // ToastService.success('${savedParent.name} ${isNew ? 'added' : 'updated'}');
    return savedParent;
  }

  @override
  Future<void> deleteParent(Parent parent) async {
    _isProcessing = true;
    await parentsService.deleteParent(parent);
    _isProcessing = false;
    // ToastService.success('${parent.name} deleted');
    handleUpdate();
  }

  @override
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parent Name is Required';
    }
    return null;
  }

  @override
  String? validateBirthdate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Birthdate is Required';
    }
    return null;
  }

  @override
  void setName(String name) {
    _parent.name = name;
    handleUpdate();
  }

  @override
  void setBirthdate(DateTime birthdate) {
    _parent.birthdate = birthdate;
    handleUpdate();
  }
}
