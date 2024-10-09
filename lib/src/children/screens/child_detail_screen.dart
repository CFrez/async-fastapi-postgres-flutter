import 'package:family/src/children/providers/child_details_provider.dart';
import 'package:flutter/material.dart';

import 'package:family/main.dart';
import 'package:family/src/components/birthday_input.dart';

class ChildDetailScreen extends StatefulWidget {
  static const routeName = '/child_detail';

  const ChildDetailScreen({super.key});

  @override
  State<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends State<ChildDetailScreen> {
  final detailsProvider = getIt<ChildDetailsProvider>();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    detailsProvider.addListener(() {
      setStateIfMounted(() {});
    });
    dateController.text = detailsProvider.birthdate;
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void _handleSave() async {
    if (detailsProvider.isProcessing) return;

    final newItem = await detailsProvider.saveChild();
    if (newItem != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      // ToastService.error('Error saving item');
      print('Error saving item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Child Details'),
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
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        autofocus: true,
                        onChanged: detailsProvider.setName,
                        validator: detailsProvider.validateName,
                        initialValue: detailsProvider.child.name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: BirthdayInput(
                        initialValue: detailsProvider.child.birthdate,
                        onChanged: detailsProvider.setBirthdate,
                        validator: detailsProvider.validateBirthdate,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Hobby',
                        ),
                        onChanged: detailsProvider.setHobby,
                        initialValue: detailsProvider.child.hobby,
                      ),
                    ),
                  ],
                ),
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
