import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/models/donation.dart';
import '../../../data/models/master_data.dart';
import '../../../data/models/need.dart';
import '../../helper/colors_res.dart';
import '../../widgets/form_dialogue.dart';
import '../bottom_navigation_screen/home_screen.dart';
import '../update_donation_need.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  SelectedOption selectedOption = SelectedOption.Need;
  List<Need> needs = [];
  List<Donation> donations = [];
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  void loadTheData() async {
    int id = ScopedModel.of<MasterData>(context).getUser.id!;
    //TODO: call the get Needs and Donations data from dio
    needs = await ScopedModel.of<MasterData>(context)
        .getDioServices
        .getNeedsListByUserID(id)
        .whenComplete(() {
      setState(() {
        needs = needs;
      });
    });
    donations = await ScopedModel.of<MasterData>(context)
        .getDioServices
        .getDonationsListByUserID(id)
        .whenComplete(() {
      setState(() {
        donations = donations;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadTheData();
  }

  @override
  Widget build(BuildContext context) {
    // MasterData state = ScopedModel.of<MasterData>(context);
    return ScopedModelDescendant<MasterData>(
      builder: (context, child, state) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsRes.appcolor,
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SfCartesianChart(
                    selectionType: SelectionType.cluster,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(
                        width: 0,
                      ),
                    ),
                    // Chart title
                    title: ChartTitle(text: 'Statistics'),
                    // Enable legend
                    legend: Legend(isVisible: true),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_SalesData, String>>[
                      LineSeries<_SalesData, String>(
                          dataSource: data,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Sales',
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ]),
                Divider(
                  color: ColorsRes.appcolor,
                  height: 3,
                ),
                Padding(
                    padding: EdgeInsets.only(
                        right: 20, left: 20, top: 10, bottom: 10),
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
                Divider(
                  color: ColorsRes.appcolor,
                  height: 3,
                ),
                Padding(
                    padding: EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: 10,
                    ),
                    child: ScopedModelDescendant<MasterData>(
                      builder: (context, child, state) {
                        return SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.30,
                            child: ListView.builder(
                              itemCount: selectedOption == SelectedOption.Need
                                  ? needs.length
                                  : donations.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 8,
                                  shadowColor: ColorsRes.appcolor,
                                  child: InkWell(
                                    onTap: () {
                                      if (selectedOption ==
                                          SelectedOption.Need) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateScreen(
                                                        needs[index].id!,
                                                        selectedOption,
                                                        loadTheData)));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateScreen(
                                                        donations[index].id!,
                                                        selectedOption,
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
                                                'Are you sure you want to delete',
                                                () {
                                              if (selectedOption ==
                                                  SelectedOption.Need) {
                                                ScopedModel.of<MasterData>(
                                                        context)
                                                    .getDioServices
                                                    .deleteNeed(
                                                        needs[index].id!)
                                                    .whenComplete(
                                                        () => loadTheData());
                                              } else {
                                                ScopedModel.of<MasterData>(
                                                        context)
                                                    .getDioServices
                                                    .deleteDonation(
                                                        donations[index].id!)
                                                    .whenComplete(
                                                        () => loadTheData());
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                        donations[index]
                                                                .subID ??
                                                            0)),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: Text(('Initial Quantity : ' +
                                              (selectedOption ==
                                                      SelectedOption.Need
                                                  ? needs[index]
                                                      .initialQuantity
                                                      .toString()
                                                  : donations[index]
                                                      .initialQuantity
                                                      .toString())) +
                                          ' ' +
                                          ('Current Quantity : ' +
                                              (selectedOption ==
                                                      SelectedOption.Need
                                                  ? needs[index]
                                                      .currentQuantity
                                                      .toString()
                                                  : donations[index]
                                                      .currentQuantity
                                                      .toString()))),
                                      title: Text(
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
              ],
            ),
          ),
        ));
      },
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
