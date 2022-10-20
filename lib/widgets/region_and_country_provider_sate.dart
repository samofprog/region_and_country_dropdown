import 'package:flutter/cupertino.dart';
import 'package:region_and_country_dropdown/models/country_model.dart';
import 'package:region_and_country_dropdown/models/region_model.dart';
import 'package:region_and_country_dropdown/providers/region_and_country_provider.dart';

class RegionAndCountryProviderState extends StatefulWidget {
  final Widget child;

  const RegionAndCountryProviderState({Key? key, required this.child})
      : super(key: key);

  @override
  State<RegionAndCountryProviderState> createState() =>
      _RegionAndCountryProviderState();
}

class _RegionAndCountryProviderState
    extends State<RegionAndCountryProviderState> {
  List<CountryModel>? countries;
  List<RegionModel>? regions;

  @override
  Widget build(BuildContext context) {
    if (countries == null || regions == null) {
      CountryModel.load().then((value) {
        setState(() {
          countries = value;
        });
      });
      RegionModel.load().then((value) {
        setState(() {
          regions = value;
        });
      });
    }
    return RegionAndCountryProvider(
      countries: countries,
      regions: regions,
      child: widget.child,
    );
  }
}
