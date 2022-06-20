import 'package:flutter/material.dart';
import 'package:naike_ui_3/ui/screens/bottom_navigation_screen/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../../data/models/donation.dart';
import '../../../data/models/master_data.dart';
import '../../../data/models/need.dart';
import '../../helper/colors_res.dart';
import '../../widgets/form_dialogue.dart';
import '../update_donation_need.dart';


class MyNeeds extends StatefulWidget {
  SelectedOption selectedOption;
  MyNeeds({Key? key, required this.selectedOption}) : super(key: key);

  @override
  _MyNeedsState createState() => _MyNeedsState();
}

class _MyNeedsState extends State<MyNeeds> {
  List<Need> needs = [];
  List<Donation> donations = [];
  late int selectedTypeCount;
  bool loading = true;
  void loadTheData() async {
    int id = ScopedModel.of<MasterData>(context).getUser.id!;

    if (widget.selectedOption == SelectedOption.Need) {
      needs = await ScopedModel.of<MasterData>(context)
          .getDioServices
          .getNeedsListByUserID(id)
          .whenComplete(() {
        setState(() {
          needs = needs;
          loading = false;
          selectedTypeCount = needs.length;
          print('CNT of Needs ' + selectedTypeCount.toString());
          // print(needs[1].title);
        });
      });
    } else {
      donations = await ScopedModel.of<MasterData>(context)
          .getDioServices
          .getDonationsListByUserID(id)
          .whenComplete(() {
        setState(() {
          donations = donations;
          loading = false;
          selectedTypeCount = donations.length;
          print('CNT of Donations ' + selectedTypeCount.toString());
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTheData();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MasterData>(builder: (context, child, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsRes.appcolor,
        ),
        body: SafeArea(
            child: Container(
          height: MediaQuery.of(context).size.height * 0.80,
          child: loading
              ? SingleChildScrollView(
                  child: SkeletonLoader(
                    builder: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    items: 10,
                    period: Duration(seconds: 2),
                    highlightColor: Colors.lightBlue,
                    direction: SkeletonDirection.ltr,
                  ),
                )
              : ListView.builder(
                  itemCount: widget.selectedOption == SelectedOption.Need
                      ? needs.length
                      : donations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      shadowColor: ColorsRes.appcolor,
                      child: InkWell(
                        onTap: () {
                          state.counter.incrementCounter();
                          if (widget.selectedOption == SelectedOption.Need) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateScreen(
                                        needs[index].id!,
                                        widget.selectedOption,
                                        loadTheData)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateScreen(
                                        donations[index].id!,
                                        widget.selectedOption,
                                        loadTheData)));
                          }
                        },
                        child: ListTile(
                          // dense: true,
                          trailing: IconButton(
                              onPressed: () {
                                showTheDeleteConfirmationDialog(
                                    context,
                                    'Sure?',
                                    'Are you sure you want to delete', () {
                                  if (widget.selectedOption ==
                                      SelectedOption.Need) {
                                    ScopedModel.of<MasterData>(context)
                                        .getDioServices
                                        .deleteNeed(needs[index].id!)
                                        .whenComplete(() => loadTheData());
                                  } else {
                                    ScopedModel.of<MasterData>(context)
                                        .getDioServices
                                        .deleteDonation(donations[index].id!)
                                        .whenComplete(() => loadTheData());
                                  }
                                  // Navigator.pushReplacement<void, void>(
                                  //   context,
                                  //   MaterialPageRoute<void>(
                                  //     builder: (BuildContext context) =>
                                  //         const DashBoardScreen(),
                                  //   ),
                                  // );
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: ColorsRes.red,
                              )),
                          leading: Container(
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    (widget.selectedOption ==
                                            SelectedOption.Need
                                        ? state.getSubCategoryName(
                                            needs[index].subID ?? 0)
                                        : state.getSubCategoryName(
                                            donations[index].subID ?? 0)),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(('Initial Quantity : ' +
                                  (widget.selectedOption == SelectedOption.Need
                                      ? needs[index].initialQuantity.toString()
                                      : donations[index]
                                          .initialQuantity
                                          .toString())) +
                              ' ' +
                              ('Current Quantity : ' +
                                  (widget.selectedOption == SelectedOption.Need
                                      ? needs[index].currentQuantity.toString()
                                      : donations[index]
                                          .currentQuantity
                                          .toString()))),
                          title: Text(
                            (widget.selectedOption == SelectedOption.Need
                                ? needs[index].title ?? ''
                                : donations[index].title ?? ''),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        )),
      );
    });
  }
}
