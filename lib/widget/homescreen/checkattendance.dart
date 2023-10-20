import 'package:hr_dispatcher/provider/dashboardprovider.dart';
import 'package:hr_dispatcher/provider/prefprovider.dart';
import 'package:hr_dispatcher/utils/authservice.dart';
import 'package:hr_dispatcher/widget/attendance_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class CheckAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CheckAttendanceState();
}

class CheckAttendanceState extends State<CheckAttendance> {
  @override
  Widget build(BuildContext context) {
    final attendanceList =
        Provider.of<DashboardProvider>(context).attendanceList;
    final pref = Provider.of<PrefProvider>(context);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE , MMMM d , yyyy').format(now);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigitalClock(
            is24HourTimeFormat: false,
            areaDecoration: BoxDecoration(color: Colors.transparent),
            hourMinuteDigitDecoration: BoxDecoration(color: Colors.transparent),
            secondDigitDecoration: BoxDecoration(color: Colors.transparent),
            digitAnimationStyle: Curves.easeOutExpo,
            hourMinuteDigitTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
          SizedBox(height: 10,),
          Center(child: Text(formattedDate,style: TextStyle(color: Colors.white),)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(90)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: attendanceList['check-in'] != "-" &&
                          attendanceList['check-out'] == "-"
                      ? HexColor("#daa520").withOpacity(.5)
                      : HexColor("#daa520").withOpacity(.5),
                  child: IconButton(
                      iconSize: 70,
                      onPressed: () async {
                        if (await pref.getUserAuth()) {
                          bool isAuthenticated =
                              await AuthService.authenticateUser();
                          if (isAuthenticated) {
                            showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                builder: (context) {
                                  return AttedanceBottomSheet();
                                });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  'Either no biometric is enrolled or biometric did not match'),
                            )));
                          }
                        } else {
                          showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) {
                                return AttedanceBottomSheet();
                              });
                        }
                      },
                      icon: const Icon(
                        Icons.fingerprint_sharp,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Center(child: Text("Check In | Check Out",style: TextStyle(color: Colors.white,fontSize: 15),)),
          SizedBox(height: 15,),
          Container(
            width: double.infinity,
            child: LinearPercentIndicator(
              animation: true,
              animationDuration: 1000,
              lineHeight: 30.0,
              padding: EdgeInsets.all(0),
              percent: attendanceList['production-time']!,
              center: Text(
                attendanceList['production_hour'],
                style: TextStyle(color: Colors.white),
              ),
              barRadius: const Radius.circular(20),
              backgroundColor: HexColor("#3dFFFFFF"),
              progressColor: attendanceList['check-in'] != "-" &&
                      attendanceList['check-out'] == "-"
                  ? HexColor("#daa520").withOpacity(.5)
                  : HexColor("#daa520").withOpacity(.5),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    attendanceList['check-in']!,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    attendanceList['check-out']!,
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
