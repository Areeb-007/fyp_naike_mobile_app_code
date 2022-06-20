import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/models/master_data.dart';
import '../widgets/drawer_widget.dart';
import 'bottom_navigation_screen/home_screen.dart';
import 'bottom_navigation_screen/list_of_all.dart';
import 'bottom_navigation_screen/map_screen.dart';
import 'bottom_navigation_screen/my_needs.dart';

late GlobalKey<ScaffoldState> scafolldmain;

class LandingPage extends StatefulWidget {
  static const pageRoute = '/LandingPage';
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    scafolldmain = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
            child: drawerData(
          context,
        )),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),

          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          // handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.once,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.bounceIn,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.bounceInOut,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style15,
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    if (ScopedModel.of<MasterData>(context, rebuildOnChange: true).getUser.id ==
        -1) {
      return [
        HomeScreen(),
        MapScreen(),
        ListOfAll(),
      ];
    } else {
      return [
        HomeScreen(),
        MyNeeds(
          selectedOption: SelectedOption.Need,
        ),
        MapScreen(),
        MyNeeds(
          selectedOption: SelectedOption.Donation,
        ),
        ListOfAll(),
      ];
    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    if (ScopedModel.of<MasterData>(context, rebuildOnChange: true).getUser.id ==
        -1) {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Home"),
          activeColorPrimary: CupertinoColors.systemGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.map_pin_ellipse),
          title: ("Maps"),
          iconSize: 30,
          activeColorPrimary: CupertinoColors.systemGreen,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.list_dash),
          title: ("List"),
          activeColorPrimary: CupertinoColors.systemYellow,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    } else {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Home"),
          activeColorPrimary: CupertinoColors.systemGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.heart_fill),
          title: ("My Needs"),
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.map_pin_ellipse),
          title: ("Maps"),
          iconSize: 30,
          activeColorPrimary: CupertinoColors.systemGreen,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.add),
          title: ("My Donations"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.list_dash),
          title: ("List"),
          activeColorPrimary: CupertinoColors.systemYellow,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }
  }
}
