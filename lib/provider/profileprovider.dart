import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/model/profile/Profile.dart';
import 'package:hr_dispatcher/data/source/network/model/profile/Profileresponse.dart';
import 'package:hr_dispatcher/model/profile.dart' as up;
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ProfileProvider with ChangeNotifier {
  final up.Profile _profile = up.Profile(
      id: 0,
      avatar: '',
      name: '',
      username: '',
      email: '',
      post: '',
      phone: '',
      dob: '',
      gender: '',
      address: '',
      bankName: '',
      bankNumber: '',
      joinedDate: '');

  up.Profile get profile {
    return _profile;
  }

  Future<Profileresponse> getProfile() async {
    var uri = Uri.parse(Constant.PROFILE_URL);

    Preferences preferences = Preferences();

    checkValueInPref(preferences);

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
        print(responseData.toString());

        final responseJson = Profileresponse.fromJson(responseData);
        parseUser(responseJson.data);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  void parseUser(Profile profile) {
    _profile.id = profile.id;
    _profile.avatar = profile.avatar;
    _profile.name = profile.name;
    _profile.username = profile.username;
    _profile.email = profile.email;
    _profile.post = profile.post;
    _profile.phone = profile.phone;
    _profile.dob = profile.dob;
    _profile.gender = profile.gender;
    _profile.address = profile.address;
    _profile.bankName = profile.bankName;
    _profile.bankNumber = profile.bankAccountNo;
    _profile.joinedDate = profile.joiningDate;

    notifyListeners();
  }

  void checkValueInPref(Preferences preferences) async {
    final user = await preferences.getUser();
    _profile.name = user.name;
    _profile.username = user.username;
    _profile.email = user.email;
    _profile.avatar = user.avatar;
    notifyListeners();
  }

  Future<Profileresponse> updateProfile(
      String name,
      String email,
      String address,
      String dob,
      String gender,
      String phone,
      File avatar) async {
    var uri = Uri.parse(Constant.EDIT_PROFILE_URL);

    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    dynamic response;
    try {
      if (avatar.path != '') {
        var requests = http.MultipartRequest('POST', uri);

        Map<String, String> headers = {
          'Accept': 'application/json; charset=UTF-8',
          'Content-type': 'multipart/form-data',
          'Authorization': 'Bearer $token'
        };

        final img.Image capturedImage = img.decodeImage(await File(avatar.path).readAsBytes())!;
        final img.Image orientedImage = img.bakeOrientation(capturedImage);
        var file = await File(avatar.path).writeAsBytes(img.encodeJpg(orientedImage));

        requests.files.add(
          http.MultipartFile(
            'avatar',
            file.readAsBytes().asStream(),
            await avatar.length(),
            filename: Random().hashCode.toString(),
          ),
        );

        requests.headers.addAll(headers);

        response = await requests.send();

        await response.stream.transform(utf8.decoder).listen((value) {
          final responseJson = Profileresponse.fromJson(json.decode(value));
          if (responseJson.statusCode == 200) {
            parseUser(responseJson.data);
            return responseJson;
          } else {
            var errorMessage = responseJson.message;
            throw errorMessage;
          }
        });

        return Future.error('error');
      } else {
        Map<String, String> headers = {
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        };

        response = await http.post(uri, headers: headers, body: {
          'name': name,
          'email': email,
          'address': address,
          'dob': dob,
          'gender': gender,
          'phone': phone,
        });

        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          debugPrint(responseData.toString());
          final responseJson = Profileresponse.fromJson(responseData);

          parseUser(responseJson.data);
          return responseJson;
        } else {
          var errorMessage = responseData['message'];
          throw errorMessage;
        }
      }
    } catch (error) {
      throw error;
    }
  }
}
