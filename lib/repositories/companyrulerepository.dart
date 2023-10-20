import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/connect.dart';
import 'package:hr_dispatcher/data/source/network/model/rules/CompanyRulesReponse.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter/material.dart';

class CompanyRuleRepository{
  Future<CompanyRulesReponse> getContent() async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(Constant.RULES_API, headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final rulesResponse = CompanyRulesReponse.fromJson(responseData);
        return rulesResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw e;
    }
  }
}