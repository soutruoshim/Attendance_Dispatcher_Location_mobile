import 'package:hr_dispatcher/provider/attendancereportprovider.dart';
import 'package:hr_dispatcher/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hr_dispatcher/widget/attendancescreen/attendancecardview.dart';

class ReportListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final attendanceList =
        Provider.of<AttendanceReportProvider>(context).attendanceReport;
    if (attendanceList.length > 0) {
      return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                attendanceReportTitle(),
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: attendanceList.length,
                    itemBuilder: (ctx, i) {
                      return AttendanceCardView(
                        i,
                        attendanceList[i].attendance_date,
                        attendanceList[i].week_day,
                        attendanceList[i].check_in,
                        attendanceList[i].check_out,
                      );
                    }),
              ],
            )),
      );
    } else {
      return Visibility(
        visible: Provider.of<AttendanceReportProvider>(context).isLoading
            ? true
            : false,
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget attendanceReportTitle() {
    return Card(
      elevation: 0,
      color: Colors.black38,
      shape: ButtonBorder(),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
            Expanded(
              child: Container(
                child: Text('Date',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.start),
              ),
            ),
            Expanded(
              child: Container(
                child: Text('Day',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.start),
              ),
            ),
            Expanded(
              child: Container(
                child: Text('Start Time',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.start),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text('End Time',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.start),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
