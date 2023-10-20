
import 'package:hr_dispatcher/data/source/network/model/teamsheet/Employee.dart';
import 'package:hr_dispatcher/data/source/network/model/teamsheet/TeamSheet.dart';
import 'package:hr_dispatcher/model/team.dart';
import 'package:hr_dispatcher/repositories/teamsheetrepository.dart';
import 'package:flutter/material.dart';

class TeamSheetProvider with ChangeNotifier {
  TeamSheetRepository repository = TeamSheetRepository();
  final List<Team> _teamList = [];

  final Map<String, String> _company = {
    'name': '',
    'id': '',
  };

  List<Team> get teamList {
    return [..._teamList];
  }

  Map<String, String> get company {
    return _company;
  }

  Future<void> getTeam() async {
    try {
      final response = await repository.getTeam();

      makeCompanyName(response.data);
      makeTeamSheet(response.data.employee);
    } catch (error) {
      rethrow;
    }
  }

  void makeCompanyName(TeamSheet data) {
    _company['name'] = data.name;
    _company['id'] = data.id.toString();
    notifyListeners();
  }

  void makeTeamSheet(List<Employee> employee) {
    _teamList.clear();
    for (var value in employee) {
      _teamList.add(Team(
          id: value.id,
          name: value.name,
          post: value.post,
          avatar: value.avatar,
          phone: value.phone,
          email: value.email,
          active: value.onlineStatus));
    }
    notifyListeners();
  }
}
