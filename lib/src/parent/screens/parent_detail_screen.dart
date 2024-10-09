import 'package:family/src/children/providers/child_details_provider.dart';
import 'package:family/src/children/screens/child_detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:family/main.dart';
import 'package:family/src/children/components/children_list.dart';
import 'package:family/src/parent/providers/parent_details_provider.dart';
import 'package:family/src/components/birthday_input.dart';

class ParentDetailScreen extends StatefulWidget {
  static const routeName = '/detail';

  const ParentDetailScreen({super.key});

  @override
  State<ParentDetailScreen> createState() => _ParentDetailScreenState();
}

class _ParentDetailScreenState extends State<ParentDetailScreen> {
  final detailsProvider = getIt<ParentDetailsProvider>();

  @override
  void initState() {
    super.initState();
    detailsProvider.addListener(() {
      setStateIfMounted(() {});
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void _handleSave() async {
    if (detailsProvider.isProcessing) return;

    final newItem = await detailsProvider.saveParent();
    if (newItem != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      // ToastService.error('Error saving item');
      print('Error saving item');
    }
  }

  void _handleAddChild() {
    getIt<ChildDetailsProvider>().clearChild(detailsProvider.parent.id);
    Navigator.of(context).pushNamed(ChildDetailScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Parent Details'),
          actions: [
            TextButton(
              onPressed: _handleSave,
              child: Text('Save',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: Form(
          key: detailsProvider.form,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                  ),
                  autofocus: true,
                  onChanged: detailsProvider.setName,
                  validator: detailsProvider.validateName,
                  initialValue: detailsProvider.parent.name,
                ),
                SizedBox(height: 8),
                BirthdayInput(
                  initialValue: detailsProvider.parent.birthdate,
                  onChanged: detailsProvider.setBirthdate,
                  validator: detailsProvider.validateBirthdate,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.child_care),
                    SizedBox(width: 12),
                    Text('Children',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    Spacer(),
                    IconButton(
                        onPressed: _handleAddChild, icon: Icon(Icons.add))
                  ],
                ),
                ChildrenList(children: detailsProvider.parent.children),
                if (detailsProvider.isProcessing)
                  Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          ),
        ));
  }
}
