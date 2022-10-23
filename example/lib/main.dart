import 'package:flutter/material.dart';
import 'package:region_and_country_dropdown/models/country_model.dart';
import 'package:region_and_country_dropdown/models/region_model.dart';
import 'package:region_and_country_dropdown/widgets/region_and_country_dropdown.dart';
import 'package:region_and_country_dropdown/widgets/region_and_country_provider_sate.dart';

void main() {
  runApp(const RegionAndCountryProviderState(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                RegionAndCountryDropdown(
                  onChanged: (CountryModel? country, RegionModel? region) {},
                  countryLabel: "Pays",
                  regionLabel: "Régions",
                  searchCountryHintText: "Recherchez votre pays",
                  searchRegionHintText: "Recherchez la ville",
                  countryRequiredErrorMessage: "Veuillez entrez un pays svp",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
