import 'dart:convert';

import 'package:flutter/services.dart';

class RegionModel {
  final String name;
  final String country;

  RegionModel({required this.name, required this.country});

  @override
  String toString() {
    return name;
  }

  static load() async {
    final String response = await rootBundle.loadString(
        'packages/region_and_country_dropdown/assets/countries/state.json');
    final data = await json.decode(response);
    return data.map<RegionModel>((cs) {
      return RegionModel(
          name: cs['name'], country: cs['country'].toLowerCase());
    }).toList();
  }
}
