import 'package:family/src/children/children_service.dart';
import 'package:family/src/children/providers/child_details_provider.dart';
import 'package:family/src/children/screens/child_detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:family/src/children/child_model.dart';
import 'package:family/main.dart';

class ChildCard extends StatelessWidget {
  final Child child;

  const ChildCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(child.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          childrenService.deleteChild(child);
        }
      },
      background: Container(
        decoration: BoxDecoration(color: Colors.red),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 18),
              onPressed: () {
                getIt<ChildDetailsProvider>().setChild(child);
                Navigator.of(context).pushNamed(ChildDetailScreen.routeName);
              },
            ),
            Expanded(
              child: Text(child.name),
            ),
          ],
        ),
      ),
    );
  }
}
