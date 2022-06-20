import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/models/master_data.dart';
import '../helper/colors_res.dart';

class PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: TextFormField(
        cursorColor: ColorsRes.white,
        validator: (value) {
          if (value!.isEmpty || value == null) {
            return 'Please enter password';
          }
        },
        style: TextStyle(
          color: Colors.white,
        ),
        obscureText: true,
        onChanged: (value) {
          ScopedModel.of<MasterData>(context).getUser.password = value;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 15,
            color: ColorsRes.orange,
            letterSpacing: 2.0,
          ),
          labelText: "Enter Password",
          labelStyle: TextStyle(color: ColorsRes.white),
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: ColorsRes.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: ColorsRes.white,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
