import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../helper/colors_res.dart';

Widget pageData(String image, String title, String desc, int pageindex,
    BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  var toppading = 2 * 56;
  return Padding(
    padding: EdgeInsets.only(
      bottom: toppading - 80,
    ),
    child: ScreenTypeLayout(
      mobile: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Image.asset(
            image,
            height: width - 60,
          ),
          // Image.asset(
          //   image,
          //   // width: width - 40,
          //   height: width / 4,
          // ),
          SizedBox(
            height: title.trim().isEmpty ? 0 : 10,
          ),
          title.trim().isEmpty
              ? Container()
              : Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4!.merge(TextStyle(
                        color: ColorsRes.appcolor,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MyFont',
                      ))),
          SizedBox(
            height: width / 10,
          ),
          Padding(
            padding: EdgeInsets.all(0.0),
            // EdgeInsetsDirectional.only(start: 40, end: 40, top: 40, bottom: 30),
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.button!.merge(TextStyle(
                  color: ColorsRes.txtdarkcolor,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyFont')),
            ),
          ),
          SizedBox(
            height: width / 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  4,
                  (index) => Material(
                        color: pageindex == index
                            ? ColorsRes.appcolor
                            : ColorsRes.appcolor.withOpacity(0.3),
                        type: MaterialType.circle,
                        child: new Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.only(left: 3, right: 3),
                        ),
                      ))),
        ],
      ),
    ),
  );
}
