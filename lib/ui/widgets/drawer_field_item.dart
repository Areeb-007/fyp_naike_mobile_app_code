import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/models/master_data.dart';
import '../helper/colors_res.dart';

Widget drawerItem(
    BuildContext context, String title, Widget screen, String image) {
  return Card(
    shadowColor: ColorsRes.appcolor,
    elevation: 5,
    child: ListTile(
        leading: SvgPicture.asset(
          image,
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.height * 0.04,
          color: ColorsRes.datecolor,
          semanticsLabel: 'User Logo',
          fit: BoxFit.cover,
        ),
        title: Text(
          title,
          style: TextStyle(color: ColorsRes.txtdarkcolor),
        ),
        dense: true,
        onTap: () async {
          Navigator.pop(context);
          if (title != 'Log out') {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => screen));
          } else {
            await ScopedModel.of<MasterData>(context).logOut();
          }
        }),
  );
}
