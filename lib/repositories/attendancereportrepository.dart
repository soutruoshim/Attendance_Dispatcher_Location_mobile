import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/connect.dart';
import 'package:hr_dispatcher/data/source/network/model/attendancereport/AttendanceReportResponse.dart';
import 'package:hr_dispatcher/utils/constant.dart';

class AttendanceReportRepository {
  Future<AttendanceReportResponse> getAttendanceReport(
      int selectedMonth) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await Connect().getResponse(
          Constant.ATTENDANCE_REPORT_URL + "?month=${selectedMonth + 1}",
          headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData.toString());

        final responseJson = AttendanceReportResponse.fromJson(responseData);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw error;
    }
  }
}
