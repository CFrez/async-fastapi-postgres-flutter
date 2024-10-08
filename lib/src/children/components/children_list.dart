import 'package:family/src/children/child_model.dart';
import 'package:family/src/children/components/child_card.dart';
import 'package:flutter/material.dart';

class ChildrenList extends StatefulWidget {
  final List<Child> children;
  const ChildrenList({super.key, this.children = const []});

  @override
  State<ChildrenList> createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  @override
  void initState() {
    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return Center(
        child: Text('No children found'),
      );
    }
    return ListView.builder(
      itemCount: widget.children.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final child = widget.children.elementAt(index);
        return ChildCard(
          child: child,
        );
      },
    );
  }
}
