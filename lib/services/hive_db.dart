import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:pinterest_2022/models/collection_model.dart';

class HiveDB {
  static String nameHive = "pinterest";
  static var box = Hive.box(nameHive);

  static put(List<Collections> list) {
    List<String> response =
        List<String>.from(list.map((x) => jsonEncode(x.toJson())));
    box.put("collections", response);
  }

  static putSaved(List<Collections> list) {
    List<String> response =
        List<String>.from(list.map((x) => jsonEncode(x.toJson())));
    box.put("save", response);
  }

  static putUser(Map<dynamic,dynamic> map) {
    box.put("user", map);
  }

  static List<Collections> get() {
    List<String> response = box.get("collections")??[];
    List<Collections> list = List<Collections>.from(
        response.map((x) => Collections.fromJson(jsonDecode(x))));
    return list;
  }

  static List<Collections> getSaved() {
    List<String> response = box.get("save")??[];
    List<Collections> list = List<Collections>.from(
        response.map((x) => Collections.fromJson(jsonDecode(x))));
    return list;
  }

  static Map<dynamic,dynamic> getUser() {
    Map<dynamic,dynamic> map = box.get("user") ?? {};
    return map;
  }

}

List<Collections> parseCollectionResponse(String response) {
  List json = jsonDecode(response);
  List<Collections> collections =
  List<Collections>.from(json.map((x) => Collections.fromJson(x)));
  return collections;
}

Map<String, dynamic> paramsSearch({page, query}) {
  Map<String, dynamic> map = {};
  map.addAll({"page": page.toString(), "query": query});
  return map;
}
