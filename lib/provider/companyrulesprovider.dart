import 'dart:convert';

import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/data/source/network/model/rules/CompanyRules.dart';
import 'package:hr_dispatcher/data/source/network/model/rules/CompanyRulesReponse.dart';
import 'package:hr_dispatcher/model/content.dart';
import 'package:hr_dispatcher/repositories/companyrulerepository.dart';
import 'package:hr_dispatcher/utils/constant.dart';
import 'package:flutter/material.dart';

class CompanyRulesProvider with ChangeNotifier {
  final List<Content> _contentList = [];
  CompanyRuleRepository repository = CompanyRuleRepository();

  List<Content> get contentList {
    return [..._contentList];
  }

  Future<void> getContent() async {
    try {
      final response = await repository.getContent();

      makeRules(response.data);
    } catch (e) {
      throw e;
    }
  }

  void makeRules(List<CompanyRules> data) {
    _contentList.clear();
    for (var item in data) {
      _contentList
          .add(Content(title: item.title, description: item.description));
    }
    notifyListeners();
  }
}
