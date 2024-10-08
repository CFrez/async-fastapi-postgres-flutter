import 'package:family/src/children/providers/child_form_provider.dart';
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
  final formProvider = getIt<ChildFormProvider>();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    formProvider.addListener(() {
      setStateIfMounted(() {});
    });
    dateController.text = formProvider.birthdate;
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void _handleSave() async {
    if (formProvider.isProcessing) return;

    final newItem = await formProvider.saveChild();
    if (newItem != null) {
      print(newItem.name);
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
          key: formProvider.form,
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
                        onChanged: formProvider.setName,
                        validator: formProvider.validateName,
                        initialValue: formProvider.child.name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: BirthdayInput(
                        birthdate: formProvider.child.birthdate,
                        onChange: formProvider.setBirthdate,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Hobby',
                        ),
                        onChanged: formProvider.setHobby,
                        initialValue: formProvider.child.hobby,
                      ),
                    ),
                  ],
                ),
                if (formProvider.isProcessing)
                  Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          ),
        ));
  }
}
