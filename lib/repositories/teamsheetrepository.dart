
import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/connect.dart';
import 'package:hr_dispatcher/data/source/network/model/teamsheet/Teamsheetresponse.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter/material.dart';

class TeamSheetRepository{
  Future<Teamsheetresponse> getTeam() async {
    Preferences preferences = Preferences();

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(Constant.TEAM_SHEET_URL, headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        debugPrint(responseData.toString());

        final responseJson = Teamsheetresponse.fromJson(responseData);
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }
}