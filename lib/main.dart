import 'package:flutter/material.dart';
import 'package:naike_ui_3/data/models/counter.dart';
import 'package:scoped_model/scoped_model.dart';

import 'data/models/master_data.dart';
import 'ui/helper/colors_res.dart';
import 'ui/helper/string_res.dart';
import 'ui/screens/intro_slider_activity.dart';
import 'ui/screens/notification_screen.dart';
import 'ui/screens/splash_screen.dart';


void main() {
  runApp(Naik_E());
}

class Naik_E extends StatelessWidget {
  // This widget is the root of your application.

  Naik_E() {
    // masterData.loadUpData().whenComplete(() => print('Data Loaded'));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MasterData>(
      model: MasterData(context, Counter()),
      child: MaterialApp(
        routes: {
          IntroSliderActivity.pageRoute: (context) => IntroSliderActivity(),
          // LandingPage.pageRoute: (context) => LandingPage(),
          SplashScreen.pageRoute: (context) => SplashScreen(),
          NotificationScreen.pageRoute: (context) => NotificationScreen(),
        },
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        title: StringsRes.mainappname,
        theme: ThemeData(
          fontFamily: 'MyFont',
          iconTheme: IconThemeData(
            color: ColorsRes.white,
          ),
          accentColor: ColorsRes.appcolor,
          primarySwatch: ColorsRes.appcolor_material,
          primaryTextTheme:
              TextTheme(headline6: TextStyle(color: ColorsRes.appcolor)),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
