// ignore_for_file: deprecated_member_use

import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uuid/uuid.dart';

import 'package:region_and_country_dropdown/models/main.dart';
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

class RegionAndCountryDropdown extends StatefulWidget {
  final Function(CountryModel? country, RegionModel? countryState) onChanged;
  final String? countryLabel;
  final String? searchCountryHint;
  final String? regionLabel;
  final String? searchRegionHintText;
  final bool? useCountryDropDown;
  final bool? useCountryStateDropDown;
  final String? regionHintText;
  final String? countryHintText;
  final String? lang;

  const RegionAndCountryDropdown(
      {Key? key,
      required this.onChanged,
      this.useCountryDropDown,
      this.useCountryStateDropDown,
      this.lang,
      this.countryLabel,
      this.searchCountryHint,
      this.regionLabel,
      this.searchRegionHintText,
      this.regionHintText,
      this.countryHintText})
      : super(key: key);

  @override
  State<RegionAndCountryDropdown> createState() =>
      _RegionAndCountryDropdownState();
}

class _RegionAndCountryDropdownState extends State<RegionAndCountryDropdown> {
  CountryModel? _selectedCountry;
  RegionModel? selectedItem;
  String uniqId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    if (widget.useCountryDropDown ?? false) {
      return Column(
        children: [
          FindDropdown<CountryModel>(
            label: widget.countryLabel,
            items: getData(widget.lang),
            onChanged: (CountryModel? data) {
              widget.onChanged(data, null);
            },
            dropdownBuilder: _buidlItemView,
            dropdownItemBuilder: _dropdownBuilder,
            searchHint: widget.searchCountryHint,
          ),
        ],
      );
    } else if (widget.useCountryStateDropDown ?? false) {
      return RegionDropdown(
        onChanged: (value) {
          widget.onChanged(null, value);
        },
        disabled: false,
        label: widget.regionLabel,
        searchText: widget.searchRegionHintText,
        hintText: widget.regionHintText,
      );
    }
    return Column(
      children: [
        FindDropdown<CountryModel>(
          label: widget.countryLabel,
          items: getData(widget.lang),
          onChanged: (CountryModel? data) {
            var previous =
                RegionAndCountryProvider.of(context).previousCountry =
                    RegionAndCountryProvider.of(context).currentCountry;
            var current =
                RegionAndCountryProvider.of(context).currentCountry = data;
            RegionAndCountryProvider.of(context).previousUniqid =
                RegionAndCountryProvider.of(context).uniqId;
            RegionAndCountryProvider.of(context).uniqId = const Uuid().v4();
            if (current != previous) {
              setState(() {
                _selectedCountry = data;
              });
            }
            widget.onChanged(_selectedCountry, null);
          },
          dropdownBuilder: _buidlItemView,
          dropdownItemBuilder: _dropdownBuilder,
          searchHint: widget.countryLabel,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: RegionDropdown(
              onChanged: (RegionModel? region) {
                widget.onChanged(_selectedCountry, region);
              },
              label: widget.regionLabel,
              searchText: widget.searchRegionHintText,
              hintText: widget.regionHintText,
              isMixWithRegion: true,
            ))
      ],
    );
  }

  Widget _dropdownBuilder(
      BuildContext context, CountryModel item, bool isSelected) {
    return Container(
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.translatedName ?? ''),
        leading: SizedBox(
          width: 30,
          height: 30,
          child: ClipOval(
            child: SvgPicture.asset(
              item.flag?.replaceAll(':', 's:') ?? '',
              width: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buidlItemView(BuildContext context, CountryModel? item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: (item?.flag == null)
          ? ListTile(
              leading: const Icon(Icons.flag),
              title: Text(widget.countryHintText ?? "Choose a country"))
          : ListTile(
              leading: SizedBox(
                width: 30,
                height: 30,
                child: ClipOval(
                  child: SvgPicture.asset(
                    item?.flag?.replaceAll(':', 's:') ?? '',
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(item?.translatedName ?? ''),
            ),
    );
  }

  List<CountryModel>? getData(String? lang) {
    if (lang != null) {
      return RegionAndCountryProvider.of(context).countries?.map((c) {
        var json = c.toJson();
        c.translatedName = json[lang] ?? json['en'];
        return c;
      }).toList();
    }
    return RegionAndCountryProvider.of(context).countries?.map((c) {
      var json = c.toJson();
      c.translatedName = json['en'];
      return c;
    }).toList();
  }
}

class RegionDropdown extends StatefulWidget {
  final Function(RegionModel?) onChanged;
  final String? label;
  final bool? disabled;
  final String? hintText;
  final String? searchText;
  final bool? isMixWithRegion;

  const RegionDropdown(
      {Key? key,
      required this.onChanged,
      this.disabled,
      this.label,
      this.hintText,
      this.searchText,
      this.isMixWithRegion})
      : super(key: key);

  @override
  State<RegionDropdown> createState() => _RegionDropdownState();
}

class _RegionDropdownState extends State<RegionDropdown> {
  bool reset = false;

  @override
  Widget build(BuildContext context) {
    var sc = RegionAndCountryProvider.of(context).currentCountry;
    return (sc == null && widget.isMixWithRegion == true)
        ? AbsorbPointer(
            child: FindDropdown<RegionModel>(
              label: widget.label,
              items: const [],
              onChanged: (RegionModel? data) {},
              dropdownBuilder: _buidlItemView,
              searchHint: widget.searchText,
            ),
          )
        : FindDropdown<RegionModel>(
            label: widget.label,
            items: filter(RegionAndCountryProvider.of(context).regions),
            onChanged: (RegionModel? data) {
              RegionAndCountryProvider.of(context).previousUniqid =
                  RegionAndCountryProvider.of(context).uniqId;
              setState(() {});
              widget.onChanged(data);
            },
            dropdownBuilder: _buidlItemView,
            dropdownItemBuilder: _dropdownBuilder,
            searchHint: widget.searchText,
          );
  }

  List<RegionModel>? filter(List<RegionModel>? regions) {
    if (RegionAndCountryProvider.of(context).currentCountry == null) {
      return regions;
    }
    var filtered = regions?.where((e) {
      var sc = RegionAndCountryProvider.of(context).currentCountry;
      return e.country == sc?.alpha2;
    }).toList() as List<RegionModel>;
    return filtered;
  }

  Widget _dropdownBuilder(
      BuildContext context, RegionModel item, bool isSelected) {
    return Container(
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name ?? ''),
      ),
    );
  }

  Widget _buidlItemView(BuildContext context, RegionModel? item) {
    if (RegionAndCountryProvider.of(context).uniqId !=
        RegionAndCountryProvider.of(context).previousUniqid) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(
              title: Text(
            widget.hintText ?? "Choose a state",
          )));
    }

    if (item != null) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(
              title: Text(
            item.name,
          )));
    }
    if (RegionAndCountryProvider.of(context).currentCountry == null &&
        item != null) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(title: Text(item.name)));
    }
    if (RegionAndCountryProvider.of(context).currentCountry == null &&
        item == null &&
        widget.isMixWithRegion != true) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(
              title: Text(
            widget.hintText ?? "Choose a state",
          )));
    }
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: ListTile(
            title: Text(
          widget.hintText ?? "Choose a state",
          style: TextStyle(color: Theme.of(context).disabledColor),
        )));
  }
}
