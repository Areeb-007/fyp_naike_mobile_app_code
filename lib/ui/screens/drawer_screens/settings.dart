import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/models/master_data.dart';
import '../../helper/colors_res.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showPassword = true;
  XFile? _image;
  ImagePicker _imagePicker = ImagePicker();
  _imgFromCamera() async {
    XFile? image = (await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    XFile? image = (await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsRes.appcolor,
            elevation: 1,
            // leading: IconButton(
            //   icon: Icon(
            //     Icons.arrow_back,
            //     color: Colors.green,
            //   ),
            //   onPressed: () {
            //     Navigator
            //   },
            // ),
          ),
          body: ScopedModelDescendant<MasterData>(
              builder: (context, child, masterData) {
            return Container(
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Text(
                      "Edit Profile",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              // image: DecorationImage(

                              //     fit: BoxFit.cover,
                              //     image: NetworkImage(
                              //       "https://picsum.photos/250?image=9",
                              //     )
                              //     )
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.file(
                                        File(_image!.path),
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: Colors.grey[800],
                                    ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    buildTextField(
                        "First Name", masterData.getUser.firstName, false),
                    buildTextField(
                        "Last Name", masterData.getUser.lastName, false),
                    buildTextField("Email", masterData.getUser.email, false),
                    buildTextField(
                        "Password", masterData.getUser.password, true),
                    buildTextField("Phone", masterData.getUser.phone, false),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     OutlineButton(
                    //       padding: EdgeInsets.symmetric(horizontal: 50),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(20)),
                    //       onPressed: () {
                    //         Navigator.pop(context);
                    //       },
                    //       child: Text("CANCEL",
                    //           style: TextStyle(
                    //               fontSize: 14,
                    //               letterSpacing: 2.2,
                    //               color: Colors.black)),
                    //     ),
                    //     RaisedButton(
                    //       onPressed: () {},
                    //       color: Colors.green,
                    //       padding: EdgeInsets.symmetric(horizontal: 50),
                    //       elevation: 2,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(20)),
                    //       child: Text(
                    //         "SAVE",
                    //         style: TextStyle(
                    //             fontSize: 14,
                    //             letterSpacing: 2.2,
                    //             color: Colors.white),
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
            );
          })),
    );
  }

  Widget buildTextField(
      String labelText, String? placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        initialValue: placeholder,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder ?? '',
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
