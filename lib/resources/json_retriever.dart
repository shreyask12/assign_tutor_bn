import 'dart:convert';

import 'package:flutter/services.dart';

Map<String, dynamic> _jsonData = {};

String? getStringBy(String key) => _jsonData[key] as String;

class JsonDataRetriever {
  const JsonDataRetriever();

  Future<Map<String, dynamic>> loadJson() async {
    String jsonString = await rootBundle.loadString("assets/json/menu.json");
    return _jsonData = await json.decode(jsonString) as Map<String, dynamic>;
  }
}
