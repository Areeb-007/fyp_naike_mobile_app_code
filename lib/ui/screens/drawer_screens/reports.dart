import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../helper/colors_res.dart';

enum SelectedReportsOption { Active, Resolved }

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  SelectedReportsOption selectedOption = SelectedReportsOption.Active;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                child: ToggleSwitch(
                  minWidth: 90.0,
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [Colors.green[800]!],
                    [Colors.green[800]!]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey[100],
                  inactiveFgColor: ColorsRes.txtdarkcolor,
                  initialLabelIndex: selectedOption.index,
                  totalSwitches: 2,
                  labels: ['Active', 'Resolved'],
                  radiusStyle: true,
                  onToggle: (index) {
                    setState(() {
                      selectedOption = (index == 0
                          ? SelectedReportsOption.Active
                          : SelectedReportsOption.Resolved);
                    });
                  },
                )),
            Divider(
              color: ColorsRes.appcolor,
              height: 3,
            ),
          ],
        ),
      ),
    ));
  }
}
