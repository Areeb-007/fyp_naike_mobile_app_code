import 'package:flutter/material.dart';
import 'package:naike_ui_3/ui/widgets/sign_up.dart';

import '../helper/colors_res.dart';
import '../widgets/btn_login.dart';
import '../widgets/first_name.dart';
import '../widgets/input_email.dart';
import '../widgets/passworf_input.dart';
import '../widgets/text_new.dart';
import '../widgets/user_old.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final _key1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsRes.appcolor,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorsRes.secondgradientcolor,
                  ColorsRes.firstgradientcolor,
                ]),
          ),
          child: ListView(
            children: <Widget>[
              Form(
                key: _key1,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SingUp(),
                        TextNew(),
                      ],
                    ),
                    NewName(),
                    InputEmail(),
                    PasswordInput(),
                    ButtonLogin(_key1, () {}),
                    UserOld(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
