import 'package:hr_dispatcher/provider/prefprovider.dart';
import 'package:hr_dispatcher/screen/dashboard/homescreen.dart';
import 'package:hr_dispatcher/screen/dashboard/leavescreen.dart';
import 'package:hr_dispatcher/screen/dashboard/attendancescreen.dart';
import 'package:hr_dispatcher/screen/dashboard/morescreen.dart';
import 'package:hr_dispatcher/screen/dashboard/projectscreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  State<StatefulWidget> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      //ProjectScreen(),
      LeaveScreen(),
      AttendanceScreen(),
      MoreScreen(),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    final prefProvider = Provider.of<PrefProvider>(context);
    prefProvider.getUser();
    return Scaffold(
      body: PersistentTabView(context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          backgroundColor: HexColor("#041033"),
          handleAndroidBackButtonPress: true,
          // Default is true.
          resizeToAvoidBottomInset: true,
          // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true,
          // Default is true.
          hideNavigationBarWhenKeyboardShows: true,
          // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          navBarStyle: NavBarStyle.style3),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_filled),
        title: "Home",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white30,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.work_history),
      //   title: "Work",
      //   activeColorPrimary: Colors.white,
      //   inactiveColorPrimary: Colors.white30,
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.work_history_rounded),
        title: "Leave",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white30,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.co_present_rounded),
        title: "Attendance",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white30,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.more),
        title: "More",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white30,
      ),
    ];
  }
}
