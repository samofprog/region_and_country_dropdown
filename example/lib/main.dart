import 'package:flutter/material.dart';
import 'package:region_and_country_dropdown/models/main.dart';
import 'package:region_and_country_dropdown/widgets/main.dart';

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
        body: Column(
          children: [
            RegionAndCountryDropdown(
              onChanged: (CountryModel? country, RegionModel? region) {
                print(country);
                print(region);
              },
            ),
          ],
        ),
      ),
    );
  }
}
