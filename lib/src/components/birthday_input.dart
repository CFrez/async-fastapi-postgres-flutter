import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class BirthdayInput extends StatefulWidget {
  final DateTime? initialValue;
  final Function(DateTime) onChanged;
  final FormFieldValidator<String> validator;

  const BirthdayInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.validator,
  });

  @override
  State<BirthdayInput> createState() => _BirthdayInputState();
}

class _BirthdayInputState extends State<BirthdayInput> {
  // must be used inside Form widget

  String _formatDate(DateTime date) {
    return DateFormat('MM-dd-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: widget.initialValue != null
            ? _formatDate(widget.initialValue!)
            : null,
        decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today), labelText: 'Birthday'),
        readOnly: true, // when true user cannot edit text
        validator: widget.validator,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: widget.initialValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());
          if (pickedDate != null) {
            widget.onChanged(pickedDate);
          }
        });
  }
}
