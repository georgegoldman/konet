import 'package:curnect/src/pages/dash_board/widgets/dashBoardForm/dropdownFormDash.dart';
import 'package:flutter/material.dart';

mixin DashBoardWidgets {
  DashBoardDropDownFormField createDropDownpList(
      String setValue, String label, List<dynamic> items) {
    return DashBoardDropDownFormField(
        setValue: setValue, label: label, items: items);
  }
}
