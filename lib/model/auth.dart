import 'dart:convert';
import 'dart:io';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/model/login/Loginresponse.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hr_dispatcher/utils/deviceuuid.dart';
import 'package:hr_dispatcher/utils/constant.dart';

class Auth with ChangeNotifier {
  Future<Loginresponse> login(String username, String password) async {
    var uri = Uri.parse(Constant.LOGIN_URL);
    print(Constant.LOGIN_URL);

    Map<String, String> headers = {"Accept": "application/json; charset=UTF-8"};

    try {
      var fcm = await FirebaseMessaging.instance.getToken();
      final response = await http.post(uri, headers: headers, body: {
        'username': username,
        'password': password,
        'fcm_token': fcm,
        'device_type': Platform.isIOS
            ? 'ios'
            : 'android',
        'uuid': await DeviceUUid().getUniqueDeviceId(),
      });

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData.toString());

        Preferences preferences = Preferences();
        final responseJson = Loginresponse.fromJson(responseData);
        await preferences.saveUser(responseJson.data);

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
