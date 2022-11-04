import 'package:flutter/material.dart';
import 'package:region_and_country_dropdown/models/country_model.dart';
import 'package:region_and_country_dropdown/models/region_model.dart';
import 'package:region_and_country_dropdown/widgets/country_dropdown.dart';
import 'package:region_and_country_dropdown/widgets/region_and_country_provider_sate.dart';
import 'package:region_and_country_dropdown/widgets/region_dropdown.dart';

void main() {
  runApp(const RegionAndCountryProviderState(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _countryError = false;
  bool _regionError = false;
  bool _countryCombinedWithRegionError = false;
  bool _regionCombinedWithCountryError = false;
  RegionModel? _selectedRegion;
  CountryModel? _selectedCountryCombinedWithRegion;
  RegionModel? _selectedRegionCombinedWithCountry;
  CountryModel? _selectedCountryWithError;
  RegionModel? _selectedRegionWithError;
  CountryModel? _selectedCountryCombinedWithRegionWithError;
  RegionModel? _selectedRegionCombinedWithCountryWithError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              singleCountryDropdownExample(context),
              singleRegionDropdownExample(),
              countryCombinedWithRegionExample(),
              singleCountryWithErrorHandlingExample(),
              singleRegionWithErrorHandlingExample(),
              countryCombinedWithRegionErrorHandlingExample()
            ],
          ),
        ),
      ),
    );
  }

  Widget singleCountryDropdownExample(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Example with only country dropdown'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: CountryDropdown(
              onChanged: (CountryModel? country) async {},
              selectedItem: CountryModel.fromTranslatedName("Côte d'Ivoire", context, 'fr'),
            )),
      ],
    );
  }

  Widget singleRegionDropdownExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Example with only region dropdown'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: RegionDropdown(
              onChanged: (RegionModel? region) async {
                setState(() {
                  _selectedRegion = region;
                });
              },
              selectedItem: _selectedRegion,
            )),
      ],
    );
  }

  Widget countryCombinedWithRegionExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Example with mix country and region dropdown'),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: CountryDropdown(
              onChanged: (CountryModel? country) async {
                setState(() {
                  _selectedCountryCombinedWithRegion = country;
                  _selectedRegionCombinedWithCountry = null;
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: RegionDropdown(
              onChanged: (RegionModel? region) async {
                setState(() {
                  _selectedRegionCombinedWithCountry = region;
                });
              },
              selectedCountry: _selectedCountryCombinedWithRegion,
              selectedItem: _selectedRegionCombinedWithCountry,
              dependsOnTheChosenCountry: true,
            )),
      ],
    );
  }

  Widget singleCountryWithErrorHandlingExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Example with only country dropdown with error handling'),
        ),
        _countryError
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CountryDropdown(
                  onChanged: (CountryModel? country) async {
                    setState(() {
                      _selectedCountryWithError = country;
                      _countryError = false;
                    });
                  },
                  requiredErrorMessage: 'country is required',
                  boxDecoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).errorColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                ))
            : Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                child: CountryDropdown(
                  onChanged: (CountryModel? country) async {
                    setState(() {
                      _selectedCountryWithError = country;
                    });
                  },
                )),
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 0),
          child: ElevatedButton(
            child: const Text('submit'),
            onPressed: () {
              if (_selectedCountryWithError == null) {
                setState(() {
                  _countryError = true;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget singleRegionWithErrorHandlingExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Example with only region dropdown with error handling'),
        ),
        _regionError
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: RegionDropdown(
                  onChanged: (RegionModel? country) async {
                    setState(() {
                      _selectedRegionWithError = country;
                      _regionError = false;
                    });
                  },
                  requiredErrorMessage: 'region is required',
                  boxDecoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).errorColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  selectedItem: _selectedRegionWithError,
                ))
            : Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                child: RegionDropdown(
                  onChanged: (RegionModel? region) async {
                    setState(() {
                      _selectedRegionWithError = region;
                    });
                  },
                  selectedItem: _selectedRegionWithError,
                )),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            child: const Text('submit'),
            onPressed: () {
              if (_selectedRegionWithError == null) {
                setState(() {
                  _regionError = true;
                });
              }
            },
          ),
        )
      ],
    );
  }

  Widget countryCombinedWithRegionErrorHandlingExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              'Example with mix country and region dropdown with error handling'),
        ),
        _countryCombinedWithRegionError
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CountryDropdown(
                  onChanged: (CountryModel? country) async {
                    setState(() {
                      _selectedCountryCombinedWithRegionWithError = country;
                      _countryCombinedWithRegionError = false;
                    });
                  },
                  requiredErrorMessage: 'country is required',
                  boxDecoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).errorColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                ))
            : Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                child: CountryDropdown(
                  onChanged: (CountryModel? country) async {
                    setState(() {
                      _selectedCountryCombinedWithRegionWithError = country;
                    });
                  },
                )),
        _regionCombinedWithCountryError
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: RegionDropdown(
                  onChanged: (RegionModel? region) async {
                    setState(() {
                      _selectedRegionCombinedWithCountryWithError = region;
                      _regionCombinedWithCountryError = false;
                    });
                  },
                  dependsOnTheChosenCountry: true,
                  requiredErrorMessage: 'region is required',
                  selectedItem: _selectedRegionCombinedWithCountryWithError,
                  selectedCountry: _selectedCountryCombinedWithRegionWithError,
                  boxDecoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).errorColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                ))
            : Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                child: RegionDropdown(
                  onChanged: (RegionModel? region) async {
                    setState(() {
                      _selectedRegionCombinedWithCountryWithError = region;
                    });
                  },
                  selectedItem: _selectedRegionCombinedWithCountryWithError,
                  selectedCountry: _selectedCountryCombinedWithRegionWithError,
                  dependsOnTheChosenCountry: true,
                )),
        Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: 8.0, top: 10.0),
          child: ElevatedButton(
            child: const Text('submit'),
            onPressed: () {
              if (_selectedCountryCombinedWithRegionWithError == null) {
                setState(() {
                  _countryCombinedWithRegionError = true;
                });
              }
              if (_selectedRegionCombinedWithCountryWithError == null) {
                setState(() {
                  _regionCombinedWithCountryError = true;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
