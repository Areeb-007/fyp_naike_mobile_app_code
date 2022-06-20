import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/colors_res.dart';
import '../helper/design_config.dart';
import 'landing_page.dart';


class SplashScreen extends StatefulWidget {
  static const pageRoute = '/SplashScreen';
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  bool appOpenningFirstTime = true;

  Future isAppOpeningFirstTime() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey('userID')) {
      setState(() {
        // TODO: uncomment the next line

        appOpenningFirstTime = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isAppOpeningFirstTime().whenComplete(() => {
          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => LandingPage()),
              ModalRoute.withName(LandingPage.pageRoute),
            );
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: DesignConfig.gradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset('assets/images/handshake.svg',
                  height: deviceSize.height * 0.30,
                  width: deviceSize.width * 0.80,
                  color: ColorsRes.white,
                  fit: BoxFit.contain,
                  semanticsLabel: 'User Logo'),
              Text(
                'Naik E',
                style: TextStyle(
                    color: ColorsRes.white,
                    fontSize: 80,
                    fontFamily: 'Open Sans'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
