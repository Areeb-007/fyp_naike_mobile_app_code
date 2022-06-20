import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showTheAlertErrorDialog(
    BuildContext context, String title, String message) {
  AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.RIGHSLIDE,
      headerAnimationLoop: true,
      title: title,
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red)
    ..show();
}
