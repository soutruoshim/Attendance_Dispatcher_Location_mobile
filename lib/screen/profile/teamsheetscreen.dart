import 'package:hr_dispatcher/model/team.dart';
import 'package:hr_dispatcher/provider/teamsheetprovider.dart';
import 'package:hr_dispatcher/screen/profile/employeedetailscreen.dart';
import 'package:hr_dispatcher/widget/buttonborder.dart';
import 'package:hr_dispatcher/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamSheetScreen extends StatelessWidget {
  static const routeName = '/teamsheet';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamSheetProvider(),
      child: TeamSheet(),
    );
  }
}

class TeamSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TeamSheetState();
}

class TeamSheetState extends State<TeamSheet> {
  var initialState = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (initialState) {
      getTeam();
      initialState = false;
    }
    super.didChangeDependencies();
  }

  Future<String> getTeam() async {
    setState(() async {
      isLoading = true;
      EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.black);
      await Provider.of<TeamSheetProvider>(context, listen: false).getTeam();
      isLoading = false;
      EasyLoading.dismiss(animation: true);
    });

    return "Loaded";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeamSheetProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(provider.company['name']!),
            elevation: 0,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () {
                return getTeam();
              },
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  itemCount: provider.teamList.length,
                  itemBuilder: (ctx, i) => Padding(
                      padding: EdgeInsets.all(5),
                      child: teamCard(provider.teamList[i]))),
            ),
          ),
        ),
      ),
    );
  }

  Widget teamCard(Team teamList) {
    return Card(
      shape: ButtonBorder(),
      elevation: 0,
      color: Colors.white10,
      child: InkWell(
        onTap: () {
          Get.to(EmployeeDetailScreen(),
              arguments: {"employeeId": teamList.id.toString()});
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color:
                            teamList.active == "1" ? Colors.green : Colors.grey,
                        width: 2)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    teamList.avatar,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        teamList.name,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(teamList.post,
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    final url = Uri.parse("tel:${teamList.phone}");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () async {
                    final url = Uri(scheme: "sms", path: teamList.phone);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  icon: const Icon(
                    Icons.message,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
