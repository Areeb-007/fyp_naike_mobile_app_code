import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/models/master_data.dart';
import '../../helper/colors_res.dart';

class ProfileScreen extends StatefulWidget {
  static const String pageRoute = '/ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double topheight = 250;

  @override
  Widget build(BuildContext context) {
    int id =
        ScopedModel.of<MasterData>(context, rebuildOnChange: true).getUser.id!;
    return ScopedModelDescendant<MasterData>(
        builder: (context, child, masterData) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsRes.black,
          title: const Center(
            child: Text(
              'User Profile',
              style: TextStyle(color: ColorsRes.white),
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorsRes.txtdarkcolor, ColorsRes.txtlightcolor],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0, 10],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: ColorsRes.white,
                        minRadius: 45.0,
                        child: CircleAvatar(
                          backgroundColor: ColorsRes.white,
                          radius: 30.0,
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: SvgPicture.asset(
                              'assets/images/user.svg',
                              height: MediaQuery.of(context).size.height * 0.67,
                              width: MediaQuery.of(context).size.height * 0.67,
                              color: ColorsRes.datecolor,
                              semanticsLabel: 'User Logo',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    (masterData.getUser.firstName ?? 'Guest'),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    (masterData.getUser.lastName ?? ''),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: ColorsRes.txtdarkcolor,
                      child: ListTile(
                        title: Text(
                          '0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Total Raised Needs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: ColorsRes.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: ColorsRes.txtdarkcolor,
                      child: ListTile(
                        title: Text(
                          '0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Total Resolved Needs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: ColorsRes.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                        color: ColorsRes.appcolor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      (masterData.getUser.email ?? ''),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Phone Number',
                      style: TextStyle(
                        color: ColorsRes.appcolor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      masterData.getUser.phone ?? '',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Date of Birth',
                      style: TextStyle(
                        color: ColorsRes.appcolor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      masterData.getUser.dateOfBirth == null
                          ? ''
                          : DateFormat.yMMMMd('en_US')
                              .format(masterData.getUser.dateOfBirth!),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Gender',
                      style: TextStyle(
                        color: ColorsRes.appcolor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      masterData.getUser.gender ?? '',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
