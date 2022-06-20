import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../data/models/donation.dart';
import '../../../data/models/master_data.dart';
import '../../../data/models/need.dart';
import '../../helper/colors_res.dart';
import '../../helper/design_config.dart';
import '../../helper/string_res.dart';
import '../../widgets/login_warning_dialogue.dart';
import '../detail_screens.dart';
import '../notification_screen.dart';
import '../raise_need_activity.dart';

enum SelectedOption { Need, Donation }

class HomeScreen extends StatefulWidget {
  static const pageRoute = '/HomeScreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  int msgcount = 0;
  double leftrightpadding = 20;
  SelectedOption selectedOption = SelectedOption.Need;
  bool ispm = true,
      ispaxbit = true,
      isbtc = true,
      iseth = true,
      isltct = true,
      isltc = true,
      isusdt = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool loading = true;

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    List<Need> needs = ScopedModel.of<MasterData>(context).getListOfNeeds;
    List<Donation> donations =
        ScopedModel.of<MasterData>(context).getListOfDonations;
    int id =
        ScopedModel.of<MasterData>(context, rebuildOnChange: true).getUser.id!;
    if (needs.length != 0 || donations.length != 0) {
      loading = false;
    }
    return Scaffold(
        body: DoubleBackToCloseApp(
      snackBar: SnackBar(
        content: Text('Press back again to Exit'),
      ),
      child: Column(children: <Widget>[
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    bottomRight: const Radius.circular(30),
                    bottomLeft: const Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                      /* stops: [1, 0],
                          end: Alignment(-0.00, -1.00),
                          begin: Alignment(0.00, 1.00), */
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorsRes.secondgradientcolor,
                        ColorsRes.firstgradientcolor
                      ])),
              margin: EdgeInsets.only(bottom: 25),
              padding: EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 14, bottom: 14, right: 14),
                            child: Icon(Icons.format_align_justify)
                            // CachedNetworkImage(

                            //   imageUrl:
                            //       'https://smartkit.wrteam.in/smartkit/cryptotech/drawer_button.png',
                            // ),
                            )),
                    actions: [
                      GestureDetector(
                        child: new Stack(children: <Widget>[
                          Center(
                            child: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.notifications)),
                          ),
                          msgcount == 0
                              ? Container()
                              : new Positioned(
                                  // draw a red marble
                                  top: 0.0,
                                  right: 3.0,
                                  bottom: 20,

                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorsRes.red),
                                      child: new Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              msgcount.toString().length == 1
                                                  ? 6
                                                  : 3),
                                          child: new Text(
                                            msgcount.toString(),
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      )),
                                ),
                        ]),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15, top: 10, bottom: 10),
                    child: Row(children: [
                      Card(
                          shape: DesignConfig.setRoundedBorder(
                              ColorsRes.black, 90),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: SvgPicture.asset(
                            'assets/images/user.svg',
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.height * 0.08,
                            semanticsLabel: 'User Logo',
                            fit: BoxFit.cover,
                          )),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(greeting(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .merge(TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorsRes.white,
                                      ))),
                              id == -1
                                  ? Text('Guest',
                                      style: TextStyle(
                                          fontSize: 20, color: ColorsRes.white))
                                  : ScopedModelDescendant<MasterData>(
                                      builder: (context, child, model) => Text(
                                          '${model.getUser.firstName}' +
                                              ' : ${model.counter.counter}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: ColorsRes.white)),
                                    )
                            ]),
                      )
                    ]),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 20, right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("\t\Active Needs",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorsRes.white.withOpacity(0.7),
                                        fontWeight: FontWeight.bold)),
                                Text("\t0 %",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .merge(TextStyle(
                                            color: ColorsRes.white,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("\t\tResolved Needs",
                                    style: TextStyle(
                                        color: ColorsRes.white.withOpacity(0.7),
                                        fontWeight: FontWeight.bold)),
                                Text("\t0 %",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .merge(TextStyle(
                                            color: ColorsRes.white,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  elevation: 8,
                  shadowColor: ColorsRes.black,
                  shape: DesignConfig.setRoundedBorder(Colors.white, 10),
                  color: ColorsRes.white,
                  margin: EdgeInsets.only(
                      left: leftrightpadding, right: leftrightpadding),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(30),
                                  bottomLeft: const Radius.circular(30),
                                ),
                                color: Colors.grey[200],
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (id == -1) {
                                    showTheLoginAlertErrorDialog(
                                        context,
                                        'Login / Singup',
                                        'You are not logged in. \n Either Login or SgnUp to continue further');
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RaiseNeedActivity(
                                                    SelectedOption.Need)));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/images/help.svg',
                                          fit: BoxFit.contain,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          semanticsLabel: 'User Logo'),
                                      SizedBox(width: 10),
                                      Text(
                                        StringsRes.raiseNeed,
                                        style: TextStyle(
                                            color: ColorsRes.firstgradientcolor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 2,
                              color: ColorsRes.txtdarkcolor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(30),
                                  bottomLeft: const Radius.circular(30),
                                ),
                                color: Colors.grey[200],
                              ),
                              child: InkWell(
                                onTap: () async {
                                  if (id == -1) {
                                    showTheLoginAlertErrorDialog(
                                        context,
                                        'Login / Singup',
                                        'You are not logged in. \n Either Login or SgnUp to continue further');
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RaiseNeedActivity(
                                                    SelectedOption.Donation)));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/donation.svg',
                                          fit: BoxFit.contain,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          semanticsLabel: 'User Logo'),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          "${StringsRes.raiseDonation}",
                                          style: TextStyle(
                                              color:
                                                  ColorsRes.firstgradientcolor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        Padding(
            padding: EdgeInsets.only(
              right: leftrightpadding - 2,
              left: leftrightpadding - 2,
              top: 10,
            ),
            child: ScopedModelDescendant<MasterData>(
              builder: (context, child, state) {
                return SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topRight: const Radius.circular(20),
                        topLeft: const Radius.circular(20),
                        bottomLeft: const Radius.circular(20),
                        bottomRight: const Radius.circular(20),
                      ),
                      color: Colors.grey[200],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: loading
                        ? SingleChildScrollView(
                            child: SkeletonLoader(
                              builder: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
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
                              highlightColor: ColorsRes.appcolor,
                              direction: SkeletonDirection.ltr,
                            ),
                          )
                        : ListView.builder(
                            itemCount: selectedOption == SelectedOption.Need
                                ? needs.length
                                : donations.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 4),
                                child: Card(
                                  elevation: 8,
                                  shadowColor: ColorsRes.appcolor,
                                  child: ListTile(
                                    // dense: true,
                                    trailing: IconButton(
                                      icon: const Icon(
                                          Icons.keyboard_arrow_right),
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
                                    tileColor: index % 2 == 0
                                        ? ColorsRes.grey
                                        : ColorsRes.white,
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
                                ),
                              );
                            },
                          ),
                  ),
                );
              },
            )),
      ]),
    ));
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return StringsRes.goodmorning;
    } else if (hour < 17) {
      return StringsRes.goodafternoon;
    } else if (hour < 21) {
      return StringsRes.goodevening;
    } else
      return StringsRes.goodnight;
  }

  // String name(AsyncSnapshot<User> snapshot) {
  //   if (snapshot.hasData) {
  //     userName = snapshot.data!.firstName;
  //   } else {
  //     userName = 'Guest';
  //   }
  //   return userName;
  // }
}
