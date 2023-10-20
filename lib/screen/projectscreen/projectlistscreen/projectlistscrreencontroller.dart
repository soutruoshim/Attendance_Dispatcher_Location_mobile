import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/model/projectlist/projectlistresponse.dart';
import 'package:hr_dispatcher/model/member.dart';
import 'package:hr_dispatcher/model/project.dart';
import 'package:hr_dispatcher/screen/projectscreen/projectdetailscreen/projectdetailscreen.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectListScreenController extends GetxController {
  final projectList = <Project>[].obs;
  final filteredList = <Project>[].obs;
  final selected = "All".obs;

  Future<String> getProjectOverview() async {
    var uri = Uri.parse(Constant.PROJECT_LIST_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(status: "Loading",maskType: EasyLoadingMaskType.black);
      final response = await http.get(
        uri,
        headers: headers,
      );
      debugPrint(response.body.toString());
      EasyLoading.dismiss(animation: true);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final projectResponse = ProjectListResponse.fromJson(responseData);
        projectList.clear();

        for (var project in projectResponse.data) {
          List<Member> members = [];
          for (var member in project.assigned_member) {
            members.add(Member(member.id, member.name, member.avatar));
          }

          List<Member> leaders = [];
          for (var member in project.project_leader) {
            leaders.add(Member(member.id, member.name, member.avatar));
          }

          projectList.add(Project(
              project.id,
              project.name,
              project.description,
              project.start_date,
              project.priority,
              project.status,
              project.progress_percent,
              project.assigned_task_count,
              members,
              leaders,[]));
        }

        filterList();

        return "loaded";
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void filterList(){
    filteredList.clear();
    if(selected.value == "All"){
      filteredList.addAll(projectList);
    }else{
      for(var project in projectList){
        if(project.status == selected.value){
          filteredList.add(project);
        }
      }
    }

  }

  void onProjectClicked(Project value) {
    Get.to(ProjectDetailScreen(), arguments: {"id": value.id});
  }

  @override
  void onInit() {
    getProjectOverview();
    super.onInit();
  }
}
