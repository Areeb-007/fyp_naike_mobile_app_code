import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../screens/login_signup_screen.dart';

void showTheLoginAlertErrorDialog(
    BuildContext context, String title, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.SCALE,
    headerAnimationLoop: true,
    dismissOnBackKeyPress: true,
    showCloseIcon: true,
    dismissOnTouchOutside: true,
    useRootNavigator: true,
    title: title,
    desc: message,
    btnOkOnPress: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginSignUpScreen()));
    },
    btnOkIcon: Icons.login,
    btnOkText: 'Login',
    btnOkColor: Colors.green,
  )..show();
}
