import 'package:hr_dispatcher/data/source/network/model/login/User.dart';
import 'package:hr_dispatcher/provider/dashboardprovider.dart';
import 'package:hr_dispatcher/provider/prefprovider.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:hr_dispatcher/utils/locationstatus.dart';
import 'package:hr_dispatcher/widget/homescreen/checkattendance.dart';
import 'package:hr_dispatcher/widget/homescreen/overviewdashboard.dart';
import 'package:hr_dispatcher/widget/homescreen/weeklyreportchart.dart';
import 'package:hr_dispatcher/widget/radialDecoration.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hr_dispatcher/widget/headerprofile.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    loadDashboard();
    locationStatus();
    super.didChangeDependencies();
  }

  void locationStatus() async {
    try {
      final position = await LocationStatus().determinePosition();

      if (!mounted) {
        return;
      }
      final location =
          Provider.of<DashboardProvider>(context, listen: false).locationStatus;

      location.update('latitude', (value) => position.latitude);
      location.update('longitude', (value) => position.longitude);
    } catch (e) {
      print(e);
      showToast(e.toString());
    }
  }

  Future<String> loadDashboard() async {
    var fcm = await FirebaseMessaging.instance.getToken();
    print(fcm);
    try {
      final dashboardResponse =
          await Provider.of<DashboardProvider>(context, listen: false)
              .getDashboard();

      final user = dashboardResponse.data.user;

      Provider.of<PrefProvider>(context, listen: false).saveBasicUser(User(
          id: user.id,
          name: user.name,
          email: user.email,
          username: user.username,
          avatar: user.avatar));

      return 'loaded';
    } catch (e) {
      print(e);
      return 'loaded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: Colors.white,
          backgroundColor: Colors.blueGrey,
          edgeOffset: 50,
          onRefresh: () {
            return loadDashboard();
          },
          child: SafeArea(
              child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  HeaderProfile(),
                  CheckAttendance(),
                  OverviewDashboard(),
                  //WeeklyReportChart()
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
