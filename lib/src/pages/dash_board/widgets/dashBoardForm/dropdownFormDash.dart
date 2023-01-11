import 'package:flutter/material.dart';

class DashBoardDropDownFormField extends StatefulWidget {
  late String setValue;
  final String label;
  final List<dynamic> items;
  DashBoardDropDownFormField(
      {super.key,
      required this.setValue,
      required this.label,
      required this.items});

  dynamic getValue() {
    return setValue;
  }

  @override
  State<DashBoardDropDownFormField> createState() =>
      _DashBoardDropDownFormFieldState();
}

class _DashBoardDropDownFormFieldState
    extends State<DashBoardDropDownFormField> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(builder: (FormFieldState<String> state) {
      return DropdownButtonFormField(
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
              label: Text(widget.label),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                    const BorderSide(width: 2.0, color: Color(0xFFE6B325)),
              )),
          isExpanded: true,
          items: widget.items.map<DropdownMenuItem<dynamic>>((dynamic value) {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            widget.setValue = value!;
          });
    });
  }
}
