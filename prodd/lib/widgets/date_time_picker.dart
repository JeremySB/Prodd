
import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget {

  DateTimePicker({this.onSaved});

  final FormFieldSetter<DateTime> onSaved;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      onSaved: onSaved,
      builder: (state) {
        return GestureDetector(
          child: Text(state.value.toString()),
          onTap: () async {
            final result = await showDatePicker(
              context: context, 
              firstDate: DateTime(2015), 
              initialDate: DateTime.now(), 
              lastDate: DateTime(2100)
            );
            state.didChange(result);
          },
        );
      },
    );
  }
}