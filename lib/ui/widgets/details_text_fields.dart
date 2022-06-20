import 'package:flutter/material.dart';

Widget detailsTextField(
    Icon icon, String labelText, String initialValue, int maxLines) {
  return TextFormField(
    maxLines: maxLines,
    decoration: InputDecoration(
      icon: icon,
      labelText: labelText,
    ),
    initialValue: initialValue,
    enabled: false,
  );
}
