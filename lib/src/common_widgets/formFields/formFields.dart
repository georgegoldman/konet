// ignore_for_file: file_names, dead_code

import 'package:flutter/material.dart';

mixin FormInputFields<T extends StatefulWidget> on State<T> {
  bool isHiddenForPassword = true;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  final regExp = RegExp(
      r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' // <-- Notice the escaped symbols
      "'" // <-- ' is added to the expression
      ']');
  double strength = 0;
  late String password;
  TextFormField email(
    TextEditingController controller,
  ) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      controller: controller,
      style: const TextStyle(
        height: 1,
      ),
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          labelStyle: TextStyle(color: Colors.black54),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFFE6B325))),
          label: Text('email'),
          border: OutlineInputBorder(),
          suffixIcon: Icon(
            Icons.email_outlined,
            color: Colors.black54,
          )),
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Please fill in the field';
        } else if (!(RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
            .hasMatch(value))) {
          return 'Please enter a valid email';
        } else {
          return null;
        }
      },
    );
  }

  TextFormField textInput(
      TextEditingController controller,
      String label,
      dynamic maxLength,
      String hint,
      int maxLines,
      TextInputType textInputType,
      bool requiredField) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (requiredField) {
            return 'It is required';
          }
        }
        return null;
      },
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      style: const TextStyle(height: 1),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          label: Text(label),
          labelStyle: const TextStyle(color: Colors.black54),
          border: const OutlineInputBorder(),
          hintText: hint,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Color(0xFFE6B325)))),
      textInputAction: TextInputAction.done,
      keyboardType: textInputType,
    );
  }
}
