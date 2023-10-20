import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/model/hollidays/HolidayResponse.dart';
import 'package:hr_dispatcher/data/source/network/model/hollidays/Holidays.dart';
import 'package:hr_dispatcher/model/holiday.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HolidayProvider with ChangeNotifier {
  final List<Holiday> _holidayList = [];
  final List<Holiday> _holidayListFilter = [];

  List<Holiday> get holidayList {
    return _holidayListFilter;
  }

  int toggleValue = 0;

  void holidayListFilter() {
    _holidayListFilter.clear();
    if (toggleValue == 0) {
      _holidayListFilter.addAll(_holidayList
          .where((element) => element.dateTime.isAfter(DateTime.now()))
          .toList());
    } else {
      _holidayListFilter.addAll(_holidayList
          .where((element) => element.dateTime.isBefore(DateTime.now()))
          .toList().reversed);
    }

    notifyListeners();
  }

  Future<HolidayResponse> getHolidays() async {
    var uri = Uri.parse(Constant.HOLIDAYS_API);

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

        final responseJson = HolidayResponse.fromJson(responseData);

        makeHolidayList(responseJson.data);
        holidayListFilter();

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  void makeHolidayList(List<Holidays>? data) {
    _holidayList.clear();
    for (var item in data ?? []) {
      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(item.eventDate);
      print(DateFormat('MMMM').format(tempDate));
      _holidayList.add(Holiday(
          id: item.id,
          day: tempDate.day.toString(),
          month: DateFormat('MMM').format(tempDate),
          title: item.event,
          description: item.description,
          dateTime: tempDate));
    }
    notifyListeners();
  }
}
