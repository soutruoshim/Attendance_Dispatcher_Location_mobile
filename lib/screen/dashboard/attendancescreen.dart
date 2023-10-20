import 'package:hr_dispatcher/provider/attendancereportprovider.dart';
import 'package:hr_dispatcher/widget/headerprofile.dart';
import 'package:hr_dispatcher/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:hr_dispatcher/widget/attendancescreen/attendancestatus.dart';
import 'package:hr_dispatcher/widget/attendancescreen/attendancetoggle.dart';
import 'package:hr_dispatcher/widget/attendancescreen/reportlistview.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen> {
  var initial = true;

  @override
  void didChangeDependencies() {
    if (initial) {
      loadAttendanceReport();
      initial = false;
    }
    super.didChangeDependencies();
  }

  Future<String> loadAttendanceReport() async {
    try {
      await Provider.of<AttendanceReportProvider>(context, listen: false)
          .getAttendanceReport();
      return 'loaded';
    } catch (e) {
      return 'loaded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () {
            return loadAttendanceReport();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  HeaderProfile(),
                  AttendanceStatus(),
                  AttendanceToggle(),
                  ReportListView()
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
