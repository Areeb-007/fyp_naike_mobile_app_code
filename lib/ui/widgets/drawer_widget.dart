import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/models/master_data.dart';
import '../../data/models/user.dart';
import '../helper/colors_res.dart';
import '../helper/design_config.dart';
import '../screens/bottom_navigation_screen/profile_screen.dart';
import '../screens/drawer_screens/dashboard.dart';
import '../screens/drawer_screens/reports.dart';
import '../screens/drawer_screens/settings.dart';
import '../screens/login_screen.dart';
import 'drawer_field_item.dart';

Widget drawerData(BuildContext context) {
  var width = MediaQuery.of(context).size.width * 0.2;
  var height = 65.0;
  User user =
      ScopedModel.of<MasterData>(context, rebuildOnChange: true).getUser;
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: DesignConfig.gradient,
        ),
        padding: const EdgeInsets.only(top: 50, bottom: 15),
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              child: ClipOval(
                  child: SvgPicture.asset(
                'assets/images/user.svg',
                color: ColorsRes.white,
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.height * 0.07,
                semanticsLabel: 'User Logo',
                fit: BoxFit.cover,
              )),
              width: 85,
              height: 85,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  border: Border.all(
                    color: ColorsRes.white,
                    width: 2,
                  )),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (user.firstName ?? 'Guest'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsRes.white,
                      ),
                    ),
                    Text(
                      (user.email ?? ''),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsRes.white.withOpacity(0.9),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
            decoration: BoxDecoration(color: ColorsRes.bgcolor),
            child: user.id != -1
                ? ListView(children: <Widget>[
                    SizedBox(
                        height: height,
                        child: drawerItem(context, 'Profile', ProfileScreen(),
                            'assets/images/user.svg')),
                    SizedBox(
                        height: height,
                        child: drawerItem(context, 'Reports', ReportsScreen(),
                            'assets/images/file.svg')),
                    SizedBox(
                        height: height,
                        child: drawerItem(context, 'Settings', SettingsScreen(),
                            'assets/images/settings.svg')),
                    SizedBox(
                      height: height,
                      child: drawerItem(context, 'Dashboard', DashBoardScreen(),
                          'assets/images/dashboard.svg'),
                    ),
                    SizedBox(
                      height: height,
                      child: drawerItem(context, 'Log out', DashBoardScreen(),
                          'assets/images/sign-out.svg'),
                    ),
                  ])
                : ListView(
                    children: <Widget>[
                      SizedBox(
                        height: height,
                        child: drawerItem(context, 'Login', LoginScreen2(),
                            'assets/images/login.svg'),
                      ),
                    ],
                  )),
      ),
    ],
  );
}
