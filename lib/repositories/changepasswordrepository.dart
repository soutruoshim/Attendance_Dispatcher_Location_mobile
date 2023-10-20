import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/connect.dart';
import 'package:hr_dispatcher/data/source/network/model/changepassword/ChangePasswordResponse.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordRepository{
  Future<ChangePasswordResponse> changePassword(
      String old, String newPassword, String confirm) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final body = {
      'current_password': old,
      'new_password': newPassword,
      'confirm_password': confirm,
    };

    try {
      final response = await Connect().postResponse(Constant.CHANGE_PASSWORD_API, headers, body);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = ChangePasswordResponse.fromJson(responseData);

        return jsonResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw e;
    }
  }
}