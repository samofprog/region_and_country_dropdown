import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:region_and_country_dropdown/models/country_model.dart';
import 'package:region_and_country_dropdown/models/region_model.dart';
import 'package:region_and_country_dropdown/widgets/region_dropdown.dart';
import 'package:region_and_country_dropdown/providers/region_and_country_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegionAndCountryDropdown extends StatefulWidget {
  final Function(CountryModel? country, RegionModel? countryState) onChanged;
  final String? countryLabel;
  final String? searchCountryHintText;
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
      this.searchCountryHintText,
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
            onFind: onFind,
            onChanged: (CountryModel? data) {
              widget.onChanged(data, null);
            },
            dropdownBuilder: _buidlItemView,
            dropdownItemBuilder: _dropdownBuilder,
            searchHint: widget.searchCountryHintText,
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
          onFind: onFind,
          dropdownBuilder: _buidlItemView,
          dropdownItemBuilder: _dropdownBuilder,
          searchHint: widget.searchCountryHintText,
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

  Future<List<CountryModel>> onFind(String value) async {
    if (value.isEmpty == false) {
      var filtered = getData(widget.lang)?.where((e) =>
          e.translatedName
              ?.toLowerCase()
              .contains(value.trim().toLowerCase()) ==
          true);
      return filtered?.toList() ?? [];
    }
    return getData(widget.lang) ?? [];
  }
}
