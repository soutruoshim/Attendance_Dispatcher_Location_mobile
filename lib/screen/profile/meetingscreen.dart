import 'package:hr_dispatcher/provider/meetingprovider.dart';
import 'package:hr_dispatcher/widget/meeting/meetinglistview.dart';
import 'package:hr_dispatcher/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class MeetingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MeetingState();
}

class MeetingState extends State<MeetingScreen> {
  var initial = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (initial) {
      getMeetingList();
      initial = false;
    }
    super.didChangeDependencies();
  }

  Future<String> getMeetingList() async {
    setState(() async {
      isLoading = true;
      EasyLoading.show(status: "Loading",maskType: EasyLoadingMaskType.black);
      await Provider.of<MeetingProvider>(context, listen: false).getMeetingList();
      isLoading = false;
      EasyLoading.dismiss(animation: true);
    });

    return "Loaded";
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
            title: Text('Meetings'),
          ),
          body: RefreshIndicator(
              onRefresh: () {
                Provider.of<MeetingProvider>(context, listen: false).page = 1;
                return getMeetingList();
              },
              child: MeetingListView()),
        ),
      ),
    );
  }
}
