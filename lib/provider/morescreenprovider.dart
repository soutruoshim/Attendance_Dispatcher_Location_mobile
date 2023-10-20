import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/model/logout/Logoutresponse.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MoreScreenProvider with ChangeNotifier {
  Future<Logoutresponse> logout() async {
    var uri = Uri.parse(Constant.LOGOUT_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = Logoutresponse.fromJson(responseData);

        preferences.clearPrefs();
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
