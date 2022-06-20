import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../data/models/donation.dart';
import '../../../data/models/master_data.dart';
import '../../../data/models/need.dart';
import '../../helper/colors_res.dart';
import '../../widgets/login_warning_dialogue.dart';
import '../detail_screens.dart';
import 'home_screen.dart';

class ListOfAll extends StatefulWidget {
  const ListOfAll({Key? key}) : super(key: key);

  @override
  _ListOfAllState createState() => _ListOfAllState();
}

class _ListOfAllState extends State<ListOfAll> {
  double leftrightpadding = 20;
  SelectedOption selectedOption = SelectedOption.Need;
  @override
  Widget build(BuildContext context) {
    final List<Need> needs = ScopedModel.of<MasterData>(context).getListOfNeeds;
    final List<Donation> donations =
        ScopedModel.of<MasterData>(context).getListOfDonations;
    int id =
        ScopedModel.of<MasterData>(context, rebuildOnChange: true).getUser.id!;
    int counter = ScopedModel.of<MasterData>(context, rebuildOnChange: true)
        .counter
        .counter;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsRes.appcolor,
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    right: leftrightpadding, left: leftrightpadding, top: 10),
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
                  labels: ['Needs', 'Donations'],
                  radiusStyle: true,
                  onToggle: (index) {
                    setState(() {
                      selectedOption = (index == 0
                          ? SelectedOption.Need
                          : SelectedOption.Donation);
                    });
                  },
                )),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(
                    right: leftrightpadding,
                    left: leftrightpadding,
                    top: 10,
                  ),
                  child: ScopedModelDescendant<MasterData>(
                    builder: (context, child, state) {
                      return SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.90,
                          child: ListView.builder(
                            itemCount: selectedOption == SelectedOption.Need
                                ? needs.length
                                : donations.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 8,
                                shadowColor: ColorsRes.appcolor,
                                child: ListTile(
                                  // dense: true,
                                  trailing: IconButton(
                                    icon:
                                        const Icon(Icons.keyboard_arrow_right),
                                    tooltip: 'Click to see the details',
                                    onPressed: () {
                                      if (id == -1) {
                                        showTheLoginAlertErrorDialog(
                                            context,
                                            'Login / Sign Up',
                                            'You are not logged in. \n Either Login or SgnUp to continue further');
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                      id: selectedOption ==
                                                              SelectedOption
                                                                  .Need
                                                          ? needs[index].id!
                                                          : donations[index]
                                                              .id!,
                                                      selectedOption:
                                                          selectedOption,
                                                    )));
                                      }
                                    },
                                  ),

                                  leading: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            (selectedOption ==
                                                    SelectedOption.Need
                                                ? state.getSubCategoryName(
                                                    needs[index].subID ?? 0)
                                                : state.getSubCategoryName(
                                                    donations[index].subID ??
                                                        0)),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  tileColor: index % 2 == 0
                                      ? ColorsRes.grey
                                      : ColorsRes.white,
                                  subtitle: Text(('Initial Quantity : ' +
                                          (selectedOption == SelectedOption.Need
                                              ? needs[index]
                                                  .initialQuantity
                                                  .toString()
                                              : donations[index]
                                                  .initialQuantity
                                                  .toString())) +
                                      ' ' +
                                      ('Current Quantity : ' +
                                          (selectedOption == SelectedOption.Need
                                              ? needs[index]
                                                  .currentQuantity
                                                  .toString()
                                              : donations[index]
                                                  .currentQuantity
                                                  .toString()))),
                                  title: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
                                    child: Text(
                                      (selectedOption == SelectedOption.Need
                                          ? needs[index].title ?? ''
                                          : donations[index].title ?? ''),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )),
            )
          ],
        ),
      )),
    );
  }
}
