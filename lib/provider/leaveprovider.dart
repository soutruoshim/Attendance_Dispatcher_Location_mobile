import 'dart:convert';

import 'package:hr_dispatcher/data/source/network/model/leaveissue/IssueLeaveResponse.dart';
import 'package:hr_dispatcher/data/source/network/model/leavetype/LeaveType.dart';
import 'package:hr_dispatcher/data/source/network/model/leavetype/Leavetyperesponse.dart';
import 'package:hr_dispatcher/data/source/network/model/leavetypedetail/LeaveTypeDetail.dart';
import 'package:hr_dispatcher/data/source/network/model/leavetypedetail/Leavetypedetailreponse.dart';
import 'package:hr_dispatcher/model/LeaveDetail.dart';
import 'package:hr_dispatcher/model/leave.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hr_dispatcher/data/source/datastore/preferences.dart';

class LeaveProvider with ChangeNotifier {
  final List<Leave> _leaveList = [];
  final List<LeaveDetail> _leaveDetailList = [];

  var _selectedMonth = 0;
  var _selectedType = 0;

  int get selectedMonth {
    return _selectedMonth;
  }

  void setMonth(int value) {
    _selectedMonth = value;
  }

  int get selectedType {
    return _selectedType;
  }

  void setType(int value) {
    _selectedType = value;
  }

  List<Leave> get leaveList {
    return [..._leaveList];
  }

  List<LeaveDetail> get leaveDetailList {
    return [..._leaveDetailList];
  }

  Future<Leavetyperesponse> getLeaveType() async {
    var uri = Uri.parse(Constant.LEAVE_TYPE_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        debugPrint(responseData.toString());

        final responseJson = Leavetyperesponse.fromJson(responseData);
        makeLeaveList(responseJson.data);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw error;
    }
  }

  void makeLeaveList(List<LeaveType> leaveList) {
    _leaveList.clear();

    for (var leave in leaveList) {
      _leaveList.add(Leave(
          id: int.parse(leave.leaveTypeId),
          name: leave.leaveTypeName,
          allocated: leave.leaveTaken,
          total: int.parse(leave.totalLeaveAllocated),
          status: leave.leaveTypeStatus,
          isEarlyLeave: leave.earlyExit));
    }

    notifyListeners();
  }

  Future<Leavetypedetailreponse> getLeaveTypeDetail() async {
    var uri =
        Uri.parse(Constant.LEAVE_TYPE_DETAIL_URL).replace(queryParameters: {
      'month': _selectedMonth != 0 ? _selectedMonth.toString() : '',
      'leave_type': _selectedType != 0 ? _selectedType.toString() : '',
    });

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        debugPrint(responseData.toString());

        final responseJson = Leavetypedetailreponse.fromJson(responseData);

        makeLeaveTypeList(responseJson.data);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw error;
    }
  }

  void makeLeaveTypeList(List<LeaveTypeDetail> leaveList) {
    _leaveDetailList.clear();

    for (var leave in leaveList) {
      _leaveDetailList.add(LeaveDetail(
          id: leave.id,
          name: leave.leaveTypeName,
          leave_from: leave.leaveFrom,
          leave_to: leave.leaveTo,
          requested_date: leave.leaveRequestedDate,
          authorization: leave.statusUpdatedBy,
          status: leave.status));
    }

    notifyListeners();
  }

  Future<IssueLeaveResponse> issueLeave(
      String from, String to, String reason, int leaveId) async {
    var uri = Uri.parse(Constant.ISSUE_LEAVE);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'leave_from': from,
        'leave_to': to,
        'leave_type_id': leaveId.toString(),
        'reasons': reason,
      });

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final responseJson = IssueLeaveResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      debugPrint(error.toString());
      throw error;
    }
  }

  Future<IssueLeaveResponse> cancelLeave(int leaveId) async {
    var uri = Uri.parse(Constant.CANCEL_LEAVE+"/$leaveId");

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final responseJson = IssueLeaveResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      debugPrint(error.toString());
      throw error;
    }
  }
}
