import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/model/notification/NotifiactionDomain.dart';
import 'package:hr_dispatcher/data/source/network/model/notification/NotificationResponse.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hr_dispatcher/model/notification.dart' as Not;
import 'package:intl/intl.dart';

class NotificationProvider with ChangeNotifier {
  static int per_page = 10;
  int page = 1;

  final List<Not.Notification> _notificationList = [];

  List<Not.Notification> get notificationList {
    return [..._notificationList];
  }

  Future<NotificationResponse> getNotification() async {
    var uri = Uri.parse(Constant.NOTIFICATION_URL).replace(queryParameters: {
      'page': page.toString(),
      'per_page': per_page.toString(),
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
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = NotificationResponse.fromJson(responseData);

        makeNotificationList(jsonResponse.data);
        return jsonResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw e;
    }
  }

  void makeNotificationList(List<NotifiactionDomain> data) {
    if (page == 1) {
      _notificationList.clear();
    }

    if (data.isNotEmpty) {
      for (var item in data) {
        DateTime tempDate =
            DateFormat("yyyy-MM-dd").parse(item.notificationPublishedDate);
        _notificationList.add(Not.Notification(
            id: item.id,
            title: item.notificationTitle,
            description: item.description,
            month: DateFormat('MMM').format(tempDate),
            day: tempDate.day,
            date: tempDate));
      }

      page += page;
    }

    notifyListeners();
  }
}
