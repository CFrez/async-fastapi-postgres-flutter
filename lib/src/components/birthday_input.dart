import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class BirthdayInput extends StatefulWidget {
  final DateTime? birthdate;
  final Function(DateTime) onChange;

  const BirthdayInput({
    super.key,
    required this.birthdate,
    required this.onChange,
  });

  @override
  State<BirthdayInput> createState() => _BirthdayInputState();
}

class _BirthdayInputState extends State<BirthdayInput> {
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text =
        widget.birthdate != null ? _formatDate(widget.birthdate!) : '';
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM-dd-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: dateController,
        decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today), labelText: 'Birthday'),
        readOnly: true, // when true user cannot edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: widget.birthdate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());
          if (pickedDate != null) {
            dateController.text = _formatDate(pickedDate);
            widget.onChange(pickedDate);
          }
        });
  }
}
