import 'package:hr_dispatcher/provider/holidayprovider.dart';
import 'package:hr_dispatcher/widget/holiday/holidaycardview.dart';
import 'package:hr_dispatcher/widget/holiday/toggleholiday.dart';
import 'package:hr_dispatcher/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class HolidayScreen extends StatelessWidget {
  static const routeName = '/holidays';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HolidayProvider(),
      child: Holiday(),
    );
  }
}

class Holiday extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HolidayState();
}

class HolidayState extends State<Holiday> {
  var inital = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (inital) {
      loadHolidays();
      inital = false;
    }
    super.didChangeDependencies();
  }

  Future<String> loadHolidays() async {
    setState(() async {
      isLoading = true;
      EasyLoading.show(status: "Loading",maskType: EasyLoadingMaskType.black);
      await Provider.of<HolidayProvider>(context, listen: false).getHolidays();
      isLoading = false;
      EasyLoading.dismiss(animation: true);
    });

    return "loaded";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return !isLoading;
      },
      child: Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text('Holidays'),
          ),
          body: RefreshIndicator(
            onRefresh: () {
              return loadHolidays();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                child: Column(
                  children: [ToggleHoliday(), HolidayCardView()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
