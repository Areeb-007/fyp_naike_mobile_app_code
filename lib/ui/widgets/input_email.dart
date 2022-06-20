import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../data/models/master_data.dart';
import '../helper/colors_res.dart';

class InputEmail extends StatefulWidget {
  @override
  _InputEmailState createState() => _InputEmailState();
}

class _InputEmailState extends State<InputEmail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      child: TextFormField(
        cursorColor: ColorsRes.white,
        validator: (value) {
          if (value!.isEmpty || value == null) {
            return 'Please enter email';
          } else if (!EmailValidator.validate(value)) {
            return 'Email incorrect';
          }
        },
        style: TextStyle(
          color: Colors.white,
        ),
        onChanged: (value) {
          ScopedModel.of<MasterData>(context).getUser.email = value;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 15,
            color: ColorsRes.orange,
            letterSpacing: 2.0,
          ),
          labelText: "Enter Email",
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
