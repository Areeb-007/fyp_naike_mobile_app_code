import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import '../helper/colors_res.dart';
import 'landing_page.dart';

class IntroSliderActivity extends StatefulWidget {
  static const String pageRoute = '/IntroSliderActivity';
  const IntroSliderActivity({Key? key}) : super(key: key);

  @override
  _IntroSliderActivityState createState() => _IntroSliderActivityState();
}

class _IntroSliderActivityState extends State<IntroSliderActivity> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        styleDescription:
            TextStyle(color: ColorsRes.txtdarkcolor, fontSize: 30),
        styleTitle: TextStyle(
            color: ColorsRes.txtdarkcolor,
            fontSize: 50,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold),
        title: "Raise A Need",
        description: "Allow other to help the needy appropriatly",
        pathImage: "assets/images/raise_hand.png",
        backgroundColor: ColorsRes.bgcolor,
      ),
    );
    slides.add(
      new Slide(
        styleDescription:
            TextStyle(color: ColorsRes.txtdarkcolor, fontSize: 30),
        styleTitle: TextStyle(
            color: ColorsRes.txtdarkcolor,
            fontSize: 50,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold),
        title: "Or Donate",
        description:
            "Donate anything that you think is spare and might help others",
        pathImage: "assets/images/donation_coloured.png",
        backgroundColor: ColorsRes.bglightgrey,
      ),
    );
    slides.add(
      new Slide(
        styleDescription:
            TextStyle(color: ColorsRes.txtdarkcolor, fontSize: 30),
        styleTitle: TextStyle(
            color: ColorsRes.txtdarkcolor,
            fontSize: 50,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold),
        title: "Naik E",
        description:
            "Let us Welcome you to a platform where you can earn your Naik E by helping the people that are needy in reality",
        pathImage: "assets/images/handshake.png",
        backgroundColor: ColorsRes.bgcolor,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (BuildContext context) => LandingPage()),
      ModalRoute.withName('/'),
    );
  }

  void onSkipPress() {
    Navigator.pushNamed(context, LandingPage.pageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
      colorActiveDot: ColorsRes.appcolor,
      colorDot: ColorsRes.grey.withOpacity(0.3),
      nextButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)),
      doneButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
      skipButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
    );
  }
}
