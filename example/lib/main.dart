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
  bool _countryMixWithRegionError = false;
  bool _regionMixWithCountryError = false;
  CountryModel? _selectedCountry;
  RegionModel? _selectedRegion;
  CountryModel? _selectedCountryMixWithRegion;
  RegionModel? _selectedRegionMixWithCountry;
  CountryModel? _selectedCountryWithError;
  RegionModel? _selectedRegionWithError;
  CountryModel? _selectedCountryMixWithRegionWithError;
  RegionModel? _selectedRegionMixWithCountryWithError;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sigleCountryDropdownExample(),
              sigleRegionDropdownExample(),
              countryMixWithRegionExample(),
              sigleCountryWithErrorHandlingExample(),
              sigleRegionWithErrorHandlingExample(),
              countryMixWithRegionErrorHandlingExample()
            ],
          ),
        ),
      ),
    );
  }

  Widget sigleCountryDropdownExample() {
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
              onChanged: (CountryModel? country) async {
                setState(() {
                  _selectedCountry = country;
                });
              },
            )),
      ],
    );
  }

  Widget sigleRegionDropdownExample() {
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

  Widget countryMixWithRegionExample() {
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
                  _selectedCountryMixWithRegion = country;
                  _selectedRegionMixWithCountry = null;
                });
              },
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: RegionDropdown(
              onChanged: (RegionModel? region) async {
                setState(() {
                  _selectedRegionMixWithCountry = region;
                });
              },
              selectedCountry: _selectedCountryMixWithRegion,
              selectedItem: _selectedRegionMixWithCountry,
              isMixWithCountry: true,
            )),
      ],
    );
  }

  Widget sigleCountryWithErrorHandlingExample() {
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

  Widget sigleRegionWithErrorHandlingExample() {
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
          padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 0),
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

  Widget countryMixWithRegionErrorHandlingExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Example with mix country and region dropdown with error handling'),
        ),
        _countryMixWithRegionError
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CountryDropdown(
                  onChanged: (CountryModel? country) async {
                    setState(() {
                      _selectedCountryMixWithRegionWithError = country;
                      _countryMixWithRegionError = false;
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
                      _selectedCountryMixWithRegionWithError = country;
                    });
                  },
                )),
        _regionMixWithCountryError
            ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: RegionDropdown(
              onChanged: (RegionModel? region) async {
                setState(() {
                  _selectedRegionMixWithCountryWithError = region;
                  _regionMixWithCountryError = false;
                });
              },
              isMixWithCountry: true,
              requiredErrorMessage: 'region is required',
              selectedItem: _selectedRegionMixWithCountryWithError,
              selectedCountry: _selectedCountryMixWithRegionWithError ,
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
                  _selectedRegionMixWithCountryWithError = region;
                });
              },
              selectedItem: _selectedRegionMixWithCountryWithError,
              selectedCountry: _selectedCountryMixWithRegionWithError ,
              isMixWithCountry: true,
            )),
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 10.0),
          child: ElevatedButton(
            child: const Text('submit'),
            onPressed: () {
              if (_selectedCountryMixWithRegionWithError == null) {
                setState(() {
                  _countryMixWithRegionError = true;
                });
              }
              if (_selectedRegionMixWithCountryWithError == null) {
                setState(() {
                  _regionMixWithCountryError = true;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
