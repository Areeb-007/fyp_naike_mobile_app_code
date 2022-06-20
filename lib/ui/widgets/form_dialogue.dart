import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../helper/colors_res.dart';

void showTheFormAlertWarningDialog(
    BuildContext context, String title, String message) {
  AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      title: title,
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.amber[600])
    ..show();
}

void showTheErrorDialog(BuildContext context, String title, String message) {
  AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      title: title,
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: ColorsRes.appcolor)
    ..show();
}

void showTheFormAlertSuccessDialog(
    BuildContext context, String title, String message) {
  AwesomeDialog(
    context: context,
    autoHide: Duration(seconds: 3),
    dialogType: DialogType.SUCCES,
    animType: AnimType.SCALE,
    headerAnimationLoop: true,
    title: title,
    desc: message,
  )..show();
}

void showTheDeleteConfirmationDialog(
    BuildContext context, String title, String message, Function()? func) {
  AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      title: title,
      desc: message,
      btnOkText: 'Yes',
      btnOkColor: ColorsRes.red,
      btnOkOnPress: func,
      btnCancelColor: ColorsRes.green,
      btnCancelText: 'No',
      btnCancelOnPress: () {})
    .show();
}

void showTheHelpDialog(
    BuildContext context, String title, String message, double maxQuantity) {
  final _key1 = GlobalKey<FormState>();
  String _message = '';
  AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      title: title,
      desc: message,
      body: Center(
        widthFactor: 20,
        child: Form(
            key: _key1,
            child: Column(
              children: [
                Text('Enter Quantity you want to help'),
                TextFormField(
                  style: TextStyle(),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null) {
                      return _message = 'Please Enter some amount';
                    }
                    if (int.parse(value) < 0) {
                      return _message = 'Please enter correct value';
                    }
                    if (int.parse(value) > maxQuantity) {
                      return _message =
                          'Your quantity exceded the need\'s max quantity';
                    }
                  },
                )
              ],
            )),
      ),
      btnOkColor: ColorsRes.appcolor,
      btnOkText: 'Help',
      keyboardAware: true,
      btnOkOnPress: () {
        if (_key1.currentState!.validate()) {
          // Scoped
          showTheFormAlertSuccessDialog(context, 'Success', 'Applied');
        } else {
          showTheErrorDialog(context, 'Error', _message);
        }
      })
    ..show();
}
