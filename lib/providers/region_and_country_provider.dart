// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:region_and_country_dropdown/models/main.dart';

class RegionAndCountryProvider extends InheritedWidget {
  final String uuid = const Uuid().v4();
  final List<CountryModel>? countries;
  final List<RegionModel>? regions;
  CountryModel? previousCountry;
  CountryModel? currentCountry;
  String uniqId = 'uuid';
  String previousUniqid = 'uuid';

  RegionAndCountryProvider(
      {super.key, required super.child, required this.countries, this.regions});

  @override
  bool updateShouldNotify(covariant RegionAndCountryProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  static RegionAndCountryProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RegionAndCountryProvider>()!;
  }
}
