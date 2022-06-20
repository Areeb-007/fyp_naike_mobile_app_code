import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../data/models/master_data.dart';
import '../helper/colors_res.dart';

class NewName extends StatefulWidget {
  @override
  _NewNameState createState() => _NewNameState();
}

class _NewNameState extends State<NewName> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      child: TextFormField(
        onChanged: (value) {
          ScopedModel.of<MasterData>(context).getUser.firstName = value;
        },
        validator: (value) {
          if (value!.isEmpty || value == null) {
            return 'Please enter first name';
          }
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 15,
            color: ColorsRes.orange,
            letterSpacing: 2.0,
          ),
          labelText: "Enter First Name",
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
